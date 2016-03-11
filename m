From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Example program for PRIO_RGRP
Date: Fri, 11 Mar 2016 11:05:22 -0500
Message-ID: <20160311160522.GA24046@htj.duckdns.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457710888-31182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

The attached test-rgrp-burn.c is an example program making use of the
new PRIO_RGRP.  The test program creates rgroup the following rgroup
hierarchy

 sgroup - main thread
        + [rgroup-0] burner-0
        + [rgroup-1] + [rgroup-2] burner-1
                     + [rgroup-3] burner-2

and takes upto 4 arguments respectively specifying the nice level for
each rgroup.  Each burner thread executes CPU burning loops and
periodically prints out how many loops it has completed.

* "./test-rgrp-burn"

If the program is run without any argument, on a kernel which doesn't
support rgroup, or from a cgroup where cpu controller is not
available, the three burner threads would run at about equivalent
speeds.

* "./test-rgrp-burn 0" from a cgroup w/ cpu controller

cpu controller is enabled across the top-level, so rgroup-0 and
rgroup-1 would compete on equal footing, so burner-0 runs twice as
fast as burner-1 or burner-2.

* "./test-rgrp-burn 0 3 -1 2" from a cgroup w/ cpu controller

cpu controller is enabled at both levels.  Nice level difference of 3
is about twice difference in weight, so the ratio would roughly be

  burner-0 : burner-1 : burner-2 ~= 3 : 2 : 1

Thanks.

-- 
tejun

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="test-rgrp-burn.c"

/*
 * test-rgrp-burn - rgrp test program
 *
 * Creates the following rgrp hierarchy of three CPU cycle burner
 * threads.
 *
 * sgrp - main thread
 *      + [rgrp-0] burner thread
 *      + [rgrp-1] + [rgrp-2] nested burner thread
 *                 + [rgrp-3] nested burner thread
 *
 * Takes upto 4 arguments specifying the nice level of each rgrp.
 */
#define _GNU_SOURCE

#include <sys/types.h>
#include <sys/wait.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <limits.h>
#include <pthread.h>
#include <sys/syscall.h>
#include <sys/time.h>
#include <sys/resource.h>

#define CLONE_NEWRGRP		0x00001000	/* New resource group */
#define PRIO_RGRP		3
#define STACK_SIZE		(4 * 1024 * 1024)
#define CLONE_THREAD_FLAGS	(CLONE_THREAD | CLONE_SIGHAND | CLONE_VM |	\
				 CLONE_FS | CLONE_FILES)

static int nice_val[] = { [0 ... 3] = INT_MIN };

static pthread_mutex_t lprintf_mutex;

#define lprintf(fmt, args...)	do {						\
	pthread_mutex_lock(&lprintf_mutex);					\
	printf(fmt, ##args);							\
	pthread_mutex_unlock(&lprintf_mutex);					\
} while (0)

static int gettid(void)
{
	return syscall(SYS_gettid);
}

static int burner_fn(void *arg)
{
	unsigned long a = 37, cnt = 0;

	sleep(1);

	lprintf("burner : %d started\n", gettid());

	while (1) {
		*(volatile unsigned long *)&a = a * 37 / 13 + 53;
		*(volatile unsigned long *)&a = a * 37 / 13 + 53;
		*(volatile unsigned long *)&a = a * 37 / 13 + 53;
		*(volatile unsigned long *)&a = a * 37 / 13 + 53;
		*(volatile unsigned long *)&a = a * 37 / 13 + 53;
		*(volatile unsigned long *)&a = a * 37 / 13 + 53;
		*(volatile unsigned long *)&a = a * 37 / 13 + 53;
		*(volatile unsigned long *)&a = a * 37 / 13 + 53;

		if (!(++cnt % (1000000 * 100))) {
			int prio;

			errno = 0;
			prio = getpriority(PRIO_RGRP, 0);
			lprintf("burner : %d finished %lum loops (rgrp nice=%d errno=%d)\n",
				gettid(), cnt / 1000000, prio, errno);
		}
	}

	return 0;
}

static void rgrp_setprio(pid_t pid, int nice)
{
	if (nice == INT_MIN)
		return;

	lprintf("setprio: setting PRIO_RGRP to %d on %d\n", nice, pid);
	if (setpriority(PRIO_RGRP, pid, nice))
		perror("setpriority");
}

static int child_fn(void *arg)
{
	char *stack;
	pid_t pid;

	stack = malloc(STACK_SIZE) + STACK_SIZE;
	pid = clone(burner_fn, stack, CLONE_THREAD_FLAGS | CLONE_NEWRGRP, NULL);
	lprintf("child  : cloned nested burner %d\n", pid);
	rgrp_setprio(pid, nice_val[2]);

	stack = malloc(STACK_SIZE) + STACK_SIZE;
	pid = clone(burner_fn, stack, CLONE_THREAD_FLAGS | CLONE_NEWRGRP, NULL);
	lprintf("child  : cloned nested burner %d\n", pid);
	rgrp_setprio(pid, nice_val[3]);

	sleep(500);
	return 0;
}

int main(int argc, char **argv)
{	
	char *stack;
	pid_t pid;
	int i;

	if (argc > 5)
		argc = 5;

	for (i = 1; i < argc; i++)
		nice_val[i - 1] = atoi(argv[i]);

	pthread_mutex_init(&lprintf_mutex, NULL);

	stack = malloc(STACK_SIZE) + STACK_SIZE;
	pid = clone(burner_fn, stack, CLONE_THREAD_FLAGS | CLONE_NEWRGRP, NULL);
	lprintf("main   : cloned burner %d\n", pid);
	rgrp_setprio(pid, nice_val[0]);

	stack = malloc(STACK_SIZE) + STACK_SIZE;
	pid = clone(child_fn, stack, CLONE_THREAD_FLAGS | CLONE_NEWRGRP, NULL);
	lprintf("main   : cloned child %d\n", pid);
	rgrp_setprio(pid, nice_val[1]);

	sleep(500);
	return 0;
}

--gBBFr7Ir9EOA20Yy--
