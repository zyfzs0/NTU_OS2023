#include "kernel/types.h"
#include "user/threads.h"
#include "user/threads_sched.h"
#include "user/user.h"
#include "user/list.h"

#define NULL 0

static LIST_HEAD(run_queue);
static LIST_HEAD(release_queue);

static struct list_head *current = NULL;
static int threading_system_time = 0;
static int main_thrd_id = -1;
static int sleeping = 0;
static uint64 allocated_time = 0;

void __dispatch(void);
void __schedule(void);

struct thread *thread_create(void (*f)(void *), void *arg, int processing_time, int period, int n)
{
    static int _id = 1;
    struct thread *t = (struct thread *)malloc(sizeof(struct thread));
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long)malloc(sizeof(unsigned long) * 0x200);
    new_stack_p = new_stack + 0x200 * 8 - 0x2 * 8;
    t->fp = f;
    t->arg = arg;
    t->ID = _id++;
    t->buf_set = 0;
    t->stack = (void *)new_stack;
    t->stack_p = (void *)new_stack_p;

    t->processing_time = processing_time;
    t->period = period;
    t->n = n;
    t->remaining_time = 0;
    t->current_deadline = 0;
    return t;
}

void thread_add_at(struct thread *t, int arrival_time)
{
    struct release_queue_entry *new_entry = (struct release_queue_entry *)malloc(sizeof(struct release_queue_entry));
    new_entry->thrd = t;
    new_entry->release_time = arrival_time;
    t->current_deadline = arrival_time;
    list_add_tail(&new_entry->thread_list, &release_queue);
}

void __release()
{
    struct release_queue_entry *cur, *nxt;
    list_for_each_entry_safe(cur, nxt, &release_queue, thread_list) {
        if (threading_system_time >= cur->release_time) {
            cur->thrd->remaining_time = cur->thrd->processing_time;
            cur->thrd->current_deadline = cur->release_time + cur->thrd->period;
            list_add_tail(&cur->thrd->thread_list, &run_queue);
            list_del(&cur->thread_list);
            free(cur);
        }
    }
}

void __thread_exit(struct thread *to_remove)
{
    current = to_remove->thread_list.prev;
    list_del(&to_remove->thread_list);

    free(to_remove->stack);
    free(to_remove);

    __schedule();
    __dispatch();
    thrdresume(main_thrd_id);
}

void thread_exit(void)
{
    if (current == &run_queue) {
        fprintf(2, "[FATAL] thread_exit is called on a nonexistent thread\n");
        exit(1);
    }

    struct thread *to_remove = list_entry(current, struct thread, thread_list);
    int consume_ticks = cancelthrdstop(to_remove->thrdstop_context_id, 1);
    threading_system_time += consume_ticks;

    __release();
    __thread_exit(to_remove);
}

void __finish_current()
{
    struct thread *current_thread = list_entry(current, struct thread, thread_list);
    --current_thread->n;

    printf("thread#%d finish one cycle at %d: %d cycles left\n",
           current_thread->ID, threading_system_time, current_thread->n);

    if (current_thread->n > 0) {
        struct list_head *to_remove = current;
        current = current->prev;
        list_del(to_remove);
        thread_add_at(current_thread, current_thread->current_deadline);
    } else {
        __thread_exit(current_thread);
    }
}

void switch_handler(void *arg)
{
    uint64 elapsed_time = (uint64)arg;
    struct thread *current_thread = list_entry(current, struct thread, thread_list);

    threading_system_time += elapsed_time;
     __release();
    current_thread->remaining_time -= elapsed_time;

    if (threading_system_time > current_thread->current_deadline || 
        (threading_system_time == current_thread->current_deadline && current_thread->remaining_time > 0)) {
        printf("thread#%d misses a deadline at %d\n", current_thread->ID, threading_system_time);
        exit(0);
    }

    if (current_thread->remaining_time <= 0) {
        __finish_current();
    }

    __release();
    __schedule();
    __dispatch();
    thrdresume(main_thrd_id);
}

void __dispatch()
{
    if (current == &run_queue) {
        return;
    }

    if (allocated_time < 0) {
        fprintf(2, "[FATAL] allocated_time is negative\n");
        exit(1);
    }

    struct thread *current_thread = list_entry(current, struct thread, thread_list);
     if (allocated_time == 0) { // miss deadline, abort
        printf("thread#%d misses a deadline at %d\n", current_thread->ID, current_thread->current_deadline);
        exit(0);
    }

    printf("dispatch thread#%d at %d: allocated_time=%d\n", current_thread->ID, threading_system_time, allocated_time);

    if (current_thread->buf_set) {
        thrdstop(allocated_time, &(current_thread->thrdstop_context_id), switch_handler, (void *)allocated_time);
        thrdresume(current_thread->thrdstop_context_id);
    } else {
        current_thread->buf_set = 1;
        unsigned long new_stack_p = (unsigned long)current_thread->stack_p;
        current_thread->thrdstop_context_id = -1;
        thrdstop(allocated_time, &(current_thread->thrdstop_context_id), switch_handler, (void *)allocated_time);
        if (current_thread->thrdstop_context_id < 0) {
            fprintf(2, "[ERROR] number of threads may exceed MAX_THRD_NUM\n");
            exit(1);
        }

        // set sp to stack pointer of current thread.
        asm volatile("mv sp, %0"
                     :
                     : "r"(new_stack_p));
        current_thread->fp(current_thread->arg);
    }
    thread_exit();
}

void __schedule(void)
{
    struct threads_sched_args args = {
        .current_time = threading_system_time,
        .run_queue = &run_queue,
        .release_queue = &release_queue,
    };

    struct threads_sched_result r;

#ifdef THREAD_SCHEDULER_DEFAULT
    r = schedule_default(args);
#endif

#ifdef THREAD_SCHEDULER_EDF
    r = schedule_edf(args);
#endif

#ifdef THREAD_SCHEDULER_RM
    r = schedule_rm(args);
#endif

    current = r.scheduled_thread_list_member;
    allocated_time = r.allocated_time;
}

void back_to_main_handler(void *arg)
{
    sleeping = 0;
    threading_system_time += (uint64)arg;
    thrdresume(main_thrd_id);
}

void thread_start_threading()
{
    threading_system_time = 0;
    current = &run_queue;

    // call thrdstop just for obtain an ID
    thrdstop(1000, &main_thrd_id, back_to_main_handler, (void *)0);
    cancelthrdstop(main_thrd_id, 0);

    while (!list_empty(&run_queue) || !list_empty(&release_queue)) {
        __release();
        __schedule();
        cancelthrdstop(main_thrd_id, 0);
        __dispatch();

        if (list_empty(&run_queue) && list_empty(&release_queue)) {
            break;
        }

        // no thread in run_queue, release_queue not empty
        printf("run_queue is empty, sleep for %d ticks\n", allocated_time);
        sleeping = 1;
        thrdstop(allocated_time, &main_thrd_id, back_to_main_handler, (void *)allocated_time);
        while (sleeping) {
            // zzz...
        }
    }
}
