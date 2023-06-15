#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0
#define TOLERENCE 1

int main_id = -1;

void thrdstop_handler_record_uptime(void *arg)
{
    int *uptime_in_handler_ptr = (int *)arg;
    *uptime_in_handler_ptr = uptime();
    thrdresume(main_id);
}

int test_cancelthrdstop_store_ctx()
{
    int t = 0;
    static int v;
    v = 99;

    thrdstop(100, &main_id, thrdstop_handler_record_uptime, (void *)&t);
    cancelthrdstop(main_id, 0);
    
    ++v; // will be executed 2 times
    if (v == 100) {
        thrdresume(main_id); // jump to line 24
    }

    return v != 101 || t != 0;
}

int main(int argc, char **argv)
{
    int result = test_cancelthrdstop_store_ctx();
    fprintf(2, "[%s] %s\n", result ? "FAILED" : "OK", "test_cancelthrdstop_store_ctx");

    exit(0);
}
