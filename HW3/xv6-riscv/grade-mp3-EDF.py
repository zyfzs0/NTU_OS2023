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
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_EDF"])
    expected = """dispatch thread#1 at 0: allocated_time=2
thread#1 finish one cycle at 2: 4 cycles left
dispatch thread#2 at 2: allocated_time=3
thread#2 finish one cycle at 5: 4 cycles left
dispatch thread#1 at 5: allocated_time=2
thread#1 finish one cycle at 7: 3 cycles left
dispatch thread#2 at 7: allocated_time=3
thread#2 finish one cycle at 10: 3 cycles left
dispatch thread#1 at 10: allocated_time=2
thread#1 finish one cycle at 12: 2 cycles left
dispatch thread#2 at 12: allocated_time=3
thread#2 finish one cycle at 15: 2 cycles left
dispatch thread#1 at 15: allocated_time=1
thread#1 misses a deadline at 16"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(3, "task2")
def test_uthread():
    r.run_qemu(shell_script([
        'task2'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_EDF"])
    expected = """dispatch thread#1 at 0: allocated_time=5
thread#1 finish one cycle at 5: 2 cycles left
dispatch thread#2 at 5: allocated_time=7
thread#2 finish one cycle at 12: 2 cycles left
dispatch thread#1 at 12: allocated_time=5
thread#1 finish one cycle at 17: 1 cycles left
dispatch thread#2 at 17: allocated_time=3
dispatch thread#1 at 20: allocated_time=5
thread#1 finish one cycle at 25: 0 cycles left
dispatch thread#2 at 25: allocated_time=4
thread#2 finish one cycle at 29: 1 cycles left
run_queue is empty, sleep for 3 ticks
dispatch thread#2 at 32: allocated_time=7
thread#2 finish one cycle at 39: 0 cycles left"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')

@test(3, "task3")
def test_uthread():
    r.run_qemu(shell_script([
        'task3'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_EDF"])
    expected = """dispatch thread#1 at 0: allocated_time=1
thread#1 finish one cycle at 1: 2 cycles left
dispatch thread#2 at 1: allocated_time=2
thread#2 finish one cycle at 3: 2 cycles left
dispatch thread#4 at 3: allocated_time=2
thread#4 finish one cycle at 5: 2 cycles left
dispatch thread#3 at 5: allocated_time=2
thread#3 finish one cycle at 7: 2 cycles left
dispatch thread#1 at 7: allocated_time=1
thread#1 finish one cycle at 8: 1 cycles left
dispatch thread#2 at 8: allocated_time=2
thread#2 finish one cycle at 10: 1 cycles left
dispatch thread#1 at 10: allocated_time=1
thread#1 finish one cycle at 11: 0 cycles left
dispatch thread#4 at 11: allocated_time=1
thread#4 misses a deadline at 12"""
    if not re.findall(expected, r.qemu.output, re.M):
        raise AssertionError('Output does not match expected output')
    
@test(3, "task4")
def test_uthread():
    r.run_qemu(shell_script([
        'task4'
    ]), make_args = ["SCHEDPOLICY=THREAD_SCHEDULER_EDF"])
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
