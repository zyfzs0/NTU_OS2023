#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0
#define TOLERENCE 1

int main_id = -1;
int second_id = -1;

void thrdstop_handler_resume_main_id(void *arg)
{
    thrdresume(main_id);  // jump to line 23
    int *v = (int *)arg;
    ++v;                  // not executed
}

int test_multi_context()
{
    static int v1 = 0, v2 = 0;

    thrdstop(100, &main_id, thrdstop_handler_resume_main_id, (void *)NULL);
    cancelthrdstop(main_id, 0);

    if (v2 == 77) {
        v1 = 210;
        thrdresume(second_id); // jump to the while loop below
    }

    v2 += 77;
    thrdstop(5, &second_id, thrdstop_handler_resume_main_id, (void *)&v1);
    while (v1 == 0) {
        // wait for the handler
    }

    return v1 != 210 || v2 != 77;
}

int main(int argc, char **argv)
{
    int result = test_multi_context();
    fprintf(2, "[%s] %s\n", result ? "FAILED" : "OK", "test_multi_context");

    exit(0);
}
