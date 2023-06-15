#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0
#define TOLERENCE 1

int main_id = -1;

void thrdstop_handler(void *arg)
{
    int *lock = (int *)arg;
    *lock = 1;
    thrdresume(main_id);
}

int test_cancelthrdstop_no_store_ctx()
{
    int lock = 0;
    thrdstop(30, &main_id, thrdstop_handler, (void *)&lock);
    cancelthrdstop(main_id, 1);  // main_id is recycled
    main_id = -1;

    int start_time = uptime();
    while (!lock) {
        int t = uptime();
        if (lock) {
            break;
        }

        int elapsed_time_lb = t - start_time;
        if (elapsed_time_lb > 30) {
            break;
        }
    }

    return lock == 1;
}

int main(int argc, char **argv)
{
    int result = test_cancelthrdstop_no_store_ctx();
    fprintf(2, "[%s] %s\n", result ? "FAILED" : "OK", "test_cancelthrdstop_no_store_ctx");

    exit(0);
}
