#!/usr/bin/env python3

import os

total_score = 0
max_score = 0

# test the syscalls
print("******************** syscalls ********************")
result = os.popen("python3 grade-mp3-syscalls.py").read()
score_line = [ln for ln in result.split("\n") if ln.startswith("Score:")][0]
scores = score_line.split("Score: ")[1].split("/")
total_score += int(scores[0])
max_score += int(scores[1])
print(f"syscalls score: {scores[0]}/{scores[1]}")

for algo in ["EDF", "RM"]:
    print(f"******************** {algo} ********************")
    result = os.popen(f"python3 grade-mp3-{algo}.py").read()
    score_line = [ln for ln in result.split("\n") if ln.startswith("Score:")][0]
    scores = score_line.split("Score: ")[1].split("/")
    total_score += int(scores[0])
    max_score += int(scores[1])
    print(f"{algo} scheduler score: {scores[0]}/{scores[1]}")


print("\n******************** Verdict ********************")
print(f'your score is {total_score}/{max_score}')
