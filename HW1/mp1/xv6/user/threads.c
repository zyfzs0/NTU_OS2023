#include "kernel/types.h"
#include "user/setjmp.h"
#include "user/threads.h"
#include "user/user.h"
#define NULL 0


static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
static jmp_buf env_tmp;
static jmp_buf handler_env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
    t->arg = arg;
    t->ID  = id;
    t->buf_set = 0;
    t->stack = (void*) new_stack;
    t->stack_p = (void*) new_stack_p;
    id++;

    // part 2
    unsigned long handler_new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
    unsigned long handler_new_stack_p = handler_new_stack +0x100*8-0x2*8;
    t->handler_stack = (void*) handler_new_stack;
    t->handler_stack_p = (void*) handler_new_stack_p;
    t->sent = 0;
    t->sig_handler[0] = NULL_FUNC;
    t->sig_handler[1] = NULL_FUNC;
    t->signo = -1;
    t->handler_buf_set = 0;
    return t;
}
void thread_add_runqueue(struct thread *t){
    if(current_thread == NULL){
        // TODO
        current_thread = t;
        t->previous = t;
        t->next = t;
    }
    else{
        // TODO
        t->previous = current_thread->previous;
        t->next = current_thread;

        current_thread->previous->next = t;
        current_thread->previous = t;

        //t->signo = current_thread->signo;  
        t->sig_handler[0] = current_thread->sig_handler[0];
        t->sig_handler[1] = current_thread->sig_handler[1];
    }
}
void thread_yield(void){
    // TODO
    if(current_thread->signo != -1){
        int pds= setjmp(current_thread->handler_env);
        if (pds == 0) {
            current_thread->handler_buf_set = 1;
            schedule();
            dispatch();
        }
        else {
            current_thread->handler_buf_set = 0;
            return;
        }
    }

    int pd= setjmp(current_thread->env);
    if (pd == 0) {
        current_thread->buf_set = 1;
        schedule();
        dispatch();
    }
    else {
        current_thread->buf_set = 0;
        return;
    }
}
void thread_func(){
  current_thread->fp(current_thread->arg);
  thread_exit();
}

void sig_func(){
  int sig_no = current_thread->signo;
  current_thread->sig_handler[sig_no](sig_no);
  current_thread->signo = -1;

  if(current_thread->buf_set)
    longjmp(current_thread->env, 1);
  else{
    env_tmp->sp = (unsigned long)current_thread->stack_p;
    env_tmp->ra = (unsigned long)thread_func;
    longjmp(env_tmp, 1);
  }
}

void dispatch(void){
    // TODO
    // check signal
    int sig_no = current_thread->signo;
    if(sig_no != -1){
      if(current_thread->sig_handler[sig_no] == NULL_FUNC){
          thread_exit();
      }

      if(current_thread->handler_buf_set == 0){
          handler_env_tmp->sp = (unsigned long)current_thread->handler_stack_p;
          handler_env_tmp->ra = (unsigned long)sig_func;
          longjmp(handler_env_tmp, 1);
      }
      else{
          longjmp(current_thread->handler_env, 1);
      }
    }

    // check thread init
    if (current_thread->buf_set == 0) {
        env_tmp->sp = (unsigned long)current_thread->stack_p;
        env_tmp->ra = (unsigned long)thread_func;
        longjmp(env_tmp, 1);
    }
    else
        longjmp(current_thread->env, 1);
}
void schedule(void){
    // TODO
    current_thread = current_thread->next;
}
void thread_exit(void){
    if(current_thread->next != current_thread){
        // TODO
        struct thread* next = current_thread->next;
        current_thread->previous->next = current_thread->next; 
        current_thread->next->previous = current_thread->previous;

        free(current_thread->stack);
        free(current_thread);

        // update current thread
        current_thread = next;
        dispatch();
    }
    else{
        // TODO
        // Hint: No more thread to execute
        free(current_thread->stack);
        free(current_thread);
        current_thread = NULL;

        longjmp(env_st, 1);   
    }
}
void thread_start_threading(void){
    // TODO
    if (current_thread==NULL) 
        return;

    int pd = setjmp(env_st);
    if (pd == 0) 
        dispatch();
    else 
        return;
}
// part 2
void thread_register_handler(int signo, void (*handler)(int)){
    // TODO
    if(signo!=-1)
        current_thread->sig_handler[signo] = handler;
}
void thread_kill(struct thread *t, int signo){
    // TODO
  if(t->sent == 0){
      t->signo = signo;
      t->sent = 1;
  }
}
