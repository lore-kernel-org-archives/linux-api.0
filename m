From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH RESEND v3 3/3] ptrace: add PTRACE_EVENT_SECCOMP
 support to PTRACE_GET_SYSCALL_INFO
Date: Mon, 26 Nov 2018 15:35:24 +0100
Message-ID: <20181126143524.GB1660@redhat.com>
References: <20181125022150.46258a20@akathisia>
 <20181125022340.5703400f@akathisia>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20181125022340.5703400f@akathisia>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: Elvira Khabirova <lineprinter-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/25, Elvira Khabirova wrote:
>
> Extend PTRACE_GET_SYSCALL_INFO to support PTRACE_EVENT_SECCOMP stops.
> The information returned is the same as for syscall-enter-stops.

Oh, this is not nice ;) there must be a better option, I hope... Plus


Can't ptrace_get_syscall() check

	child->exit_code == (PTRACE_EVENT_SECCOMP << 8) | SIGTRAP;

to detect the PTRACE_EVENT_SECCOMP case?

Oleg.

> Signed-off-by: Elvira Khabirova <lineprinter-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
> Signed-off-by: Dmitry V. Levin <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
> ---
>  include/linux/ptrace.h    | 1 +
>  include/linux/sched.h     | 1 +
>  include/linux/tracehook.h | 1 +
>  kernel/ptrace.c           | 7 +++++--
>  4 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
> index 6c2ffed907f5..a993d0fde865 100644
> --- a/include/linux/ptrace.h
> +++ b/include/linux/ptrace.h
> @@ -166,6 +166,7 @@ static inline void ptrace_event(int event, unsigned long message)
>  {
>  	if (unlikely(ptrace_event_enabled(current, event))) {
>  		current->ptrace_message = message;
> +		current->ptrace_event = event;
>  		ptrace_notify((event << 8) | SIGTRAP);
>  	} else if (event == PTRACE_EVENT_EXEC) {
>  		/* legacy EXEC report via SIGTRAP */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index a51c13c2b1a0..86215fb654d6 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -964,6 +964,7 @@ struct task_struct {
>  
>  	/* Ptrace state: */
>  	unsigned long			ptrace_message;
> +	int				ptrace_event;
>  	kernel_siginfo_t		*last_siginfo;
>  
>  	struct task_io_accounting	ioac;
> diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
> index 633a83fe7051..5d2e5aa07a5c 100644
> --- a/include/linux/tracehook.h
> +++ b/include/linux/tracehook.h
> @@ -66,6 +66,7 @@ static inline int ptrace_report_syscall(struct pt_regs *regs,
>  		return 0;
>  
>  	current->ptrace_message = message;
> +	current->ptrace_event = 0;
>  	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
>  
>  	/*
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 92c47cd5ad84..74a37e74c7f1 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -904,7 +904,9 @@ static int ptrace_get_syscall(struct task_struct *child,
>  	unsigned long actual_size;
>  	unsigned long write_size;
>  
> -	if (child->ptrace_message == PTRACE_EVENTMSG_SYSCALL_ENTRY) {
> +	if ((child->ptrace_event == 0 &&
> +	     child->ptrace_message == PTRACE_EVENTMSG_SYSCALL_ENTRY) ||
> +	    child->ptrace_event == PTRACE_EVENT_SECCOMP) {
>  		int i;
>  
>  		info.op = PTRACE_SYSCALL_INFO_ENTRY;
> @@ -917,7 +919,8 @@ static int ptrace_get_syscall(struct task_struct *child,
>  		for (i = 0; i < ARRAY_SIZE(args); i++)
>  			info.entry.args[i] = args[i];
>  		actual_size = offsetofend(struct ptrace_syscall_info, entry);
> -	} else if (child->ptrace_message == PTRACE_EVENTMSG_SYSCALL_EXIT) {
> +	} else if (child->ptrace_event == 0 &&
> +		   child->ptrace_message == PTRACE_EVENTMSG_SYSCALL_EXIT) {
>  		info.op = PTRACE_SYSCALL_INFO_EXIT;
>  		info.arch = syscall_get_arch(child);
>  		info.exit.rval = syscall_get_error(child, regs);
> -- 
> 2.19.1
> 

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel
