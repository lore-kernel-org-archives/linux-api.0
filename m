From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH RESEND v3 3/3] ptrace: add PTRACE_EVENT_SECCOMP
 support to PTRACE_GET_SYSCALL_INFO
Date: Tue, 27 Nov 2018 13:31:17 +0100
Message-ID: <20181127123116.GA13284@redhat.com>
References: <20181125022150.46258a20@akathisia>
 <20181125022340.5703400f@akathisia>
 <20181126143524.GB1660@redhat.com>
 <20181127040732.1c9f7965@akathisia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181127040732.1c9f7965@akathisia>
Sender: linux-kernel-owner@vger.kernel.org
To: Elvira Khabirova <lineprinter@altlinux.org>
Cc: rostedt@goodmis.org, mingo@redhat.com, linux-kernel@vger.kernel.org, ldv@altlinux.org, esyr@redhat.com, luto@kernel.org, strace-devel@lists.strace.io, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/27, Elvira Khabirova wrote:
>
> On Mon, 26 Nov 2018 15:35:24 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 11/25, Elvira Khabirova wrote:
> > >
> > > Extend PTRACE_GET_SYSCALL_INFO to support PTRACE_EVENT_SECCOMP stops.
> > > The information returned is the same as for syscall-enter-stops.
> >
> > Oh, this is not nice ;) there must be a better option, I hope... Plus
> >
> >
> > Can't ptrace_get_syscall() check
> >
> > 	child->exit_code == (PTRACE_EVENT_SECCOMP << 8) | SIGTRAP;
> >
> > to detect the PTRACE_EVENT_SECCOMP case?
>
> Nope; looks like exit_code is zeroed after wait().

Yes, thanks for correcting me,

but we can use child->last_siginfo->si_code. Just like ptrace_request(PTRACE_LISTEN)
does but you can do this lockless (no need to lock_task_sighand()).

And if we require that the user of ptrace_get_syscall() should also use TRACESYSGOOD
then ptrace_get_syscall() can probably do something like

	int entry;

	if (!child->last_siginfo)
		return -EINVAL;
	else if (child->last_siginfo->si_code == (PTRACE_EVENT_SECCOMP << 8) | SIGTRAP)
		entry = 1;
	else if (child->last_siginfo->si_code == SIGTRAP | 0x80)
		entry = child->ptrace_message == PTRACE_EVENTMSG_SYSCALL_ENTRY;
	else
		return -EINVAL;

and this way PTRACE_EVENTMSG_SYSCALL_ENTRY/EXIT can't confict with seccomp or
anything else.

No?

Of course, debugger can do PTRACE_SETSIGINFO and confuse itself but probably we
do not care?

Oleg.
