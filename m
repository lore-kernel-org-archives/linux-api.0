From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC PATCH v2] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Tue, 27 Nov 2018 14:28:58 -0800
Message-ID: <CAGXu5jJyMG2r09Hfi9G9159J-s5rne12OAvmRTqMz8AP-qVFfQ@mail.gmail.com>
References: <20181121165806.07da7c98@akathisia> <CALCETrV3TPCkYyhoLLcikXVeF-RdZUuLTCvKReK3Qb9LSS9Csw@mail.gmail.com>
 <20181121235634.GA14146@altlinux.org> <CALCETrXea_uRAqw_srW5CWgOzeM=RubaDbjnxZ=cUMy5Zv1TsA@mail.gmail.com>
 <20181122191504.GB27204@altlinux.org> <CALCETrXvXzRzoEqwEY_VZ7Vpt-sLwaF+rZPg+y_eG2xyzubXtw@mail.gmail.com>
 <20181123040139.GB2572@altlinux.org> <20181125041003.GA3258@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181125041003.GA3258@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Andy Lutomirski <luto@kernel.org>, Elvira Khabirova <lineprinter@altlinux.org>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Eugene Syromiatnikov <esyr@redhat.com>, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org

On Sat, Nov 24, 2018 at 8:10 PM, Dmitry V. Levin <ldv@altlinux.org> wrote:
> On Fri, Nov 23, 2018 at 07:01:39AM +0300, Dmitry V. Levin wrote:
>> On Thu, Nov 22, 2018 at 04:19:10PM -0800, Andy Lutomirski wrote:
>> > On Thu, Nov 22, 2018 at 11:15 AM Dmitry V. Levin wrote:
>> > > On Thu, Nov 22, 2018 at 06:55:29AM -0800, Andy Lutomirski wrote:
>> > > > On Wed, Nov 21, 2018 at 3:56 PM Dmitry V. Levin wrote:
>> > > > > On Wed, Nov 21, 2018 at 02:56:57PM -0800, Andy Lutomirski wrote:
>> > > > > > Please cc linux-api@vger.kernel.org for future versions.
>> > > > > >
>> > > > > > On Wed, Nov 21, 2018 at 7:58 AM Elvira Khabirova wrote:
>> > > > > > >
>> > > > > > > struct ptrace_syscall_info {
>> > > > > > >         __u8 op; /* 0 for entry, 1 for exit */
>> > > > > >
>> > > > > > Can you add proper defines, like:
>> > > > > >
>> > > > > > #define PTRACE_SYSCALL_ENTRY 0
>> > > > > > #define PTRACE_SYSCALL_EXIT 1
>> > > > > > #define PTRACE_SYSCALL_SECCOMP 2
>> > > > > >
>> > > > > > and make seccomp work from the start?  I'd rather we don't merge an
>> > > > > > implementation that doesn't work for seccomp and then have to rework
>> > > > > > it later.

Yes, please.

>> > > > >
>> > > > > What's the difference between PTRACE_EVENT_SECCOMP and syscall-entry-stop
>> > > > > with regards to PTRACE_GET_SYSCALL_INFO request?  At least they have the
>> > > > > same entry_info to return.
>> > > >
>> > > > I'm not sure there's any material difference.
>> > >
>> > > In that case we don't really need PTRACE_SYSCALL_SECCOMP: op field
>> > > describes the structure inside the union to use, not the ptrace stop.
>> >
>> > Unless we think the structures might diverge in the future.

Yes, I want to make sure we have a way to expand this, especially for
seccomp: we've come close a few times to adding new fields to struct
seccomp_data, for example.

>>
>> If these structures ever diverge, then a seccomp structure will be added
>> to the union, and a portable userspace code will likely look this way:
>>
>> #include <linux/ptrace.h>
>> ...
>> struct ptrace_syscall_info info;
>> long rc = ptrace(PTRACE_GET_SYSCALL_INFO, pid, (void *) sizeof(info), &info);
>> ...
>> switch (info.op) {
>>       case PTRACE_SYSCALL_INFO_ENTRY:
>>               /* handle info.entry */
>>       case PTRACE_SYSCALL_INFO_EXIT:
>>               /* handle info.exit */
>> #ifdef PTRACE_SYSCALL_INFO_SECCOMP
>>       case PTRACE_SYSCALL_INFO_SECCOMP:
>>               /* handle info.seccomp */
>> #endif
>>       default:
>>               /* handle unknown info.op */
>> }
>>
>> In other words, it would be better if PTRACE_SYSCALL_INFO_* selector
>> constants were introduced along with corresponding structures in the
>> union.
>
> However, the approach I suggested doesn't provide forward compatibility:
> if userspace is compiled with kernel headers that don't define
> PTRACE_SYSCALL_INFO_SECCOMP, it will break when the kernel
> starts to use PTRACE_SYSCALL_INFO_SECCOMP instead of
> PTRACE_SYSCALL_INFO_ENTRY for PTRACE_EVENT_SECCOMP support
> in PTRACE_GET_SYSCALL_INFO.
>
> The solution is to introduce PTRACE_SYSCALL_INFO_SECCOMP and struct
> ptrace_syscall_info.seccomp along with PTRACE_EVENT_SECCOMP support
> in PTRACE_GET_SYSCALL_INFO.  The initial revision of the seccomp
> structure could be made the same as the entry structure, or it can
> diverge from the beginning, e.g., by adding ret_data field containing
> SECCOMP_RET_DATA return value stored in ptrace_message, this would save
> ptracers an extra PTRACE_GETEVENTMSG call currently required to obtain it.

Yup, that'd be a nice addition.

-- 
Kees Cook
