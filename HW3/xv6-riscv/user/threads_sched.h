#ifndef THREADS_SCHE_H_
#define THREADS_SCHE_H_

#include "user/list.h"

struct threads_sched_args {
    // the number of ticks since threading starts
    int current_time;
    // the linked list containing all the threads available to be run
    struct list_head *run_queue;
    // the linked list containing all the threads that will be available later
    struct list_head *release_queue;
};

struct threads_sched_result {
    // `scheduled_thread_list_member` should point to the `thread_list` member of
    // the scheduled `struct thread` entry
    struct list_head *scheduled_thread_list_member;
    // the number of ticks allocated for this thread to run
    int allocated_time;
};

struct threads_sched_result schedule_default(struct threads_sched_args args);
struct threads_sched_result schedule_edf(struct threads_sched_args args);
struct threads_sched_result schedule_rm(struct threads_sched_args args);

#endif
