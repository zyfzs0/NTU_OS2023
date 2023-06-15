#!/usr/bin/env python3

import re
from gradelib import *

import os

os.system("make clean")
r = Runner(save("xv6.out"))

@test(3, "task1")
def test_uthread():
    r.run_qemu(shell_script([
        'task1'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_RM"])
    expected = """dispatch thread#1 at 0: allocated_time=2
thread#1 finish one cycle at 2: 4 cycles left
dispatch thread#2 at 2: allocated_time=2
dispatch thread#1 at 4: allocated_time=2
thread#1 finish one cycle at 6: 3 cycles left
thread#2 misses a deadline at 5"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(3, "task2")
def test_uthread():
    r.run_qemu(shell_script([
        'task2'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_RM"])
    expected = """dispatch thread#1 at 0: allocated_time=5
thread#1 finish one cycle at 5: 2 cycles left
dispatch thread#2 at 5: allocated_time=5
dispatch thread#1 at 10: allocated_time=5
thread#1 finish one cycle at 15: 1 cycles left
dispatch thread#2 at 15: allocated_time=1
thread#2 misses a deadline at 16"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(3, "task3")
def test_uthread():
    r.run_qemu(shell_script([
        'task3'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_RM"])
    expected = """dispatch thread#1 at 0: allocated_time=1
thread#1 finish one cycle at 1: 2 cycles left
dispatch thread#2 at 1: allocated_time=2
thread#2 finish one cycle at 3: 2 cycles left
dispatch thread#4 at 3: allocated_time=1
dispatch thread#1 at 4: allocated_time=1
thread#1 finish one cycle at 5: 1 cycles left
dispatch thread#2 at 5: allocated_time=2
thread#2 finish one cycle at 7: 1 cycles left
thread#3 misses a deadline at 7"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')
    
@test(3, "task4")
def test_uthread():
    r.run_qemu(shell_script([
        'task4'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_RM"])
    expected = """dispatch thread#1 at 0: allocated_time=3
thread#1 finish one cycle at 3: 2 cycles left
dispatch thread#1 at 3: allocated_time=3
thread#1 finish one cycle at 6: 1 cycles left
dispatch thread#1 at 6: allocated_time=3
thread#1 finish one cycle at 9: 0 cycles left"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

run_tests()
os.system("make clean")
