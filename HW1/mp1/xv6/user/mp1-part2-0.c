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
        if(i == 13) {
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
    int i = 10000;
    while (1) {
        printf("thread 3: %d\n", i++);
        if(i == 10003) {
            thread_exit();
        }
        thread_yield();
    }
}

void f2(void *arg)
{
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

    thread_register_handler(1, s3);

    struct thread *t2 = thread_create(f2, NULL);
    thread_add_runqueue(t2);
    struct thread *t3 = thread_create(f3, NULL);
    thread_add_runqueue(t3);

    thread_kill(t2, 0);
    thread_kill(t3, 1);

    while(1) {
        printf("thread 1: %d\n",i++);
        if (i == 106) {
            thread_exit();
        }
        thread_yield();
    }
}

int main(int argc, char **argv)
{
    printf("mp1-part2-0\n");
    struct thread *t1 = thread_create(f1, NULL);
    thread_add_runqueue(t1);
    thread_start_threading();
    printf("\nexited\n");
    exit(0);
}
