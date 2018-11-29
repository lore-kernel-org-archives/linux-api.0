From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Thu, 29 Nov 2018 16:08:26 -0700
Message-ID: <20181129230826.GB4676@cisco>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181029224031.29809-2-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 29, 2018 at 04:40:30PM -0600, Tycho Andersen wrote:
> +	resp.id = req.id;
> +	resp.error = -512; /* -ERESTARTSYS */
> +	resp.val = 0;
> +
> +	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);

So, it turns out this *doesn't* work, and the reason this test was
passing is because of poor hygiene on my part.

Per the documentation in include/linux/errno.h,

/*
 * These should never be seen by user programs.  To return one of ERESTART*
 * codes, signal_pending() MUST be set.  Note that ptrace can observe these
 * at syscall exit tracing, but they will never be left for the debugged user
 * process to see.
 */
#define ERESTARTSYS     512

So basically, if you respond with -ERESTARTSYS with no signal pending, you'll
leak it to userspace. It turns out this is already possible with
SECCOMP_RET_TRAP (and probably ptrace alone, although I didn't try it out),
see the program below.

The question is: do we care? If so, it seems like we may need to handle the
-ERESTARTSYS-style cases even when there is no signal pending. If we don't,
there's precedent for us to just do the same thing as what happens for
SECCOMP_RET_TRACE, but we should probably at least fix the docs.

Tycho


#include <stdio.h>
#include <stddef.h>
#include <stdbool.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <signal.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <sys/ptrace.h>
#include <sys/ioctl.h>
#include <inttypes.h>
#include <linux/filter.h>
#include <linux/seccomp.h>
#include <linux/ptrace.h>
#include <linux/elf.h>
#include <pthread.h>


static int filter_syscall(int syscall_nr)
{
	struct sock_filter filter[] = {
		BPF_STMT(BPF_LD+BPF_W+BPF_ABS, offsetof(struct seccomp_data, nr)),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, syscall_nr, 0, 1),
		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_TRACE),
		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
	};

	struct sock_fprog bpf_prog = {
		.len = (unsigned short)(sizeof(filter)/sizeof(filter[0])),
		.filter = filter,
	};

	int ret;

	ret = syscall(__NR_seccomp, SECCOMP_SET_MODE_FILTER, 0, &bpf_prog);
	if (ret < 0) {
		perror("prctl failed");
		return -1;
	}

	return ret;
}

typedef struct {
        uint64_t        r15;
        uint64_t        r14;
        uint64_t        r13;
        uint64_t        r12;
        uint64_t        bp;
        uint64_t        bx;
        uint64_t        r11;
        uint64_t        r10;
        uint64_t        r9;
        uint64_t        r8;
        uint64_t        ax;
        uint64_t        cx;
        uint64_t        dx;
        uint64_t        si;
        uint64_t        di;
        uint64_t        orig_ax;
        uint64_t        ip;
        uint64_t        cs;
        uint64_t        flags;
        uint64_t        sp;
        uint64_t        ss;
        uint64_t        fs_base;
        uint64_t        gs_base;
        uint64_t        ds;
        uint64_t        es;
        uint64_t        fs;
        uint64_t        gs;
} user_regs_struct64;

int main(int argc, char **argv)
{
	pid_t pid;
	user_regs_struct64 regs;
	struct iovec iov = {.iov_base = &regs, .iov_len = sizeof(regs)};
	int status;

	pid = fork();

	if (pid == 0) {
		if (signal(SIGUSR1, signal_handler) == SIG_ERR) {
			perror("signal");
			exit(1);
		}

		if (filter_syscall(__NR_getpid) < 0)
			exit(1);

		/* i'm lazy, so sue me :) */
		sleep(1);

		errno = 0;
		pid = syscall(__NR_getpid);

		/*
		 * we get:
		 *   getpid(): -1, errno: 512
		 * probably should get
		 *   getpid(): <pid> errno: 0
		 */
		printf("getpid(): %d, errno: %d\n", pid, errno);
		exit(errno);
	}

	if (ptrace(PTRACE_ATTACH, pid, NULL, 0) < 0) {
		perror("ptrace attach");
		goto out;
	}

	if (waitpid(pid, NULL, 0) != pid) {
		perror("waitpid");
		goto out;
	}

	if (ptrace(PTRACE_SETOPTIONS, pid, NULL, PTRACE_O_TRACESECCOMP) < 0) {
		perror("ptrace setoptions");
		goto out;
	}

	if (ptrace(PTRACE_CONT, pid, NULL, 0) != 0) {
		perror("ptrace cont");
		goto out;
	}

	if (waitpid(pid, &status, 0) != pid) {
		perror("wait for trace");
		goto out;
	}

	if (status >> 8 != (SIGTRAP | (PTRACE_EVENT_SECCOMP<<8))) {
		printf("got bad trap event?\n");
		goto out;
	}

	if (ptrace(PTRACE_GETREGSET, pid, NT_PRSTATUS, &iov) < 0) {
		perror("getregset");
		goto out;
	}

	/*
	 * Tell the syscall to restart. Per include/linux/errno.h this should
	 * only be set when signal_pending() is set. But we just won't send
	 * any signals to the process, and we'll see this in userspace.
	 */
	regs.ax = -512; /* -ERESTARTSYS */

	/*
	 * This makes the this_syscall < 0 check in __seccomp_filter()
	 * trigger, so we skip the syscall and return whatever is in ax
	 */
	regs.orig_ax = -512; /* -ERESTARTSYS */

	if (ptrace(PTRACE_SETREGSET, pid, NT_PRSTATUS, &iov) < 0) {
		perror("setregset");
		goto out;
	}

	if (ptrace(PTRACE_CONT, pid, NULL, 0) < 0) {
		perror("cont after setregset");
		goto out;
	}

	while (1) {
		if (waitpid(pid, &status, 0) != pid) {
			perror("wait for death");
			goto out;
		}

		if (!WIFSTOPPED(status)) {
			break;
		}

		if (ptrace(PTRACE_CONT, pid, NULL, 0) < 0) {
			perror("cont after setregset");
			goto out;
		}

	}

	if (WIFSIGNALED(status)) {
		printf("didn't exit: %d\n", WTERMSIG(status));
		return 1;
	}

	if (WEXITSTATUS(status)) {
		printf("exited: %d\n", WEXITSTATUS(status));
		return 1;
	}

	return 0;
out:
	kill(pid, SIGKILL);
	return 1;
}
