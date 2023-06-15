#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/vm.h"
#include "user/user.h"

#define PGSIZE 4096

int main(int argc, char *argv[]) {
  int result = 0;

  char *page1 = sbrk(PGSIZE * 3);
  char *page2 = page1 + PGSIZE;

  /* Trigger page fault */
  *page2 = 1;

  printf("# After page fault (1)\n");
  vmprint();
  printf("\n");

  /* madvise(MADV_DONTNEED) */
  result = madvise(page1, PGSIZE * 2, MADV_DONTNEED);
  if (result != 0) {
    printf("error: return value of madvise() is incorrect.\n");
    exit(-1);
  }

  printf("# After madvise(DONTNEED) (1)\n");
  vmprint();
  printf("\n");

  exit(0);
}
