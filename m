From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH RESEND v3 3/3] ptrace: add PTRACE_EVENT_SECCOMP
 support to PTRACE_GET_SYSCALL_INFO
Date: Wed, 28 Nov 2018 13:35:46 +0100
Message-ID: <20181128123545.GA30395@redhat.com>
References: <20181125022150.46258a20@akathisia>
 <20181125022340.5703400f@akathisia>
 <20181126143524.GB1660@redhat.com>
 <20181127040732.1c9f7965@akathisia>
 <20181127123116.GA13284@redhat.com>
 <20181127232753.GA18755@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181127232753.GA18755@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Elvira Khabirova <lineprinter@altlinux.org>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Eugene Syromyatnikov <esyr@redhat.com>, Andy Lutomirski <luto@kernel.org>, strace-devel@lists.strace.io, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/28, Dmitry V. Levin wrote:
>
> > Just like ptrace_request(PTRACE_LISTEN)
> > does but you can do this lockless (no need to lock_task_sighand()).
>
> Why this can be done lockless?  All other places in that file do
> the locking,

PTRACE_LISTEN too doesn't need lock_task_sighand() to access ->last_siginfo,
this code predates ptrace_freeze_traced() which ensures that the tracee can't
go away and clear ->last_siginfo.

However, unlike ptrace_get_syscall(), PTRACE_LISTEN needs spin_lock_irq(siglock),
it modifies ->jobctl and calls signal_wake_up().

> > Of course, debugger can do PTRACE_SETSIGINFO and confuse itself but probably we
> > do not care?
>
> The only potential issue I could think of is whether PTRACE_SETSIGINFO
> could be used this way to cause an information leak by making
> PTRACE_GET_SYSCALL_INFO access some unrelated data.

Well, afaics ptrace_get_syscall() does nothing "special", debugger can use other
PTRACE_ requests to get the same info?

Oleg.
