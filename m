From: Kazimierz Krosman <k.krosman-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v6 0/8] Additional kmsg devices
Date: Wed, 24 Feb 2016 12:53:13 +0100
Message-ID: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pmladek-AlSwsSmVLrQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, k.krosman-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, knhoon.baik-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Dear All,

This is the sixth iteration of Marcin Niesluchowski's series of patches
extending kmsg interface with ability to dynamically create (and destroy)
kmsg-like devices which can be used by userspace for logging,

Changed from v5:

 * ioctl that adds kmsg device with minor number higher than 255 returns
   with error. This is because of registering kmsg as character device with
   register_chrdev which creates 256 minor numbers for a given major.

 * minor fix for selftest- changed size of message to write.
   Previous value causes exceeding of LOG_LINE_MAX limits.

 * dropped RFC tag in subject.

 * rebased patches v5 on Linux v4.5-rc5.

Changes from v4:

 * selftests are rearranged to use kselftest.h API

 * a disputed patch "add predefined _PID, _TID, _COMM keywords to kmsg*
   log dict" is removed - no chance it will be ever accepted. It is not
   critical for this patchset as a whole.

Changes from v3:

 * fixes problems spotted by kbuild test robot

 * fiesed problem with inproper use of copy_from_user()

Changes from v2:

 * Extracted kmsg related functions from printk.c to a new file, kmsg.c

Changes from v1:

 * all occurences of '#ifdef CONFIG_PRINTK' removed from drivers/char/mem.c

 * printk related code moved to kernel/printk/printk.c

 * use of VMCOREINFO_STRUCT_SIZE

 * selftests for kmsg added (shape of testing infrastructure based on
   kdbus selftests)

We would like to share our opinion about this changes. We see following advantages
of the proposed extensions to kmsg interface:

1. kmsg device does not require maintenance by reader process side.
Multiple writers can write to a device and new records overwrite logs saved earlier.
When system crashes logs can be restored with pstore mechanism.

2. Using kmsg can cause lower CPU utilisation in the real-word use case than 
userspace logging mechanisms.
We created 2 tests: (1) 100 writer processes write to created kmsg buffer and
(2) 100 writers write to socket (stream)- there is one reader to protect
socket buffer against overflow. Tests show that cpu utilisation in case of first
test is about 2.3 times lower (39.1%) than it is in second case (87.7%) (measured
with top program; tests code is attached below). Tested on Odroid XU4.

Possible future enhancements:
1. It is possible to extend kmsg interface with ioctl that is blockingi read process
until the cyclic buffer is almost full (for example 3/4 of max size). This
modification can enable efficient read of records and prevents against cyclic buffer
overwriting.

2. Maybe we should consider to set some global and local limit for creating
additional buffer. In current version of patches it is possible to create buffers
as long as minor is below 256 and there is a free memory (ioctl fail if kmalloc fail).
It means that it is possible to allocate whole kernel memory for kmsg devices.

Best regards,
Kazimierz Krosman

Marcin Niesluchowski (6):
  printk: add one function for storing log in proper format
  kmsg: introduce additional kmsg devices support
  kmsg: add additional buffers support to memory class
  kmsg: add function for adding and deleting additional buffers
  kmsg: add ioctl for adding and deleting kmsg* devices
  kmsg: add ioctl for kmsg* devices operating on buffers

