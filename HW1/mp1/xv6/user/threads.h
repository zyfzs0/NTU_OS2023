#ifndef THREADS_H_
#define THREADS_H_
#define NULL_FUNC ((void (*)(int))-1)
// TODO: necessary includes, if any
#include "user/setjmp.h"
// TODO: necessary defines, if any


struct thread {
    void (*fp)(void *arg);
    void *arg;
    void *stack;
    void *stack_p;
    jmp_buf env; // for thread function
    int buf_set; //1: indicate jmp_buf (env) has been set, 0: indicate jmp_buf (env) not set
    int ID;
    struct thread *previous;
    struct thread *next;

    // part 2
    int sent;
    void *handler_stack;
    void *handler_stack_p;
    void (*sig_handler[2])(int); // sig_handler[0] is for signo = 0, sig_handler[1] is for signo = 1
    int signo; // -1: no signal comes, 0: receive a signal signo = 0, 1: receive a signal signo = 1
    jmp_buf handler_env; // for signal handler function
    int handler_buf_set; //1: indicate jmp_buf (handler_env) has been set, 0: indicate jmp_buf (handler_env) not set
};

struct thread *thread_create(void (*f)(void *), void *arg);
void thread_add_runqueue(struct thread *t);
void thread_yield(void);
void dispatch(void);
void schedule(void);
void thread_exit(void);
void thread_start_threading(void);

// part 2
void thread_register_handler(int signo, void (*f)(int));
void thread_kill(struct thread *t, int signo);
#endif // THREADS_H_
