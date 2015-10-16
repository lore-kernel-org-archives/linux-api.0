From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] glibc: Remove CPU set size checking from affinity functions
 [BZ #19143]
Date: Fri, 16 Oct 2015 17:06:22 +0200
Message-ID: <5621126E.5080801@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030403010801000001030001"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: GNU C Library <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------030403010801000001030001
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

I still believe this is the right course of action.

This is a straight rebase of an old glibc patch, this time with a bug
and a NEWS entry.

The goal of this patch is to remove the CPU set size checking in user
space from the glibc system call wrappers for the sched_setaffinity
system call (that is, sched_setaffinity and pthread_setaffinity_np).

The previous discussion is here:

  <https://sourceware.org/ml/libc-alpha/2015-05/msg00449.html>

I do not have any new arguments to bring forward.  I can try to explain
what is going on in a few different words, though.

The current situation, briefly stated, is this: glibc tries to guess the
kernel CPU set size and rejects attempts to specify an affinity mask
which is larger than that, but it does not work, and glibc and the
kernel still silently accept CPU affinity masks with invalid bits,
without returning an error.  The glibc check does not provide any value
to applications, it just adds pointless complexity to the library.
Therefore, I want to remove it from glibc.

Thanks,
Florian

--------------030403010801000001030001
Content-Type: text/x-patch;
 name="0001-Remove-CPU-set-size-checking-from-affinity-functions.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-Remove-CPU-set-size-checking-from-affinity-functions.pa";
 filename*1="tch"

Remove CPU set size checking from affinity functions [BZ #19143]

With current kernel versions, the check does not reliably detect that
unavailable CPUs are requested, for these reasons:

(1) The kernel will silently ignore non-allowed CPUs.

(2) Similarly, CPU bits which lack an online CPU (possible CPUs)
    are ignored.

(3) The existing probing code assumes that the CPU mask size is a
    power of two and at least 1024.  Neither it has to be a power
    of two, nor is the minimum possible value 1024, so the value
    determined is often too large, resulting in incorrect false
    negatives.

The kernel will still return EINVAL if no CPU in the requested set
remains which can run the current thread after the affinity change.

Applications which care about the exact affinity mask will have to query
it using sched_getaffinity after setting it.  Due to the effects above,
this commit does not change this.

2015-10-16  Florian Weimer  <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

	* nptl/check-cpuset.h: Remove.
	* nptl/pthread_attr_setaffinity.c (__pthread_attr_setaffinity_new):
	Remove CPU set size check.
	* nptl/pthread_setattr_default_np.c (pthread_setattr_default_np):
	Likewise.
	* sysdeps/unix/sysv/linux/check-cpuset.h: Remove.
	* sysdeps/unix/sysv/linux/pthread_setaffinity.c
	(__kernel_cpumask_size, __determine_cpumask_size): Remove.
	(__pthread_setaffinity_new): Remove CPU set size check.
	* sysdeps/unix/sysv/linux/sched_setaffinity.c
	(__kernel_cpumask_size): Remove.
	(__sched_setaffinity_new): Remove CPU set size check.
	* manual/threads.texi (Default Thread Attributes): Remove stale
	reference to check_cpuset_attr, determine_cpumask_size in comment.
	* posix/Makefile (tests): Add tst-affinity.
	* posix/tst-affinity.c: New file.
	* nptl/Makefile (tests): Add tst-thread-affinity.
	* nptl/tst-thread-affinity.c: New file.

diff --git a/NEWS b/NEWS
index 861027a..d012c82 100644
--- a/NEWS
+++ b/NEWS
@@ -20,11 +20,19 @@ Version 2.23
   18961, 18966, 18967, 18969, 18970, 18977, 18980, 18981, 18985, 19003,
   19007, 19012, 19016, 19018, 19032, 19046, 19049, 19050, 19059, 19071,
   19074, 19076, 19077, 19078, 19079, 19085, 19086, 19088, 19094, 19095,
-  19124, 19125, 19129, 19134, 19137
+  19124, 19125, 19129, 19134, 19137, 19143.
=20
 * The LD_POINTER_GUARD environment variable can no longer be used to
   disable the pointer guard feature.  It is always enabled.
=20
+* sched_setaffinity, pthread_setaffinity_np no longer attempt to guess t=
he
+  kernel-internal CPU set size.  This means that requests that change th=
e
+  CPU affinity which failed before will now succeed.  Applications that =
need
+  to determine the effective CPU affinities need to call sched_getaffini=
ty
+  or pthread_getaffinity_np after setting it because the kernel can adju=
st
+  it (and the previous size check would not detect this in the majority =
of
+  cases).
+
 * The obsolete header <regexp.h> has been removed.  Programs that requir=
e
   this header must be updated to use <regex.h> instead.
=20
diff --git a/manual/threads.texi b/manual/threads.texi
index 4d080d4..00cc725 100644
--- a/manual/threads.texi
+++ b/manual/threads.texi
@@ -111,8 +111,6 @@ failure.
 @c  check_sched_priority_attr ok
 @c   sched_get_priority_min dup ok
 @c   sched_get_priority_max dup ok
-@c  check_cpuset_attr ok
-@c   determine_cpumask_size ok
 @c  check_stacksize_attr ok
 @c  lll_lock @asulock @aculock
 @c  free dup @ascuheap @acsmem
diff --git a/nptl/Makefile b/nptl/Makefile
index 311b1a7..e172a0a 100644
--- a/nptl/Makefile
+++ b/nptl/Makefile
@@ -287,7 +287,8 @@ tests =3D tst-typesizes \
 	tst-setuid3 \
 	tst-initializers1 $(addprefix tst-initializers1-,c89 gnu89 c99 gnu99) \=

 	tst-bad-schedattr \
-	tst-thread_local1
+	tst-thread_local1 \
+	tst-thread-affinity
 xtests =3D tst-setuid1 tst-setuid1-static tst-setuid2 \
 	tst-mutexpp1 tst-mutexpp6 tst-mutexpp10
 test-srcs =3D tst-oddstacklimit
diff --git a/nptl/check-cpuset.h b/nptl/check-cpuset.h
deleted file mode 100644
index 315bdf2..0000000
--- a/nptl/check-cpuset.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/* Validate cpu_set_t values for NPTL.  Stub version.
-   Copyright (C) 2015 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <http://www.gnu.org/licenses/>.  */
-
-#include <errno.h>
-
-/* Returns 0 if CS and SZ are valid values for the cpuset and cpuset siz=
e
-   respectively.  Otherwise it returns an error number.  */
-static inline int
-check_cpuset_attr (const cpu_set_t *cs, const size_t sz)
-{
-  if (sz =3D=3D 0)
-    return 0;
-
-  /* This means pthread_attr_setaffinity will return ENOSYS, which
-     is the right thing when the cpu_set_t features are not available.  =
*/
-  return ENOSYS;
-}
diff --git a/nptl/pthread_attr_setaffinity.c b/nptl/pthread_attr_setaffin=
ity.c
index 7a127b8..571835d 100644
--- a/nptl/pthread_attr_setaffinity.c
+++ b/nptl/pthread_attr_setaffinity.c
@@ -23,7 +23,6 @@
 #include <string.h>
 #include <pthreadP.h>
 #include <shlib-compat.h>
-#include <check-cpuset.h>
=20
=20
 int
@@ -43,11 +42,6 @@ __pthread_attr_setaffinity_new (pthread_attr_t *attr, =
size_t cpusetsize,
     }
   else
     {
-      int ret =3D check_cpuset_attr (cpuset, cpusetsize);
-
-      if (ret)
-        return ret;
-
       if (iattr->cpusetsize !=3D cpusetsize)
 	{
 	  void *newp =3D (cpu_set_t *) realloc (iattr->cpuset, cpusetsize);
diff --git a/nptl/pthread_setattr_default_np.c b/nptl/pthread_setattr_def=
ault_np.c
index 457a467..1a661f1 100644
--- a/nptl/pthread_setattr_default_np.c
+++ b/nptl/pthread_setattr_default_np.c
@@ -21,7 +21,6 @@
 #include <pthreadP.h>
 #include <assert.h>
 #include <string.h>
-#include <check-cpuset.h>
=20
=20
 int
@@ -48,10 +47,6 @@ pthread_setattr_default_np (const pthread_attr_t *in)
 	return ret;
     }
=20
-  ret =3D check_cpuset_attr (real_in->cpuset, real_in->cpusetsize);
-  if (ret)
-    return ret;
-
   /* stacksize =3D=3D 0 is fine.  It means that we don't change the curr=
ent
      value.  */
   if (real_in->stacksize !=3D 0)
diff --git a/nptl/tst-thread-affinity.c b/nptl/tst-thread-affinity.c
new file mode 100644
index 0000000..9e120b8
--- /dev/null
+++ b/nptl/tst-thread-affinity.c
@@ -0,0 +1,295 @@
+/* Copyright (C) 2015 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#include <errno.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <sys/time.h>
+
+static int
+setaffinity (size_t size, const cpu_set_t *set)
+{
+  int ret =3D pthread_setaffinity_np (pthread_self (), size, set);
+  if (ret !=3D 0)
+    {
+      errno =3D ret;
+      return -1;
+    }
+  return 0;
+}
+
+static int
+getaffinity (size_t size, cpu_set_t *set)
+{
+  int ret =3D pthread_getaffinity_np (pthread_self (), size, set);
+  if (ret !=3D 0)
+    {
+      errno =3D ret;
+      return -1;
+    }
+  return 0;
+}
+
+struct conf;
+static bool early_test (struct conf *);
+
+#define SETAFFINITY(size, set) setaffinity ((size), (set))
+#define GETAFFINITY(size, set) getaffinity ((size), (set))
+#define EARLY_TEST(conf) early_test (conf)
+
+/* We wave two loops running for two seconds each.  */
+#define TIMEOUT 8
+
+#include "../posix/tst-affinity.c"
+
+static int still_running;
+static int failed;
+
+static void *
+thread_burn_one_cpu (void *closure)
+{
+  int cpu =3D (uintptr_t) closure;
+  while (__atomic_load_n (&still_running, __ATOMIC_RELAXED) =3D=3D 0)
+    {
+      int current =3D sched_getcpu ();
+      if (sched_getcpu () !=3D cpu)
+	{
+	  printf ("FAIL: Pinned thread %d ran on impossible cpu %d\n",
+		  cpu, current);
+	  __atomic_store_n (&failed, 1, __ATOMIC_RELAXED);
+	  __atomic_store_n (&still_running, 1, __ATOMIC_RELAXED);
+	}
+    }
+  return NULL;
+}
+
+struct burn_thread
+{
+  pthread_t self;
+  struct conf *conf;
+  cpu_set_t *initial_set;
+  cpu_set_t *seen_set;
+  int thread;
+};
+
+static void *
+thread_burn_any_cpu (void *closure)
+{
+  struct burn_thread *param =3D closure;
+
+  /* Schedule this thread around a bit to see if it lands on another
+     CPU.  Run this for 2 seconds, once with sched_yield, once
+     without.  */
+  for (int pass =3D 1; pass <=3D 2; ++pass)
+    {
+      time_t start =3D time (NULL);
+      while (time (NULL) - start < 3)
+	{
+	  int cpu =3D sched_getcpu ();
+	  if (cpu > param->conf->last_cpu
+	      || !CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (param->conf->set_size),
+			       param->initial_set))
+	    {
+	      printf ("FAIL: Unpinned thread %d ran on impossible CPU %d\n",
+		      param->thread, cpu);
+	      __atomic_store_n (&failed, 1, __ATOMIC_RELAXED);
+	      return NULL;
+	    }
+	  CPU_SET_S (cpu, CPU_ALLOC_SIZE (param->conf->set_size),
+		     param->seen_set);
+	  if (pass =3D=3D 1)
+	    sched_yield ();
+	}
+    }
+  return NULL;
+}
+
+static void
+stop_and_join_threads (struct conf *conf, cpu_set_t *set,
+		       pthread_t *pinned_first, pthread_t *pinned_last,
+		       struct burn_thread *other_first,
+		       struct burn_thread *other_last)
+{
+  __atomic_store_n (&still_running, 1, __ATOMIC_RELAXED);
+  for (pthread_t *p =3D pinned_first; p < pinned_last; ++p)
+    {
+      int cpu =3D p - pinned_first;
+      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), set))
+	continue;
+
+      int ret =3D pthread_join (*p, NULL);
+      if (ret !=3D 0)
+	{
+	  printf ("Failed to join thread %d: %s\n", cpu, strerror (ret));
+	  fflush (stdout);
+	  /* Cannot shut down cleanly with threads still running.  */
+	  abort ();
+	}
+    }
+
+  for (struct burn_thread *p =3D other_first; p < other_last; ++p)
+    {
+      int cpu =3D p - other_first;
+      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), set))
+	continue;
+
+      int ret =3D pthread_join (p->self, NULL);
+      if (ret !=3D 0)
+	{
+	  printf ("Failed to join thread %d: %s\n", cpu, strerror (ret));
+	  fflush (stdout);
+	  /* Cannot shut down cleanly with threads still running.  */
+	  abort ();
+	}
+    }
+}
+
+/* Tries to check that the initial set of CPUs is complete and that
+   the main thread will not run on any other threads.  */
+static bool
+early_test (struct conf *conf)
+{
+  pthread_t *pinned_threads
+    =3D calloc (conf->last_cpu + 1, sizeof (*pinned_threads));
+  struct burn_thread *other_threads
+    =3D calloc (conf->last_cpu + 1, sizeof (*other_threads));
+  cpu_set_t *initial_set =3D CPU_ALLOC (conf->set_size);
+  cpu_set_t *scratch_set =3D CPU_ALLOC (conf->set_size);
+
+  if (pinned_threads =3D=3D NULL || other_threads =3D=3D NULL
+      || initial_set =3D=3D NULL || scratch_set =3D=3D NULL)
+    {
+      puts ("Memory allocation failure");
+      return false;
+    }
+  if (getaffinity (CPU_ALLOC_SIZE (conf->set_size), initial_set) < 0)
+    {
+      printf ("pthread_getaffinity_np failed: %m\n");
+      return false;
+    }
+  for (int cpu =3D 0; cpu <=3D conf->last_cpu; ++cpu)
+    {
+      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), initial_se=
t))
+	continue;
+      other_threads[cpu].conf =3D conf;
+      other_threads[cpu].initial_set =3D initial_set;
+      other_threads[cpu].thread =3D cpu;
+      other_threads[cpu].seen_set =3D CPU_ALLOC (conf->set_size);
+      if (other_threads[cpu].seen_set =3D=3D NULL)
+	{
+	  puts ("Memory allocation failure");
+	  return false;
+	}
+      CPU_ZERO_S (CPU_ALLOC_SIZE (conf->set_size),
+		  other_threads[cpu].seen_set);
+    }
+
+  pthread_attr_t attr;
+  int ret =3D pthread_attr_init (&attr);
+  if (ret !=3D 0)
+    {
+      printf ("pthread_attr_init failed: %s\n", strerror (ret));
+      return false;
+    }
+
+  /* Spawn a thread pinned to each available CPU.  */
+  for (int cpu =3D 0; cpu <=3D conf->last_cpu; ++cpu)
+    {
+      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), initial_se=
t))
+	continue;
+      CPU_ZERO_S (CPU_ALLOC_SIZE (conf->set_size), scratch_set);
+      CPU_SET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), scratch_set);
+      ret =3D pthread_attr_setaffinity_np
+	(&attr, CPU_ALLOC_SIZE (conf->set_size), scratch_set);
+      if (ret !=3D 0)
+	{
+	  printf ("pthread_attr_setaffinity_np for CPU %d failed: %s\n",
+		  cpu, strerror (ret));
+	  stop_and_join_threads (conf, initial_set,
+				 pinned_threads, pinned_threads + cpu,
+				 NULL, NULL);
+	  return false;
+	}
+      ret =3D pthread_create (pinned_threads + cpu, &attr,
+			    thread_burn_one_cpu, (void *) (uintptr_t) cpu);
+      if (ret !=3D 0)
+	{
+	  printf ("pthread_create for CPU %d failed: %s\n",
+		  cpu, strerror (ret));
+	  stop_and_join_threads (conf, initial_set,
+				 pinned_threads, pinned_threads + cpu,
+				 NULL, NULL);
+	  return false;
+	}
+    }
+
+  /* Spawn another set of threads running on all CPUs.  */
+  for (int cpu =3D 0; cpu <=3D conf->last_cpu; ++cpu)
+    {
+      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), initial_se=
t))
+	continue;
+      ret =3D pthread_create (&other_threads[cpu].self, NULL,
+			    thread_burn_any_cpu, other_threads + cpu);
+      if (ret !=3D 0)
+	{
+	  printf ("pthread_create for thread %d failed: %s\n",
+		  cpu, strerror (ret));
+	  stop_and_join_threads (conf, initial_set,
+				 pinned_threads,
+				 pinned_threads + conf->last_cpu + 1,
+				 other_threads, other_threads + cpu);
+	  return false;
+	}
+    }
+
+  /* Main thread.  */
+  struct burn_thread main_thread;
+  main_thread.conf =3D conf;
+  main_thread.initial_set =3D initial_set;
+  main_thread.seen_set =3D scratch_set;
+  main_thread.thread =3D -1;
+  CPU_ZERO_S (CPU_ALLOC_SIZE (conf->set_size), main_thread.seen_set);
+  thread_burn_any_cpu (&main_thread);
+  stop_and_join_threads (conf, initial_set,
+			 pinned_threads,
+			 pinned_threads + conf->last_cpu + 1,
+			 other_threads, other_threads + conf->last_cpu + 1);
+
+  printf ("Main thread ran on %d CPU(s) of %d available CPU(s)\n",
+	  CPU_COUNT_S (CPU_ALLOC_SIZE (conf->set_size), scratch_set),
+	  CPU_COUNT_S (CPU_ALLOC_SIZE (conf->set_size), initial_set));
+  CPU_ZERO_S (CPU_ALLOC_SIZE (conf->set_size), scratch_set);
+  for (int cpu =3D 0; cpu <=3D conf->last_cpu; ++cpu)
+    {
+      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), initial_se=
t))
+	continue;
+      CPU_OR_S (CPU_ALLOC_SIZE (conf->set_size),
+		scratch_set, scratch_set, other_threads[cpu].seen_set);
+      CPU_FREE (other_threads[cpu].seen_set);
+    }
+  printf ("Other threads ran on %d CPU(s)\n",
+	  CPU_COUNT_S (CPU_ALLOC_SIZE (conf->set_size), scratch_set));;
+
+
+  pthread_attr_destroy (&attr);
+  CPU_FREE (scratch_set);
+  CPU_FREE (initial_set);
+  free (pinned_threads);
+  free (other_threads);
+  return failed =3D=3D 0;
+}
diff --git a/posix/Makefile b/posix/Makefile
index cbc4bc6..2d03d4f 100644
--- a/posix/Makefile
+++ b/posix/Makefile
@@ -87,7 +87,8 @@ tests		:=3D tstgetopt testfnm runtests runptests	     \=

 		   bug-getopt1 bug-getopt2 bug-getopt3 bug-getopt4 \
 		   bug-getopt5 tst-getopt_long1 bug-regex34 bug-regex35 \
 		   tst-pathconf tst-getaddrinfo4 tst-rxspencer-no-utf8 \
