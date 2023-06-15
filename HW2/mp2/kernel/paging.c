#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "defs.h"
#include "proc.h"

/* NTU OS 2022 */
/* Page fault handler */
int handle_pgfault() {
  /* Find the address that caused the fault */
  uint64 va = r_stval(); 

  /* TODO */
  pte_t *pte = walk(myproc()->pagetable,va,0);
  uint64 wrong_addr = PGROUNDDOWN(va);
  uint64 correct_addr = wrong_addr + PGSIZE;
  if (*pte & PTE_S) {
    /* Get the BLOCKNO from a PTE */
    uint64 blockno = PTE2BLOCKNO(*pte);
    /*Allocate a 4096-byte physical memory page and return the address*/
    char* pa = kalloc();
    //Notes on Device I/O
    begin_op();
    read_page_from_disk(ROOTDEV,pa,blockno);
    bfree_page(ROOTDEV,blockno);
    end_op();
    /* Set the PTE_V bit */
    *pte |= PTE_V;
    /* Unset the PTE_S bit */
    *pte &= ~PTE_S;
    /* Create a PTE from a PA and flag bits */
    *pte = PA2PTE(pa) | PTE_FLAGS(*pte);
  }
  else{
    // reference link
    // https://github.com/KuangjuX/xv6-riscv-solution/tree/main/lazy
    if(wrong_addr > myproc()->sz || correct_addr >= MAXVA || wrong_addr <= myproc()->trapframe->sp)
        myproc()->killed = 1;
    else{
      /*Allocate a 4096-byte physical memory page and return the address*/
      char *page_net = kalloc();
      if (page_net != 0){ 
        /*zeros out a fraction of memory*/
        memset(page_net,0,PGSIZE);
        /*assign a physical to virual address mapping in the page table*/
        int term = PTE_U; //mark flags on newly allocated pages
        term |= PTE_R;
        term |= PTE_W;
        term |= PTE_X;
        if (mappages(myproc()->pagetable,wrong_addr,PGSIZE,(uint64)page_net,term) != 0){
            kfree(page_net);
            uvmdealloc(myproc()->pagetable, wrong_addr, correct_addr);
            //myproc()->killed = 1;
        }
      }
      else
        myproc()->killed = 1;
    }
  }
  return 0;
}
