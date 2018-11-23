From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Thu, 22 Nov 2018 16:19:10 -0800
Message-ID: <CALCETrXvXzRzoEqwEY_VZ7Vpt-sLwaF+rZPg+y_eG2xyzubXtw@mail.gmail.com>
References: <20181121165806.07da7c98@akathisia>
 <CALCETrV3TPCkYyhoLLcikXVeF-RdZUuLTCvKReK3Qb9LSS9Csw@mail.gmail.com>
 <20181121235634.GA14146@altlinux.org>
 <CALCETrXea_uRAqw_srW5CWgOzeM=RubaDbjnxZ=cUMy5Zv1TsA@mail.gmail.com>
 <20181122191504.GB27204@altlinux.org>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181122191504.GB27204-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Cc: Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 22, 2018 at 11:15 AM Dmitry V. Levin <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org> wrote:
>
> On Thu, Nov 22, 2018 at 06:55:29AM -0800, Andy Lutomirski wrote:
> > On Wed, Nov 21, 2018 at 3:56 PM Dmitry V. Levin wrote:
> > > On Wed, Nov 21, 2018 at 02:56:57PM -0800, Andy Lutomirski wrote:
> > > > Please cc linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org for future versions.
> > > >
> > > > On Wed, Nov 21, 2018 at 7:58 AM Elvira Khabirova wrote:
> > > > >
> > > > > struct ptrace_syscall_info {
> > > > >         __u8 op; /* 0 for entry, 1 for exit */
> > > >
> > > > Can you add proper defines, like:
> > > >
> > > > #define PTRACE_SYSCALL_ENTRY 0
> > > > #define PTRACE_SYSCALL_EXIT 1
> > > > #define PTRACE_SYSCALL_SECCOMP 2
> > > >
> > > > and make seccomp work from the start?  I'd rather we don't merge an
> > > > implementation that doesn't work for seccomp and then have to rework
> > > > it later.
> > >
> > > What's the difference between PTRACE_EVENT_SECCOMP and syscall-entry-stop
> > > with regards to PTRACE_GET_SYSCALL_INFO request?  At least they have the
> > > same entry_info to return.
> >
> > I'm not sure there's any material difference.
>
> In that case we don't really need PTRACE_SYSCALL_SECCOMP: op field
> describes the structure inside the union to use, not the ptrace stop.

Unless we think the structures might diverge in the future.

>
> > > As long as implementation (ab)uses ptrace_message to tell one kind of stop
> > > from another, it can distinguish syscall-entry-stop and syscall-exit-stop
> > > from each other and from many other kinds of stops, but it cannot
> > > distinguish PTRACE_EVENT_SECCOMP from e.g. PTRACE_EVENT_EXIT.
> >
> > Hmm.  PTRACE_GET_SYSCALL_INFO should fail for PTRACE_EVENT_EXIT, I think.
>
> Unless we can change PTRACE_EVENT_SECCOMP to set some higher bits of
> ptrace_message (beyond SECCOMP_RET_DATA) which is very unlikely because
> it would qualify as an ABI change, this would require an additional field
> in struct task_struct because ptrace_message wouldn't be enough
> to distinguish PTRACE_EVENT_SECCOMP from PTRACE_EVENT_EXIT.

At the risk of making the patch more complicated, there's room to
massively clean up the ptrace state.  We could add a struct
ptrace_tracee and put a struct ptrace_tracee *ptrace_tracee into
task_struct.  The struct would contain a pointer to the task_struct as
well as ptrace (the flag field, I think), ptrace_entry, ptracer_cred,
ptrace_message, and last_siginfo.  And then we could add a field for
the ptrace stop state that would indicate the actual reason for the
current stop.  We'd only allocate ptrace_tracee when someone attaches
with ptrace, thus saving quite a few bytes for each task.

It's a bit unfortunate if we allow PTRACE_GET_SYSCALL_INFO to success
if the event is PTRACE_EVENT_EXIT.  I'd also be a bit nervous about
info leaks if we start calling the syscall accessors for tasks that
aren't in syscalls.

--Andy
-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel
