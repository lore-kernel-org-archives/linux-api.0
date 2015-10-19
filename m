From: "Carlos O'Donell" <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] glibc: Remove CPU set size checking from affinity
 functions [BZ #19143]
Date: Mon, 19 Oct 2015 13:23:47 -0400
Message-ID: <56252723.6010407@redhat.com>
References: <5621126E.5080801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5621126E.5080801-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, GNU C Library <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/16/2015 11:06 AM, Florian Weimer wrote:
> I still believe this is the right course of action.

>From a high level design I don't object to this patch. I've gotten over
the fact that applications using these interfaces might have slighlty
changed behaviour as we cleanup the wrappers to the kernel syscalls.

There is one piece where I object to the code used in the test where
you loop over sched_getaffinity in find_set_size. I think this sets
a bad example for users, and we should be using sysconf here, but that
does not constitute a lack of consensus that this fix is the right way
forward. It is my objection and desire that sysconf be used here, but
again it does not block this patch.

At a nit-picking level there are a few nits.

Therefore if you feel like you can answer all of my questions in this
response, then I think the change is OK. Please post a v2 with the
changes requested and we'll do one last review.

> This is a straight rebase of an old glibc patch, this time with a bug
> and a NEWS entry.
> 
> The goal of this patch is to remove the CPU set size checking in user
> space from the glibc system call wrappers for the sched_setaffinity
> system call (that is, sched_setaffinity and pthread_setaffinity_np).
> 
> The previous discussion is here:
> 
>   <https://sourceware.org/ml/libc-alpha/2015-05/msg00449.html>
> 
> I do not have any new arguments to bring forward.  I can try to explain
> what is going on in a few different words, though.
> 
> The current situation, briefly stated, is this: glibc tries to guess the
> kernel CPU set size and rejects attempts to specify an affinity mask
> which is larger than that, but it does not work, and glibc and the
> kernel still silently accept CPU affinity masks with invalid bits,
> without returning an error.  The glibc check does not provide any value
> to applications, it just adds pointless complexity to the library.
> Therefore, I want to remove it from glibc.

The point of the code you want to remove was to detect the case where
the user set CPU bits outside of the maximum possible number of supported
CPUs. AFAIK today that value is CONFIG_NR_CPUS and the various variables
that derive from that value.

To be honest, it seems like a terrible goal since it is optimizing the
error case where the user is calling the API with invalid bits set.
I would like to see nothing more than the removal of the API, but I'm
still worried about the existing applications that might have come to
rely on the broken behaviour. 

Can you elaborate some more on any of the false negative cases you think
might impact user applications? For example what happens if you use the
stock cpu_set_t size? It would seem to me that such a use keeps working
and there is no change.

All I'm asking is that you speak to the compatibility impact of this
change. If there is none, then please state that and why.

> Remove CPU set size checking from affinity functions [BZ #19143]
> 
> With current kernel versions, the check does not reliably detect that
> unavailable CPUs are requested, for these reasons:
> 
> (1) The kernel will silently ignore non-allowed CPUs.

You mean to say that if sched_setaffinity is called with a CPU mask 
bit set to enabled, but that cpu is not allowed for the process, then
it will ignore the setting? This requires you run sched_getaffinity to
verify what CPUs you're actually set to run on? Is this because the
cpuset mechanism is merged with sched_setaffinity and overrides it?

> (2) Similarly, CPU bits which lack an online CPU (possible CPUs)
>     are ignored.

OK.

> (3) The existing probing code assumes that the CPU mask size is a
>     power of two and at least 1024.  Neither it has to be a power
>     of two, nor is the minimum possible value 1024, so the value
>     determined is often too large, resulting in incorrect false
>     negatives.

Could you explain those "false negative" cases again?

> The kernel will still return EINVAL if no CPU in the requested set
> remains which can run the current thread after the affinity change.

OK.

> Applications which care about the exact affinity mask will have to query
> it using sched_getaffinity after setting it.  Due to the effects above,
> this commit does not change this.

Right. I assume this is due to cpuset and NUMA memory policy?

> 2015-10-16  Florian Weimer  <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

	[BZ #19143]

> 	* nptl/check-cpuset.h: Remove.
> 	* nptl/pthread_attr_setaffinity.c (__pthread_attr_setaffinity_new):
> 	Remove CPU set size check.
> 	* nptl/pthread_setattr_default_np.c (pthread_setattr_default_np):
> 	Likewise.
> 	* sysdeps/unix/sysv/linux/check-cpuset.h: Remove.
> 	* sysdeps/unix/sysv/linux/pthread_setaffinity.c
> 	(__kernel_cpumask_size, __determine_cpumask_size): Remove.
> 	(__pthread_setaffinity_new): Remove CPU set size check.
> 	* sysdeps/unix/sysv/linux/sched_setaffinity.c
> 	(__kernel_cpumask_size): Remove.
> 	(__sched_setaffinity_new): Remove CPU set size check.
> 	* manual/threads.texi (Default Thread Attributes): Remove stale
> 	reference to check_cpuset_attr, determine_cpumask_size in comment.
> 	* posix/Makefile (tests): Add tst-affinity.
> 	* posix/tst-affinity.c: New file.
> 	* nptl/Makefile (tests): Add tst-thread-affinity.
> 	* nptl/tst-thread-affinity.c: New file.

The goal is to keep nptl/ free from linux-isms, and AFAICT your test is
indeed free of any linux-specific features since your code for finding
the size of the cpu mask is generic. Is there anything I might have missed
that would make your test linux-specific? Keep in mind that we share nptl/
with the nacl port.

> diff --git a/NEWS b/NEWS
> index 861027a..d012c82 100644
> --- a/NEWS
> +++ b/NEWS
> @@ -20,11 +20,19 @@ Version 2.23
>    18961, 18966, 18967, 18969, 18970, 18977, 18980, 18981, 18985, 19003,
>    19007, 19012, 19016, 19018, 19032, 19046, 19049, 19050, 19059, 19071,
>    19074, 19076, 19077, 19078, 19079, 19085, 19086, 19088, 19094, 19095,
> -  19124, 19125, 19129, 19134, 19137
> +  19124, 19125, 19129, 19134, 19137, 19143.
>  
>  * The LD_POINTER_GUARD environment variable can no longer be used to
>    disable the pointer guard feature.  It is always enabled.
>  
> +* sched_setaffinity, pthread_setaffinity_np no longer attempt to guess the
> +  kernel-internal CPU set size.  This means that requests that change the
> +  CPU affinity which failed before will now succeed.  Applications that need

Please provide at least one example of a failure which now succeeds.

> +  to determine the effective CPU affinities need to call sched_getaffinity
> +  or pthread_getaffinity_np after setting it because the kernel can adjust
> +  it (and the previous size check would not detect this in the majority of
> +  cases).

OK.

> +
>  * The obsolete header <regexp.h> has been removed.  Programs that require
>    this header must be updated to use <regex.h> instead.
>  
> diff --git a/manual/threads.texi b/manual/threads.texi
> index 4d080d4..00cc725 100644
> --- a/manual/threads.texi
> +++ b/manual/threads.texi
> @@ -111,8 +111,6 @@ failure.
>  @c  check_sched_priority_attr ok
>  @c   sched_get_priority_min dup ok
>  @c   sched_get_priority_max dup ok
> -@c  check_cpuset_attr ok
> -@c   determine_cpumask_size ok

OK.

>  @c  check_stacksize_attr ok
>  @c  lll_lock @asulock @aculock
>  @c  free dup @ascuheap @acsmem
> diff --git a/nptl/Makefile b/nptl/Makefile
> index 311b1a7..e172a0a 100644
> --- a/nptl/Makefile
> +++ b/nptl/Makefile
> @@ -287,7 +287,8 @@ tests = tst-typesizes \
>  	tst-setuid3 \
>  	tst-initializers1 $(addprefix tst-initializers1-,c89 gnu89 c99 gnu99) \
>  	tst-bad-schedattr \
> -	tst-thread_local1
> +	tst-thread_local1 \
> +	tst-thread-affinity

OK.

>  xtests = tst-setuid1 tst-setuid1-static tst-setuid2 \
>  	tst-mutexpp1 tst-mutexpp6 tst-mutexpp10
>  test-srcs = tst-oddstacklimit
> diff --git a/nptl/check-cpuset.h b/nptl/check-cpuset.h
> deleted file mode 100644
> index 315bdf2..0000000
> --- a/nptl/check-cpuset.h
> +++ /dev/null
> @@ -1,32 +0,0 @@
> -/* Validate cpu_set_t values for NPTL.  Stub version.
> -   Copyright (C) 2015 Free Software Foundation, Inc.
> -   This file is part of the GNU C Library.
> -
> -   The GNU C Library is free software; you can redistribute it and/or
> -   modify it under the terms of the GNU Lesser General Public
> -   License as published by the Free Software Foundation; either
> -   version 2.1 of the License, or (at your option) any later version.
> -
> -   The GNU C Library is distributed in the hope that it will be useful,
> -   but WITHOUT ANY WARRANTY; without even the implied warranty of
> -   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> -   Lesser General Public License for more details.
> -
> -   You should have received a copy of the GNU Lesser General Public
> -   License along with the GNU C Library; if not, see
> -   <http://www.gnu.org/licenses/>.  */
> -
> -#include <errno.h>
> -
> -/* Returns 0 if CS and SZ are valid values for the cpuset and cpuset size
> -   respectively.  Otherwise it returns an error number.  */
> -static inline int
> -check_cpuset_attr (const cpu_set_t *cs, const size_t sz)
> -{
> -  if (sz == 0)
> -    return 0;
> -
> -  /* This means pthread_attr_setaffinity will return ENOSYS, which
> -     is the right thing when the cpu_set_t features are not available.  */
> -  return ENOSYS;
> -}

OK.

> diff --git a/nptl/pthread_attr_setaffinity.c b/nptl/pthread_attr_setaffinity.c
> index 7a127b8..571835d 100644
> --- a/nptl/pthread_attr_setaffinity.c
> +++ b/nptl/pthread_attr_setaffinity.c
> @@ -23,7 +23,6 @@
>  #include <string.h>
>  #include <pthreadP.h>
>  #include <shlib-compat.h>
> -#include <check-cpuset.h>
>  
>  
>  int
> @@ -43,11 +42,6 @@ __pthread_attr_setaffinity_new (pthread_attr_t *attr, size_t cpusetsize,
>      }
>    else
>      {
> -      int ret = check_cpuset_attr (cpuset, cpusetsize);
> -
> -      if (ret)
> -        return ret;

OK.

> -
>        if (iattr->cpusetsize != cpusetsize)
>  	{
>  	  void *newp = (cpu_set_t *) realloc (iattr->cpuset, cpusetsize);
> diff --git a/nptl/pthread_setattr_default_np.c b/nptl/pthread_setattr_default_np.c
> index 457a467..1a661f1 100644
> --- a/nptl/pthread_setattr_default_np.c
> +++ b/nptl/pthread_setattr_default_np.c
> @@ -21,7 +21,6 @@
>  #include <pthreadP.h>
>  #include <assert.h>
>  #include <string.h>
> -#include <check-cpuset.h>
>  
>  
>  int
> @@ -48,10 +47,6 @@ pthread_setattr_default_np (const pthread_attr_t *in)
>  	return ret;
>      }
>  
> -  ret = check_cpuset_attr (real_in->cpuset, real_in->cpusetsize);
> -  if (ret)
> -    return ret;

OK.

> -
>    /* stacksize == 0 is fine.  It means that we don't change the current
>       value.  */
>    if (real_in->stacksize != 0)
> diff --git a/nptl/tst-thread-affinity.c b/nptl/tst-thread-affinity.c
> new file mode 100644
> index 0000000..9e120b8
> --- /dev/null
> +++ b/nptl/tst-thread-affinity.c
> @@ -0,0 +1,295 @@
> +/* Copyright (C) 2015 Free Software Foundation, Inc.

Please add a one line test description with BZ #.

> +   This file is part of the GNU C Library.
> +
> +   The GNU C Library is free software; you can redistribute it and/or
> +   modify it under the terms of the GNU Lesser General Public
> +   License as published by the Free Software Foundation; either
> +   version 2.1 of the License, or (at your option) any later version.
> +
> +   The GNU C Library is distributed in the hope that it will be useful,
> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> +   Lesser General Public License for more details.
> +
> +   You should have received a copy of the GNU Lesser General Public
> +   License along with the GNU C Library; if not, see
> +   <http://www.gnu.org/licenses/>.  */
> +
> +#include <errno.h>
> +#include <pthread.h>
> +#include <stdbool.h>
> +#include <stdlib.h>
> +#include <sys/time.h>
> +
> +static int
> +setaffinity (size_t size, const cpu_set_t *set)
> +{
> +  int ret = pthread_setaffinity_np (pthread_self (), size, set);
> +  if (ret != 0)
> +    {
> +      errno = ret;
> +      return -1;
> +    }
> +  return 0;

OK.

> +}
> +
> +static int
> +getaffinity (size_t size, cpu_set_t *set)
> +{
> +  int ret = pthread_getaffinity_np (pthread_self (), size, set);
> +  if (ret != 0)
> +    {
> +      errno = ret;
> +      return -1;
> +    }
> +  return 0;

OK.

> +}
> +
> +struct conf;
> +static bool early_test (struct conf *);
> +
> +#define SETAFFINITY(size, set) setaffinity ((size), (set))
> +#define GETAFFINITY(size, set) getaffinity ((size), (set))
> +#define EARLY_TEST(conf) early_test (conf)

See comments below about macro API issues.

> +
> +/* We wave two loops running for two seconds each.  */
> +#define TIMEOUT 8

Why two seconds?

Why two threads?

If the value of 2 seconds is arbitrary please state so in 
a comment such that future reviewers can adjust it as they
see fit without having to review the history of the value.

> +
> +#include "../posix/tst-affinity.c"
> +
> +static int still_running;
> +static int failed;
> +
> +static void *
> +thread_burn_one_cpu (void *closure)
> +{
> +  int cpu = (uintptr_t) closure;
> +  while (__atomic_load_n (&still_running, __ATOMIC_RELAXED) == 0)
> +    {
> +      int current = sched_getcpu ();
> +      if (sched_getcpu () != cpu)
> +	{
> +	  printf ("FAIL: Pinned thread %d ran on impossible cpu %d\n",
> +		  cpu, current);
> +	  __atomic_store_n (&failed, 1, __ATOMIC_RELAXED);
> +	  __atomic_store_n (&still_running, 1, __ATOMIC_RELAXED);
> +	}
> +    }
> +  return NULL;

OK.

> +}
> +
> +struct burn_thread
> +{
> +  pthread_t self;
> +  struct conf *conf;
> +  cpu_set_t *initial_set;
> +  cpu_set_t *seen_set;
> +  int thread;
> +};

OK.

> +
> +static void *
> +thread_burn_any_cpu (void *closure)
> +{
> +  struct burn_thread *param = closure;
> +
> +  /* Schedule this thread around a bit to see if it lands on another
> +     CPU.  Run this for 2 seconds, once with sched_yield, once
> +     without.  */

See note abouve about 2 seconds, and 2 passes, if it's arbitrary,
please state that.

Would be nicer if you had a macro that could adjust all of this
with one change.

> +  for (int pass = 1; pass <= 2; ++pass)
> +    {
> +      time_t start = time (NULL);
> +      while (time (NULL) - start < 3)
> +	{
> +	  int cpu = sched_getcpu ();
> +	  if (cpu > param->conf->last_cpu
> +	      || !CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (param->conf->set_size),
> +			       param->initial_set))
> +	    {
> +	      printf ("FAIL: Unpinned thread %d ran on impossible CPU %d\n",
> +		      param->thread, cpu);
> +	      __atomic_store_n (&failed, 1, __ATOMIC_RELAXED);
> +	      return NULL;
> +	    }
> +	  CPU_SET_S (cpu, CPU_ALLOC_SIZE (param->conf->set_size),
> +		     param->seen_set);
> +	  if (pass == 1)
> +	    sched_yield ();
> +	}
> +    }
> +  return NULL;
> +}
> +
> +static void
> +stop_and_join_threads (struct conf *conf, cpu_set_t *set,
> +		       pthread_t *pinned_first, pthread_t *pinned_last,
> +		       struct burn_thread *other_first,
> +		       struct burn_thread *other_last)
> +{
> +  __atomic_store_n (&still_running, 1, __ATOMIC_RELAXED);

OK. Good use of atomics.

> +  for (pthread_t *p = pinned_first; p < pinned_last; ++p)
> +    {
> +      int cpu = p - pinned_first;
> +      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), set))
> +	continue;
> +
> +      int ret = pthread_join (*p, NULL);
> +      if (ret != 0)
> +	{
> +	  printf ("Failed to join thread %d: %s\n", cpu, strerror (ret));
> +	  fflush (stdout);
> +	  /* Cannot shut down cleanly with threads still running.  */
> +	  abort ();
> +	}
> +    }

OK.

> +
> +  for (struct burn_thread *p = other_first; p < other_last; ++p)
> +    {
> +      int cpu = p - other_first;
> +      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), set))
> +	continue;
> +
> +      int ret = pthread_join (p->self, NULL);
> +      if (ret != 0)
> +	{
> +	  printf ("Failed to join thread %d: %s\n", cpu, strerror (ret));
> +	  fflush (stdout);
> +	  /* Cannot shut down cleanly with threads still running.  */
> +	  abort ();
> +	}
> +    }

