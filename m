From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH v4 2/2] pidfd: add tests for NSpid info in fdinfo
Date: Wed, 13 Nov 2019 17:22:33 +0530
Message-ID: <CA+G9fYu=Z+mZs7+571PbChODV2drUYrxkdWEb7=XqkK2O3_Tyw@mail.gmail.com>
References: <20191011122323.7770-1-ckellner@redhat.com> <20191014162034.2185-1-ckellner@redhat.com>
 <20191014162034.2185-2-ckellner@redhat.com> <20191015100743.t6gowsic7c347ldv@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191015100743.t6gowsic7c347ldv@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Christian Kellner <ckellner@redhat.com>, open list <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Jann Horn <jannh@google.com>, Christian Kellner <christian@kellner.me>, Christian Brauner <christian@ubuntu.com>, Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, "Dmitry V. Levin" <ldv@altlinux.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Christian,

On Tue, 15 Oct 2019 at 15:37, Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Mon, Oct 14, 2019 at 06:20:33PM +0200, Christian Kellner wrote:
> > From: Christian Kellner <christian@kellner.me>
> >
> > Add a test that checks that if pid namespaces are configured the fdinfo
> > file of a pidfd contains an NSpid: entry containing the process id in
> > the current and additionally all nested namespaces. In the case that
> > a pidfd is from a pid namespace not in the same namespace hierarchy as
> > the process accessing the fdinfo file, ensure the 'NSpid' shows 0 for
> > that pidfd, analogous to the 'Pid' entry.
> >
> > Signed-off-by: Christian Kellner <christian@kellner.me>
>
> That looks reasonable to me.

on arm64 Juno-r2, Hikey (hi6220) and dragonboard 410c and arm32
Beagleboard x15 test pidfd_test failed.
and on x86_64 and i386 test fails intermittently with TIMEOUT error.
Test code is being used from linux next tree.

Juno-r2 test output:
--------------------------
# selftests pidfd pidfd_test
pidfd: pidfd_test_ #
# TAP version 13
version: 13_ #
# 1..4
: _ #
# # Parent pid 10586
Parent: pid_10586 #
# # Parent Waiting for Child (10587) to complete.
Parent: Waiting_for #
# # Time waited for child 0
Time: waited_for #
# Bail out! pidfd_poll check for premature notification on child
thread exec test Failed
out!: pidfd_poll_check #
# # Planned tests != run tests (4 != 0)
Planned: tests_!= #
# # Pass 0 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
Pass: 0_Fail #
[FAIL] 1 selftests pidfd pidfd_test # exit=1
selftests: pidfd_pidfd_test [FAIL]

arm32 x15 output log,
-----------------------------
# selftests pidfd pidfd_test
pidfd: pidfd_test_ #
[FAIL] 1 selftests pidfd pidfd_test # TIMEOUT
selftests: pidfd_pidfd_test [FAIL]

x86_64 output log,
-------------------------
# selftests pidfd pidfd_test
pidfd: pidfd_test_ #
[FAIL] 1 selftests pidfd pidfd_test # TIMEOUT
selftests: pidfd_pidfd_test [FAIL]

Test results comparison,
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kselftest/pidfd_pidfd_test
https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/pidfd_pidfd_test

link,
https://lkft.validation.linaro.org/scheduler/job/993549#L17835

- Naresh
