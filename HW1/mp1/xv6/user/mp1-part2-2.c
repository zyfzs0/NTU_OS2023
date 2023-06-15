#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0

void s5(int signo)
{
    int i = 5;
    while(1) {
        if(signo) printf("handler 5: %d\n", i*5);
        else printf("handler 5: %d\n", i*5+1);
        i++;
        if(i == 8) {
            thread_exit();
        }
        thread_yield();
    }
}

void s4(int signo)
{
    printf("handler 4: %d\n", signo);
}


void s3(int signo)
{
    printf("handler 3: %d\n", signo);
}

void s2(int signo)
{   
    int i = 22;
    while(1) {
        if(signo) printf("handler 2: %d\n", i*2);
        else printf("handler 2: %d\n", i*2+1);
        i++;
        if(i == 26) {
            return;
        }
        thread_yield();
    }
}

void f5(void *arg)
{
    thread_register_handler(1, s5);

    int i = 10;
    while(1) {
        printf("thread 5: %d\n", i++);
        if (i == 17) {
            thread_exit();
        }
        thread_yield();
    }
}

void f4(void *arg)
{
    thread_register_handler(0, s4);

    int i = 1000;
    while(1) {
        printf("thread 4: %d\n", i++);
        if (i == 1011) {
            thread_exit();
        }
        thread_yield();
    }
}

void f3(void *arg)
{
    thread_register_handler(0, s3);

    int i = 10000;

    struct thread *t4 = thread_create(f4, NULL);
    thread_add_runqueue(t4);
    struct thread *t5 = thread_create(f5, NULL);
    thread_add_runqueue(t5);
    
    while(1) {
        printf("thread 3: %d\n", i++);
        if (i == 10003) {
            thread_kill(t4, 1);
        }
        if (i == 10004) {
            thread_kill(t5, 1);
        }
        if (i == 10006) {
            thread_exit();
        }
        thread_yield();
    }
}

void f2(void *arg)
{
    int i = 0;
    while(1) {
        printf("thread 2: %d\n", i++);
        if (i == 4) {
            thread_exit();
        }
        thread_yield();
    }
}

void f1(void *arg)
{
    thread_register_handler(0, s2);
    int i = 100;

    struct thread *t2 = thread_create(f2, NULL);
    thread_add_runqueue(t2);
    struct thread *t3 = thread_create(f3, NULL);
    thread_add_runqueue(t3);
    

    while(1) {
        printf("thread 1: %d\n", i++);
        if (i == 101) {
            thread_kill(t2, 0);
        }
        if (i == 104) {
            thread_kill(t3, 0);
        }
        if (i == 105) {
            thread_exit();
        }
        thread_yield();
    }
}

int main(int argc, char **argv)
{
    printf("mp1-part2-2\n");
    struct thread *t1 = thread_create(f1, NULL);
    thread_add_runqueue(t1);
    thread_start_threading();
    printf("\nexited\n");
    exit(0);
}