OK.

> +}
> +
> +/* Tries to check that the initial set of CPUs is complete and that
> +   the main thread will not run on any other threads.  */
> +static bool
> +early_test (struct conf *conf)
> +{
> +  pthread_t *pinned_threads
> +    = calloc (conf->last_cpu + 1, sizeof (*pinned_threads));
> +  struct burn_thread *other_threads
> +    = calloc (conf->last_cpu + 1, sizeof (*other_threads));
> +  cpu_set_t *initial_set = CPU_ALLOC (conf->set_size);
> +  cpu_set_t *scratch_set = CPU_ALLOC (conf->set_size);
> +
> +  if (pinned_threads == NULL || other_threads == NULL
> +      || initial_set == NULL || scratch_set == NULL)
> +    {
> +      puts ("Memory allocation failure");
> +      return false;
> +    }
> +  if (getaffinity (CPU_ALLOC_SIZE (conf->set_size), initial_set) < 0)
> +    {
> +      printf ("pthread_getaffinity_np failed: %m\n");
> +      return false;
> +    }
> +  for (int cpu = 0; cpu <= conf->last_cpu; ++cpu)
> +    {
> +      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), initial_set))
> +	continue;
> +      other_threads[cpu].conf = conf;
> +      other_threads[cpu].initial_set = initial_set;
> +      other_threads[cpu].thread = cpu;
> +      other_threads[cpu].seen_set = CPU_ALLOC (conf->set_size);
> +      if (other_threads[cpu].seen_set == NULL)
> +	{
> +	  puts ("Memory allocation failure");
> +	  return false;
> +	}
> +      CPU_ZERO_S (CPU_ALLOC_SIZE (conf->set_size),
> +		  other_threads[cpu].seen_set);
> +    }

