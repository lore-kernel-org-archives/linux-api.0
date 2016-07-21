From: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v13 00/12] support "task_isolation" mode
Date: Thu, 21 Jul 2016 10:06:56 -0400
Message-ID: <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
 <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1607202059180.25838-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 7/20/2016 10:04 PM, Christoph Lameter wrote:
> We are trying to test the patchset on x86 and are getting strange
> backtraces and aborts. It seems that the cpu before the cpu we are running
> on creates an irq_work event that causes a latency event on the next cpu.
>
> This is weird. Is there a new round robin IPI feature in the kernel that I
> am not aware of?

This seems to be from your clocksource declaring itself to be
unstable, and then scheduling work to safely remove that timer.
I haven't looked at this code before (in kernel/time/clocksource.c
under CONFIG_CLOCKSOURCE_WATCHDOG) since the timers on
arm64 and tile aren't unstable.  Is it possible to boot your machine
with a stable clocksource?


> Backtraces from dmesg:
>
> [  956.603223] latencytest/7928: task_isolation mode lost due to irq_work
> [  956.610817] cpu 12: irq_work violating task isolation for latencytest/7928 on cpu 13
> [  956.619985] CPU: 12 PID: 0 Comm: swapper/12 Not tainted 4.7.0-rc7-stream1 #1
> [  956.628765] Hardware name: Dell Inc. PowerEdge R630/0CNCJW, BIOS 2.0.2 03/15/2016
> [  956.637642]  0000000000000086 ce6735c7b39e7b81 ffff88103e783d00 ffffffff8134f6ff
> [  956.646739]  ffff88102c50d700 000000000000000d ffff88103e783d28 ffffffff811986f4
> [  956.655828]  ffff88102c50d700 ffff88203cf97f80 000000000000000d ffff88103e783d68
> [  956.664924] Call Trace:
> [  956.667945]  <IRQ>  [<ffffffff8134f6ff>] dump_stack+0x63/0x84
> [  956.674740]  [<ffffffff811986f4>] task_isolation_debug_task+0xb4/0xd0
> [  956.682229]  [<ffffffff810b4a13>] _task_isolation_debug+0x83/0xc0
> [  956.689331]  [<ffffffff81179c0c>] irq_work_queue_on+0x9c/0x120
> [  956.696142]  [<ffffffff811075e4>] tick_nohz_full_kick_cpu+0x44/0x50
> [  956.703438]  [<ffffffff810b48d9>] wake_up_nohz_cpu+0x99/0x110
> [  956.710150]  [<ffffffff810f57e1>] internal_add_timer+0x71/0xb0
> [  956.716959]  [<ffffffff810f696b>] add_timer_on+0xbb/0x140
> [  956.723283]  [<ffffffff81100ca0>] clocksource_watchdog+0x230/0x300
> [  956.730480]  [<ffffffff81100a70>] ? __clocksource_unstable.isra.2+0x40/0x40
> [  956.738555]  [<ffffffff810f5615>] call_timer_fn+0x35/0x120
> [  956.744973]  [<ffffffff81100a70>] ? __clocksource_unstable.isra.2+0x40/0x40
> [  956.753046]  [<ffffffff810f64cc>] run_timer_softirq+0x23c/0x2f0
> [  956.759952]  [<ffffffff816d4397>] __do_softirq+0xd7/0x2c5
> [  956.766272]  [<ffffffff81091245>] irq_exit+0xf5/0x100
> [  956.772209]  [<ffffffff816d41d2>] smp_apic_timer_interrupt+0x42/0x50
> [  956.779600]  [<ffffffff816d231c>] apic_timer_interrupt+0x8c/0xa0
> [  956.786602]  <EOI>  [<ffffffff81569eb0>] ? poll_idle+0x40/0x80
> [  956.793490]  [<ffffffff815697dc>] cpuidle_enter_state+0x9c/0x260
> [  956.800498]  [<ffffffff815699d7>] cpuidle_enter+0x17/0x20
> [  956.806810]  [<ffffffff810cf497>] cpu_startup_entry+0x2b7/0x3a0
> [  956.813717]  [<ffffffff81050e6c>] start_secondary+0x15c/0x1a0
> [ 1036.601758] cpu 12: irq_work violating task isolation for latencytest/8447 on cpu 13
> [ 1036.610922] CPU: 12 PID: 0 Comm: swapper/12 Not tainted 4.7.0-rc7-stream1 #1
> [ 1036.619692] Hardware name: Dell Inc. PowerEdge R630/0CNCJW, BIOS 2.0.2 03/15/2016
> [ 1036.628551]  0000000000000086 ce6735c7b39e7b81 ffff88103e783d00 ffffffff8134f6ff
> [ 1036.637648]  ffff88102dca0000 000000000000000d ffff88103e783d28 ffffffff811986f4
> [ 1036.646741]  ffff88102dca0000 ffff88203cf97f80 000000000000000d ffff88103e783d68
> [ 1036.655833] Call Trace:
> [ 1036.658852]  <IRQ>  [<ffffffff8134f6ff>] dump_stack+0x63/0x84
> [ 1036.665649]  [<ffffffff811986f4>] task_isolation_debug_task+0xb4/0xd0
> [ 1036.673136]  [<ffffffff810b4a13>] _task_isolation_debug+0x83/0xc0
> [ 1036.680237]  [<ffffffff81179c0c>] irq_work_queue_on+0x9c/0x120
> [ 1036.687091]  [<ffffffff811075e4>] tick_nohz_full_kick_cpu+0x44/0x50
> [ 1036.694388]  [<ffffffff810b48d9>] wake_up_nohz_cpu+0x99/0x110
> [ 1036.701089]  [<ffffffff810f57e1>] internal_add_timer+0x71/0xb0
> [ 1036.707896]  [<ffffffff810f696b>] add_timer_on+0xbb/0x140
> [ 1036.714210]  [<ffffffff81100ca0>] clocksource_watchdog+0x230/0x300
> [ 1036.721411]  [<ffffffff81100a70>] ? __clocksource_unstable.isra.2+0x40/0x40
> [ 1036.729478]  [<ffffffff810f5615>] call_timer_fn+0x35/0x120
> [ 1036.735899]  [<ffffffff81100a70>] ? __clocksource_unstable.isra.2+0x40/0x40
> [ 1036.743970]  [<ffffffff810f64cc>] run_timer_softirq+0x23c/0x2f0
> [ 1036.750878]  [<ffffffff816d4397>] __do_softirq+0xd7/0x2c5
> [ 1036.757199]  [<ffffffff81091245>] irq_exit+0xf5/0x100
> [ 1036.763132]  [<ffffffff816d41d2>] smp_apic_timer_interrupt+0x42/0x50
> [ 1036.770520]  [<ffffffff816d231c>] apic_timer_interrupt+0x8c/0xa0
> [ 1036.777520]  <EOI>  [<ffffffff81569eb0>] ? poll_idle+0x40/0x80
> [ 1036.784410]  [<ffffffff815697dc>] cpuidle_enter_state+0x9c/0x260
> [ 1036.791413]  [<ffffffff815699d7>] cpuidle_enter+0x17/0x20
> [ 1036.797734]  [<ffffffff810cf497>] cpu_startup_entry+0x2b7/0x3a0
> [ 1036.804641]  [<ffffffff81050e6c>] start_secondary+0x15c/0x1a0
>
>

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
