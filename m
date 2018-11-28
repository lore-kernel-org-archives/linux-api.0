From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 1/2] ptrace: save the type of syscall-stop in
 ptrace_message
Date: Wed, 28 Nov 2018 14:49:14 +0100
Message-ID: <20181128134913.GC30395@redhat.com>
References: <20181128130439.GB28206@altlinux.org>
 <20181128130601.GC28206@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128130601.GC28206@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Andy Lutomirski <luto@kernel.org>, Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromyatnikov <esyr@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Michael Ellerman <mpe@ellerman.id.au>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org

On 11/28, Dmitry V. Levin wrote:
>
> +/*
> + * These values are stored in task->ptrace_message by tracehook_report_syscall_*
> + * to describe current syscall-stop.
> + *
> + * Values for these constants are chosen so that they do not appear
> + * in task->ptrace_message by other means.
> + */
> +#define PTRACE_EVENTMSG_SYSCALL_ENTRY	0x80000000U
> +#define PTRACE_EVENTMSG_SYSCALL_EXIT	0x90000000U

Again, I do not really understand the comment... Why should we care about
"do not appear in task->ptrace_message by other means" ?

2/2 should detect ptrace_report_syscall() case correctly, so we can use any
numbers, say, 1 and 2?

If debugger does PTRACE_GETEVENTMSG it should know how to interpet the value
anyway after wait(status).

Oleg.
