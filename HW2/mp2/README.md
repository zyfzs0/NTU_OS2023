# NTU OS 2022 -  MP2

## About the Tests

There are 5 test programs for this assignment, respectively named `mp2_N` with `N = 1, ..., 5`. The source code can be found at `user/mp2_N.c`.


- `mp2_1`

  `vmprint()` test.

- `mp2_2`

  `sbrk()` test and page fault test.

- `mp2_3`

  `madvise()` test with `MADV_NORMAL` and `MADV_DONTNEED` options.

- `mp2_4`

  `madvise()` test with `MADV_WILLNEED` options.

- `mp2_4`

  Page fault test on swapped page.

## Run the Public Judge

Run `make STUDENT_ID=d10922013 zip` to create zip archive to be tested
and to be submitted. The archived files are organized in the
structure.

```
d10922013/
`--xv6/
    |-- Makefile
    |-- kernel/
    |-- user/
    |-- mkfs/
    `-- ...
```

Run the `judge` binary shipped with the template. It will produce
judge reports in the directory `2023-02-15_14-54-36_mp2-judge/` named
by the date and time.

```sh
./judge d10922013.zip
```

## Run Tests Manually

To enter the xv6 shell on QEMU,

```sh
make clean
make qemu
```

Then, you can run `mp2_N` programs manually.


To escape from the QEMU, open another terminal and run:

```sh
killall qemu-system-riscv64
```
