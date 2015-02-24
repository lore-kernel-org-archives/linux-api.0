From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Tue, 24 Feb 2015 21:25:39 +0000 (GMT)
Message-ID: <cover.1424805740.git.jbaron@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, luto@amacapital.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

When we are sharing a wakeup source among multiple epoll fds, we end up with
thundering herd wakeups, since there is currently no way to add to the
wakeup source exclusively. This series introduces a new EPOLL_ROTATE flag
to allow for round robin exclusive wakeups.

I believe this patch series addresses the two main concerns that were raised in
prior postings. Namely, that it affected code (and potentially performance)
of the core kernel wakeup functions, even in cases where it was not strictly
needed, and that it could lead to wakeup starvation (since we were are no
longer waking up all waiters). It does so by adding an extra layer of
indirection, whereby waiters are attached to a 'psuedo' epoll fd, which in turn
is attached directly to the wakeup source.

Patch 1 introduces the required wakeup hooks. This could be restricted to just
the epoll code, but I added them to the generic code in case other ppl might
find them useful.

Patch 2 adds an optimization to the epoll wakeup code that allows EPOLL_ROTATE
to work optimally, however it could be its own standalone patch.

Finally, patch 3 adds the EPOLL_ROTATE, and documents the API usage.

I'm also inlining test code making use of this interface, which shows roughly
a 50% speedup, similar to my previous results: http://lwn.net/Articles/632590/.

Sample epoll_create1 manpage text:

EPOLL_ROTATE
	Set the 'exclusive rotation' rotation flag on the new file descriptor.
	This new file descriptor can be added via epoll_ctl() to at most 1
	non-epoll file descriptors. Any epoll fds addeded directory to the
	new file descriptor via epoll_ctl() will be woken up in a round robin
	exclusive manner.

Thanks,

-Jason

v3:
-restrict epoll exclusive rotate wakeups to within the epoll code
-Add epoll optimization for overflow list

Jason Baron (3):
  sched/wait: add __wake_up_rotate()
  epoll: limit wakeups to the overflow list
  epoll: Add EPOLL_ROTATE mode

 fs/eventpoll.c                 | 52 +++++++++++++++++++++++++++++++++++-------
 include/linux/wait.h           |  1 +
 include/uapi/linux/eventpoll.h |  4 ++++
 kernel/sched/wait.c            | 27 ++++++++++++++++++++++
 4 files changed, 76 insertions(+), 8 deletions(-)

-- 
1.8.2.rc2



#include <unistd.h>
#include <sys/epoll.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NUM_THREADS 100
#define NUM_EVENTS 20000
#define EPOLLEXCLUSIVE (1 << 28)
#define EPOLLBALANCED (1 << 27)

int optimize, exclusive;
int p[2];
int ep_src_fd;
pthread_t threads[NUM_THREADS];
int event_count[NUM_THREADS];

struct epoll_event evt = {
	.events = EPOLLIN 
};

void die(const char *msg) {
    perror(msg);
    exit(-1);
}

void *run_func(void *ptr)
{
	int i = 0;
	int j = 0;
	int ret;
	int epfd;
	char buf[4];
	int id = *(int *)ptr;
	int *contents;

	if ((epfd = epoll_create(1)) < 0)
		die("create");

	ret = epoll_ctl(epfd, EPOLL_CTL_ADD, ep_src_fd, &evt);
	if (ret)
		perror("epoll_ctl add error!\n");

	while (1) { 
    		ret = epoll_wait(epfd, &evt, 10000, -1);
		ret = read(p[0], buf, sizeof(int));
		if (ret == 4)
			event_count[id]++;
	}
}

#define EPOLL_ROTATE 1

int main(int argc, char *argv[])
{
	int ret, i, j;
	int id[NUM_THREADS];
	int total = 0;
	int nohit = 0;
	int extra_wakeups = 0;

	if (argc == 2) {
		if (strcmp(argv[1], "-o") == 0)
			optimize = 1;
		if (strcmp(argv[1], "-e") == 0)
			exclusive = 1;
	}

	if (pipe(p) < 0)
		die("pipe");
	if (optimize) {
		if ((ep_src_fd = epoll_create1(EPOLL_ROTATE)) < 0)
			die("create");
	} else {
		if ((ep_src_fd = epoll_create1(0)) < 0)
			die("create");
	}
			
	ret = epoll_ctl(ep_src_fd, EPOLL_CTL_ADD, p[0], &evt);
	if (ret)
		perror("epoll_ctl add core error!\n");

	for (i = 0; i < NUM_THREADS; i++) {
		id[i] = i;
		pthread_create(&threads[i], NULL, run_func, &id[i]);
	} 

	for (j = 0; j < NUM_EVENTS; j++) {
		write(p[1], p, sizeof(int));
		usleep(100);
	}

	for (i = 0; i < NUM_THREADS; i++) {
		pthread_cancel(threads[i]);
		printf("joined: %d\n", i);
		printf("event count: %d\n", event_count[i]);
		total += event_count[i];
		if (!event_count[i])
			nohit++;
	} 

	printf("total events is: %d\n", total);
	printf("nohit is: %d\n", nohit);
}
