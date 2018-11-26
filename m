From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RESEND v3 1/3] ptrace: pass type of a syscall-stop in
 ptrace_message
Date: Mon, 26 Nov 2018 15:56:43 +0100
Message-ID: <20181126145643.GD1660@redhat.com>
References: <20181125022150.46258a20@akathisia>
 <20181125022227.55e8caf7@akathisia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181125022227.55e8caf7@akathisia>
Sender: linux-kernel-owner@vger.kernel.org
To: Elvira Khabirova <lineprinter@altlinux.org>
Cc: rostedt@goodmis.org, mingo@redhat.com, linux-kernel@vger.kernel.org, ldv@altlinux.org, esyr@redhat.com, luto@kernel.org, strace-devel@lists.strace.io, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/25, Elvira Khabirova wrote:
>
> + * These values are stored in task->ptrace_message by tracehook_report_syscall_*
> + * to describe current syscall-stop.
> + *
> + * Values for these constants are chosen so that they do not appear
> + * in task->ptrace_message by other means.
> + */
> +#define PTRACE_EVENTMSG_SYSCALL_ENTRY	0x80000000U
> +#define PTRACE_EVENTMSG_SYSCALL_EXIT	0x90000000U

Stupid question, why not

	#define PTRACE_EVENT_SYSCALL_ENTRY	8
	#define PTRACE_EVENT_SYSCALL_EXIT	9

right after other PTRACE_EVENT_* constants?

The next 3/3 tries to detect PTRACE_EVENT_SECCOMP case anyway, so I am not sure
I understand what "do not appear in task->ptrace_message by other means" actually
means...

Oleg.
