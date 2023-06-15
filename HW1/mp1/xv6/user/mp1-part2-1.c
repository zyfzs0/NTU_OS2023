#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0

void s3(int signo)
{
    int i = 10;
    while(1) {
        if(signo) printf("handler 3: %d\n", i*2);
        else printf("handler 3: %d\n", i*2+1);
        i++;
        if(i == 15) {
            return;
        }
        thread_yield();
    }
}

void s2(int signo)
{
    printf("handler 2: %d\n", signo);
}

void f3(void *arg)
{
    thread_register_handler(0, s3);
    thread_register_handler(1, s3);

    int i = 10000;
    while (1) {
        printf("thread 3: %d\n", i++);
        if(i == 10005) {
            thread_exit();
        }
        thread_yield();
    }
}

void f2(void *arg)
{
    thread_register_handler(0, s2);
    thread_register_handler(1, s2);

    int i = 0;
    while(1) {
        printf("thread 2: %d\n",i++);
        if (i == 10) {
            thread_exit();
        }
        thread_yield();
    }
}

void f1(void *arg)
{
    int i = 100;
    struct thread *t2 = thread_create(f2, NULL);
    thread_add_runqueue(t2);
    struct thread *t3 = thread_create(f3, NULL);
    thread_add_runqueue(t3);
    
    
    while(1) {
        printf("thread 1: %d\n", i++);
        if (i == 102) {
            thread_kill(t2, 1);
        }
        if (i == 105) {
            thread_kill(t3, 0);
        }
        if (i == 110) {
            thread_exit();
        }
        thread_yield();
    }
}

int main(int argc, char **argv)
{
    printf("mp1-part2-1\n");
    struct thread *t1 = thread_create(f1, NULL);
    thread_add_runqueue(t1);
    thread_start_threading();
    printf("\nexited\n");
    exit(0);
}