OK.

> +
> +  pthread_attr_t attr;
> +  int ret = pthread_attr_init (&attr);
> +  if (ret != 0)
> +    {
> +      printf ("pthread_attr_init failed: %s\n", strerror (ret));
> +      return false;
> +    }
> +
> +  /* Spawn a thread pinned to each available CPU.  */
> +  for (int cpu = 0; cpu <= conf->last_cpu; ++cpu)
> +    {
> +      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), initial_set))
> +	continue;
> +      CPU_ZERO_S (CPU_ALLOC_SIZE (conf->set_size), scratch_set);
> +      CPU_SET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), scratch_set);
> +      ret = pthread_attr_setaffinity_np
> +	(&attr, CPU_ALLOC_SIZE (conf->set_size), scratch_set);
> +      if (ret != 0)
> +	{
> +	  printf ("pthread_attr_setaffinity_np for CPU %d failed: %s\n",
> +		  cpu, strerror (ret));
> +	  stop_and_join_threads (conf, initial_set,
> +				 pinned_threads, pinned_threads + cpu,
> +				 NULL, NULL);
> +	  return false;
> +	}
> +      ret = pthread_create (pinned_threads + cpu, &attr,
> +			    thread_burn_one_cpu, (void *) (uintptr_t) cpu);
> +      if (ret != 0)
> +	{
> +	  printf ("pthread_create for CPU %d failed: %s\n",
> +		  cpu, strerror (ret));
> +	  stop_and_join_threads (conf, initial_set,
> +				 pinned_threads, pinned_threads + cpu,
> +				 NULL, NULL);
> +	  return false;
> +	}
> +    }

