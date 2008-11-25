From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] Display active jiffie timers in /proc/timer_list
Date: Tue, 25 Nov 2008 22:36:48 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0811252224430.3235@localhost.localdomain>
References: <20081121221113.GA13566@tsunami.ccur.com> <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com> <20081125185740.GA21806@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081125185740.GA21806-jPwT5PJblzyhckIl5yWhCw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Joe,

On Tue, 25 Nov 2008, Joe Korty wrote:
> Add to /proc/timer_list a display of the active jiffie timers.
> 
> Tested on i386 and x86_64, with 'less /proc/timer_list' and
> through SysRq-Q.
> 
> Signed-off-by: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
> 
> Index: 2.6.28-rc6/kernel/timer.c
> ===================================================================
> --- 2.6.28-rc6.orig/kernel/timer.c	2008-11-25 11:59:07.000000000 -0500
> +++ 2.6.28-rc6/kernel/timer.c	2008-11-25 13:49:05.000000000 -0500
> @@ -36,6 +36,8 @@
>  #include <linux/syscalls.h>
>  #include <linux/delay.h>
>  #include <linux/tick.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
>  #include <linux/kallsyms.h>
>  
>  #include <asm/uaccess.h>
> @@ -1568,6 +1570,87 @@
>  	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
>  }
>  
> +#if defined(CONFIG_PROC_FS) || defined(CONFIG_MAGIC_SYSRQ)

This belongs into kernel/time/timer_list.c and there is no need to
copy that code around.

> +void print_cpu_jtimers(struct seq_file *m, int cpu)
> +{
> +	int i;
> +	struct tvec_base *base = per_cpu(tvec_bases, cpu);
> +
> +	SEQ_printf(m, "active jiffie timers:\n");
> +	spin_lock_irq(&base->lock);

Yuck. We really do _NOT_ stop everything just to print timers. Check
the hrtimer print code in timer_list.c

> Index: 2.6.28-rc6/kernel/time/timer_list.c
> ===================================================================
> --- 2.6.28-rc6.orig/kernel/time/timer_list.c	2008-11-25 11:59:07.000000000 -0500
> +++ 2.6.28-rc6/kernel/time/timer_list.c	2008-11-25 13:47:30.000000000 -0500
> @@ -17,6 +17,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/kallsyms.h>
>  #include <linux/tick.h>
> +#include <linux/jiffies.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -139,6 +140,7 @@
>  		SEQ_printf(m, " clock %d:\n", i);
>  		print_base(m, cpu_base->clock_base + i, now);
>  	}
> +

random whitespace change

>  #define P(x) \
>  	SEQ_printf(m, "  .%-15s: %Lu\n", #x, \
>  		   (unsigned long long)(cpu_base->x))
> @@ -176,9 +178,11 @@
>  		P(last_jiffies);
>  		P(next_jiffies);
>  		P_ns(idle_expires);
> -		SEQ_printf(m, "jiffies: %Lu\n",
> +		SEQ_printf(m, "jiffies: %llu (0x%llx)\n",
> +			   (unsigned long long)jiffies,
>  			   (unsigned long long)jiffies);

The exact purpose of this change ?

> @@ -286,7 +290,7 @@
>  {
>  	struct proc_dir_entry *pe;
>  
> -	pe = proc_create("timer_list", 0644, NULL, &timer_list_fops);
> +	pe = proc_create("timer_list", 0444, NULL, &timer_list_fops);
>  	if (!pe)
>  		return -ENOMEM;
>  	return 0;

Correct, but unrelated $subject. Separate patch please. 

Thanks,

	tglx
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