-		   tst-fnmatch3 bug-regex36 tst-getaddrinfo5
+		   tst-fnmatch3 bug-regex36 tst-getaddrinfo5 \
+		   tst-affinity
 xtests		:=3D bug-ga2
 ifeq (yes,$(build-shared))
 test-srcs	:=3D globtest
diff --git a/posix/tst-affinity.c b/posix/tst-affinity.c
new file mode 100644
index 0000000..1078c63
--- /dev/null
+++ b/posix/tst-affinity.c
@@ -0,0 +1,254 @@
+/* Copyright (C) 2015 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+/* This file is included by nptl/tst-thread-affinity.c to test the
+   pthread variants of the functions.  */
+
+#include <errno.h>
+#include <limits.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <stdio.h>
+
+/* Overide this to test other functions.  */
+#ifndef GETAFFINITY
+#define GETAFFINITY(size, set) sched_getaffinity (0, (size), (set))
+#endif
+#ifndef SETAFFINITY
+#define SETAFFINITY(size, set) sched_setaffinity (0, (size), (set))
+#endif
+#ifndef EARLY_TEST
+#define EARLY_TEST(conf) true
+#endif
+
+struct conf
+{
+  int set_size;			/* in bits */
+  int last_cpu;
+};
+
+static int
+find_set_size (void)
+{
+  /* We need to use multiples of 64 because otherwise, CPU_ALLOC
+     over-allocates, and and we do not see all bits returned by the
+     kernel.  */
+  for (int num_cpus =3D 64; num_cpus <=3D INT_MAX / 2; num_cpus +=3D 64)=

+    {
+      cpu_set_t *set =3D CPU_ALLOC (num_cpus);
+      size_t size =3D CPU_ALLOC_SIZE (num_cpus);
+
+      if (set =3D=3D NULL)
+	{
+	  printf ("CPU_ALLOC(%d) failed\n", num_cpus);
+	  return -1;
+	}
+      if (GETAFFINITY (size, set) =3D=3D 0)
+	{
+	  CPU_FREE (set);
+	  return num_cpus;
+	}
+      if (errno !=3D EINVAL)
+	{
+	  printf ("getaffinity for %d CPUs: %m\n", num_cpus);
+	  CPU_FREE (set);
+	  return -1;
+	}
+      CPU_FREE (set);
+    }
+  puts ("Cannot find maximum CPU number");
+  return -1;
+}
+
+static int
+find_last_cpu (const cpu_set_t *set, size_t size)
+{
+  size_t cpus_found =3D 0;
+  size_t total_cpus =3D CPU_COUNT_S (size, set);
+  int last_cpu =3D -1;
+
+  for (int cpu =3D 0; cpus_found < total_cpus; ++cpu)
+    {
+      if (CPU_ISSET_S (cpu, size, set))
+	{
+	  last_cpu =3D cpu;
+	  ++cpus_found;
+	}
+    }
+  return last_cpu;
+}
+
+static void
+setup_conf (struct conf *conf)
+{
+  *conf =3D (struct conf) {-1, -1};
+  conf->set_size =3D find_set_size ();
+  if (conf->set_size > 0)
+    {
+      cpu_set_t *set =3D CPU_ALLOC (conf->set_size);
+
+      if (set =3D=3D NULL)
+	{
+	  printf ("CPU_ALLOC (%d) failed\n", conf->set_size);
+	  CPU_FREE (set);
+	  return;
+	}
+      if (GETAFFINITY (CPU_ALLOC_SIZE (conf->set_size), set) < 0)
+	{
+	  printf ("getaffinity failed: %m\n");
+	  CPU_FREE (set);
+	  return;
+	}
+      conf->last_cpu =3D find_last_cpu (set, CPU_ALLOC_SIZE (conf->set_s=
ize));
+      if (conf->last_cpu < 0)
+	puts ("No test CPU found");
+      CPU_FREE (set);
+    }
+}
+
+static bool
+test_size (const struct conf *conf, size_t size)
+{
+  if (size < conf->set_size)
+    {
+      printf ("Test not run for CPU set size %zu\n", size);
+      return true;
+    }
+
+  cpu_set_t *initial_set =3D CPU_ALLOC (size);
+  cpu_set_t *set2 =3D CPU_ALLOC (size);
+  cpu_set_t *active_cpu_set =3D CPU_ALLOC (size);
+
+  if (initial_set =3D=3D NULL || set2 =3D=3D NULL || active_cpu_set =3D=3D=
 NULL)
+    {
+      printf ("size %zu: CPU_ALLOC failed\n", size);
+      return false;
+    }
+  size =3D CPU_ALLOC_SIZE (size);
+
+  if (GETAFFINITY (size, initial_set) < 0)
+    {
+      printf ("size %zu: getaffinity: %m\n", size);
+      return false;
+    }
+  if (SETAFFINITY (size, initial_set) < 0)
+    {
+      printf ("size %zu: setaffinity: %m\n", size);
+      return true;
+    }
+
+  /* Use one-CPU set to test switching between CPUs.  */
+  int last_active_cpu =3D -1;
+  for (int cpu =3D 0; cpu <=3D conf->last_cpu; ++cpu)
+    {
+      int active_cpu =3D sched_getcpu ();
+      if (last_active_cpu >=3D 0 && last_active_cpu !=3D active_cpu)
+	{
+	  printf ("Unexpected CPU %d, expected %d\n",
+		  active_cpu, last_active_cpu);
+	  return false;
+	}
+
+      if (!CPU_ISSET_S (cpu, size, initial_set))
+	continue;
+      last_active_cpu =3D cpu;
+
+      CPU_ZERO_S (size, active_cpu_set);
+      CPU_SET_S (cpu, size, active_cpu_set);
+      if (SETAFFINITY (size, active_cpu_set) < 0)
+	{
+	  printf ("size %zu: setaffinity (%d): %m\n", size, cpu);
+	  return false;
+	}
+      active_cpu =3D sched_getcpu ();
+      if (active_cpu !=3D cpu)
+	{
+	  printf ("Unexpected CPU %d, expected %d\n", active_cpu, cpu);
+	  return false;
+	}
+      if (GETAFFINITY (size, set2) < 0)
+	{
+	  printf ("size %zu: getaffinity (2): %m\n", size);
+	  return false;
+	}
+      if (!CPU_EQUAL_S (size, active_cpu_set, set2))
+	{
+	  printf ("size %zu: CPU sets do not match\n", size);
+	  return false;
+	}
+    }
+
+  if (SETAFFINITY (size, initial_set) < 0)
+    {
+      printf ("size %zu: setaffinity (3): %m\n", size);
+      return false;
+    }
+  if (GETAFFINITY (size, set2) < 0)
+    {
+      printf ("size %zu: getaffinity (3): %m\n", size);
+      return false;
+    }
+  if (!CPU_EQUAL_S (size, initial_set, set2))
+    {
+      printf ("size %zu: CPU sets do not match (2)\n", size);
+      return false;
+    }
+
+  CPU_FREE (initial_set);
+  CPU_FREE (set2);
+  CPU_FREE (active_cpu_set);
+
+  return true;
+}
+
+static int
+do_test (void)
+{
+  {
+    cpu_set_t set;
+    if (GETAFFINITY (sizeof (set), &set) < 0 && errno =3D=3D ENOSYS)
+      {
+	puts ("getaffinity not supported");
+	return 0;
+      }
+  }
+
+  struct conf conf;
+  setup_conf (&conf);
+  printf ("Detected CPU set size (in bits): %d\n", conf.set_size);
+  printf ("Maximum test CPU: %d\n", conf.last_cpu);
+  if (conf.set_size < 0 || conf.last_cpu < 0)
+    return 1;
+
+  if (!EARLY_TEST (&conf))
+    return 1;
+
+  if (test_size (&conf, 1024)
+      && test_size (&conf, 2)
+      && test_size (&conf, 32)
+      && test_size (&conf, 40)
+      && test_size (&conf, 64)
+      && test_size (&conf, 96)
+      && test_size (&conf, 128)
+      && test_size (&conf, 256)
+      && test_size (&conf, 1024 * 1024))
+    return 0;
+  return 1;
+}
+
+#define TEST_FUNCTION do_test ()
+#include "../test-skeleton.c"
diff --git a/sysdeps/unix/sysv/linux/check-cpuset.h b/sysdeps/unix/sysv/l=
inux/check-cpuset.h
deleted file mode 100644
index 1d55e0b..0000000
--- a/sysdeps/unix/sysv/linux/check-cpuset.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/* Validate cpu_set_t values for NPTL.  Linux version.
-   Copyright (C) 2002-2015 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <http://www.gnu.org/licenses/>.  */
-
-#include <pthread.h>
-#include <errno.h>
-
-
-/* Defined in pthread_setaffinity.c.  */
-extern size_t __kernel_cpumask_size attribute_hidden;
-extern int __determine_cpumask_size (pid_t tid);
-
-/* Returns 0 if CS and SZ are valid values for the cpuset and cpuset siz=
e
-   respectively.  Otherwise it returns an error number.  */
-static inline int
-check_cpuset_attr (const cpu_set_t *cs, const size_t sz)
-{
-  if (__kernel_cpumask_size =3D=3D 0)
-    {
-      int res =3D __determine_cpumask_size (THREAD_SELF->tid);
-      if (res)
-	return res;
-    }
-
-  /* Check whether the new bitmask has any bit set beyond the
-     last one the kernel accepts.  */
-  for (size_t cnt =3D __kernel_cpumask_size; cnt < sz; ++cnt)
-    if (((char *) cs)[cnt] !=3D '\0')
-      /* Found a nonzero byte.  This means the user request cannot be
-	 fulfilled.  */
-      return EINVAL;
-
-  return 0;
-}
diff --git a/sysdeps/unix/sysv/linux/pthread_setaffinity.c b/sysdeps/unix=
/sysv/linux/pthread_setaffinity.c
index e891818..2ebf09d 100644
--- a/sysdeps/unix/sysv/linux/pthread_setaffinity.c
+++ b/sysdeps/unix/sysv/linux/pthread_setaffinity.c
@@ -23,62 +23,14 @@
 #include <shlib-compat.h>