OK.

> +
> +  /* Spawn another set of threads running on all CPUs.  */
> +  for (int cpu = 0; cpu <= conf->last_cpu; ++cpu)
> +    {
> +      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), initial_set))
> +	continue;
> +      ret = pthread_create (&other_threads[cpu].self, NULL,
> +			    thread_burn_any_cpu, other_threads + cpu);
> +      if (ret != 0)
> +	{
> +	  printf ("pthread_create for thread %d failed: %s\n",
> +		  cpu, strerror (ret));
> +	  stop_and_join_threads (conf, initial_set,
> +				 pinned_threads,
> +				 pinned_threads + conf->last_cpu + 1,
> +				 other_threads, other_threads + cpu);
> +	  return false;
> +	}
> +    }

OK.

> +
> +  /* Main thread.  */
> +  struct burn_thread main_thread;
> +  main_thread.conf = conf;
> +  main_thread.initial_set = initial_set;
> +  main_thread.seen_set = scratch_set;
> +  main_thread.thread = -1;
> +  CPU_ZERO_S (CPU_ALLOC_SIZE (conf->set_size), main_thread.seen_set);
> +  thread_burn_any_cpu (&main_thread);
> +  stop_and_join_threads (conf, initial_set,
> +			 pinned_threads,
> +			 pinned_threads + conf->last_cpu + 1,
> +			 other_threads, other_threads + conf->last_cpu + 1);
> +
> +  printf ("Main thread ran on %d CPU(s) of %d available CPU(s)\n",
> +	  CPU_COUNT_S (CPU_ALLOC_SIZE (conf->set_size), scratch_set),
> +	  CPU_COUNT_S (CPU_ALLOC_SIZE (conf->set_size), initial_set));
> +  CPU_ZERO_S (CPU_ALLOC_SIZE (conf->set_size), scratch_set);
> +  for (int cpu = 0; cpu <= conf->last_cpu; ++cpu)
> +    {
> +      if (!CPU_ISSET_S (cpu, CPU_ALLOC_SIZE (conf->set_size), initial_set))
> +	continue;
> +      CPU_OR_S (CPU_ALLOC_SIZE (conf->set_size),
> +		scratch_set, scratch_set, other_threads[cpu].seen_set);
> +      CPU_FREE (other_threads[cpu].seen_set);
> +    }
> +  printf ("Other threads ran on %d CPU(s)\n",
> +	  CPU_COUNT_S (CPU_ALLOC_SIZE (conf->set_size), scratch_set));;
> +
> +
> +  pthread_attr_destroy (&attr);
> +  CPU_FREE (scratch_set);
> +  CPU_FREE (initial_set);
> +  free (pinned_threads);
> +  free (other_threads);
> +  return failed == 0;