Paul Osmialowski (2):
  printk: extract kmsg-related routines from printk.c to kmsg.c
  kmsg: selftests

 Documentation/ioctl/ioctl-number.txt               |    1 +
 drivers/char/mem.c                                 |   27 +-
 fs/proc/kmsg.c                                     |    4 +-
 include/linux/printk.h                             |   48 +
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/kmsg_ioctl.h                    |   45 +
 kernel/printk/Makefile                             |    1 +
 kernel/printk/kmsg.c                               | 1022 ++++++++++++++++
 kernel/printk/printk.c                             | 1255 +++++---------------
 kernel/printk/printk.h                             |  260 ++++
 samples/kmsg/kmsg-api.h                            |   44 +
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/kmsg/.gitignore            |    1 +
 tools/testing/selftests/kmsg/Makefile              |   30 +
 tools/testing/selftests/kmsg/kmsg-test.c           |  344 ++++++
 tools/testing/selftests/kmsg/kmsg-test.h           |   28 +
 tools/testing/selftests/kmsg/test-buffer-add-del.c |   78 ++
 .../kmsg/test-buffer-add-write-read-del.c          |  163 +++
 .../kmsg/test-buffer-buf-multithreaded-torture.c   |  201 ++++
 .../selftests/kmsg/test-buffer-buf-torture.c       |  141 +++
 20 files changed, 2725 insertions(+), 970 deletions(-)
 create mode 100644 include/uapi/linux/kmsg_ioctl.h
 create mode 100644 kernel/printk/kmsg.c
 create mode 100644 kernel/printk/printk.h
 create mode 100644 samples/kmsg/kmsg-api.h
 create mode 100644 tools/testing/selftests/kmsg/.gitignore
 create mode 100644 tools/testing/selftests/kmsg/Makefile
 create mode 100644 tools/testing/selftests/kmsg/kmsg-test.c
 create mode 100644 tools/testing/selftests/kmsg/kmsg-test.h
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-add-del.c
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-add-write-read-del.c
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-buf-multithreaded-torture.c
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-buf-torture.c

-- 
1.9.1

Attached Test programs:
(1) kmsg_test.c
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/time.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <linux/kmsg_ioctl.h>


enum { ARGS_NUM_MAX = 4};
int MSG_COUNT = 1024*102;
int MSG_SIZE = 256;
int KMSG_SIZE = 1024;
int WRITERS_NUM = 100;

int* args[ARGS_NUM_MAX] = {&KMSG_SIZE, &WRITERS_NUM, &MSG_SIZE, &MSG_COUNT};

int main_minor = 0;
int main_fd = 0;

static int print_help(char* name)
{
    printf( "Usage:  %s [KMSG_SIZE [WRITERS_NUM [MSG_SIZE [MSG_COUNT]]]]\n"
            "Example call: %s 1024 10 256 1048576\n"
            "\nOption description:\n"
            "\tKMSG_SIZE: size of buffer created with ioctl on /dev/kmsg\n"
            "\tWRITER_NUM: number of process that writes to created buffer\n"
            "\tMSG_SIZE: size of message\n"
            "\tMSG_COUNT: number of write() calls done by each writer\n"
            "\n\n", name, name
        );
}

static int kmsg_cmd_buffer_add(char* path)
{
    struct kmsg_cmd_buffer_add cmd;
    int ret;
    int fd = open("/dev/kmsg", O_RDWR);
    
    if (fd < 0) 
    {
        fprintf(stderr, "Cannot open /dev/kmsg: fd=%d, errno=%d\n", fd, errno);
        exit(EXIT_FAILURE);
    }
    cmd.size = KMSG_SIZE;
    cmd.mode = 0662;
    
    ret = ioctl(fd, KMSG_CMD_BUFFER_ADD, &cmd);
    if (ret < 0)
    {
        fprintf(stderr, "ioctl failed (size=%lld, mode=0%o) = return=%d, errno=%d\n", cmd.size, cmd.mode, ret, errno);
        exit(EXIT_FAILURE);
    }
    
    main_minor = cmd.minor;
    snprintf(path, 80, "/dev/kmsg%d", main_minor);
    printf("Created device: %s\n", path);
    main_fd = fd;
    return (ret < 0) ? (errno > 0 ? -errno : -EINVAL) : 0;
}

static void kmsg_cmd_buffer_del()
{
    int ret;
    ret = ioctl(main_fd, KMSG_CMD_BUFFER_DEL, &main_minor);
    printf("Deleted /dev/kmsg%d %d %d\n",  main_minor, ret, errno);
    close(main_fd);
}

static void fail()
{
    kmsg_cmd_buffer_del();
    exit(EXIT_FAILURE);
}

