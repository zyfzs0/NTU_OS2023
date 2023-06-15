#include "kernel/types.h"
#include "user/user.h"
#include "user/list.h"
#include "user/threads.h"
#include "user/threads_sched.h"

#define NULL 0

/* default scheduling algorithm */
struct threads_sched_result schedule_default(struct threads_sched_args args)
{
    struct thread *thread_with_smallest_id = NULL;
    struct thread *th = NULL;
    // find the running thread with smallest id  
    list_for_each_entry(th, args.run_queue, thread_list) {
        if (thread_with_smallest_id == NULL || th->ID < thread_with_smallest_id->ID) {
            thread_with_smallest_id = th;
        }
    }

    struct threads_sched_result r;
    if (thread_with_smallest_id != NULL) {
        r.scheduled_thread_list_member = &thread_with_smallest_id->thread_list;
        r.allocated_time = thread_with_smallest_id->remaining_time;
    } else {
        r.scheduled_thread_list_member = args.run_queue;
        r.allocated_time = 1;
    }

    return r;
}

/* Earliest-Deadline-First scheduling */
struct threads_sched_result schedule_edf(struct threads_sched_args args)
{
    struct thread *thread_edf = NULL;
    struct thread *th = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
      if (thread_edf==NULL || th->current_deadline<thread_edf->current_deadline 
          || (th->current_deadline==thread_edf->current_deadline&&th->ID<thread_edf->ID) )
        thread_edf = th;
    }

    struct threads_sched_result r;

    if (list_empty(args.run_queue)) {
        // empty run_queue
        r.scheduled_thread_list_member = args.run_queue;

        int next_intval = 9999;
        struct release_queue_entry *rqe;
        list_for_each_entry(rqe, args.release_queue, thread_list) {
            if (rqe->release_time-args.current_time < next_intval)
                next_intval = rqe->release_time-args.current_time; 
        }

        //printf("%d\n", next_release);
        r.allocated_time = next_intval;
    } else {
        // look for missed threads
        struct thread *thread_missed = NULL;
        list_for_each_entry(th, args.run_queue, thread_list) {
          if (th->current_deadline <= args.current_time){
            if (thread_missed == NULL || th->ID < thread_missed->ID)
              thread_missed = th;
          }
        }

        if (thread_missed){
          r.scheduled_thread_list_member = &thread_missed->thread_list;
          r.allocated_time = 0;

          return r;
        }

        r.scheduled_thread_list_member = &thread_edf->thread_list;

        // get allocated_time
        r.allocated_time = thread_edf->current_deadline - args.current_time;
        if (thread_edf->remaining_time < r.allocated_time)
            r.allocated_time = thread_edf->remaining_time; 

        // maybe preepted by other threads in terms of deadline priority
        struct release_queue_entry *rqe;
        int preepted_time = 9999;
        list_for_each_entry(rqe, args.release_queue, thread_list) {
            int future_deadline = rqe->thrd->period + rqe->release_time;
            //printf("%d\n", future_deadline);
            if (thread_edf->current_deadline > future_deadline){
              int tmp = rqe->release_time - args.current_time; 
              if (tmp < preepted_time)
                preepted_time = tmp;
            }
        }
        if (preepted_time < r.allocated_time)
          r.allocated_time = preepted_time;

        //printf("%d\n", preepted_time);
        //printf("%d\n", r.allocated_time);
    }

    return r;
}

/* Rate-Monotonic Scheduling */
struct threads_sched_result schedule_rm(struct threads_sched_args args)
{
    struct thread *thread_rm = NULL;
    struct thread *th = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
      if (thread_rm==NULL || th->period<thread_rm->period || 
          (th->period==thread_rm->period&&th->ID<thread_rm->ID) )
        thread_rm = th;
    }

    struct threads_sched_result r;

    if (list_empty(args.run_queue)) {
    // empty run_queue
        r.scheduled_thread_list_member = args.run_queue;

        int near_intval = 9999;
        struct release_queue_entry *rqe = NULL;
        list_for_each_entry(rqe, args.release_queue, thread_list) {
            if (rqe->release_time-args.current_time < near_intval)
              near_intval = rqe->release_time-args.current_time; 
        }

        r.allocated_time = near_intval;
    } else {
        // look for missed threads
        struct thread *thread_missed = NULL;
        list_for_each_entry(th, args.run_queue, thread_list) {
          if (th->current_deadline <= args.current_time){
            //printf("th id %d\n", th->ID);
            if (thread_missed == NULL || th->ID < thread_missed->ID)
              thread_missed = th;
          }
        }

        if (thread_missed){
          r.scheduled_thread_list_member = &thread_missed->thread_list;
          r.allocated_time = 0;

          return r;
        }

        r.scheduled_thread_list_member = &thread_rm->thread_list;

        // get allocated_time
        r.allocated_time = thread_rm->current_deadline - args.current_time;
        if (thread_rm->remaining_time < r.allocated_time)
            r.allocated_time = thread_rm->remaining_time; 

        // look for higer priority thread in release_queue
        struct release_queue_entry *rqe;
        int intval = 9999;
        list_for_each_entry(rqe, args.release_queue, thread_list) {
          if (rqe->thrd->period < thread_rm->period){
              int tmp = rqe->release_time - args.current_time; 
              if (tmp < intval)
                intval = tmp;
          }
        }

        if (intval < r.allocated_time)
            r.allocated_time = intval;
    }

    return r;
}
