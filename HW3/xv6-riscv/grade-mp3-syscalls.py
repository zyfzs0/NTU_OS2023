#!/usr/bin/env python3
import os
import re

from gradelib import *

os.system("make clean")

r = Runner(save("xv6.out"))


@test(4, "thrdtest1")
def test_uthread():
    global passTestNum
    r.run_qemu(shell_script([
        'thrdtest1'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_DEFAULT"])

    if not re.findall(r"\[OK\] test_thrdstop_correct_timing", r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(4, "thrdtest2")
def test_uthread():
    global passTestNum
    r.run_qemu(shell_script([
        'thrdtest2'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_DEFAULT"])

    if not re.findall("\[OK\] test_cancelthrdstop_no_store_ctx", r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(4, "thrdtest3")
def test_uthread():
    global passTestNum
    r.run_qemu(shell_script([
        'thrdtest3'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_DEFAULT"])

    if not re.findall("\[OK\] test_cancelthrdstop_store_ctx", r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(4, "thrdtest4")
def test_uthread():
    global passTestNum
    r.run_qemu(shell_script([
        'thrdtest4'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_DEFAULT"])

    if not re.findall("\[OK\] test_multi_context", r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')


run_tests()

os.system("make clean")