int main(int argc , char *argv[])
{
    char path[80];
    char buf[MSG_SIZE];
    size_t size;
    struct timeval start, end;
    int i, fd, forked, pid;
    forked = 0;

    if (argc > 1)
    {
        int i = 0;
        while ( i < ARGS_NUM_MAX  && i+1 < argc)
            *(args[i++]) = atoi(argv[i]);
    } else 
        print_help(argv[0]);

    printf("Test parameters: KMSG_SIZE=%d, WRITERS_NUM=%d, MSG_SIZE=%d, MSG_COUNT=%d\n", KMSG_SIZE, WRITERS_NUM, MSG_SIZE, MSG_COUNT);

    kmsg_cmd_buffer_add(path);

    if(argc == (ARGS_NUM_MAX+2))
    {
        fd = open(path, O_WRONLY);
        if (fd < 0)
        {
            fprintf(stderr, "open failed: %s (fd=%d, errno=%d)\n", path, fd, errno);
            fail();
        }

        return 0;
    }

    for (i = 0;i<WRITERS_NUM;i++)
    {
        if(!fork())
        {
            forked =1;
            break;
        }
    }

    if (!forked)
    {
        if (-1 == gettimeofday(&start, 0)) {
            fprintf(stderr, "gettimeofday failed\n");
            fail();
        }
        printf("%ld.%06ld\n", start.tv_sec, start.tv_usec);
    } else {
        fd = open(path, O_WRONLY);
        if (fd < 0)
        {
            fprintf(stderr, "open failed: %s (fd=%d, errno=%d)\n", path, fd, errno);
            exit(EXIT_FAILURE);
        }

        for(i=0; i<MSG_COUNT; i++)
            if (write(fd, buf, MSG_SIZE) < 0) {
                fprintf(stderr, "Write failed. %s\n", strerror(errno));
                exit(EXIT_FAILURE);
            }
        return 0;
    }

    while (pid = waitpid(-1, NULL, 0))
        if (errno == ECHILD)
            break;

    if (-1 == gettimeofday(&end, 0)) {
        fprintf(stderr, "gettimeofday failed\n");
        fail();
    }

    printf("%ld.%06ld\n", end.tv_sec, end.tv_usec);

    printf("Time: %ld us\n", (end.tv_sec-start.tv_sec)*1000000 + end.tv_usec - start.tv_usec);
    kmsg_cmd_buffer_del();
    return 0;
}
//-------------------------------------------------------------------------------------------
(2) stream_test.c
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/time.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/epoll.h>

#define SOCKET_PATH "/var/run/test_socket"
enum {MSG_MAX_SIZE  = 8192};
int WRT_NUM   = 100; //WRITERS_NUMBER
enum { ARGS_NUM_MAX = 3};
int MSG_COUNT = 1024*102;
int MSG_SIZE = 256;

char buf[MSG_MAX_SIZE];
int sd;

static int print_help(char* name)
{
    printf( "Usage:  %s [WRITERS_NUM [MSG_SIZE [MSG_COUNT]]]\n"
            "Example call: %s 10 256 1048576\n"
            "\nOption description:\n"
            "\tWRITERS_NUM: number of process that writes to created buffer\n"
            "\tMSG_SIZE: size of message\n"
            "\tMSG_COUNT: number of write() calls done by each writer\n"
            "\n\n", name, name
        );
}

