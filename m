From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 1/6] selftests: Add futex functional tests
Date: Tue, 12 May 2015 21:07:52 -0700
Message-ID: <077301628833a25c85ee597cd8f4b8fcc3f30714.1431489408.git.dvhart@linux.intel.com>
References: <cover.1431489408.git.dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1431489408.git.dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: chrubis-AlSwsSmVLrQ@public.gmane.org, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The futextest testsuite [1] provides functional, stress, and
performance tests for the various futex op codes. Those tests will be o=
f
more use to futex developers if they are included with the kernel
source.

Copy the core infrastructure and the functional tests into selftests,
but adapt them for inclusion in the kernel:

- Update the Makefile to include the run_tests target, remove reference
  to the performance and stress tests from the contributed sources.
- Replace my dead IBM email address with my current Intel email address=
=2E
- Remove the warrantee and write-to paragraphs from the license blurbs.
- Remove the NAME section as the filename is easily determined. ;-)
- Make the whitespace usage consistent in a couple of places.
- Cleanup various CodingStyle violations.

A future effort will explore moving the performance and stress tests
into the kernel.

1. http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git

Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Signed-off-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 tools/testing/selftests/futex/Makefile             |  11 +
 tools/testing/selftests/futex/README               |  62 ++++
 tools/testing/selftests/futex/functional/Makefile  |  24 ++
 .../selftests/futex/functional/futex_requeue_pi.c  | 409 +++++++++++++=
++++++++
 .../functional/futex_requeue_pi_mismatched_ops.c   | 135 +++++++
 .../functional/futex_requeue_pi_signal_restart.c   | 223 +++++++++++
 .../functional/futex_wait_private_mapped_file.c    | 125 +++++++
 .../futex/functional/futex_wait_timeout.c          |  86 +++++
 .../functional/futex_wait_uninitialized_heap.c     | 124 +++++++
 .../futex/functional/futex_wait_wouldblock.c       |  79 ++++
 tools/testing/selftests/futex/functional/run.sh    |  79 ++++
 tools/testing/selftests/futex/include/atomic.h     |  83 +++++
 tools/testing/selftests/futex/include/futextest.h  | 266 +++++++++++++=
+
 tools/testing/selftests/futex/include/logging.h    | 150 ++++++++
 tools/testing/selftests/futex/run.sh               |  33 ++
 15 files changed, 1889 insertions(+)
 create mode 100644 tools/testing/selftests/futex/Makefile
 create mode 100644 tools/testing/selftests/futex/README
 create mode 100644 tools/testing/selftests/futex/functional/Makefile
 create mode 100644 tools/testing/selftests/futex/functional/futex_requ=
eue_pi.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_requ=
eue_pi_mismatched_ops.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_requ=
eue_pi_signal_restart.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_wait=
_private_mapped_file.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_wait=
_timeout.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_wait=
_uninitialized_heap.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_wait=
_wouldblock.c
 create mode 100755 tools/testing/selftests/futex/functional/run.sh
 create mode 100644 tools/testing/selftests/futex/include/atomic.h
 create mode 100644 tools/testing/selftests/futex/include/futextest.h
 create mode 100644 tools/testing/selftests/futex/include/logging.h
 create mode 100755 tools/testing/selftests/futex/run.sh

diff --git a/tools/testing/selftests/futex/Makefile b/tools/testing/sel=
ftests/futex/Makefile
new file mode 100644
index 0000000..2c26d59
--- /dev/null
+++ b/tools/testing/selftests/futex/Makefile
@@ -0,0 +1,11 @@
+SUBDIRS :=3D functional
+
+.PHONY: all clean
+all:
+	for DIR in $(SUBDIRS); do $(MAKE) -C $$DIR $@ ; done
+
+run_tests: all
+	./run.sh
+
+clean:
+	for DIR in $(SUBDIRS); do $(MAKE) -C $$DIR $@ ; done
diff --git a/tools/testing/selftests/futex/README b/tools/testing/selft=
ests/futex/README
new file mode 100644
index 0000000..3224a04
--- /dev/null
+++ b/tools/testing/selftests/futex/README
@@ -0,0 +1,62 @@
+Futex Test
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Futex Test is intended to thoroughly test the Linux kernel futex syste=
m call
+API.
+
+Functional tests shall test the documented behavior of the futex opera=
tion
+code under test. This includes checking for proper behavior under norm=
al use,
+odd corner cases, regression tests, and abject abuse and misuse.
+
+Futextest will also provide example implementation of mutual exclusion
+primitives. These can be used as is in user applications or can serve =
as
+examples for system libraries. These will likely be added to either a =
new lib/
+directory or purely as header files under include/, I'm leaning toward=
 the
+latter.
+
+Quick Start
+-----------
+# make
+# ./run.sh
+
+Design and Implementation Goals
+-------------------------------
+o Tests should be as self contained as is practical so as to facilitat=
e sharing
+  the individual tests on mailing list discussions and bug reports.
+o The build system shall remain as simple as possible, avoiding any ar=
chive or
+  shared object building and linking.
+o Where possible, any helper functions or other package-wide code shal=
l be
+  implemented in header files, avoiding the need to compile intermedia=
te object
+  files.
+o External dependendencies shall remain as minimal as possible. Curren=
tly gcc
+  and glibc are the only dependencies.
+o Tests return 0 for success and < 0 for failure.
+
+Output Formatting
+-----------------
+Test output shall be easily parsable by both human and machine. Title =
and
+results are printed to stdout, while intermediate ERROR or FAIL messag=
es are
+sent to stderr. Tests shall support the -c option to print PASS, FAIL,=
 and
+ERROR strings in color for easy visual parsing. Output shall conform t=
o the
+following format:
+
+test_name: Description of the test
+	Arguments: arg1=3Dval1 #units specified for clarity where appropriate
+	ERROR: Description of unexpected error
+	 FAIL: Reason for test failure
+	# FIXME: Perhaps an " INFO: informational message" option would be
+	#        useful here. Using -v to toggle it them on and off, as with =
-c.
+	# there may be multiple ERROR or FAIL messages
+Result: (PASS|FAIL|ERROR)
+
+Naming
+------
+o FIXME: decide on a sane test naming scheme.  Currently the tests are=
 named
+  based on the primary futex operation they test. Eventually this will=
 become a
+  problem as we intend to write multiple tests which collide in this n=
amespace.
+  Perhaps something like "wait-wake-1" "wait-wake-2" is adequate, leav=
ing the
+  detailed description in the test source and the output.
+
+Coding Style
+------------
+o The Futex Test project adheres to the coding standards set forth by =
Linux
+  kernel as defined in the Linux source Documentation/CodingStyle.
diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/=
testing/selftests/futex/functional/Makefile
new file mode 100644
index 0000000..720023e
--- /dev/null
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -0,0 +1,24 @@
+INCLUDES :=3D -I../include
+CFLAGS :=3D $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES)
+LDFLAGS :=3D $(LDFLAGS) -pthread -lrt
+
+HEADERS :=3D ../include/futextest.h
+TARGETS :=3D \
+	futex_wait_timeout \
+	futex_wait_wouldblock \
+	futex_requeue_pi \
+	futex_requeue_pi_signal_restart \
+	futex_requeue_pi_mismatched_ops \
+	futex_wait_uninitialized_heap \
+	futex_wait_private_mapped_file
+
+.PHONY: all clean
+all: $(TARGETS)
+
+$(TARGETS): $(HEADERS)
+
+run_tests: all
+	./run.sh
+
+clean:
+	rm -f $(TARGETS)
diff --git a/tools/testing/selftests/futex/functional/futex_requeue_pi.=
c b/tools/testing/selftests/futex/functional/futex_requeue_pi.c
new file mode 100644
index 0000000..3da06ad
--- /dev/null
+++ b/tools/testing/selftests/futex/functional/futex_requeue_pi.c
@@ -0,0 +1,409 @@
+/*********************************************************************=
*********
+ *
+ *   Copyright =C2=A9 International Business Machines  Corp., 2006-200=
8
+ *
+ *   This program is free software;  you can redistribute it and/or mo=
dify
+ *   it under the terms of the GNU General Public License as published=
 by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ * DESCRIPTION
+ *      This test excercises the futex syscall op codes needed for req=
ueuing
+ *      priority inheritance aware POSIX condition variables and mutex=
es.
+ *
+ * AUTHORS
+ *      Sripathi Kodi <sripathik-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
+ *      Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *
+ * HISTORY
+ *      2008-Jan-13: Initial version by Sripathi Kodi <sripathik-rWuWpvqGGmM@public.gmane.org=
m.com>
+ *      2009-Nov-6: futex test adaptation by Darren Hart <dvhart@linux=
=2Eintel.com>
+ *
+ *********************************************************************=
********/
+
+#include <errno.h>
+#include <limits.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <string.h>
+#include "atomic.h"
+#include "futextest.h"
+#include "logging.h"
+
+#define MAX_WAKE_ITERS 1000
+#define THREAD_MAX 10
+#define SIGNAL_PERIOD_US 100
+
+atomic_t waiters_blocked =3D ATOMIC_INITIALIZER;
+atomic_t waiters_woken =3D ATOMIC_INITIALIZER;
+
+futex_t f1 =3D FUTEX_INITIALIZER;
+futex_t f2 =3D FUTEX_INITIALIZER;
+futex_t wake_complete =3D FUTEX_INITIALIZER;
+
+/* Test option defaults */
+static long timeout_ns;
+static int broadcast;
+static int owner;
+static int locked;
+
+struct thread_arg {
+	long id;
+	struct timespec *timeout;
+	int lock;
+	int ret;
+};
+#define THREAD_ARG_INITIALIZER { 0, NULL, 0, 0 }
+
+void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -b	Broadcast wakeup (all waiters)\n");
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -l	Lock the pi futex across requeue\n");
+	printf("  -o	Use a third party pi futex owner during requeue (cancels=
 -l)\n");
