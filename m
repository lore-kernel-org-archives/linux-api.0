From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC 00/20] ns: Introduce Time Namespace
Date: Fri, 21 Sep 2018 14:27:29 +0200
Message-ID: <874lej6nny.fsf@xmission.com>
References: <20180919205037.9574-1-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com> (Dmitry Safonov's message
        of "Wed, 19 Sep 2018 21:50:17 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Dmitry Safonov <dima@arista.com> writes:

> Discussions around time virtualization are there for a long time.
> The first attempt to implement time namespace was in 2006 by Jeff Dike.
> From that time, the topic appears on and off in various discussions.
>
> There are two main use cases for time namespaces:
> 1. change date and time inside a container;
> 2. adjust clocks for a container restored from a checkpoint.
>
> “It seems like this might be one of the last major obstacles keeping
> migration from being used in production systems, given that not all
> containers and connections can be migrated as long as a time dependency
> is capable of messing it up.” (by github.com/dav-ell)
>
> The kernel provides access to several clocks: CLOCK_REALTIME,
> CLOCK_MONOTONIC, CLOCK_BOOTTIME. Last two clocks are monotonous, but the
> start points for them are not defined and are different for each running
> system. When a container is migrated from one node to another, all
> clocks have to be restored into consistent states; in other words, they
> have to continue running from the same points where they have been
> dumped.
>
> The main idea behind this patch set is adding per-namespace offsets for
> system clocks. When a process in a non-root time namespace requests
> time of a clock, a namespace offset is added to the current value of
> this clock on a host and the sum is returned.
>
> All offsets are placed on a separate page, this allows up to map it as 
> part of vvar into user processes and use offsets from vdso calls.
>
> Now offsets are implemented for CLOCK_MONOTONIC and CLOCK_BOOTTIME
> clocks.
>
> Questions to discuss:
>
> * Clone flags exhaustion. Currently there is only one unused clone flag
> bit left, and it may be worth to use it to extend arguments of the clone
> system call.
>
> * Realtime clock implementation details:
>   Is having a simple offset enough?
>   What to do when date and time is changed on the host?
>   Is there a need to adjust vfs modification and creation times? 
>   Implementation for adjtime() syscall.

Overall I support this effort.  In my quick skim this code looked good.

My feeling is that we need to be able to support running ntpd and
support one namespace doing googles smoothing of leap seconds while
another namespace takes the leap second.

What I was imagining when I was last thinking about this was one
instance of struct timekeeper aka tk_core per time namespace.  That
structure already keeps offsets for all of the various clocks from
the kerne internal time sources.  What would be needed would be to
pass in an appropriate time namespace pointer.

I could be completely wrong as I have not take the time to completely
trace through the code.  Have you looked at pushing the time namespace
down as far as tk_core?

What I think would be the big advantage (besides ntp working) is that
the bulk of the code could be reused.  Allowing testing of the kernel's
time code by setting up a new time namespace.  So a person in production
could setup a time namespace with the time set ahead a little  bit and
be able to verify that the kernel handles the upcoming leap second
properly.



I don't know about the vfs.  I think the danger is being able to write
dates in the future or in the past.  It appears that utimes(2) and
utimesnat(2) already allow this except for status change.  So it is
possible we simply don't care.  I seem to remember that what nfs does
is take the time stamp from the host writing to the file.

I think the guide for filesystem timestamps should be to first ensure
we don't introduce security issues, and then do what distributed
filesystems do when dealing with hosts with different clocks.

Given those those two guidlines above I don't think there is a need to
change timestamsp the way the user namespace changes uid when displayed.



As for the hardware like the real time clock we definitely should not
let a root in a time namespace change it.  We might even be able to get
away with leaving the real time clock out of the time namespace.  If not
we need to be very careful how the real time clock is abstracted.  I
would start by leaving the real time clock hardware out of the time
namespace and see if there is any part of userspace that cares.

Eric

> Cc: Dmitry Safonov <0x7f454c46@gmail.com>
> Cc: Adrian Reber <adrian@lisas.de>
> Cc: Andrei Vagin <avagin@openvz.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com> 
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Pavel Emelyanov <xemul@virtuozzo.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: containers@lists.linux-foundation.org
> Cc: criu@openvz.org
> Cc: linux-api@vger.kernel.org
> Cc: x86@kernel.org
>
> Andrei Vagin (12):
>   ns: Introduce Time Namespace
>   timens: Add timens_offsets
>   timens: Introduce CLOCK_MONOTONIC offsets
>   timens: Introduce CLOCK_BOOTTIME offset
>   timerfd/timens: Take into account ns clock offsets
>   kernel: Take into account timens clock offsets in clock_nanosleep
>   x86/vdso/timens: Add offsets page in vvar
>   x86/vdso: Use set_normalized_timespec() to avoid 32 bit overflow
>   posix-timers/timens: Take into account clock offsets
>   selftest/timens: Add test for timerfd
>   selftest/timens: Add test for clock_nanosleep
>   timens/selftest: Add timer offsets test
>
> Dmitry Safonov (8):
>   timens: Shift /proc/uptime
>   x86/vdso: Restrict splitting vvar vma
>   x86/vdso: Purge timens page on setns()/unshare()/clone()
>   x86/vdso: Look for vvar vma to purge timens page
>   timens: Add align for timens_offsets
>   timens: Optimize zero-offsets
>   selftest: Add Time Namespace test for supported clocks
>   timens/selftest: Add procfs selftest
>
>  arch/Kconfig                                     |   5 +
>  arch/x86/Kconfig                                 |   1 +
>  arch/x86/entry/vdso/vclock_gettime.c             |  52 +++++
>  arch/x86/entry/vdso/vdso-layout.lds.S            |   9 +-
>  arch/x86/entry/vdso/vdso2c.c                     |   3 +
>  arch/x86/entry/vdso/vma.c                        |  67 +++++++
>  arch/x86/include/asm/vdso.h                      |   2 +
>  fs/proc/namespaces.c                             |   3 +
>  fs/proc/uptime.c                                 |   3 +
>  fs/timerfd.c                                     |  16 +-
>  include/linux/nsproxy.h                          |   1 +
>  include/linux/proc_ns.h                          |   1 +
>  include/linux/time_namespace.h                   |  72 +++++++
>  include/linux/timens_offsets.h                   |  25 +++
>  include/linux/user_namespace.h                   |   1 +
>  include/uapi/linux/sched.h                       |   1 +
>  init/Kconfig                                     |   8 +
>  kernel/Makefile                                  |   1 +
>  kernel/fork.c                                    |   3 +-
>  kernel/nsproxy.c                                 |  19 +-
>  kernel/time/hrtimer.c                            |   8 +
>  kernel/time/posix-timers.c                       |  89 ++++++++-
>  kernel/time/posix-timers.h                       |   2 +
>  kernel/time_namespace.c                          | 230 +++++++++++++++++++++++
>  tools/testing/selftests/timens/.gitignore        |   5 +
>  tools/testing/selftests/timens/Makefile          |   6 +
>  tools/testing/selftests/timens/clock_nanosleep.c |  98 ++++++++++
>  tools/testing/selftests/timens/config            |   1 +
>  tools/testing/selftests/timens/log.h             |  21 +++
>  tools/testing/selftests/timens/procfs.c          | 145 ++++++++++++++
>  tools/testing/selftests/timens/timens.c          | 196 +++++++++++++++++++
>  tools/testing/selftests/timens/timer.c           |  95 ++++++++++
>  tools/testing/selftests/timens/timerfd.c         |  96 ++++++++++
>  33 files changed, 1272 insertions(+), 13 deletions(-)
>  create mode 100644 include/linux/time_namespace.h
>  create mode 100644 include/linux/timens_offsets.h
>  create mode 100644 kernel/time_namespace.c
>  create mode 100644 tools/testing/selftests/timens/.gitignore
>  create mode 100644 tools/testing/selftests/timens/Makefile
>  create mode 100644 tools/testing/selftests/timens/clock_nanosleep.c
>  create mode 100644 tools/testing/selftests/timens/config
>  create mode 100644 tools/testing/selftests/timens/log.h
>  create mode 100644 tools/testing/selftests/timens/procfs.c
>  create mode 100644 tools/testing/selftests/timens/timens.c
>  create mode 100644 tools/testing/selftests/timens/timer.c
>  create mode 100644 tools/testing/selftests/timens/timerfd.c
