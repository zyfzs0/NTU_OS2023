#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

// for mp3
uint64
sys_thrdstop(void)
{
  int delay;
  uint64 context_id_ptr;
  uint64 handler, handler_arg;
  if (argint(0, &delay) < 0)
    return -1;
  if (argaddr(1, &context_id_ptr) < 0)
    return -1;
  if (argaddr(2, &handler) < 0)
    return -1;
  if (argaddr(3, &handler_arg) < 0)
    return -1;
  //printf("handler_arg in thrdstop: %d\n", handler_arg);

  struct proc *proc = myproc();

  //TODO: mp3

  // get context_id
  int context_id;
  copyin(proc->pagetable, (char*)&context_id, context_id_ptr, sizeof(int));

  if(context_id == -1){
    int err = 1;
    for (int i = 0; i < MAX_THRD_NUM; i++) {
      if(!proc->context_used[i]){
        context_id = i;
        //printf("context_id(-1) is: %d\n", context_id);
        proc->context_id = i;
        proc->context_used[i] = 1;
        copyout(proc->pagetable, context_id_ptr, (char*)&i, sizeof(int));
        err = 0;
        break;
      }
    }

    if (err)
      return -1;
  }
  else{
    //printf("context_id is: %d\n", context_id);
    int err = 1;
    for (int i = 0; i < MAX_THRD_NUM; i++) {
      if (proc->context_used[i] && i==context_id){
        err = 0;
        proc->context_id = context_id;
        break;
      }
    }
    
    if (err)
      return -1;
  }

  proc->delay = delay;
  proc->ps_ticks = 0;
  proc->handler = handler;
  proc->handler_arg = handler_arg;

  return 0;
}

// for mp3
uint64
sys_cancelthrdstop(void)
{
  int context_id, is_exit;
  if (argint(0, &context_id) < 0)
    return -1;
  if (argint(1, &is_exit) < 0)
    return -1;

  if (context_id < 0 || context_id >= MAX_THRD_NUM) {
    return -1;
  }

  struct proc *proc = myproc();

  //TODO: mp3
  proc->delay = 0;

  // recycle context_id
  // attention: context_id is in use
  if (is_exit){
    proc->context_used[context_id] = 0;
  }
  else{
    memmove(proc->contexts + proc->context_id, proc->trapframe, sizeof(struct trapframe));
  }

  return proc->ps_ticks;
}

// for mp3
uint64
sys_thrdresume(void)
{
  int context_id;
  if (argint(0, &context_id) < 0)
    return -1;

  struct proc *proc = myproc();

  //TODO: mp3
  if (context_id >= MAX_THRD_NUM || !proc->context_used[context_id])
    return -1;

  memmove(proc->trapframe, proc->contexts + context_id, sizeof(struct trapframe));
  // avoid re-entrant of handler
  proc->ps_ticks = 0;

  return 0;
}
