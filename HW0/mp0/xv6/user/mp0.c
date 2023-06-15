//#include<stdio.h>
//#include<string.h>
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/stat.h"
#include "kernel/fs.h"


struct mes {
    char path[100];
    char formal[100];
};

int ReadDir(char const* path, char const* formal, char ch0, int* dir_num, int* file_num) 		//¶ÁÈ¡ÎÄ¼þ
{
    char buf[512],temp[512],*q, * p;
    int fd;
    struct dirent de;
    struct stat st;
    if ((fd = open(path, 0)) < 0) {
        fprintf(2, "find: cannot open %s\n", formal);
        return -1;
    }

    if (fstat(fd, &st) < 0) {
        fprintf(2, "find: cannot stat %s\n", formal);
        return -1;
    }

    switch (st.type) {
        case T_FILE:
            break;
        case T_DIR:
            if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
                printf("find: path too long\n");
                break;
            }
            strcpy(buf, path);
            strcpy(temp, formal);
            p = buf + strlen(buf);
            q = temp + strlen(temp);
            *p++ = '/';
            *q++ = '/';
            while (read(fd, &de, sizeof(de)) == sizeof(de)) {
                if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
                    continue;
                memmove(p, de.name, DIRSIZ);
                p[DIRSIZ] = 0;
                memmove(q, de.name, DIRSIZ);
                q[DIRSIZ] = 0;
                if (stat(buf, &st) < 0) {
                    printf("find: cannot stat %s\n", buf);
                    continue;
                }
                if (st.type == T_DIR) {
                    (*dir_num)++;
                    int num = 0;
                    for (int i = 0; i < strlen(de.name); i++) {
                        if (de.name[i] == ch0)
                            num++;
                    }
                    for (int i = 0; i < strlen(path); i++) {
                        if (path[i] == ch0)
                            num++;
                    }
                    printf("%s/%s %d\n", formal, de.name, num);
             
                    ReadDir(buf,temp, ch0, dir_num, file_num);
                }
                else if (st.type == T_FILE) {
                    (*file_num)++;
                    int num = 0;
                    for (int i = 0; i < strlen(de.name); i++) {
                        if (de.name[i] == ch0)
                            num++;
                    }
                    for (int i = 0; i < strlen(path); i++) {
                        if (path[i] == ch0)
                            num++;
                    }
                    printf("%s/%s %d\n", formal, de.name, num);
                }
            }
            break;
    }
    close(fd);
    return 0;
}



int main(int argc, char* argv[])
{
    if (argc != 3) {
        printf("your format is wrong\n");
        exit(-1);
    }

    int pipes[2];
    pipe(pipes);

    int dir_num = 0, file_num = 0;

    if(fork() == 0){
        char ch0 = argv[2][0];
        int fd;
        struct mes startfile;
        strcpy(startfile.path, argv[1]);
        strcpy(startfile.formal, argv[1]);
        if (startfile.path[strlen(startfile.path) - 1] == '/') {
            int i;
            for (i = strlen(startfile.formal) - 1; i > 0; i--) {
                if (startfile.path[i] == '/' && startfile.path[i - 1] != '/') {
                    startfile.path[i] = '\0';
                    break;
                }
            }
        }
        if ((fd = open(startfile.path, 0)) < 0) {
            printf("%s [error opening dir]\n", startfile.formal);
        }
        else {
            close(fd);
            int num = 0;
            for (int i = 0; i < strlen(startfile.path); i++) {
                if (startfile.path[i] == ch0)
                    num++;
            }
            printf("%s %d\n", startfile.formal, num);
            ReadDir(startfile.path,startfile.formal, ch0,&dir_num,&file_num);
        }

        write(pipes[1], (char*)(&dir_num), 8);
        write(pipes[1], (char*)(&file_num), 8);

        exit(0);

    }
    else{
        read(pipes[0], (char*)(&dir_num), 8);
        read(pipes[0], (char*)(&file_num), 8);
        printf("\n%d directories, %d files\n", dir_num, file_num);
        wait(0);
        exit(0);
    }
}