OK.

> +}
> diff --git a/posix/Makefile b/posix/Makefile
> index cbc4bc6..2d03d4f 100644
> --- a/posix/Makefile
> +++ b/posix/Makefile
> @@ -87,7 +87,8 @@ tests		:= tstgetopt testfnm runtests runptests	     \
>  		   bug-getopt1 bug-getopt2 bug-getopt3 bug-getopt4 \
>  		   bug-getopt5 tst-getopt_long1 bug-regex34 bug-regex35 \
>  		   tst-pathconf tst-getaddrinfo4 tst-rxspencer-no-utf8 \
> -		   tst-fnmatch3 bug-regex36 tst-getaddrinfo5
> +		   tst-fnmatch3 bug-regex36 tst-getaddrinfo5 \
> +		   tst-affinity

OK.

>  xtests		:= bug-ga2
>  ifeq (yes,$(build-shared))
>  test-srcs	:= globtest
> diff --git a/posix/tst-affinity.c b/posix/tst-affinity.c
> new file mode 100644
> index 0000000..1078c63
> --- /dev/null
> +++ b/posix/tst-affinity.c
> @@ -0,0 +1,254 @@

Needs a one line test description with BZ#.

> +/* Copyright (C) 2015 Free Software Foundation, Inc.
> +   This file is part of the GNU C Library.
> +
> +   The GNU C Library is free software; you can redistribute it and/or
> +   modify it under the terms of the GNU Lesser General Public
> +   License as published by the Free Software Foundation; either
> +   version 2.1 of the License, or (at your option) any later version.
> +
> +   The GNU C Library is distributed in the hope that it will be useful,
> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> +   Lesser General Public License for more details.
> +
> +   You should have received a copy of the GNU Lesser General Public
> +   License along with the GNU C Library; if not, see
> +   <http://www.gnu.org/licenses/>.  */
> +
> +/* This file is included by nptl/tst-thread-affinity.c to test the
> +   pthread variants of the functions.  */
> +
> +#include <errno.h>
> +#include <limits.h>
> +#include <sched.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +
> +/* Overide this to test other functions.  */
> +#ifndef GETAFFINITY
> +#define GETAFFINITY(size, set) sched_getaffinity (0, (size), (set))
> +#endif
> +#ifndef SETAFFINITY
> +#define SETAFFINITY(size, set) sched_setaffinity (0, (size), (set))
> +#endif
> +#ifndef EARLY_TEST
> +#define EARLY_TEST(conf) true
> +#endif

If possible please avoid ifndef pattern and provide two files. One 
for the non-threaded case and one for the threaded case and let the
sysdep selection mechanism pick the right one. Otherwise a typo here
or elshwere results in testing the wrong thing and nobody notices.
Without ifndef a typo results in a build erorr.