=20
=20
-size_t __kernel_cpumask_size attribute_hidden;
-
-
-/* Determine the size of cpumask_t in the kernel.  */
-int
-__determine_cpumask_size (pid_t tid)
-{
-  size_t psize;
-  int res;
-
-  for (psize =3D 128; ; psize *=3D 2)
-    {
-      char buf[psize];
-      INTERNAL_SYSCALL_DECL (err);
-
-      res =3D INTERNAL_SYSCALL (sched_getaffinity, err, 3, tid, psize, b=
uf);
-      if (INTERNAL_SYSCALL_ERROR_P (res, err))
-	{
-	  if (INTERNAL_SYSCALL_ERRNO (res, err) !=3D EINVAL)
-	    return INTERNAL_SYSCALL_ERRNO (res, err);
-	}
-      else
-	break;
-    }
-
-  if (res !=3D 0)
-    __kernel_cpumask_size =3D res;
-
-  return 0;
-}
-
-
 int
 __pthread_setaffinity_new (pthread_t th, size_t cpusetsize,
 			   const cpu_set_t *cpuset)
 {
   const struct pthread *pd =3D (const struct pthread *) th;
-
   INTERNAL_SYSCALL_DECL (err);
   int res;
=20
-  if (__glibc_unlikely (__kernel_cpumask_size =3D=3D 0))
-    {
-      res =3D __determine_cpumask_size (pd->tid);
-      if (res !=3D 0)
-	return res;
-    }
-
-  /* We now know the size of the kernel cpumask_t.  Make sure the user
-     does not request to set a bit beyond that.  */
-  for (size_t cnt =3D __kernel_cpumask_size; cnt < cpusetsize; ++cnt)
-    if (((char *) cpuset)[cnt] !=3D '\0')
-      /* Found a nonzero byte.  This means the user request cannot be
-	 fulfilled.  */
-      return EINVAL;
-
   res =3D INTERNAL_SYSCALL (sched_setaffinity, err, 3, pd->tid, cpusetsi=
ze,
 			  cpuset);
=20
diff --git a/sysdeps/unix/sysv/linux/sched_setaffinity.c b/sysdeps/unix/s=
ysv/linux/sched_setaffinity.c
index b528617..dfddce7 100644
--- a/sysdeps/unix/sysv/linux/sched_setaffinity.c
+++ b/sysdeps/unix/sysv/linux/sched_setaffinity.c
@@ -22,50 +22,13 @@
 #include <unistd.h>
 #include <sys/types.h>
 #include <shlib-compat.h>
-#include <alloca.h>
=20
=20
 #ifdef __NR_sched_setaffinity
-static size_t __kernel_cpumask_size;
-
=20
 int
 __sched_setaffinity_new (pid_t pid, size_t cpusetsize, const cpu_set_t *=
cpuset)
 {
-  if (__glibc_unlikely (__kernel_cpumask_size =3D=3D 0))
-    {
-      INTERNAL_SYSCALL_DECL (err);
-      int res;
-
-      size_t psize =3D 128;
-      void *p =3D alloca (psize);
-
-      while (res =3D INTERNAL_SYSCALL (sched_getaffinity, err, 3, getpid=
 (),
-				     psize, p),
-	     INTERNAL_SYSCALL_ERROR_P (res, err)
-	     && INTERNAL_SYSCALL_ERRNO (res, err) =3D=3D EINVAL)
-	p =3D extend_alloca (p, psize, 2 * psize);
-
-      if (res =3D=3D 0 || INTERNAL_SYSCALL_ERROR_P (res, err))
-	{
-	  __set_errno (INTERNAL_SYSCALL_ERRNO (res, err));
-	  return -1;
-	}
-
-      __kernel_cpumask_size =3D res;
-    }
-
-  /* We now know the size of the kernel cpumask_t.  Make sure the user
-     does not request to set a bit beyond that.  */
-  for (size_t cnt =3D __kernel_cpumask_size; cnt < cpusetsize; ++cnt)
-    if (((char *) cpuset)[cnt] !=3D '\0')
-      {
-        /* Found a nonzero byte.  This means the user request cannot be
-	   fulfilled.  */
-	__set_errno (EINVAL);
-	return -1;
-      }
-
   int result =3D INLINE_SYSCALL (sched_setaffinity, 3, pid, cpusetsize, =
cpuset);
=20
 #ifdef RESET_VGETCPU_CACHE
--=20
2.4.3


--------------030403010801000001030001--