+	printf("  -t N	Timeout in nanoseconds (default: 0)\n");
+	printf("  -v L	Verbosity level: %d=3DQUIET %d=3DCRITICAL %d=3DINFO\n"=
,
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+int create_rt_thread(pthread_t *pth, void*(*func)(void *), void *arg,
+		     int policy, int prio)
+{
+	int ret;
+	struct sched_param schedp;
+	pthread_attr_t attr;
+
+	pthread_attr_init(&attr);
+	memset(&schedp, 0, sizeof(schedp));
+
+	ret =3D pthread_attr_setinheritsched(&attr, PTHREAD_EXPLICIT_SCHED);
+	if (ret) {
+		error("pthread_attr_setinheritsched\n", ret);
+		return -1;
+	}
+
+	ret =3D pthread_attr_setschedpolicy(&attr, policy);
+	if (ret) {
+		error("pthread_attr_setschedpolicy\n", ret);
+		return -1;
+	}
+
+	schedp.sched_priority =3D prio;
+	ret =3D pthread_attr_setschedparam(&attr, &schedp);
+	if (ret) {
+		error("pthread_attr_setschedparam\n", ret);
+		return -1;
+	}
+
+	ret =3D pthread_create(pth, &attr, func, arg);
+	if (ret) {
+		error("pthread_create\n", ret);
+		return -1;
+	}
+	return 0;
+}
+
+
+void *waiterfn(void *arg)
+{
+	struct thread_arg *args =3D (struct thread_arg *)arg;
+	futex_t old_val;
+
+	info("Waiter %ld: running\n", args->id);
+	/* Each thread sleeps for a different amount of time
+	 * This is to avoid races, because we don't lock the
+	 * external mutex here */
+	usleep(1000 * (long)args->id);
+
+	old_val =3D f1;
+	atomic_inc(&waiters_blocked);
+	info("Calling futex_wait_requeue_pi: %p (%u) -> %p\n",
+	     &f1, f1, &f2);
+	args->ret =3D futex_wait_requeue_pi(&f1, old_val, &f2, args->timeout,
+					  FUTEX_PRIVATE_FLAG);
+
+	info("waiter %ld woke with %d %s\n", args->id, args->ret,
+	     args->ret < 0 ? strerror(errno) : "");
+	atomic_inc(&waiters_woken);
+	if (args->ret < 0) {
+		if (args->timeout && errno =3D=3D ETIMEDOUT)
+			args->ret =3D 0;
+		else {
+			args->ret =3D RET_ERROR;
+			error("futex_wait_requeue_pi\n", errno);
+		}
+		futex_lock_pi(&f2, NULL, 0, FUTEX_PRIVATE_FLAG);
+	}
+	futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+
+	info("Waiter %ld: exiting with %d\n", args->id, args->ret);
+	pthread_exit((void *)&args->ret);
+}
+
+void *broadcast_wakerfn(void *arg)
+{
+	struct thread_arg *args =3D (struct thread_arg *)arg;
+	int nr_requeue =3D INT_MAX;
+	int task_count =3D 0;
+	futex_t old_val;
+	int nr_wake =3D 1;
+	int i =3D 0;
+
+	info("Waker: waiting for waiters to block\n");
+	while (waiters_blocked.val < THREAD_MAX)
+		usleep(1000);
+	usleep(1000);
+
+	info("Waker: Calling broadcast\n");
+	if (args->lock) {
+		info("Calling FUTEX_LOCK_PI on mutex=3D%x @ %p\n", f2, &f2);
+		futex_lock_pi(&f2, NULL, 0, FUTEX_PRIVATE_FLAG);
+	}
+ continue_requeue:
+	old_val =3D f1;
+	args->ret =3D futex_cmp_requeue_pi(&f1, old_val, &f2, nr_wake, nr_req=
ueue,
+				   FUTEX_PRIVATE_FLAG);
+	if (args->ret < 0) {
+		args->ret =3D RET_ERROR;
+		error("FUTEX_CMP_REQUEUE_PI failed\n", errno);
+	} else if (++i < MAX_WAKE_ITERS) {
+		task_count +=3D args->ret;
+		if (task_count < THREAD_MAX - waiters_woken.val)
+			goto continue_requeue;
+	} else {
+		error("max broadcast iterations (%d) reached with %d/%d tasks woken =
or requeued\n",
+		       0, MAX_WAKE_ITERS, task_count, THREAD_MAX);
+		args->ret =3D RET_ERROR;
+	}
+
+	futex_wake(&wake_complete, 1, FUTEX_PRIVATE_FLAG);
+
+	if (args->lock)
+		futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+
+	if (args->ret > 0)
+		args->ret =3D task_count;
+
+	info("Waker: exiting with %d\n", args->ret);
+	pthread_exit((void *)&args->ret);
+}
+
+void *signal_wakerfn(void *arg)
+{
+	struct thread_arg *args =3D (struct thread_arg *)arg;
+	unsigned int old_val;
+	int nr_requeue =3D 0;
+	int task_count =3D 0;
+	int nr_wake =3D 1;
+	int i =3D 0;
+
+	info("Waker: waiting for waiters to block\n");
+	while (waiters_blocked.val < THREAD_MAX)
+		usleep(1000);
+	usleep(1000);
+
+	while (task_count < THREAD_MAX && waiters_woken.val < THREAD_MAX) {
+		info("task_count: %d, waiters_woken: %d\n",
+		     task_count, waiters_woken.val);
+		if (args->lock) {
+			info("Calling FUTEX_LOCK_PI on mutex=3D%x @ %p\n",
+			     f2, &f2);
+			futex_lock_pi(&f2, NULL, 0, FUTEX_PRIVATE_FLAG);
+		}
+		info("Waker: Calling signal\n");
+		/* cond_signal */
+		old_val =3D f1;
+		args->ret =3D futex_cmp_requeue_pi(&f1, old_val, &f2,
+						 nr_wake, nr_requeue,
+						 FUTEX_PRIVATE_FLAG);
+		if (args->ret < 0)
+			args->ret =3D -errno;
+		info("futex: %x\n", f2);
+		if (args->lock) {
+			info("Calling FUTEX_UNLOCK_PI on mutex=3D%x @ %p\n",
+			     f2, &f2);
+			futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+		}
+		info("futex: %x\n", f2);
+		if (args->ret < 0) {
+			error("FUTEX_CMP_REQUEUE_PI failed\n", errno);
+			args->ret =3D RET_ERROR;
+			break;
+		}
+
+		task_count +=3D args->ret;
+		usleep(SIGNAL_PERIOD_US);
+		i++;
+		/* we have to loop at least THREAD_MAX times */
+		if (i > MAX_WAKE_ITERS + THREAD_MAX) {
+			error("max signaling iterations (%d) reached, giving up on pending =
waiters.\n",
+			      0, MAX_WAKE_ITERS + THREAD_MAX);
+			args->ret =3D RET_ERROR;
+			break;
+		}
+	}
+
+	futex_wake(&wake_complete, 1, FUTEX_PRIVATE_FLAG);
+
+	if (args->ret >=3D 0)
+		args->ret =3D task_count;
+
+	info("Waker: exiting with %d\n", args->ret);
+	info("Waker: waiters_woken: %d\n", waiters_woken.val);
+	pthread_exit((void *)&args->ret);
+}
+
+void *third_party_blocker(void *arg)
+{
+	struct thread_arg *args =3D (struct thread_arg *)arg;
+	int ret2 =3D 0;
+
+	args->ret =3D futex_lock_pi(&f2, NULL, 0, FUTEX_PRIVATE_FLAG);
+	if (args->ret)
+		goto out;
+	args->ret =3D futex_wait(&wake_complete, wake_complete, NULL,
+			       FUTEX_PRIVATE_FLAG);
+	ret2 =3D futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+
+ out:
+	if (args->ret || ret2) {
+		error("third_party_blocker() futex error", 0);
+		args->ret =3D RET_ERROR;
+	}
+
+	pthread_exit((void *)&args->ret);
+}
+
+int unit_test(int broadcast, long lock, int third_party_owner, long ti=
meout_ns)
+{
+	void *(*wakerfn)(void *) =3D signal_wakerfn;
+	struct thread_arg blocker_arg =3D THREAD_ARG_INITIALIZER;
+	struct thread_arg waker_arg =3D THREAD_ARG_INITIALIZER;
+	pthread_t waiter[THREAD_MAX], waker, blocker;
+	struct timespec ts, *tsp =3D NULL;
+	struct thread_arg args[THREAD_MAX];
+	int *waiter_ret;
+	int i, ret =3D RET_PASS;
+
+	if (timeout_ns) {
+		time_t secs;
+
+		info("timeout_ns =3D %ld\n", timeout_ns);
+		ret =3D clock_gettime(CLOCK_MONOTONIC, &ts);
+		secs =3D (ts.tv_nsec + timeout_ns) / 1000000000;
+		ts.tv_nsec =3D ((int64_t)ts.tv_nsec + timeout_ns) % 1000000000;
+		ts.tv_sec +=3D secs;
+		info("ts.tv_sec  =3D %ld\n", ts.tv_sec);
+		info("ts.tv_nsec =3D %ld\n", ts.tv_nsec);
+		tsp =3D &ts;
+	}
+
+	if (broadcast)
+		wakerfn =3D broadcast_wakerfn;
+
+	if (third_party_owner) {
+		if (create_rt_thread(&blocker, third_party_blocker,
+				     (void *)&blocker_arg, SCHED_FIFO, 1)) {
+			error("Creating third party blocker thread failed\n",
+			      errno);
+			ret =3D RET_ERROR;
+			goto out;
+		}
+	}
+
+	atomic_set(&waiters_woken, 0);
+	for (i =3D 0; i < THREAD_MAX; i++) {
+		args[i].id =3D i;
+		args[i].timeout =3D tsp;
+		info("Starting thread %d\n", i);
+		if (create_rt_thread(&waiter[i], waiterfn, (void *)&args[i],
+				     SCHED_FIFO, 1)) {
+			error("Creating waiting thread failed\n", errno);
+			ret =3D RET_ERROR;
+			goto out;
+		}
+	}
+	waker_arg.lock =3D lock;
+	if (create_rt_thread(&waker, wakerfn, (void *)&waker_arg,
+			     SCHED_FIFO, 1)) {
+		error("Creating waker thread failed\n", errno);
+		ret =3D RET_ERROR;
+		goto out;
+	}
+
+	/* Wait for threads to finish */
+	/* Store the first error or failure encountered in waiter_ret */
+	waiter_ret =3D &args[0].ret;
+	for (i =3D 0; i < THREAD_MAX; i++)
+		pthread_join(waiter[i],
+			     *waiter_ret ? NULL : (void **)&waiter_ret);
+
+	if (third_party_owner)
+		pthread_join(blocker, NULL);
+	pthread_join(waker, NULL);
+
+out:
+	if (!ret) {
+		if (*waiter_ret)
+			ret =3D *waiter_ret;
+		else if (waker_arg.ret < 0)
+			ret =3D waker_arg.ret;
+		else if (blocker_arg.ret)
+			ret =3D blocker_arg.ret;
+	}
+
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int c, ret;
+
+	while ((c =3D getopt(argc, argv, "bchlot:v:")) !=3D -1) {
+		switch (c) {
+		case 'b':
+			broadcast =3D 1;
+			break;
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'l':
+			locked =3D 1;
+			break;
+		case 'o':
+			owner =3D 1;
+			locked =3D 0;
+			break;
+		case 't':
+			timeout_ns =3D atoi(optarg);
+			break;
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Test requeue functionality\n", basename(argv[0]));
+	printf("\tArguments: broadcast=3D%d locked=3D%d owner=3D%d timeout=3D=
%ldns\n",
+	       broadcast, locked, owner, timeout_ns);
+
+	/*
+	 * FIXME: unit_test is obsolete now that we parse options and the
+	 * various style of runs are done by run.sh - simplify the code and m=
ove
+	 * unit_test into main()
+	 */
+	ret =3D unit_test(broadcast, locked, owner, timeout_ns);
+
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/functional/futex_requeue_pi_=
mismatched_ops.c b/tools/testing/selftests/futex/functional/futex_reque=
ue_pi_mismatched_ops.c
new file mode 100644
index 0000000..d5e4f2c
--- /dev/null
+++ b/tools/testing/selftests/futex/functional/futex_requeue_pi_mismatc=
hed_ops.c
@@ -0,0 +1,135 @@
+/*********************************************************************=
*********
+ *
+ *   Copyright =C2=A9 International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or mo=
dify
+ *   it under the terms of the GNU General Public License as published=
 by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ * DESCRIPTION
+ *      1. Block a thread using FUTEX_WAIT
+ *      2. Attempt to use FUTEX_CMP_REQUEUE_PI on the futex from 1.
+ *      3. The kernel must detect the mismatch and return -EINVAL.
+ *
+ * AUTHOR
+ *      Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *
+ * HISTORY
+ *      2009-Nov-9: Initial version by Darren Hart <dvhart-VuQAYsv1560/9W2qTSuDoA@public.gmane.org=
=2Ecom>
+ *
+ *********************************************************************=
********/
+
+#include <errno.h>
+#include <getopt.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include "futextest.h"
+#include "logging.h"
+
+futex_t f1 =3D FUTEX_INITIALIZER;
+futex_t f2 =3D FUTEX_INITIALIZER;
+int child_ret =3D 0;
+
+void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -v L	Verbosity level: %d=3DQUIET %d=3DCRITICAL %d=3DINFO\n"=
,
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+void *blocking_child(void *arg)
+{
+	child_ret =3D futex_wait(&f1, f1, NULL, FUTEX_PRIVATE_FLAG);
+	if (child_ret < 0) {
+		child_ret =3D -errno;
+		error("futex_wait\n", errno);
+	}
+	return (void *)&child_ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret =3D RET_PASS;
+	pthread_t child;
+	int c;
+
+	while ((c =3D getopt(argc, argv, "chv:")) !=3D -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Detect mismatched requeue_pi operations\n",
+	       basename(argv[0]));
+
+	if (pthread_create(&child, NULL, blocking_child, NULL)) {
+		error("pthread_create\n", errno);
+		ret =3D RET_ERROR;
+		goto out;
+	}
+	/* Allow the child to block in the kernel. */
+	sleep(1);
+
+	/*
+	 * The kernel should detect the waiter did not setup the
+	 * q->requeue_pi_key and return -EINVAL. If it does not,
+	 * it likely gave the lock to the child, which is now hung
+	 * in the kernel.
+	 */
+	ret =3D futex_cmp_requeue_pi(&f1, f1, &f2, 1, 0, FUTEX_PRIVATE_FLAG);
+	if (ret < 0) {
+		if (errno =3D=3D EINVAL) {
+			/*
+			 * The kernel correctly detected the mismatched
+			 * requeue_pi target and aborted. Wake the child with
+			 * FUTEX_WAKE.
+			 */
+			ret =3D futex_wake(&f1, 1, FUTEX_PRIVATE_FLAG);
+			if (ret =3D=3D 1) {
+				ret =3D RET_PASS;
+			} else if (ret < 0) {
+				error("futex_wake\n", errno);
+				ret =3D RET_ERROR;
+			} else {
+				error("futex_wake did not wake the child\n", 0);
+				ret =3D RET_ERROR;
+			}
+		} else {
+			error("futex_cmp_requeue_pi\n", errno);
+			ret =3D RET_ERROR;
+		}
+	} else if (ret > 0) {
+		fail("futex_cmp_requeue_pi failed to detect the mismatch\n");
+		ret =3D RET_FAIL;
+	} else {
+		error("futex_cmp_requeue_pi found no waiters\n", 0);
+		ret =3D RET_ERROR;
+	}
+
+	pthread_join(child, NULL);
+
+	if (!ret)
+		ret =3D child_ret;
+
+ out:
+	/* If the kernel crashes, we shouldn't return at all. */
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/functional/futex_requeue_pi_=
signal_restart.c b/tools/testing/selftests/futex/functional/futex_reque=
ue_pi_signal_restart.c
new file mode 100644
index 0000000..7f0c756
--- /dev/null
+++ b/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_=
restart.c
@@ -0,0 +1,223 @@
+/*********************************************************************=
*********
+ *
+ *   Copyright =C2=A9 International Business Machines  Corp., 2006-200=
8
+ *
+ *   This program is free software;  you can redistribute it and/or mo=
dify
+ *   it under the terms of the GNU General Public License as published=
 by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ * DESCRIPTION
+ *      This test exercises the futex_wait_requeue_pi() signal handlin=
g both
+ *      before and after the requeue. The first should be restarted by=
 the
+ *      kernel. The latter should return EWOULDBLOCK to the waiter.
+ *
+ * AUTHORS
+ *      Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *
+ * HISTORY
+ *      2008-May-5: Initial version by Darren Hart <dvhart-VuQAYsv1560/9W2qTSuDoA@public.gmane.org=
=2Ecom>
+ *
+ *********************************************************************=
********/
+
+#include <errno.h>
+#include <getopt.h>
+#include <limits.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include "atomic.h"
+#include "futextest.h"
+#include "logging.h"
+
+#define DELAY_US 100
+
+futex_t f1 =3D FUTEX_INITIALIZER;
+futex_t f2 =3D FUTEX_INITIALIZER;
+atomic_t requeued =3D ATOMIC_INITIALIZER;
+
+int waiter_ret =3D 0;
+
+void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -v L	Verbosity level: %d=3DQUIET %d=3DCRITICAL %d=3DINFO\n"=
,
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+int create_rt_thread(pthread_t *pth, void*(*func)(void *), void *arg,
+		     int policy, int prio)
+{
+	struct sched_param schedp;
+	pthread_attr_t attr;
+	int ret;
+
+	pthread_attr_init(&attr);
+	memset(&schedp, 0, sizeof(schedp));
+
+	ret =3D pthread_attr_setinheritsched(&attr, PTHREAD_EXPLICIT_SCHED);
+	if (ret) {
+		error("pthread_attr_setinheritsched\n", ret);
+		return -1;
+	}
+
+	ret =3D pthread_attr_setschedpolicy(&attr, policy);
+	if (ret) {
+		error("pthread_attr_setschedpolicy\n", ret);
+		return -1;
+	}
+
+	schedp.sched_priority =3D prio;
+	ret =3D pthread_attr_setschedparam(&attr, &schedp);
+	if (ret) {
+		error("pthread_attr_setschedparam\n", ret);
+		return -1;
+	}
+
+	ret =3D pthread_create(pth, &attr, func, arg);
+	if (ret) {
+		error("pthread_create\n", ret);
+		return -1;
+	}
+	return 0;
+}
+
+void handle_signal(int signo)
+{
+	info("signal received %s requeue\n",
+	     requeued.val ? "after" : "prior to");
+}
+
+void *waiterfn(void *arg)
+{
+	unsigned int old_val;
+	int res;
+
+	waiter_ret =3D RET_PASS;
+
+	info("Waiter running\n");
+	info("Calling FUTEX_LOCK_PI on f2=3D%x @ %p\n", f2, &f2);
+	old_val =3D f1;
+	res =3D futex_wait_requeue_pi(&f1, old_val, &(f2), NULL,
+				    FUTEX_PRIVATE_FLAG);
+	if (!requeued.val || errno !=3D EWOULDBLOCK) {
+		fail("unexpected return from futex_wait_requeue_pi: %d (%s)\n",
+		     res, strerror(errno));
+		info("w2:futex: %x\n", f2);
+		if (!res)
+			futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+		waiter_ret =3D RET_FAIL;
+	}
+
+	info("Waiter exiting with %d\n", waiter_ret);
+	pthread_exit(NULL);
+}
+
+
+int main(int argc, char *argv[])
+{
+	unsigned int old_val;
+	struct sigaction sa;
+	pthread_t waiter;
+	int c, res, ret =3D RET_PASS;
+
+	while ((c =3D getopt(argc, argv, "chv:")) !=3D -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Test signal handling during requeue_pi\n",
+	       basename(argv[0]));
+	printf("\tArguments: <none>\n");
+
+	sa.sa_handler =3D handle_signal;
+	sigemptyset(&sa.sa_mask);
+	sa.sa_flags =3D 0;
+	if (sigaction(SIGUSR1, &sa, NULL)) {
+		error("sigaction\n", errno);
+		exit(1);
+	}
+
+	info("m1:f2: %x\n", f2);
+	info("Creating waiter\n");
+	res =3D create_rt_thread(&waiter, waiterfn, NULL, SCHED_FIFO, 1);
+	if (res) {
+		error("Creating waiting thread failed", res);
+		ret =3D RET_ERROR;
+		goto out;
+	}
+
+	info("Calling FUTEX_LOCK_PI on f2=3D%x @ %p\n", f2, &f2);
+	info("m2:f2: %x\n", f2);
+	futex_lock_pi(&f2, 0, 0, FUTEX_PRIVATE_FLAG);
+	info("m3:f2: %x\n", f2);
+
+	while (1) {
+		/*
+		 * signal the waiter before requeue, waiter should automatically
+		 * restart futex_wait_requeue_pi() in the kernel. Wait for the
+		 * waiter to block on f1 again.
+		 */
+		info("Issuing SIGUSR1 to waiter\n");
+		pthread_kill(waiter, SIGUSR1);
+		usleep(DELAY_US);
+
+		info("Requeueing waiter via FUTEX_CMP_REQUEUE_PI\n");
+		old_val =3D f1;
+		res =3D futex_cmp_requeue_pi(&f1, old_val, &(f2), 1, 0,
+					   FUTEX_PRIVATE_FLAG);
+		/*
+		 * If res is non-zero, we either requeued the waiter or hit an
+		 * error, break out and handle it. If it is zero, then the
+		 * signal may have hit before the the waiter was blocked on f1.
+		 * Try again.
+		 */
+		if (res > 0) {
+			atomic_set(&requeued, 1);
+			break;
+		} else if (res > 0) {
+			error("FUTEX_CMP_REQUEUE_PI failed\n", errno);
+			ret =3D RET_ERROR;
+			break;
+		}
+	}
+	info("m4:f2: %x\n", f2);
+
+	/*
+	 * Signal the waiter after requeue, waiter should return from
+	 * futex_wait_requeue_pi() with EWOULDBLOCK. Join the thread here so =
the
+	 * futex_unlock_pi() can't happen before the signal wakeup is detecte=
d
+	 * in the kernel.
+	 */
+	info("Issuing SIGUSR1 to waiter\n");
+	pthread_kill(waiter, SIGUSR1);
+	info("Waiting for waiter to return\n");
+	pthread_join(waiter, NULL);
+
+	info("Calling FUTEX_UNLOCK_PI on mutex=3D%x @ %p\n", f2, &f2);
+	futex_unlock_pi(&f2, FUTEX_PRIVATE_FLAG);
+	info("m5:f2: %x\n", f2);
+
+ out:
+	if (ret =3D=3D RET_PASS && waiter_ret)
+		ret =3D waiter_ret;
+
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/functional/futex_wait_privat=
e_mapped_file.c b/tools/testing/selftests/futex/functional/futex_wait_p=
rivate_mapped_file.c
new file mode 100644
index 0000000..5f687f2
--- /dev/null
+++ b/tools/testing/selftests/futex/functional/futex_wait_private_mappe=
d_file.c
@@ -0,0 +1,125 @@
+/*********************************************************************=
*********
+ *
+ * Copyright FUJITSU LIMITED 2010
+ * Copyright KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
+ *
+ *   This program is free software;  you can redistribute it and/or mo=
dify
+ *   it under the terms of the GNU General Public License as published=
 by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ * DESCRIPTION
+ *      Internally, Futex has two handling mode, anon and file. The pr=
ivate file
+ *      mapping is special. At first it behave as file, but after writ=
e anything
+ *      it behave as anon. This test is intent to test such case.
+ *
+ * AUTHOR
+ *      KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
+ *
+ * HISTORY
+ *      2010-Jan-6: Initial version by KOSAKI Motohiro <kosaki.motohir=
o@jp.fujitsu.com>
+ *
+ *********************************************************************=
********/
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <syscall.h>
+#include <unistd.h>
+#include <errno.h>
+#include <linux/futex.h>
+#include <pthread.h>
+#include <libgen.h>
+#include <signal.h>
+
+#include "logging.h"
+#include "futextest.h"
+
+#define PAGE_SZ 4096
+
+char pad[PAGE_SZ] =3D {1};
+futex_t val =3D 1;
+char pad2[PAGE_SZ] =3D {1};
+
+#define WAKE_WAIT_US 3000000
+struct timespec wait_timeout =3D { .tv_sec =3D 5, .tv_nsec =3D 0};
+
+void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -v L	Verbosity level: %d=3DQUIET %d=3DCRITICAL %d=3DINFO\n"=
,
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+void *thr_futex_wait(void *arg)
+{
+	int ret;
+
+	info("futex wait\n");
+	ret =3D futex_wait(&val, 1, &wait_timeout, 0);
+	if (ret && errno !=3D EWOULDBLOCK && errno !=3D ETIMEDOUT) {
+		error("futex error.\n", errno);
+		print_result(RET_ERROR);
+		exit(RET_ERROR);
+	}
+
+	if (ret && errno =3D=3D ETIMEDOUT)
+		fail("waiter timedout\n");
+
+	info("futex_wait: ret =3D %d, errno =3D %d\n", ret, errno);
+
+	return NULL;
+}
+
+int main(int argc, char **argv)
+{
+	pthread_t thr;
+	int ret =3D RET_PASS;
+	int res;
+	int c;
+
+	while ((c =3D getopt(argc, argv, "chv:")) !=3D -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Test the futex value of private file mappings in FUTEX_WA=
IT\n",
+	       basename(argv[0]));
+
+	ret =3D pthread_create(&thr, NULL, thr_futex_wait, NULL);
+	if (ret < 0) {
+		fprintf(stderr, "pthread_create error\n");
+		ret =3D RET_ERROR;
+		goto out;
+	}
+
+	info("wait a while\n");
+	usleep(WAKE_WAIT_US);
+	val =3D 2;
+	res =3D futex_wake(&val, 1, 0);
+	info("futex_wake %d\n", res);
+	if (res !=3D 1) {
+		fail("FUTEX_WAKE didn't find the waiting thread.\n");
+		ret =3D RET_FAIL;
+	}
+
+	info("join\n");
+	pthread_join(thr, NULL);
+
+ out:
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/functional/futex_wait_timeou=
t.c b/tools/testing/selftests/futex/functional/futex_wait_timeout.c
new file mode 100644
index 0000000..ab428ca
--- /dev/null
+++ b/tools/testing/selftests/futex/functional/futex_wait_timeout.c
@@ -0,0 +1,86 @@
+/*********************************************************************=
*********
+ *
+ *   Copyright =C2=A9 International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or mo=
dify
+ *   it under the terms of the GNU General Public License as published=
 by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ * DESCRIPTION
+ *      Block on a futex and wait for timeout.
+ *
+ * AUTHOR
+ *      Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *
+ * HISTORY
+ *      2009-Nov-6: Initial version by Darren Hart <dvhart-VuQAYsv1560/9W2qTSuDoA@public.gmane.org=
=2Ecom>
+ *
+ *********************************************************************=
********/
+
+#include <errno.h>
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include "futextest.h"
+#include "logging.h"
+
+static long timeout_ns =3D 100000;	/* 100us default timeout */
+
+void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -t N	Timeout in nanoseconds (default: 100,000)\n");
+	printf("  -v L	Verbosity level: %d=3DQUIET %d=3DCRITICAL %d=3DINFO\n"=
,
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+int main(int argc, char *argv[])
+{
+	futex_t f1 =3D FUTEX_INITIALIZER;
+	struct timespec to;
+	int res, ret =3D RET_PASS;
+	int c;
+
+	while ((c =3D getopt(argc, argv, "cht:v:")) !=3D -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 't':
+			timeout_ns =3D atoi(optarg);
+			break;
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Block on a futex and wait for timeout\n",
+	       basename(argv[0]));
+	printf("\tArguments: timeout=3D%ldns\n", timeout_ns);
+
+	/* initialize timeout */
+	to.tv_sec =3D 0;
+	to.tv_nsec =3D timeout_ns;
+
+	info("Calling futex_wait on f1: %u @ %p\n", f1, &f1);
+	res =3D futex_wait(&f1, f1, &to, FUTEX_PRIVATE_FLAG);
+	if (!res || errno !=3D ETIMEDOUT) {
+		fail("futex_wait returned %d\n", ret < 0 ? errno : ret);
+		ret =3D RET_FAIL;
+	}
+
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/functional/futex_wait_uninit=
ialized_heap.c b/tools/testing/selftests/futex/functional/futex_wait_un=
initialized_heap.c
new file mode 100644
index 0000000..fe7aee9
--- /dev/null
+++ b/tools/testing/selftests/futex/functional/futex_wait_uninitialized=
_heap.c
@@ -0,0 +1,124 @@
+/*********************************************************************=
*********
+ *
+ * Copyright FUJITSU LIMITED 2010
+ * Copyright KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
+ *
+ *   This program is free software;  you can redistribute it and/or mo=
dify
+ *   it under the terms of the GNU General Public License as published=
 by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ * DESCRIPTION
+ *      Wait on uninitialized heap. It shold be zero and FUTEX_WAIT sh=
ould
+ *      return immediately. This test is intent to test zero page hand=
ling in
+ *      futex.
+ *
+ * AUTHOR
+ *      KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
+ *
+ * HISTORY
+ *      2010-Jan-6: Initial version by KOSAKI Motohiro <kosaki.motohir=
o@jp.fujitsu.com>
+ *
+ *********************************************************************=
********/
+
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <syscall.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <errno.h>
+#include <linux/futex.h>
+#include <libgen.h>
+
+#include "logging.h"
+#include "futextest.h"
+
+#define WAIT_US 5000000
+
+static int child_blocked =3D 1;
+static int child_ret;
+void *buf;
+
+void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -v L	Verbosity level: %d=3DQUIET %d=3DCRITICAL %d=3DINFO\n"=
,
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+void *wait_thread(void *arg)
+{
+	int res;
+
+	child_ret =3D RET_PASS;
+	res =3D futex_wait(buf, 1, NULL, 0);
+	child_blocked =3D 0;
+
+	if (res !=3D 0 && errno !=3D EWOULDBLOCK) {
+		error("futex failure\n", errno);
+		child_ret =3D RET_ERROR;
+	}
+	pthread_exit(NULL);
+}
+
+int main(int argc, char **argv)
+{
+	int c, ret =3D RET_PASS;
+	long page_size;
+	pthread_t thr;
+
+	while ((c =3D getopt(argc, argv, "chv:")) !=3D -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	page_size =3D sysconf(_SC_PAGESIZE);
+
+	buf =3D mmap(NULL, page_size, PROT_READ|PROT_WRITE,
+		   MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
+	if (buf =3D=3D (void *)-1) {
+		error("mmap\n", errno);
+		exit(1);
+	}
+
+	printf("%s: Test the uninitialized futex value in FUTEX_WAIT\n",
+	       basename(argv[0]));
+
+
+	ret =3D pthread_create(&thr, NULL, wait_thread, NULL);
+	if (ret) {
+		error("pthread_create\n", errno);
+		ret =3D RET_ERROR;
+		goto out;
+	}
+
+	info("waiting %dus for child to return\n", WAIT_US);
+	usleep(WAIT_US);
+
+	ret =3D child_ret;
+	if (child_blocked) {
+		fail("child blocked in kernel\n");
+		ret =3D RET_FAIL;
+	}
+
+ out:
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/functional/futex_wait_wouldb=
lock.c b/tools/testing/selftests/futex/functional/futex_wait_wouldblock=
=2Ec
new file mode 100644
index 0000000..b6b0274
--- /dev/null
+++ b/tools/testing/selftests/futex/functional/futex_wait_wouldblock.c
@@ -0,0 +1,79 @@
+/*********************************************************************=
*********
+ *
+ *   Copyright =C2=A9 International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or mo=
dify
+ *   it under the terms of the GNU General Public License as published=
 by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ * DESCRIPTION
+ *      Test if FUTEX_WAIT op returns -EWOULDBLOCK if the futex value =
differs
+ *      from the expected one.
+ *
+ * AUTHOR
+ *      Gowrishankar <gowrishankar.m-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
+ *
+ * HISTORY
+ *      2009-Nov-14: Initial version by Gowrishankar <gowrishankar.m@i=
n.ibm.com>
+ *
+ *********************************************************************=
********/
+
+#include <errno.h>
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include "futextest.h"
+#include "logging.h"
+
+#define timeout_ns 100000
+
+void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -c	Use color\n");
+	printf("  -h	Display this help message\n");
+	printf("  -v L	Verbosity level: %d=3DQUIET %d=3DCRITICAL %d=3DINFO\n"=
,
+	       VQUIET, VCRITICAL, VINFO);
+}
+
+int main(int argc, char *argv[])
+{
+	struct timespec to =3D {.tv_sec =3D 0, .tv_nsec =3D timeout_ns};
+	futex_t f1 =3D FUTEX_INITIALIZER;
+	int res, ret =3D RET_PASS;
+	int c;
+
+	while ((c =3D getopt(argc, argv, "cht:v:")) !=3D -1) {
+		switch (c) {
+		case 'c':
+			log_color(1);
+			break;
+		case 'h':
+			usage(basename(argv[0]));
+			exit(0);
+		case 'v':
+			log_verbosity(atoi(optarg));
+			break;
+		default:
+			usage(basename(argv[0]));
+			exit(1);
+		}
+	}
+
+	printf("%s: Test the unexpected futex value in FUTEX_WAIT\n",
+	       basename(argv[0]));
+
+	info("Calling futex_wait on f1: %u @ %p with val=3D%u\n", f1, &f1, f1=
+1);
+	res =3D futex_wait(&f1, f1+1, &to, FUTEX_PRIVATE_FLAG);
+	if (!res || errno !=3D EWOULDBLOCK) {
+		fail("futex_wait returned: %d %s\n",
+		     res ? errno : res, res ? strerror(errno) : "");
+		ret =3D RET_FAIL;
+	}
+
+	print_result(ret);
+	return ret;
+}
diff --git a/tools/testing/selftests/futex/functional/run.sh b/tools/te=
sting/selftests/futex/functional/run.sh
new file mode 100755
index 0000000..e87dbe2
--- /dev/null
+++ b/tools/testing/selftests/futex/functional/run.sh
@@ -0,0 +1,79 @@
+#!/bin/sh
+
+######################################################################=
#########
+#
+#   Copyright =C2=A9 International Business Machines  Corp., 2009
+#
+#   This program is free software;  you can redistribute it and/or mod=
ify
+#   it under the terms of the GNU General Public License as published =
by
+#   the Free Software Foundation; either version 2 of the License, or
+#   (at your option) any later version.
+#
+# DESCRIPTION
+#      Run tests in the current directory.
+#
+# AUTHOR
+#      Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+#
+# HISTORY
+#      2009-Nov-9: Initial version by Darren Hart <dvhart-VuQAYsv1562uYJLRA6qg5Q@public.gmane.org=
com>
+#      2010-Jan-6: Add futex_wait_uninitialized_heap and futex_wait_pr=
ivate_mapped_file
+#                  by KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
+#
+######################################################################=
#########
+
+# Test for a color capable console
+if [ -z "$USE_COLOR" ]; then
+    tput setf 7
+    if [ $? -eq 0 ]; then
+        USE_COLOR=3D1
+        tput sgr0
+    fi
+fi
+if [ "$USE_COLOR" -eq 1 ]; then
+    COLOR=3D"-c"
+fi
+
+
+echo
+# requeue pi testing
+# without timeouts
+./futex_requeue_pi $COLOR
+./futex_requeue_pi $COLOR -b
+./futex_requeue_pi $COLOR -b -l
+./futex_requeue_pi $COLOR -b -o
+./futex_requeue_pi $COLOR -l
+./futex_requeue_pi $COLOR -o
+# with timeouts
+./futex_requeue_pi $COLOR -b -l -t 5000
+./futex_requeue_pi $COLOR -l -t 5000
+./futex_requeue_pi $COLOR -b -l -t 500000
+./futex_requeue_pi $COLOR -l -t 500000
+./futex_requeue_pi $COLOR -b -t 5000
+./futex_requeue_pi $COLOR -t 5000
+./futex_requeue_pi $COLOR -b -t 500000
+./futex_requeue_pi $COLOR -t 500000
+./futex_requeue_pi $COLOR -b -o -t 5000
+./futex_requeue_pi $COLOR -l -t 5000
+./futex_requeue_pi $COLOR -b -o -t 500000
+./futex_requeue_pi $COLOR -l -t 500000
+# with long timeout
+./futex_requeue_pi $COLOR -b -l -t 2000000000
+./futex_requeue_pi $COLOR -l -t 2000000000
+
+
+echo
+./futex_requeue_pi_mismatched_ops $COLOR
+
+echo
+./futex_requeue_pi_signal_restart $COLOR
+
+echo
+./futex_wait_timeout $COLOR
+
+echo
+./futex_wait_wouldblock $COLOR
+
+echo
+./futex_wait_uninitialized_heap $COLOR
+./futex_wait_private_mapped_file $COLOR
diff --git a/tools/testing/selftests/futex/include/atomic.h b/tools/tes=
ting/selftests/futex/include/atomic.h
new file mode 100644
index 0000000..f861da3
--- /dev/null
+++ b/tools/testing/selftests/futex/include/atomic.h
@@ -0,0 +1,83 @@
+/*********************************************************************=
*********
+ *
+ *   Copyright =C2=A9 International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or mo=
dify
+ *   it under the terms of the GNU General Public License as published=
 by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ * DESCRIPTION
+ *      GCC atomic builtin wrappers
+ *      http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.ht=
ml
+ *
+ * AUTHOR
+ *      Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *
+ * HISTORY
+ *      2009-Nov-17: Initial version by Darren Hart <dvhart-VuQAYsv1563N0uC3ymp8PA@public.gmane.org=
l.com>
+ *
+ *********************************************************************=
********/
+
+#ifndef _ATOMIC_H
+#define _ATOMIC_H
+
+typedef struct {
+	volatile int val;
+} atomic_t;
+
+#define ATOMIC_INITIALIZER { 0 }
+
+/**
+ * atomic_cmpxchg() - Atomic compare and exchange
+ * @uaddr:	The address of the futex to be modified
+ * @oldval:	The expected value of the futex
+ * @newval:	The new value to try and assign the futex
+ *
+ * Return the old value of addr->val.
+ */
+static inline int
+atomic_cmpxchg(atomic_t *addr, int oldval, int newval)
+{
+	return __sync_val_compare_and_swap(&addr->val, oldval, newval);
+}
+
+/**
+ * atomic_inc() - Atomic incrememnt
+ * @addr:	Address of the variable to increment
+ *
+ * Return the new value of addr->val.
+ */
+static inline int
+atomic_inc(atomic_t *addr)
+{
+	return __sync_add_and_fetch(&addr->val, 1);
+}
+
+/**
+ * atomic_dec() - Atomic decrement
+ * @addr:	Address of the variable to decrement
+ *
+ * Return the new value of addr-val.
+ */
+static inline int
+atomic_dec(atomic_t *addr)
+{
+	return __sync_sub_and_fetch(&addr->val, 1);
+}
+
+/**
+ * atomic_set() - Atomic set
+ * @addr:	Address of the variable to set
+ * @newval:	New value for the atomic_t
+ *
+ * Return the new value of addr->val.
+ */
+static inline int
+atomic_set(atomic_t *addr, int newval)
+{
+	addr->val =3D newval;
+	return newval;
+}
+
+#endif
diff --git a/tools/testing/selftests/futex/include/futextest.h b/tools/=
testing/selftests/futex/include/futextest.h
new file mode 100644
index 0000000..b98c3ab
--- /dev/null
+++ b/tools/testing/selftests/futex/include/futextest.h
@@ -0,0 +1,266 @@
+/*********************************************************************=
*********
+ *
+ *   Copyright =C2=A9 International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or mo=
dify
+ *   it under the terms of the GNU General Public License as published=
 by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ * DESCRIPTION
+ *      Glibc independent futex library for testing kernel functionali=
ty.
+ *
+ * AUTHOR
+ *      Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *
+ * HISTORY
+ *      2009-Nov-6: Initial version by Darren Hart <dvhart-VuQAYsv1560/9W2qTSuDoA@public.gmane.org=
=2Ecom>
+ *
+ *********************************************************************=
********/
+
+#ifndef _FUTEXTEST_H
+#define _FUTEXTEST_H
+
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <linux/futex.h>
+
+typedef volatile u_int32_t futex_t;
+#define FUTEX_INITIALIZER 0
+
+/* Define the newer op codes if the system header file is not up to da=
te. */
+#ifndef FUTEX_WAIT_BITSET
+#define FUTEX_WAIT_BITSET		9
+#endif
+#ifndef FUTEX_WAKE_BITSET
+#define FUTEX_WAKE_BITSET		10
+#endif
+#ifndef FUTEX_WAIT_REQUEUE_PI
+#define FUTEX_WAIT_REQUEUE_PI		11
+#endif
+#ifndef FUTEX_CMP_REQUEUE_PI
+#define FUTEX_CMP_REQUEUE_PI		12
+#endif
+#ifndef FUTEX_WAIT_REQUEUE_PI_PRIVATE
+#define FUTEX_WAIT_REQUEUE_PI_PRIVATE	(FUTEX_WAIT_REQUEUE_PI | \
+					 FUTEX_PRIVATE_FLAG)
+#endif
+#ifndef FUTEX_REQUEUE_PI_PRIVATE
+#define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
+					 FUTEX_PRIVATE_FLAG)
+#endif
+
+/**
+ * futex() - SYS_futex syscall wrapper
+ * @uaddr:	address of first futex
+ * @op:		futex op code
+ * @val:	typically expected value of uaddr, but varies by op
+ * @timeout:	typically an absolute struct timespec (except where noted
+ *              otherwise). Overloaded by some ops
+ * @uaddr2:	address of second futex for some ops\
+ * @val3:	varies by op
+ * @opflags:	flags to be bitwise OR'd with op, such as FUTEX_PRIVATE_F=
LAG
+ *
+ * futex() is used by all the following futex op wrappers. It can also=
 be
+ * used for misuse and abuse testing. Generally, the specific op wrapp=
ers
+ * should be used instead. It is a macro instead of an static inline f=
unction as
+ * some of the types over overloaded (timeout is used for nr_requeue f=
or
+ * example).
+ *
+ * These argument descriptions are the defaults for all
+ * like-named arguments in the following wrappers except where noted b=
elow.
+ */
+#define futex(uaddr, op, val, timeout, uaddr2, val3, opflags) \
+	syscall(SYS_futex, uaddr, op | opflags, val, timeout, uaddr2, val3)
+
+/**
+ * futex_wait() - block on uaddr with optional timeout
+ * @timeout:	relative timeout
+ */
+static inline int
+futex_wait(futex_t *uaddr, futex_t val, struct timespec *timeout, int =
opflags)
+{
+	return futex(uaddr, FUTEX_WAIT, val, timeout, NULL, 0, opflags);
+}
+
+/**
+ * futex_wake() - wake one or more tasks blocked on uaddr
+ * @nr_wake:	wake up to this many tasks
+ */
+static inline int
+futex_wake(futex_t *uaddr, int nr_wake, int opflags)
+{
+	return futex(uaddr, FUTEX_WAKE, nr_wake, NULL, NULL, 0, opflags);
+}
+
+/**
+ * futex_wait_bitset() - block on uaddr with bitset
+ * @bitset:	bitset to be used with futex_wake_bitset
+ */
+static inline int
+futex_wait_bitset(futex_t *uaddr, futex_t val, struct timespec *timeou=
t,
+		  u_int32_t bitset, int opflags)
+{
+	return futex(uaddr, FUTEX_WAIT_BITSET, val, timeout, NULL, bitset,
+		     opflags);
+}
+
+/**
+ * futex_wake_bitset() - wake one or more tasks blocked on uaddr with =
bitset
+ * @bitset:	bitset to compare with that used in futex_wait_bitset
+ */
+static inline int
+futex_wake_bitset(futex_t *uaddr, int nr_wake, u_int32_t bitset, int o=
pflags)
+{
+	return futex(uaddr, FUTEX_WAKE_BITSET, nr_wake, NULL, NULL, bitset,
+		     opflags);
+}
+
+/**
+ * futex_lock_pi() - block on uaddr as a PI mutex
+ * @detect:	whether (1) or not (0) to perform deadlock detection
+ */
+static inline int
+futex_lock_pi(futex_t *uaddr, struct timespec *timeout, int detect,
+	      int opflags)
+{
+	return futex(uaddr, FUTEX_LOCK_PI, detect, timeout, NULL, 0, opflags)=
;
+}
+
+/**
+ * futex_unlock_pi() - release uaddr as a PI mutex, waking the top wai=
ter
+ */
+static inline int
+futex_unlock_pi(futex_t *uaddr, int opflags)
+{
+	return futex(uaddr, FUTEX_UNLOCK_PI, 0, NULL, NULL, 0, opflags);
+}
+
+/**
+ * futex_wake_op() - FIXME: COME UP WITH A GOOD ONE LINE DESCRIPTION
+ */
+static inline int
+futex_wake_op(futex_t *uaddr, futex_t *uaddr2, int nr_wake, int nr_wak=
e2,
+	      int wake_op, int opflags)
+{
+	return futex(uaddr, FUTEX_WAKE_OP, nr_wake, nr_wake2, uaddr2, wake_op=
,
+		     opflags);
+}
+
+/**
+ * futex_requeue() - requeue without expected value comparison, deprec=
ated
+ * @nr_wake:	wake up to this many tasks
+ * @nr_requeue:	requeue up to this many tasks
+ *
+ * Due to its inherently racy implementation, futex_requeue() is depre=
cated in
+ * favor of futex_cmp_requeue().
+ */
+static inline int
+futex_requeue(futex_t *uaddr, futex_t *uaddr2, int nr_wake, int nr_req=
ueue,
+	      int opflags)
+{
+	return futex(uaddr, FUTEX_REQUEUE, nr_wake, nr_requeue, uaddr2, 0,
+		     opflags);
+}
+
+/**
+ * futex_cmp_requeue() - requeue tasks from uaddr to uaddr2
+ * @nr_wake:	wake up to this many tasks
+ * @nr_requeue:	requeue up to this many tasks
+ */
+static inline int
+futex_cmp_requeue(futex_t *uaddr, futex_t val, futex_t *uaddr2, int nr=
_wake,
+		  int nr_requeue, int opflags)
+{
+	return futex(uaddr, FUTEX_CMP_REQUEUE, nr_wake, nr_requeue, uaddr2,
+		     val, opflags);
+}
+
+/**
+ * futex_wait_requeue_pi() - block on uaddr and prepare to requeue to =
uaddr2
+ * @uaddr:	non-PI futex source
+ * @uaddr2:	PI futex target
+ *
+ * This is the first half of the requeue_pi mechanism. It shall always=
 be
+ * paired with futex_cmp_requeue_pi().
+ */
+static inline int
+futex_wait_requeue_pi(futex_t *uaddr, futex_t val, futex_t *uaddr2,
+		      struct timespec *timeout, int opflags)
+{
+	return futex(uaddr, FUTEX_WAIT_REQUEUE_PI, val, timeout, uaddr2, 0,
+		     opflags);
+}
+
+/**
+ * futex_cmp_requeue_pi() - requeue tasks from uaddr to uaddr2 (PI awa=
re)
+ * @uaddr:	non-PI futex source
+ * @uaddr2:	PI futex target
+ * @nr_wake:	wake up to this many tasks
+ * @nr_requeue:	requeue up to this many tasks
+ */
+static inline int
+futex_cmp_requeue_pi(futex_t *uaddr, futex_t val, futex_t *uaddr2, int=
 nr_wake,
+		     int nr_requeue, int opflags)
+{
+	return futex(uaddr, FUTEX_CMP_REQUEUE_PI, nr_wake, nr_requeue, uaddr2=
,
+		     val, opflags);
+}
+
+/**
+ * futex_cmpxchg() - atomic compare and exchange
+ * @uaddr:	The address of the futex to be modified
+ * @oldval:	The expected value of the futex
+ * @newval:	The new value to try and assign the futex
+ *
+ * Implement cmpxchg using gcc atomic builtins.
+ * http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
+ *
+ * Return the old futex value.
+ */
+static inline u_int32_t
+futex_cmpxchg(futex_t *uaddr, u_int32_t oldval, u_int32_t newval)
+{
+	return __sync_val_compare_and_swap(uaddr, oldval, newval);
+}
+
+/**
+ * futex_dec() - atomic decrement of the futex value
+ * @uaddr:	The address of the futex to be modified
+ *
+ * Return the new futex value.
+ */
+static inline u_int32_t
+futex_dec(futex_t *uaddr)
+{
+	return __sync_sub_and_fetch(uaddr, 1);
+}
+
+/**
+ * futex_inc() - atomic increment of the futex value
+ * @uaddr:	the address of the futex to be modified
+ *
+ * Return the new futex value.
+ */
+static inline u_int32_t
+futex_inc(futex_t *uaddr)
+{
+	return __sync_add_and_fetch(uaddr, 1);
+}
+
+/**
+ * futex_set() - atomic decrement of the futex value
+ * @uaddr:	the address of the futex to be modified
+ * @newval:	New value for the atomic_t
+ *
+ * Return the new futex value.
+ */
+static inline u_int32_t
+futex_set(futex_t *uaddr, u_int32_t newval)
+{
+	*uaddr =3D newval;
+	return newval;
+}
+
+#endif
diff --git a/tools/testing/selftests/futex/include/logging.h b/tools/te=
sting/selftests/futex/include/logging.h
new file mode 100644
index 0000000..f6ed5c2
--- /dev/null
+++ b/tools/testing/selftests/futex/include/logging.h
@@ -0,0 +1,150 @@
+/*********************************************************************=
*********
+ *
+ *   Copyright =C2=A9 International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or mo=
dify
+ *   it under the terms of the GNU General Public License as published=
 by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ * DESCRIPTION
+ *      Glibc independent futex library for testing kernel functionali=
ty.
+ *
+ * AUTHOR
+ *      Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *
+ * HISTORY
+ *      2009-Nov-6: Initial version by Darren Hart <dvhart-VuQAYsv1560/9W2qTSuDoA@public.gmane.org=
=2Ecom>
+ *
+ *********************************************************************=
********/
+
+#ifndef _LOGGING_H
+#define _LOGGING_H
+
+#include <string.h>
+#include <unistd.h>
+#include <linux/futex.h>
+
+/*
+ * Define PASS, ERROR, and FAIL strings with and without color escape
+ * sequences, default to no color.
+ */
+#define ESC 0x1B, '['
+#define BRIGHT '1'
+#define GREEN '3', '2'
+#define YELLOW '3', '3'
+#define RED '3', '1'
+#define ESCEND 'm'
+#define BRIGHT_GREEN ESC, BRIGHT, ';', GREEN, ESCEND
+#define BRIGHT_YELLOW ESC, BRIGHT, ';', YELLOW, ESCEND
+#define BRIGHT_RED ESC, BRIGHT, ';', RED, ESCEND
+#define RESET_COLOR ESC, '0', 'm'
+static const char PASS_COLOR[] =3D {BRIGHT_GREEN, ' ', 'P', 'A', 'S', =
'S',
+				  RESET_COLOR, 0};
+static const char ERROR_COLOR[] =3D {BRIGHT_YELLOW, 'E', 'R', 'R', 'O'=
, 'R',
+				   RESET_COLOR, 0};
+static const char FAIL_COLOR[] =3D {BRIGHT_RED, ' ', 'F', 'A', 'I', 'L=
',
+				  RESET_COLOR, 0};
+static const char INFO_NORMAL[] =3D " INFO";
+static const char PASS_NORMAL[] =3D " PASS";
+static const char ERROR_NORMAL[] =3D "ERROR";
+static const char FAIL_NORMAL[] =3D " FAIL";
+const char *INFO =3D INFO_NORMAL;
+const char *PASS =3D PASS_NORMAL;
+const char *ERROR =3D ERROR_NORMAL;
+const char *FAIL =3D FAIL_NORMAL;
+
+/* Verbosity setting for INFO messages */
+#define VQUIET    0
+#define VCRITICAL 1
+#define VINFO     2
+#define VMAX      VINFO
+int _verbose =3D VCRITICAL;
+
+/* Functional test return codes */
+#define RET_PASS   0
+#define RET_ERROR -1
+#define RET_FAIL  -2
+
+/**
+ * log_color() - Use colored output for PASS, ERROR, and FAIL strings
+ * @use_color:	use color (1) or not (0)
+ */
+void log_color(int use_color)
+{
+	if (use_color) {
+		PASS =3D PASS_COLOR;
+		ERROR =3D ERROR_COLOR;
+		FAIL =3D FAIL_COLOR;
+	} else {
+		PASS =3D PASS_NORMAL;
+		ERROR =3D ERROR_NORMAL;
+		FAIL =3D FAIL_NORMAL;
+	}
+}
+
+/**
+ * log_verbosity() - Set verbosity of test output
+ * @verbose:	Enable (1) verbose output or not (0)
+ *
+ * Currently setting verbose=3D1 will enable INFO messages and 0 will =
disable
+ * them. FAIL and ERROR messages are always displayed.
+ */
+void log_verbosity(int level)
+{
+	if (level > VMAX)
+		level =3D VMAX;
+	else if (level < 0)
+		level =3D 0;
+	_verbose =3D level;
+}
+
+/**
+ * print_result() - Print standard PASS | ERROR | FAIL results
+ * @ret:	the return value to be considered: 0 | RET_ERROR | RET_FAIL
+ *
+ * print_result() is primarily intended for functional tests.
+ */
+void print_result(int ret)
+{
+	const char *result =3D "Unknown return code";
+
+	switch (ret) {
+	case RET_PASS:
+		result =3D PASS;
+		break;
+	case RET_ERROR:
+		result =3D ERROR;
+		break;
+	case RET_FAIL:
+		result =3D FAIL;
+		break;
+	}
+	printf("Result: %s\n", result);
+}
+
+/* log level macros */
+#define info(message, vargs...) \
+do { \
+	if (_verbose >=3D VINFO) \
+		fprintf(stderr, "\t%s: "message, INFO, ##vargs); \
+} while (0)
+
+#define error(message, err, args...) \
+do { \
+	if (_verbose >=3D VCRITICAL) {\
+		if (err) \
+			fprintf(stderr, "\t%s: %s: "message, \
+				ERROR, strerror(err), ##args); \
+		else \
+			fprintf(stderr, "\t%s: "message, ERROR, ##args); \
+	} \
+} while (0)
+
+#define fail(message, args...) \
+do { \
+	if (_verbose >=3D VCRITICAL) \
+		fprintf(stderr, "\t%s: "message, FAIL, ##args); \
+} while (0)
+
+#endif
diff --git a/tools/testing/selftests/futex/run.sh b/tools/testing/selft=
ests/futex/run.sh
new file mode 100755
index 0000000..4126312
--- /dev/null
+++ b/tools/testing/selftests/futex/run.sh
@@ -0,0 +1,33 @@
+#!/bin/sh
+
+######################################################################=
#########
+#
+#   Copyright =C2=A9 International Business Machines  Corp., 2009
+#
+#   This program is free software;  you can redistribute it and/or mod=
ify
+#   it under the terms of the GNU General Public License as published =
by
+#   the Free Software Foundation; either version 2 of the License, or
+#   (at your option) any later version.
+#
+# DESCRIPTION
+#      Run all tests under the functional, performance, and stress dir=
ectories.
+#      Format and summarize the results.
+#
+# AUTHOR
+#      Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+#
+# HISTORY
+#      2009-Nov-9: Initial version by Darren Hart <dvhart-VuQAYsv1562uYJLRA6qg5Q@public.gmane.org=
com>
+#
+######################################################################=
#########
+
+# Test for a color capable shell and pass the result to the subdir scr=
ipts
+USE_COLOR=3D0
+tput setf 7
+if [ $? -eq 0 ]; then
+    USE_COLOR=3D1
+    tput sgr0
+fi
+export USE_COLOR
+
+(cd functional; ./run.sh)
--=20
2.1.4