See:
https://sourceware.org/glibc/wiki/Wundef

> +
> +struct conf
> +{
> +  int set_size;			/* in bits */
> +  int last_cpu;
> +};
> +
> +static int
> +find_set_size (void)
> +{
> +  /* We need to use multiples of 64 because otherwise, CPU_ALLOC
> +     over-allocates, and and we do not see all bits returned by the
> +     kernel.  */

How does CPU_ALLOC over-allocating result in not seeing bits from 
the kernel? Is this because you get over-allocation in CPU_ALLOC,
but your own external count of num_cpus would be lower and it's
num_cpus you return? Can't you rely on the result of CPU_ALLOC_SIZE
and return that?

We should really fix sched_getaffinity and make it not fail like
sched_setaffinity. The asymmetry in the APIs leads to the following
code which I don't like.

> +  for (int num_cpus = 64; num_cpus <= INT_MAX / 2; num_cpus += 64)
> +    {
> +      cpu_set_t *set = CPU_ALLOC (num_cpus);
> +      size_t size = CPU_ALLOC_SIZE (num_cpus);
> +
> +      if (set == NULL)
> +	{
> +	  printf ("CPU_ALLOC(%d) failed\n", num_cpus);
> +	  return -1;
> +	}
> +      if (GETAFFINITY (size, set) == 0)
> +	{
> +	  CPU_FREE (set);
> +	  return num_cpus;
> +	}
> +      if (errno != EINVAL)
> +	{
> +	  printf ("getaffinity for %d CPUs: %m\n", num_cpus);
> +	  CPU_FREE (set);
> +	  return -1;
> +	}
> +      CPU_FREE (set);
> +    }

Why do we do this instead of calling sysconf to get the number
of CPUs?

I don't want to condone the use of code like that in find_set_size
for our users of the dynamic interface. I would like us to be able to 
send the linux man pages a patch that explains exactly how to use
the CPU_ALLOC code optimally without looping to compute the size
we want. Right now all the examples use fixed cpu_set_t sizes.

Related:
https://sourceware.org/bugzilla/show_bug.cgi?id=15630

This is not a sustained objection. However, if you do go forward
with this code please add a comment saying that it should use
sysconf and that looping like this is a bad example.

In summary, the only way to find the maximum should be to use sysconf
not loops like you do above.

> +  puts ("Cannot find maximum CPU number");
> +  return -1;
> +}
> +
> +static int
> +find_last_cpu (const cpu_set_t *set, size_t size)
> +{
> +  size_t cpus_found = 0;
> +  size_t total_cpus = CPU_COUNT_S (size, set);
> +  int last_cpu = -1;
> +
> +  for (int cpu = 0; cpus_found < total_cpus; ++cpu)
> +    {
> +      if (CPU_ISSET_S (cpu, size, set))
> +	{
> +	  last_cpu = cpu;
> +	  ++cpus_found;
> +	}
> +    }
> +  return last_cpu;
> +}

OK.

> +
> +static void
> +setup_conf (struct conf *conf)
> +{
> +  *conf = (struct conf) {-1, -1};
> +  conf->set_size = find_set_size ();
> +  if (conf->set_size > 0)
> +    {
> +      cpu_set_t *set = CPU_ALLOC (conf->set_size);
> +
> +      if (set == NULL)
> +	{
> +	  printf ("CPU_ALLOC (%d) failed\n", conf->set_size);
> +	  CPU_FREE (set);
> +	  return;
> +	}
> +      if (GETAFFINITY (CPU_ALLOC_SIZE (conf->set_size), set) < 0)
> +	{
> +	  printf ("getaffinity failed: %m\n");
> +	  CPU_FREE (set);
> +	  return;
> +	}
> +      conf->last_cpu = find_last_cpu (set, CPU_ALLOC_SIZE (conf->set_size));
> +      if (conf->last_cpu < 0)
> +	puts ("No test CPU found");
> +      CPU_FREE (set);
> +    }
> +}

OK.

