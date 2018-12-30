From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v6 2/2] selftests: add tests for pidfd_send_signal()
Date: Mon, 31 Dec 2018 00:27:13 +0100
Message-ID: <20181230232711.7aayb7vnhogbv4co@brauner.io>
References: <20181229222756.30027-1-christian@brauner.io>
 <20181229222756.30027-2-christian@brauner.io>
 <20181230210245.GA30252@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181230210245.GA30252@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, keescook@chromium.org, akpm@linux-foundation.org, jannh@google.com, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On Sun, Dec 30, 2018 at 03:02:45PM -0600, Serge Hallyn wrote:
> On Sat, Dec 29, 2018 at 11:27:56PM +0100, Christian Brauner wrote:
> > As suggested by Andrew Morton in [1] add selftests for the new
> > sys_pidfd_send_signal() syscall.
> > This tests whether we can send a signal to an existing process and whether
> > sending a signal to a process that has already exited fails with ESRCH.
> > 
> > [1]: https://lore.kernel.org/lkml/20181228152012.dbf0508c2508138efc5f2bbe@linux-foundation.org/
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Serge Hallyn <serge@hallyn.com>
> 
> Acked-by: Serge Hallyn <serge@hallyn.com>
> 
> Not saying you need to do this, but it would be neat if you could test
> sending to a pid which has been recycled :)

Yeah, I thought about it but it's a little weird code. First of all, we
can't set /proc/sys/kernel/pid_max to a very low value since this is a
system wide setting. So we need to recycle a lot via fork(). Something
along the lines of:
- unshare pid namespace
- fork to create pid 1 in new pid namespace
- cycle with fork() until pid > 300 since pids lower than 300 are
  reserved by the kernel.
  (That means if we simply use the first fork() after we created pid 1 we
  would never be able to recycle the pid since we skip over it. :))
- get pidfd to the pid > 300 we just created
- wait on the pid > 300
- cycle via fork() until we have reached the same pid > 300 again
- send SIGSTOP to that recycled process
- test that we cannot send SIGCONT to this SIGSTOPed task via the pidfd we
  received before
- send SIGCONT to the SIGSTOPed recycled pid and exit

Christian

