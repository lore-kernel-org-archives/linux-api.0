From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v4 1/2] ptrace: save the type of syscall-stop in ptrace_message
Date: Wed, 28 Nov 2018 15:17:49 -0800
Message-ID: <CALCETrVjMorQDsJzQGaREEB5_7B24ApWSoNQfRd3K3QNSGAyEA@mail.gmail.com>
References: <20181128130439.GB28206@altlinux.org> <20181128130601.GC28206@altlinux.org>
 <20181128134913.GC30395@redhat.com> <20181128140533.GF28206@altlinux.org>
 <20181128142006.GE30395@redhat.com> <20181128152346.GG28206@altlinux.org> <20181128221125.GA2800@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181128221125.GA2800@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Michael Ellerman <mpe@ellerman.id.au>, Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromiatnikov <esyr@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org

On Wed, Nov 28, 2018 at 2:11 PM Dmitry V. Levin <ldv@altlinux.org> wrote:
>
> On Wed, Nov 28, 2018 at 06:23:46PM +0300, Dmitry V. Levin wrote:
> > On Wed, Nov 28, 2018 at 03:20:06PM +0100, Oleg Nesterov wrote:
> > > On 11/28, Dmitry V. Levin wrote:
> > > > On Wed, Nov 28, 2018 at 02:49:14PM +0100, Oleg Nesterov wrote:
> > > > > On 11/28, Dmitry V. Levin wrote:
> > > > > >
> > > > > > +/*
> > > > > > + * These values are stored in task->ptrace_message by tracehook_report_syscall_*
> > > > > > + * to describe current syscall-stop.
> > > > > > + *
> > > > > > + * Values for these constants are chosen so that they do not appear
> > > > > > + * in task->ptrace_message by other means.
> > > > > > + */
> > > > > > +#define PTRACE_EVENTMSG_SYSCALL_ENTRY        0x80000000U
> > > > > > +#define PTRACE_EVENTMSG_SYSCALL_EXIT 0x90000000U
> > > > >
> > > > > Again, I do not really understand the comment... Why should we care about
> > > > > "do not appear in task->ptrace_message by other means" ?
> > > > >
> > > > > 2/2 should detect ptrace_report_syscall() case correctly, so we can use any
> > > > > numbers, say, 1 and 2?
> > > > >
> > > > > If debugger does PTRACE_GETEVENTMSG it should know how to interpet the value
> > > > > anyway after wait(status).
> > > >
> > > > Given that without this patch the value returned by PTRACE_GETEVENTMSG
> > > > during syscall stop is undefined, we need two different ptrace_message
> > > > values that cannot be set by other ptrace events to enable reliable
> > > > identification of syscall-enter-stop and syscall-exit-stop in userspace:
> > > > if we make PTRACE_GETEVENTMSG return 0 or any other value routinely set by
> > > > other ptrace events, it would be hard for userspace to find out whether
> > > > the kernel implements new semantics or not.
> > >
> > > Hmm, why? Debugger can just do ptrace(PTRACE_GET_SYSCALL_INFO, NULL), if it
> > > returns EIO then it is not implemented?
> >
> > The debugger that uses PTRACE_GET_SYSCALL_INFO does not need to call
> > PTRACE_GETEVENTMSG for syscall stops.
> > My concern here is the PTRACE_GETEVENTMSG interface itself.  If we use
> > ptrace_message to implement PTRACE_GET_SYSCALL_INFO and expose
> > PTRACE_EVENTMSG_SYSCALL_{ENTRY,EXIT} for regular PTRACE_GETEVENTMSG users,
> > it should have clear semantics.
>
> Since our implementation of PTRACE_GET_SYSCALL_INFO uses ptrace_message
> to distinguish syscall-enter-stop from syscall-exit-stop, we could choose
> one of the following approaches:
>
> 1. Do not document the values saved into ptrace_message during syscall
> stops (and exposed via PTRACE_GETEVENTMSG) as a part of ptrace API,
> leaving the value returned by PTRACE_GETEVENTMSG during syscall stops
> as undefined.
>
> 2. Document these values chosen to avoid collisions with ptrace_message values
> set by other ptrace events so that PTRACE_GETEVENTMSG users can easily tell
> whether this new semantics is supported by the kernel or not.

I don't like any of this at all.  Can we please choose a sensible API
design and let the API drive the implementation instead of vice versa?
 ISTM the correct solution is to add some new state to task_struct for
this.

If we're concerned about making task_struct bigger, I have a
half-finished patch to factor all the ptrace tracee state into a
separate struct.
