#ifndef THREADS_H_
#define THREADS_H_

#include "user/list.h"
#include "kernel/types.h"

struct thread {
    void (*fp)(void *arg);
    void *arg;
    void *stack;
    void *stack_p;
    int ID; // a unique ID, mainly used for tie-breaking
    struct list_head thread_list; // for linked list
    int buf_set;

    // for mp3
    int thrdstop_context_id; // When yeild or interrupt are happening, kernel stores the thread context, this is index for that.
    int processing_time;
    int period;
    int n;

    // number of ticks to be allocated in the current cycle
    int remaining_time;
    // the deadline of the current cycle, measured in ticks
    int current_deadline;
};

struct release_queue_entry {
    struct thread *thrd;
    struct list_head thread_list;
    int release_time;
};

struct thread *thread_create(void (*f)(void *), void *arg, int processing_time, int period, int n);
void thread_add_at(struct thread *t, int arrival_time);
void thread_exit(void);
void thread_start_threading();

#endif // THREADS_H_