> 
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Andy Lutomirsky <luto@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Aleksa Sarai <cyphar@cyphar.com>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Florian Weimer <fweimer@redhat.com>
> > Signed-off-by: Christian Brauner <christian@brauner.io>
> > ---
> > /* Changelog */
> > v6:
> > - patch introduced
> > v5..v0:
> > - patch not present
> > ---
> >  tools/testing/selftests/Makefile           |   1 +
> >  tools/testing/selftests/pidfd/Makefile     |   6 +
> >  tools/testing/selftests/pidfd/pidfd_test.c | 130 +++++++++++++++++++++
> >  3 files changed, 137 insertions(+)
> >  create mode 100644 tools/testing/selftests/pidfd/Makefile
> >  create mode 100644 tools/testing/selftests/pidfd/pidfd_test.c
> > 
> > diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> > index 24b9934fb269..63b0d8a0ebf7 100644
> > --- a/tools/testing/selftests/Makefile
> > +++ b/tools/testing/selftests/Makefile
> > @@ -27,6 +27,7 @@ TARGETS += net
> >  TARGETS += netfilter
> >  TARGETS += networking/timestamping
> >  TARGETS += nsfs
> > +TARGETS += pidfd
> >  TARGETS += powerpc
> >  TARGETS += proc
> >  TARGETS += pstore
> > diff --git a/tools/testing/selftests/pidfd/Makefile b/tools/testing/selftests/pidfd/Makefile
> > new file mode 100644
> > index 000000000000..deaf8073bc06
> > --- /dev/null
> > +++ b/tools/testing/selftests/pidfd/Makefile
> > @@ -0,0 +1,6 @@
> > +CFLAGS += -g -I../../../../usr/include/
> > +
> > +TEST_GEN_PROGS := pidfd_test
> > +
> > +include ../lib.mk
> > +
> > diff --git a/tools/testing/selftests/pidfd/pidfd_test.c b/tools/testing/selftests/pidfd/pidfd_test.c
> > new file mode 100644
> > index 000000000000..edcd59979b10
> > --- /dev/null
> > +++ b/tools/testing/selftests/pidfd/pidfd_test.c
> > @@ -0,0 +1,130 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#define _GNU_SOURCE
> > +#include <errno.h>
> > +#include <fcntl.h>
> > +#include <linux/types.h>
> > +#include <signal.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <syscall.h>
> > +#include <sys/wait.h>
> > +#include <unistd.h>
> > +
> > +#include "../kselftest.h"
> > +
> > +static inline int sys_pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
> > +					unsigned int flags)
> > +{
> > +	return syscall(__NR_pidfd_send_signal, pidfd, sig, info, flags);
> > +}
> > +
> > +static int signal_received;
> > +
> > +static void do_exit_success(int sig)
> > +{
> > +	signal_received = 1;
> > +}
> > +
> > +/*
> > + * Straightforward test to see whether pidfd_send_signal() works is to send
> > + * a signal to ourselves.
> > + */
> > +static int test_pidfd_send_signal_simple_success(void)
> > +{
> > +	int pidfd, ret;
> > +	const char *test_name = "pidfd_send_signal send SIGUSR1";
> > +
> > +	pidfd = open("/proc/self", O_DIRECTORY | O_CLOEXEC);
> > +	if (pidfd < 0)
> > +		ksft_exit_fail_msg(
> > +			"%s test: Failed to open process file descriptor\n",
> > +			test_name);
> > +
> > +	signal(SIGUSR1, do_exit_success);
> > +
> > +	ret = sys_pidfd_send_signal(pidfd, SIGUSR1, NULL, 0);
> > +	close(pidfd);
> > +	if (ret < 0)
> > +		ksft_exit_fail_msg("%s test: Failed to send signal\n",
> > +				   test_name);
> > +
> > +	if (signal_received != 1)
> > +		ksft_exit_fail_msg("%s test: Failed to receive signal\n",
> > +				   test_name);
> > +
> > +	signal_received = 0;
> > +	ksft_test_result_pass("%s test: Sent signal\n", test_name);
> > +	return 0;
> > +}
> > +
> > +static void wait_for_pid(pid_t pid)
> > +{
> > +	int status, ret;
> > +
> > +again:
> > +	ret = waitpid(pid, &status, 0);
> > +	if (ret == -1) {
> > +		if (errno == EINTR)
> > +			goto again;
> > +
> > +		return;
> > +	}
> > +
> > +	if (ret != pid)
> > +		goto again;
> > +}
> > +
> > +static int test_pidfd_send_signal_exited_fail(void)
> > +{
> > +	int pidfd, ret, saved_errno;
> > +	char buf[256];
> > +	pid_t pid;
> > +	const char *test_name = "pidfd_send_signal signal exited process";
> > +
> > +	pid = fork();
> > +	if (pid < 0)
> > +		ksft_exit_fail_msg("%s test: Failed to create new process\n",
> > +				   test_name);
> > +
> > +	if (pid == 0)
> > +		_exit(EXIT_SUCCESS);
> > +
> > +	snprintf(buf, sizeof(buf), "/proc/%d", pid);
> > +
> > +	pidfd = open(buf, O_DIRECTORY | O_CLOEXEC);
> > +
> > +	wait_for_pid(pid);
> > +
> > +	if (pidfd < 0)
> > +		ksft_exit_fail_msg(
> > +			"%s test: Failed to open process file descriptor\n",
> > +			test_name);
> > +
> > +	ret = sys_pidfd_send_signal(pidfd, 0, NULL, 0);
> > +	saved_errno = errno;
> > +	close(pidfd);
> > +	if (ret == 0)
> > +		ksft_exit_fail_msg(
> > +			"%s test: Managed to send signal to process even though it should have failed\n",
> > +			test_name);
> > +
> > +	if (saved_errno != ESRCH)
> > +		ksft_exit_fail_msg(
> > +			"%s test: Expected to receive ESRCH as errno value but received %d instead\n",
> > +			test_name, saved_errno);
> > +
> > +	ksft_test_result_pass("%s test: Failed to send signal as expected\n",
> > +			      test_name);
> > +	return 0;
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +	ksft_print_header();
> > +
> > +	test_pidfd_send_signal_simple_success();
> > +	test_pidfd_send_signal_exited_fail();
> > +
> > +	return ksft_exit_pass();
> > +}
> > -- 
> > 2.19.1
