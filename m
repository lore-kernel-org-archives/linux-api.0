From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 2/2] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Wed, 28 Nov 2018 15:10:50 +0100
Message-ID: <20181128141049.GD30395@redhat.com>
References: <20181128130439.GB28206@altlinux.org>
 <20181128130715.GD28206@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128130715.GD28206@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Andy Lutomirski <luto@kernel.org>, Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromyatnikov <esyr@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Michael Ellerman <mpe@ellerman.id.au>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org

On 11/28, Dmitry V. Levin wrote:
>
> +static unsigned long
> +ptrace_get_syscall_info_entry(struct task_struct *child,
> +			      struct ptrace_syscall_info *info)
> +{
> +	struct pt_regs *regs = task_pt_regs(child);
> +	unsigned long args[ARRAY_SIZE(info->entry.args)];
> +	int i;
> +
> +	info->op = PTRACE_SYSCALL_INFO_ENTRY;
> +	info->arch = syscall_get_arch(child);
> +	info->entry.nr = syscall_get_nr(child, regs);
> +	info->entry.instruction_pointer = instruction_pointer(regs);
> +	info->entry.stack_pointer = user_stack_pointer(regs);
> +	info->entry.frame_pointer = frame_pointer(regs);
> +	syscall_get_arguments(child, regs, 0, ARRAY_SIZE(args), args);
> +	for (i = 0; i < ARRAY_SIZE(args); i++)
> +		info->entry.args[i] = args[i];

I must have missed something, but why do we need the temporary args[],
syscall_get_arguments(..., info->entry.args) should equally work?

Oleg.
