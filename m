From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH v2] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Wed, 21 Nov 2018 14:56:57 -0800
Message-ID: <CALCETrV3TPCkYyhoLLcikXVeF-RdZUuLTCvKReK3Qb9LSS9Csw@mail.gmail.com>
References: <20181121165806.07da7c98@akathisia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181121165806.07da7c98@akathisia>
Sender: linux-kernel-owner@vger.kernel.org
To: Elvira Khabirova <lineprinter@altlinux.org>, Kees Cook <keescook@chromium.org>, Sasha Levin <sasha.levin@oracle.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "Dmitry V. Levin" <ldv@altlinux.org>, Eugene Syromiatnikov <esyr@redhat.com>, Andrew Lutomirski <luto@kernel.org>, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org

Please cc linux-api@vger.kernel.org for future versions.

On Wed, Nov 21, 2018 at 7:58 AM Elvira Khabirova
<lineprinter@altlinux.org> wrote:
>
> struct ptrace_syscall_info {
>         __u8 op; /* 0 for entry, 1 for exit */

Can you add proper defines, like:

#define PTRACE_SYSCALL_ENTRY 0
#define PTRACE_SYSCALL_EXIT 1
#define PTRACE_SYSCALL_SECCOMP 2

and make seccomp work from the start?  I'd rather we don't merge an
implementation that doesn't work for seccomp and then have to rework
it later.

>         __u8 __pad0[7];
>         union {
>                 struct {
>                         __s32 nr;

__u64 please.  Syscall numbers are, as a practical matter, 64 bits.
Admittedly, the actual effects of setting the high bits are unclear,
and seccomp has issues with it, but let's not perpetuate the problem.

>                         __u32 arch;
>                         __u64 instruction_pointer;
>                         __u64 args[6];
>                 } entry_info;
>                 struct {
>                         __s64 rval;
>                         __u8 is_error;
>                         __u8 __pad1[7];
>                 } exit_info;
>         };
> };

Should seccomp events use entry_info or should they just literally
supply seccomp_data?