void prepare_server()
{
    struct sockaddr_un server_addr;
    sd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sd == -1) {
        fprintf(stderr, "Could not create socket");
        exit(EXIT_FAILURE);
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sun_family = AF_UNIX;
    strcpy(server_addr.sun_path, SOCKET_PATH);
    unlink(server_addr.sun_path);

    if (bind(sd, (struct sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
        fprintf(stderr, "Bind failed");
        exit(EXIT_FAILURE);
    }

    if (listen(sd, 5) == -1) {
        fprintf(stderr, "Listen failed");
        exit(EXIT_FAILURE);
    }

}


void do_server()
{
    struct sockaddr_un client_addr;
    long long int readed_size = 0;
    long long int to_read = (MSG_COUNT*MSG_SIZE*(long long int)WRT_NUM);
    int i = 0, conn_sock, epollfd, nfds, flags;
    unsigned int client_len = sizeof(client_addr);
    ssize_t size_one;
    struct epoll_event ev, events[WRT_NUM+1];

    epollfd = epoll_create1(0);
    if (epollfd == -1) {
        perror("epoll_create1");
        exit(EXIT_FAILURE);
    }

    ev.events = EPOLLIN;
    ev.data.fd = sd;
    if (epoll_ctl(epollfd, EPOLL_CTL_ADD, sd, &ev) == -1) {
        perror("epoll_ctl: listen_sock");
        exit(EXIT_FAILURE);
    }

    for (;;) {
        nfds = epoll_wait(epollfd, events, WRT_NUM+1, -1);
        if (nfds == -1) {
            perror("epoll_wait");
            exit(EXIT_FAILURE);
        }

        for (i=0; i < nfds; ++i) {
            if (events[i].data.fd == sd) {
                conn_sock = accept(sd,
                                    (struct sockaddr *) &client_addr, &client_len);
                if (conn_sock == -1) {
                    perror("accept");
                    exit(EXIT_FAILURE);
                }
                ev.events = EPOLLIN;
                ev.data.fd = conn_sock;
                flags = fcntl(conn_sock, F_GETFL, 0);
                fcntl(conn_sock, F_SETFL, flags | O_NONBLOCK);
                if (epoll_ctl(epollfd, EPOLL_CTL_ADD, conn_sock, &ev) == -1) {
                    perror("epoll_ctl: conn_sock");
                    exit(EXIT_FAILURE);
                }
            } else {
                size_one = read(events[i].data.fd, buf, MSG_MAX_SIZE);
                if (size_one == 0 && events[i].events & EPOLLHUP)
                    close(events[i].data.fd);
                readed_size += size_one;
            }
        }
        if (readed_size >= to_read)
            return;
    }
}

int main(int argc , char *argv[])
{
    int sd;
    struct sockaddr_un client_addr;
    size_t size;
    ssize_t size_one;
    struct timeval start;
    struct timeval end;
    int pid, i;
    int forked=0;

    int* args[ARGS_NUM_MAX] = {&WRT_NUM, &MSG_SIZE, &MSG_COUNT};

    if (argc > 1)
    {
        int i = 0;
        while ( i < ARGS_NUM_MAX  && i+1 < argc)
            *(args[i++]) = atoi(argv[i]);
    } else
        print_help(argv[0]);

    printf("Test parameters: WRITERS_NUM=%d, MSG_SIZE=%d, MSG_COUNT=%d\n", WRT_NUM, MSG_SIZE, MSG_COUNT);
    prepare_server();

    for (i=0;i<WRT_NUM;i++)
        if (!fork())
        {
            forked=1;
            break;
        }

    if (!forked)
    {
        if (-1 == gettimeofday(&start, 0)) {
            fprintf(stderr, "gettimeofday failed");
            exit(EXIT_FAILURE);
        }
        printf("%ld.%06ld\n", start.tv_sec, start.tv_usec);
    } else
    {
        sd = socket(AF_UNIX, SOCK_STREAM, 0);
        if (sd == -1) {
            fprintf(stderr, "Could not create socket");
            exit(EXIT_FAILURE);
        }

        memset(&client_addr, 0, sizeof(client_addr));
        client_addr.sun_family = AF_UNIX;
        strcpy(client_addr.sun_path, SOCKET_PATH);

        if (connect(sd, (struct sockaddr*)&client_addr, sizeof(client_addr)) == -1) {
            fprintf(stderr, "Connect failed");
            exit(EXIT_FAILURE);
        }

        for(i=0; i<MSG_COUNT; i++) {
            if (write(sd, buf, MSG_SIZE) < 0) {
                fprintf(stderr, "Write failed. %s", strerror(errno));
                exit(EXIT_FAILURE);
            }
        }
        return 0;
    }
    do_server();

    while (pid = waitpid(-1, NULL, 0))
        if (errno == ECHILD)
            break;

    if (-1 == gettimeofday(&end, 0)) {
        fprintf(stderr, "gettimeofday failed");
        exit(EXIT_FAILURE);
    }

    printf("%ld.%06ld\n", end.tv_sec, end.tv_usec);
    printf("Time: %ld us\n", (end.tv_sec-start.tv_sec)*1000000 + end.tv_usec - start.tv_usec);

    return 0;
}
