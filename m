From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 1/2] ptrace: save the type of syscall-stop in
 ptrace_message
Date: Wed, 28 Nov 2018 15:20:06 +0100
Message-ID: <20181128142006.GE30395@redhat.com>
References: <20181128130439.GB28206@altlinux.org>
 <20181128130601.GC28206@altlinux.org>
 <20181128134913.GC30395@redhat.com>
 <20181128140533.GF28206@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128140533.GF28206@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Michael Ellerman <mpe@ellerman.id.au>, Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromyatnikov <esyr@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org

On 11/28, Dmitry V. Levin wrote:
>
> On Wed, Nov 28, 2018 at 02:49:14PM +0100, Oleg Nesterov wrote:
> > On 11/28, Dmitry V. Levin wrote:
> > >
> > > +/*
> > > + * These values are stored in task->ptrace_message by tracehook_report_syscall_*
> > > + * to describe current syscall-stop.
> > > + *
> > > + * Values for these constants are chosen so that they do not appear
> > > + * in task->ptrace_message by other means.
> > > + */
> > > +#define PTRACE_EVENTMSG_SYSCALL_ENTRY	0x80000000U
> > > +#define PTRACE_EVENTMSG_SYSCALL_EXIT	0x90000000U
> > 
> > Again, I do not really understand the comment... Why should we care about
> > "do not appear in task->ptrace_message by other means" ?
> > 
> > 2/2 should detect ptrace_report_syscall() case correctly, so we can use any
> > numbers, say, 1 and 2?
> > 
> > If debugger does PTRACE_GETEVENTMSG it should know how to interpet the value
> > anyway after wait(status).
> 
> Given that without this patch the value returned by PTRACE_GETEVENTMSG
> during syscall stop is undefined, we need two different ptrace_message
> values that cannot be set by other ptrace events to enable reliable
> identification of syscall-enter-stop and syscall-exit-stop in userspace:
> if we make PTRACE_GETEVENTMSG return 0 or any other value routinely set by
> other ptrace events, it would be hard for userspace to find out whether
> the kernel implements new semantics or not.

Hmm, why? Debugger can just do ptrace(PTRACE_GET_SYSCALL_INFO, NULL), if it
returns EIO then it is not implemented?

Oleg.