> +
> +static bool
> +test_size (const struct conf *conf, size_t size)
> +{

Should print PASS:/FAIL: prefix to make grepping easier.

> +  if (size < conf->set_size)
> +    {
> +      printf ("Test not run for CPU set size %zu\n", size);
> +      return true;
> +    }
> +
> +  cpu_set_t *initial_set = CPU_ALLOC (size);
> +  cpu_set_t *set2 = CPU_ALLOC (size);
> +  cpu_set_t *active_cpu_set = CPU_ALLOC (size);
> +
> +  if (initial_set == NULL || set2 == NULL || active_cpu_set == NULL)
> +    {
> +      printf ("size %zu: CPU_ALLOC failed\n", size);
> +      return false;
> +    }
> +  size = CPU_ALLOC_SIZE (size);
> +
> +  if (GETAFFINITY (size, initial_set) < 0)
> +    {
> +      printf ("size %zu: getaffinity: %m\n", size);
> +      return false;
> +    }
> +  if (SETAFFINITY (size, initial_set) < 0)
> +    {
> +      printf ("size %zu: setaffinity: %m\n", size);
> +      return true;
> +    }
> +
> +  /* Use one-CPU set to test switching between CPUs.  */
> +  int last_active_cpu = -1;
> +  for (int cpu = 0; cpu <= conf->last_cpu; ++cpu)
> +    {
> +      int active_cpu = sched_getcpu ();
> +      if (last_active_cpu >= 0 && last_active_cpu != active_cpu)
> +	{
> +	  printf ("Unexpected CPU %d, expected %d\n",
> +		  active_cpu, last_active_cpu);
> +	  return false;
> +	}
> +
> +      if (!CPU_ISSET_S (cpu, size, initial_set))
> +	continue;
> +      last_active_cpu = cpu;
> +
> +      CPU_ZERO_S (size, active_cpu_set);
> +      CPU_SET_S (cpu, size, active_cpu_set);
> +      if (SETAFFINITY (size, active_cpu_set) < 0)
> +	{
> +	  printf ("size %zu: setaffinity (%d): %m\n", size, cpu);
> +	  return false;
> +	}
> +      active_cpu = sched_getcpu ();
> +      if (active_cpu != cpu)
> +	{
> +	  printf ("Unexpected CPU %d, expected %d\n", active_cpu, cpu);
> +	  return false;
> +	}
> +      if (GETAFFINITY (size, set2) < 0)
> +	{
> +	  printf ("size %zu: getaffinity (2): %m\n", size);
> +	  return false;
> +	}
> +      if (!CPU_EQUAL_S (size, active_cpu_set, set2))
> +	{
> +	  printf ("size %zu: CPU sets do not match\n", size);
> +	  return false;
> +	}
> +    }
> +
> +  if (SETAFFINITY (size, initial_set) < 0)
> +    {
> +      printf ("size %zu: setaffinity (3): %m\n", size);
> +      return false;
> +    }
> +  if (GETAFFINITY (size, set2) < 0)
> +    {
> +      printf ("size %zu: getaffinity (3): %m\n", size);
> +      return false;
> +    }
> +  if (!CPU_EQUAL_S (size, initial_set, set2))
> +    {
> +      printf ("size %zu: CPU sets do not match (2)\n", size);
> +      return false;
> +    }
> +
> +  CPU_FREE (initial_set);
> +  CPU_FREE (set2);
> +  CPU_FREE (active_cpu_set);
> +
> +  return true;
> +}
> +
> +static int
> +do_test (void)
> +{
> +  {
> +    cpu_set_t set;
> +    if (GETAFFINITY (sizeof (set), &set) < 0 && errno == ENOSYS)
> +      {
> +	puts ("getaffinity not supported");
> +	return 0;
> +      }
> +  }

OK.

> +
> +  struct conf conf;
> +  setup_conf (&conf);
> +  printf ("Detected CPU set size (in bits): %d\n", conf.set_size);
> +  printf ("Maximum test CPU: %d\n", conf.last_cpu);
> +  if (conf.set_size < 0 || conf.last_cpu < 0)
> +    return 1;
> +
> +  if (!EARLY_TEST (&conf))
> +    return 1;
> +
> +  if (test_size (&conf, 1024)
> +      && test_size (&conf, 2)
> +      && test_size (&conf, 32)
> +      && test_size (&conf, 40)
> +      && test_size (&conf, 64)
> +      && test_size (&conf, 96)
> +      && test_size (&conf, 128)
> +      && test_size (&conf, 256)
> +      && test_size (&conf, 1024 * 1024))

Should do what other tests do e.g. err |= and run each
test on a distinct line. Makes it easier to add tests and
disable tests while debugging.

> +    return 0;
> +  return 1;

OK.

> +}
> +
> +#define TEST_FUNCTION do_test ()
> +#include "../test-skeleton.c"
> diff --git a/sysdeps/unix/sysv/linux/check-cpuset.h b/sysdeps/unix/sysv/linux/check-cpuset.h
> deleted file mode 100644
> index 1d55e0b..0000000
> --- a/sysdeps/unix/sysv/linux/check-cpuset.h
> +++ /dev/null
> @@ -1,48 +0,0 @@
> -/* Validate cpu_set_t values for NPTL.  Linux version.
> -   Copyright (C) 2002-2015 Free Software Foundation, Inc.
> -   This file is part of the GNU C Library.
> -
> -   The GNU C Library is free software; you can redistribute it and/or
> -   modify it under the terms of the GNU Lesser General Public
> -   License as published by the Free Software Foundation; either
> -   version 2.1 of the License, or (at your option) any later version.
> -
> -   The GNU C Library is distributed in the hope that it will be useful,
> -   but WITHOUT ANY WARRANTY; without even the implied warranty of
> -   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> -   Lesser General Public License for more details.
> -
> -   You should have received a copy of the GNU Lesser General Public
> -   License along with the GNU C Library; if not, see
> -   <http://www.gnu.org/licenses/>.  */
> -
> -#include <pthread.h>
> -#include <errno.h>
> -
> -
> -/* Defined in pthread_setaffinity.c.  */
> -extern size_t __kernel_cpumask_size attribute_hidden;
> -extern int __determine_cpumask_size (pid_t tid);
> -
> -/* Returns 0 if CS and SZ are valid values for the cpuset and cpuset size
> -   respectively.  Otherwise it returns an error number.  */
> -static inline int
> -check_cpuset_attr (const cpu_set_t *cs, const size_t sz)
> -{
> -  if (__kernel_cpumask_size == 0)
> -    {
> -      int res = __determine_cpumask_size (THREAD_SELF->tid);
> -      if (res)
> -	return res;
> -    }
> -
> -  /* Check whether the new bitmask has any bit set beyond the
> -     last one the kernel accepts.  */
> -  for (size_t cnt = __kernel_cpumask_size; cnt < sz; ++cnt)
> -    if (((char *) cs)[cnt] != '\0')
> -      /* Found a nonzero byte.  This means the user request cannot be
> -	 fulfilled.  */
> -      return EINVAL;
> -
> -  return 0;
> -}

