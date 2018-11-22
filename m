From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH v2] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Thu, 22 Nov 2018 06:55:29 -0800
Message-ID: <CALCETrXea_uRAqw_srW5CWgOzeM=RubaDbjnxZ=cUMy5Zv1TsA@mail.gmail.com>
References: <20181121165806.07da7c98@akathisia> <CALCETrV3TPCkYyhoLLcikXVeF-RdZUuLTCvKReK3Qb9LSS9Csw@mail.gmail.com>
 <20181121235634.GA14146@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181121235634.GA14146@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Andrew Lutomirski <luto@kernel.org>, Elvira Khabirova <lineprinter@altlinux.org>, Kees Cook <keescook@chromium.org>, Sasha Levin <sasha.levin@oracle.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Eugene Syromiatnikov <esyr@redhat.com>, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org

On Wed, Nov 21, 2018 at 3:56 PM Dmitry V. Levin <ldv@altlinux.org> wrote:
>
> On Wed, Nov 21, 2018 at 02:56:57PM -0800, Andy Lutomirski wrote:
> > Please cc linux-api@vger.kernel.org for future versions.
> >
> > On Wed, Nov 21, 2018 at 7:58 AM Elvira Khabirova wrote:
> > >
> > > struct ptrace_syscall_info {
> > >         __u8 op; /* 0 for entry, 1 for exit */
> >
> > Can you add proper defines, like:
> >
> > #define PTRACE_SYSCALL_ENTRY 0
> > #define PTRACE_SYSCALL_EXIT 1
> > #define PTRACE_SYSCALL_SECCOMP 2
> >
> > and make seccomp work from the start?  I'd rather we don't merge an
> > implementation that doesn't work for seccomp and then have to rework
> > it later.
>
> What's the difference between PTRACE_EVENT_SECCOMP and syscall-entry-stop
> with regards to PTRACE_GET_SYSCALL_INFO request?  At least they have the
> same entry_info to return.

I'm not sure there's any material difference.

>
> As long as implementation (ab)uses ptrace_message to tell one kind of stop
> from another, it can distinguish syscall-entry-stop and syscall-exit-stop
> from each other and from many other kinds of stops, but it cannot
> distinguish PTRACE_EVENT_SECCOMP from e.g. PTRACE_EVENT_EXIT.

Hmm.  PTRACE_GET_SYSCALL_INFO should fail for PTRACE_EVENT_EXIT, I think.

>
> > >         __u8 __pad0[7];
> > >         union {
> > >                 struct {
> > >                         __s32 nr;
> >
> > __u64 please.  Syscall numbers are, as a practical matter, 64 bits.
> > Admittedly, the actual effects of setting the high bits are unclear,
> > and seccomp has issues with it, but let's not perpetuate the problem.
>
> I agree.  Although the implementation uses syscall_get_nr()
> which returns int, this could potentially be fixed in the future.

Agreed.  Although if we ever start using those high bits, things will
get confusing.

>
> > >                         __u32 arch;
> > >                         __u64 instruction_pointer;
> > >                         __u64 args[6];
> > >                 } entry_info;
> > >                 struct {
> > >                         __s64 rval;
> > >                         __u8 is_error;
> > >                         __u8 __pad1[7];
> > >                 } exit_info;
> > >         };
> > > };
> >
> > Should seccomp events use entry_info or should they just literally
> > supply seccomp_data?
>
> It certainly can use entry_info.
> I'd prefer to avoid using in uapi/linux/ptrace.h those types
> that are defined in uapi/linux/seccomp.h.

Makes sense to me.  Also, it's possible in principle to extend
seccomp_data with other fields that are only generated if they're
read, so passing struct seccomp_data to userspace as a struct may be
the wrong thing to do.
