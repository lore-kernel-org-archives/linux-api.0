From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 1/2] ptrace: save the type of syscall-stop in
 ptrace_message
Date: Thu, 29 Nov 2018 16:03:28 +0100
Message-ID: <20181129150327.GC10645@redhat.com>
References: <20181128130439.GB28206@altlinux.org>
 <20181128130601.GC28206@altlinux.org>
 <20181128134913.GC30395@redhat.com>
 <20181128140533.GF28206@altlinux.org>
 <20181128142006.GE30395@redhat.com>
 <20181128152346.GG28206@altlinux.org>
 <20181128221125.GA2800@altlinux.org>
 <CALCETrVjMorQDsJzQGaREEB5_7B24ApWSoNQfRd3K3QNSGAyEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVjMorQDsJzQGaREEB5_7B24ApWSoNQfRd3K3QNSGAyEA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: "Dmitry V. Levin" <ldv@altlinux.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Michael Ellerman <mpe@ellerman.id.au>, Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromiatnikov <esyr@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org

On 11/28, Andy Lutomirski wrote:
>
> I don't like any of this at all.  Can we please choose a sensible API
> design and let the API drive the implementation instead of vice versa?

I too do not understand your concerns...

>  ISTM the correct solution is to add some new state to task_struct for
> this.

Sure we can do this. I have argued with the previous version not because
the new member blows the task_struct. Although I think it is better to avoid
this if possible.

But this doesn't affect the API.

Yes, this version uses ->ptrace_message but I think this is _good_ exactly
because it is already visible to userspace, so if debugger only needs to
distinguish syscall entry/exit it can simply use PTRACE_GETEVENTMSG without
PTRACE_GET_SYSCALL_INFO.

> If we're concerned about making task_struct bigger, I have a
> half-finished patch to factor all the ptrace tracee state into a
> separate struct.

I even sent the patch(es) which does this several years ago ;)

Oleg.
