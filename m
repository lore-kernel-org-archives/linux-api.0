From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/2] Add epoll round robin wakeup mode
Date: Mon, 9 Feb 2015 21:25:24 +0100
Message-ID: <CAHO5Pa2edof0bq8r+0sEVZqomLy7BU8b9=tYR6uwXLPPOT_TNA@mail.gmail.com>
References: <cover.1423509605.git.jbaron@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1423509605.git.jbaron@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, normalperson@yhbt.net, Davide Libenzi <davidel@xmailserver.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@vger.kernel.org]

Jason,

Since this is a kernel-user-space API change, please CC linux-api@.
The kernel source file Documentation/SubmitChecklist notes that all
Linux kernel patches that change userspace interfaces should be CCed
to linux-api@vger.kernel.org, so that the various parties who are
interested in API changes are informed. For further information, see
https://www.kernel.org/doc/man-pages/linux-api-ml.html


Thanks,

Michael


On Mon, Feb 9, 2015 at 9:05 PM, Jason Baron <jbaron@akamai.com> wrote:
> Hi,
>
> When we are sharing a wakeup source among multiple epoll fds, we end up with
> thundering herd wakeups, since there is currently no way to add to the
> wakeup source exclusively. This series introduces 2 new epoll flags,
> EPOLLEXCLUSIVE for adding to a wakeup source exclusively. And EPOLLROUNDROBIN
> which is to be used in conjunction to EPOLLEXCLUSIVE to evenly
> distribute the wakeups. I'm showing perf results from the simple pipe() usecase
> below. But this patch was originally motivated by a desire to improve
> wakeup balance and cpu usage for a shared listen socket().
>
> Perf stat, 3.19.0-rc7+, 4 core, Intel(R) Xeon(R) CPU E3-1265L v3 @ 2.50GHz:
>
> pipe test wake all:
>
>  Performance counter stats for './wake':
>
>       10837.480396      task-clock (msec)         #    1.879 CPUs utilized
>            2047108      context-switches          #    0.189 M/sec
>             214491      cpu-migrations            #    0.020 M/sec
>                247      page-faults               #    0.023 K/sec
>        23655687888      cycles                    #    2.183 GHz
>    <not supported>      stalled-cycles-frontend
>    <not supported>      stalled-cycles-backend
>        11242141621      instructions              #    0.48  insns per cycle
>         2313479486      branches                  #  213.470 M/sec
>           13679036      branch-misses             #    0.59% of all branches
>
>        5.768295821 seconds time elapsed
>
> pipe test wake balanced:
>
>  Performance counter stats for './wake -o':
>
>         291.250312      task-clock (msec)         #    0.094 CPUs utilized
>              40308      context-switches          #    0.138 M/sec
>               1448      cpu-migrations            #    0.005 M/sec
>                248      page-faults               #    0.852 K/sec
>          646407197      cycles                    #    2.219 GHz
>    <not supported>      stalled-cycles-frontend
>    <not supported>      stalled-cycles-backend
>          364256883      instructions              #    0.56  insns per cycle
>           65775397      branches                  #  225.838 M/sec
>             535637      branch-misses             #    0.81% of all branches
>
>        3.086694452 seconds time elapsed
>
> Rough epoll manpage text:
>
> EPOLLEXCLUSIVE
>         Provides exclusive wakeups when attaching multiple epoll fds to a
>         shared wakeup source. Must be specified on an EPOLL_CTL_ADD operation.
>
> EPOLLROUNDROBIN
>         Provides balancing for exclusive wakeups when attaching multiple epoll
>         fds to a shared wakeup soruce. Must be specificed with EPOLLEXCLUSIVE
>         during an EPOLL_CTL_ADD operation.
>
>
> Thanks,
>
> -Jason
>
> #include <unistd.h>
> #include <sys/epoll.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <pthread.h>
>
> #define NUM_THREADS 100
> #define NUM_EVENTS 20000
> #define EPOLLEXCLUSIVE (1 << 28)
> #define EPOLLBALANCED (1 << 27)
>
> int optimize, exclusive;
> int p[2];
> pthread_t threads[NUM_THREADS];
> int event_count[NUM_THREADS];
>
> struct epoll_event evt = {
>         .events = EPOLLIN
> };
>
> void die(const char *msg) {
>     perror(msg);
>     exit(-1);
> }
>
> void *run_func(void *ptr)
> {
>         int i = 0;
>         int j = 0;
>         int ret;
>         int epfd;
>         char buf[4];
>         int id = *(int *)ptr;
>         int *contents;
>
>         if ((epfd = epoll_create(1)) < 0)
>                 die("create");
>
>         if (optimize)
>                 evt.events |= ((EPOLLBALANCED | EPOLLEXCLUSIVE));
>         else if (exclusive)
>                 evt.events |= EPOLLEXCLUSIVE;
>         ret = epoll_ctl(epfd, EPOLL_CTL_ADD, p[0], &evt);
>         if (ret)
>                 perror("epoll_ctl add error!\n");
>
>         while (1) {
>                 ret = epoll_wait(epfd, &evt, 10000, -1);
>                 ret = read(p[0], buf, sizeof(int));
>                 if (ret == 4)
>                         event_count[id]++;
>         }
> }
>
> int main(int argc, char *argv[])
> {
>         int ret, i, j;
>         int id[NUM_THREADS];
>         int total = 0;
>         int nohit = 0;
>         int extra_wakeups = 0;
>
>         if (argc == 2) {
>                 if (strcmp(argv[1], "-o") == 0)
>                         optimize = 1;
>                 if (strcmp(argv[1], "-e") == 0)
>                         exclusive = 1;
>         }
>
>         if (pipe(p) < 0)
>                 die("pipe");
>
>         for (i = 0; i < NUM_THREADS; i++) {
>                 id[i] = i;
>                 pthread_create(&threads[i], NULL, run_func, &id[i]);
>         }
>
>         for (j = 0; j < NUM_EVENTS; j++) {
>                 write(p[1], p, sizeof(int));
>                 usleep(100);
>         }
>
>         for (i = 0; i < NUM_THREADS; i++) {
>                 pthread_cancel(threads[i]);
>                 printf("joined: %d\n", i);
>                 printf("event count: %d\n", event_count[i]);
>                 total += event_count[i];
>                 if (!event_count[i])
>                         nohit++;
>         }
>
>         printf("total events is: %d\n", total);
>         printf("nohit is: %d\n", nohit);
> }
>
>
> Jason Baron (2):
>   sched/wait: add round robin wakeup mode
>   epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN
>
>  fs/eventpoll.c                 | 25 ++++++++++++++++++++-----
>  include/linux/wait.h           | 11 +++++++++++
>  include/uapi/linux/eventpoll.h |  6 ++++++
>  kernel/sched/wait.c            |  5 ++++-
>  4 files changed, 41 insertions(+), 6 deletions(-)
>
> --
> 1.8.2.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
