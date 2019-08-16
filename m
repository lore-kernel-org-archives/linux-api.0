From: Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCHv6 30/36] selftest/timens: Add Time Namespace test for
 supported clocks
Date: Thu, 15 Aug 2019 23:20:32 -0700
Message-ID: <20190816062032.GB14312@gmail.com>
References: <20190815163836.2927-1-dima@arista.com>
 <20190815163836.2927-31-dima@arista.com>
 <02add700-b626-a1b4-09e1-1e4d5cd242f2@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <02add700-b626-a1b4-09e1-1e4d5cd242f2@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shuah <shuah@kernel.org>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 15, 2019 at 05:18:21PM -0600, shuah wrote:
> Hi Dmitry,
> 
> Thanks for the patch.
> 
> On 8/15/19 10:38 AM, Dmitry Safonov wrote:
> > A test to check that all supported clocks work on host and inside
> > a new time namespace. Use both ways to get time: through VDSO and
> > by entering the kernel with implicit syscall.
> > 
> > Introduce a new timens directory in selftests framework for
> > the next timens tests.
> > 
> > Co-developed-by: Andrei Vagin <avagin@openvz.org>
> > Signed-off-by: Andrei Vagin <avagin@openvz.org>
> > Signed-off-by: Dmitry Safonov <dima@arista.com>
> > ---
> >   tools/testing/selftests/Makefile          |   1 +
> >   tools/testing/selftests/timens/.gitignore |   1 +
> >   tools/testing/selftests/timens/Makefile   |   5 +
> >   tools/testing/selftests/timens/config     |   1 +
> >   tools/testing/selftests/timens/log.h      |  26 +++
> >   tools/testing/selftests/timens/timens.c   | 185 ++++++++++++++++++++++
> >   tools/testing/selftests/timens/timens.h   |  63 ++++++++
> >   7 files changed, 282 insertions(+)
> >   create mode 100644 tools/testing/selftests/timens/.gitignore
> >   create mode 100644 tools/testing/selftests/timens/Makefile
> >   create mode 100644 tools/testing/selftests/timens/config
> >   create mode 100644 tools/testing/selftests/timens/log.h
> >   create mode 100644 tools/testing/selftests/timens/timens.c
> >   create mode 100644 tools/testing/selftests/timens/timens.h
> > 
> > diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> > index 25b43a8c2b15..6fc63b84a857 100644
> > --- a/tools/testing/selftests/Makefile
> > +++ b/tools/testing/selftests/Makefile
> > @@ -47,6 +47,7 @@ TARGETS += splice
> >   TARGETS += static_keys
> >   TARGETS += sync
> >   TARGETS += sysctl
> > +TARGETS += timens
> 
> How long does this test run for?

On my laptop, it needs 30 miliseconds.

> Does this test need to be run
> as root? If yes, please add a root check and skip the test.

Yes, it needs to be as root. We will add this check. Thanks.

> 
> What does the test output looks like for skip and pass/fail cases?

[avagin@laptop timens]$ ./timens 
not ok 1 # SKIP Time namespaces are not supported

[root@fc24 timens]# ./timens 
1..10
ok 1 Passed for CLOCK_BOOTTIME (syscall)
ok 2 Passed for CLOCK_BOOTTIME (vdso)
ok 3 Passed for CLOCK_BOOTTIME_ALARM (syscall)
ok 4 Passed for CLOCK_BOOTTIME_ALARM (vdso)
ok 5 Passed for CLOCK_MONOTONIC (syscall)
ok 6 Passed for CLOCK_MONOTONIC (vdso)
ok 7 Passed for CLOCK_MONOTONIC_COARSE (syscall)
ok 8 Passed for CLOCK_MONOTONIC_COARSE (vdso)
ok 9 Passed for CLOCK_MONOTONIC_RAW (syscall)
ok 10 Passed for CLOCK_MONOTONIC_RAW (vdso)
# Pass 10 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0

Thanks,
Andrei

> 
> thanks,
> -- Shuah
