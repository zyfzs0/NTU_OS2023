#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0

int main_id = -1;

void thrdstop_handler(void *arg)
{
    int *lock = (int *)arg;
    *lock = 1;
    thrdresume(main_id);
}

int test_thrdstop_correct_timing_helper(int num_ticks)
{
    int lock = 0;
    int start_time_outer = uptime();

    // should jump to thrdstop_handler_record_uptime after [num_ticks] timer interrupts
    if (thrdstop(num_ticks, &main_id, thrdstop_handler, (void *)&lock) == -1) {
        fprintf(2, "thrdstop error\n");
        exit(1);
    }

    int start_time_inner = uptime();
    int elapsed_time_lb = 0;
    while (!lock) {
        int t = uptime();
        if (lock) {
            break;
        }

        // t should be assigned before handler execution
        elapsed_time_lb = t - start_time_inner;
        if (elapsed_time_lb > num_ticks) {
            fprintf(2, "thrdstop timing differs too much from expected value: "
                       "expected=%d actual>=%d\n", num_ticks, elapsed_time_lb);
            return 1;
        }
    }

    int elapsed_time_ub = uptime() - start_time_outer;
    if (elapsed_time_ub < num_ticks || elapsed_time_lb > num_ticks) {
        fprintf(2, "thrdstop timing differs too much from expected value: "
                   "lower_bound=%d upper_bound=%d expected=%d\n", elapsed_time_lb, elapsed_time_ub, num_ticks);
        return 1;
    }

    return 0;
}

int test_thrdstop_correct_timing()
{
    int args[] = {2, 1, 3, 5, 7, 1, 2};
    int failed = 0;
    for (int i = 0; i < sizeof(args) / sizeof(int); i++) {
        int result = test_thrdstop_correct_timing_helper(args[i]);
        if (result) {
            failed = 1;
            break;
        }
    }

    return failed;
}

int main(int argc, char **argv)
{
    int result = test_thrdstop_correct_timing();
    printf("[%s] %s\n", result ? "FAILED" : "OK", "test_thrdstop_correct_timing");

    exit(0);
}
