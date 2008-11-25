From: "Michael Kerrisk" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] create /proc/timer-wheel-list
Date: Tue, 25 Nov 2008 11:06:44 -0500
Message-ID: <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com>
References: <20081121221113.GA13566@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081121221113.GA13566-jPwT5PJblzyhckIl5yWhCw@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Joe,

On Fri, Nov 21, 2008 at 5:11 PM, Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org> wrote:
> Create /proc/timer_wheel_list.
>
> This does for the timer wheel what /proc/timer_list
> does for hrtimers -- provide a way of displaying what
> timers are running on what cpus, and their attributes.

Please CC linux-api on kernel-userland API changes.

See Documentation/SubmitChecklist and
http://thread.gmane.org/gmane.linux.ltp/5658.

Cheers,

Michael

> Index: 2.6.28-rc6/kernel/timer.c
> ===================================================================
> --- 2.6.28-rc6.orig/kernel/timer.c      2008-11-21 17:02:04.000000000 -0500
> +++ 2.6.28-rc6/kernel/timer.c   2008-11-21 17:04:25.000000000 -0500
> @@ -36,6 +36,8 @@
>  #include <linux/syscalls.h>
>  #include <linux/delay.h>
>  #include <linux/tick.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
>  #include <linux/kallsyms.h>
>
>  #include <asm/uaccess.h>
> @@ -1568,6 +1570,113 @@
>        open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
>  }
>
> +#ifdef CONFIG_PROC_FS
> +
> +static void seq_printf_symbol(struct seq_file *m, void *symaddr, int width)
> +{
> +       char symname[KSYM_NAME_LEN];
> +       int stat, len = m->count;
> +
> +       if (lookup_symbol_name((unsigned long)symaddr, symname) < 0)
> +               stat = seq_printf(m, "<%p>", symaddr);
> +       else
> +               stat = seq_printf(m, "%s", symname);
> +       if (width && stat == 0) {
> +               len += (width - m->count);
> +               if (len > 0)
> +                       seq_printf(m, "%*s", len, " ");
> +       }
> +}
> +
> +static void print_single_timer(struct seq_file *m, struct timer_list *timer)
> +{
> +       unsigned long base_jiffies = tbase_get_base(timer->base)->timer_jiffies;
> +
> +       seq_printf(m, " %p - ", (void *)(timer->expires - base_jiffies));
> +       seq_printf_symbol(m, timer->function, 24);
> +       seq_printf(m, " (data ");
> +       seq_printf_symbol(m, (void *)(timer->data), 24);
> +       seq_printf(m, ")");
> +#ifdef CONFIG_TIMER_STATS
> +       seq_printf(m, " from ");
> +       seq_printf_symbol(m, timer->start_site, 28);
> +       seq_printf(m, " %*s/%d",
> +               TASK_COMM_LEN, timer->start_comm,
> +               timer->start_pid);
> +#endif
> +       seq_printf(m, "\n");
> +}
> +
> +static void print_timer_list(struct seq_file *m, struct list_head *head)
> +{
> +       struct timer_list *timer;
> +       struct list_head *item;
> +
> +       for (item = head->next; item != head; item = item->next) {
> +               timer = list_entry(item, struct timer_list, entry);
> +               print_single_timer(m, timer);
> +       }
> +}
> +
> +static void print_cpu_timers(struct seq_file *m, int cpu)
> +{
> +       int i;
> +       struct tvec_base *base = per_cpu(tvec_bases, cpu);
> +
> +       spin_lock_irq(&base->lock);
> +       seq_printf(m, "\ncpu: %d, base jiffies: %p\n\n",
> +               cpu, (void *)(base->timer_jiffies));
> +
> +       for (i = 0; i < TVR_SIZE; i++)
> +               print_timer_list(m, base->tv1.vec + i);
> +       for (i = 0; i < TVN_SIZE; i++) {
> +               print_timer_list(m, base->tv2.vec + i);
> +               print_timer_list(m, base->tv3.vec + i);
> +               print_timer_list(m, base->tv4.vec + i);
> +               print_timer_list(m, base->tv5.vec + i);
> +       }
> +       spin_unlock_irq(&base->lock);
> +}
> +
> +static int timer_list_show(struct seq_file *m, void *v)
> +{
> +       int cpu;
> +
> +       seq_printf(m, "Timer Wheel List Version: 1\n");
> +       seq_printf(m, "Jiffies: %px\n", (void *)jiffies);
> +
> +       for_each_online_cpu(cpu) {
> +               print_cpu_timers(m, cpu);
> +       }
> +
> +       return 0;
> +}
> +
> +static int timer_list_open(struct inode *inode, struct file *filp)
> +{
> +       return single_open(filp, timer_list_show, NULL);
> +}
> +
> +static struct file_operations timer_list_fops = {
> +       .open           = timer_list_open,
> +       .read           = seq_read,
> +       .llseek         = seq_lseek,
> +       .release        = single_release,
> +};
> +
> +static int __init init_timer_list_procfs(void)
> +{
> +       struct proc_dir_entry *pe;
> +
> +       pe = proc_create("timer_wheel_list", 0444, NULL, &timer_list_fops);
> +       if (!pe)
> +               return -ENOMEM;
> +       return 0;
> +}
> +late_initcall(init_timer_list_procfs);
> +
> +#endif /* CONFIG_PROC_FS */
> +
>  /**
>  * msleep - sleep safely even with waitqueue interruptions
>  * @msecs: Time in milliseconds to sleep for
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