OK.

> diff --git a/sysdeps/unix/sysv/linux/pthread_setaffinity.c b/sysdeps/unix/sysv/linux/pthread_setaffinity.c
> index e891818..2ebf09d 100644
> --- a/sysdeps/unix/sysv/linux/pthread_setaffinity.c
> +++ b/sysdeps/unix/sysv/linux/pthread_setaffinity.c
> @@ -23,62 +23,14 @@
>  #include <shlib-compat.h>
>  
>  
> -size_t __kernel_cpumask_size attribute_hidden;
> -
> -
> -/* Determine the size of cpumask_t in the kernel.  */
> -int
> -__determine_cpumask_size (pid_t tid)
> -{
> -  size_t psize;
> -  int res;
> -
> -  for (psize = 128; ; psize *= 2)
> -    {
> -      char buf[psize];
> -      INTERNAL_SYSCALL_DECL (err);
> -
> -      res = INTERNAL_SYSCALL (sched_getaffinity, err, 3, tid, psize, buf);
> -      if (INTERNAL_SYSCALL_ERROR_P (res, err))
> -	{
> -	  if (INTERNAL_SYSCALL_ERRNO (res, err) != EINVAL)
> -	    return INTERNAL_SYSCALL_ERRNO (res, err);
> -	}
> -      else
> -	break;
> -    }
> -
> -  if (res != 0)
> -    __kernel_cpumask_size = res;
> -
> -  return 0;
> -}
> -

OK.

> -
>  int
>  __pthread_setaffinity_new (pthread_t th, size_t cpusetsize,
>  			   const cpu_set_t *cpuset)
>  {
>    const struct pthread *pd = (const struct pthread *) th;
> -
>    INTERNAL_SYSCALL_DECL (err);
>    int res;
>  
> -  if (__glibc_unlikely (__kernel_cpumask_size == 0))
> -    {
> -      res = __determine_cpumask_size (pd->tid);
> -      if (res != 0)
> -	return res;
> -    }
> -
> -  /* We now know the size of the kernel cpumask_t.  Make sure the user
> -     does not request to set a bit beyond that.  */
> -  for (size_t cnt = __kernel_cpumask_size; cnt < cpusetsize; ++cnt)
> -    if (((char *) cpuset)[cnt] != '\0')
> -      /* Found a nonzero byte.  This means the user request cannot be
> -	 fulfilled.  */
> -      return EINVAL;
> -

OK.

>    res = INTERNAL_SYSCALL (sched_setaffinity, err, 3, pd->tid, cpusetsize,
>  			  cpuset);
>  
> diff --git a/sysdeps/unix/sysv/linux/sched_setaffinity.c b/sysdeps/unix/sysv/linux/sched_setaffinity.c
> index b528617..dfddce7 100644
> --- a/sysdeps/unix/sysv/linux/sched_setaffinity.c
> +++ b/sysdeps/unix/sysv/linux/sched_setaffinity.c
> @@ -22,50 +22,13 @@
>  #include <unistd.h>
>  #include <sys/types.h>
>  #include <shlib-compat.h>
> -#include <alloca.h>
>  
>  
>  #ifdef __NR_sched_setaffinity
> -static size_t __kernel_cpumask_size;
> -
>  
>  int
>  __sched_setaffinity_new (pid_t pid, size_t cpusetsize, const cpu_set_t *cpuset)
>  {
> -  if (__glibc_unlikely (__kernel_cpumask_size == 0))
> -    {
> -      INTERNAL_SYSCALL_DECL (err);
> -      int res;
> -
> -      size_t psize = 128;
> -      void *p = alloca (psize);
> -
> -      while (res = INTERNAL_SYSCALL (sched_getaffinity, err, 3, getpid (),
> -				     psize, p),
> -	     INTERNAL_SYSCALL_ERROR_P (res, err)
> -	     && INTERNAL_SYSCALL_ERRNO (res, err) == EINVAL)
> -	p = extend_alloca (p, psize, 2 * psize);
> -
> -      if (res == 0 || INTERNAL_SYSCALL_ERROR_P (res, err))
> -	{
> -	  __set_errno (INTERNAL_SYSCALL_ERRNO (res, err));
> -	  return -1;
> -	}
> -
> -      __kernel_cpumask_size = res;
> -    }
> -
> -  /* We now know the size of the kernel cpumask_t.  Make sure the user
> -     does not request to set a bit beyond that.  */
> -  for (size_t cnt = __kernel_cpumask_size; cnt < cpusetsize; ++cnt)
> -    if (((char *) cpuset)[cnt] != '\0')
> -      {
> -        /* Found a nonzero byte.  This means the user request cannot be
> -	   fulfilled.  */
> -	__set_errno (EINVAL);
> -	return -1;
> -      }

OK.

> -
>    int result = INLINE_SYSCALL (sched_setaffinity, 3, pid, cpusetsize, cpuset);
>  
>  #ifdef RESET_VGETCPU_CACHE
> -- 2.4.3

Cheers,
Carlos.
