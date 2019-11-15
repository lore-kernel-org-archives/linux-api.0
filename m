From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 17/23] y2038: time: avoid timespec usage in settimeofday()
Date: Fri, 15 Nov 2019 08:58:38 +0100
Message-ID: <CAK8P3a3jn8GcedX=HaTFiPY+fyHPoyVUnpcX19nMZqmuUA1RzA@mail.gmail.com>
References: <20191108210236.1296047-1-arnd@arndb.de> <20191108211323.1806194-8-arnd@arndb.de>
 <20191114230127.GA3580@ryzen.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191114230127.GA3580@ryzen.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Abel Vesa <abelvesa@linux.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Deepa Dinamani <deepa.kernel@gmail.com>, Christian Brauner <christian@brauner.io>, Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>, Corey Minyard <cminyard@mvista.com>, zhengbin <zhengbin13@huawei.com>, Li RongQing <lirongqing@baidu.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 15, 2019 at 12:01 AM Abel Vesa <abelvesa@linux.com> wrote:
>
> On 19-11-08 22:12:16, Arnd Bergmann wrote:
> > The compat_get_timeval() and timeval_valid() interfaces
> > are deprecated and getting removed along with the definition
> > of struct timeval itself.
> >
> > Change the two implementations of the settimeofday()
> > system call to open-code these helpers and completely
> > avoid references to timeval.
> >

I'm not sure how we get to the RCU stall, but this is almost certainly another
symptom of a typo I had introduced in the patch, which others have also
reported. This is the the fix in today's linux-next:

--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -207,7 +207,7 @@ SYSCALL_DEFINE2(settimeofday, struct
__kernel_old_timeval __user *, tv,
                    get_user(new_ts.tv_nsec, &tv->tv_usec))
                        return -EFAULT;

-               if (tv->tv_usec > USEC_PER_SEC)
+               if (new_ts->tv_usec > USEC_PER_SEC)
                        return -EINVAL;

                new_ts.tv_nsec *= NSEC_PER_USEC;


    Arnd

> I get the following rcu stalls due to this patch on riscv64 (on qemu):
>
>         [root@riscv ~]# uname -a
>         Linux riscv 5.4.0-rc6-00018-gadde74306a4b #112 SMP Fri Nov 15 00:46:20 EET 2019 riscv64 riscv64 riscv64 GNU/Linux
>         [root@riscv ~]# [  420.135710] rcu: INFO: rcu_sched self-detected stall
>         on CPU
>         [  420.136839] rcu:     3-....: (99702 ticks this GP) idle=482/1/0x4000000000000002 softirq=3322/3322 fqs=48784
>         [  420.138917]  (t=99768 jiffies g=4985 q=8343)
>         [  420.139772] Task dump for CPU 3:
>         [  420.140236] rdate           R  running task        0   254      1 0x00000008
>         [  420.142226] Call Trace:
>         [  420.142791] [<ffffffe000037954>] walk_stackframe+0x0/0xa6
>         [  420.143911] [<ffffffe000037aba>] show_stack+0x2a/0x34
>         [  420.145010] [<ffffffe0000569c8>] sched_show_task+0xf0/0x116
>         [  420.145996] [<ffffffe00005b502>] dump_cpu_task+0x3e/0x48
>         [  420.147073] [<ffffffe000084e5e>] rcu_dump_cpu_stacks+0x7c/0xb4
>         [  420.148243] [<ffffffe0000842f6>] rcu_sched_clock_irq+0x3d6/0x582
>         [  420.149349] [<ffffffe0000897b4>] update_process_times+0x1e/0x42
>         [  420.150306] [<ffffffe000093a34>] tick_sched_handle.isra.0+0x2a/0x3a
>         [  420.150997] [<ffffffe000093ce8>] tick_sched_timer+0x4e/0x92
>         [  420.151603] [<ffffffe000089eb6>] __hrtimer_run_queues+0xae/0x108
>         [  420.152639] [<ffffffe00008a5ac>] hrtimer_interrupt+0xca/0x1d4
>         [  420.153629] [<ffffffe0004de564>] riscv_timer_interrupt+0x32/0x3a
>         [  420.154629] [<ffffffe000612ad4>] do_IRQ+0xa4/0xb8
>         [  420.155294] [<ffffffe000036814>] ret_from_exception+0x0/0xc
>         [  420.156073] [<ffffffe000036814>] ret_from_exception+0x0/0xc
