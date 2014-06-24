From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 3/9] seccomp: introduce writer locking
Date: Tue, 24 Jun 2014 13:26:57 -0700
Message-ID: <CAGXu5jJvAhnVVLvwvC54YUWvZngQGAAhoGoqvDsHs3SK723O5w@mail.gmail.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
	<1403560693-21809-4-git-send-email-keescook@chromium.org>
	<20140624165216.GA29272@redhat.com>
	<CAGXu5j+G8qAkGD7H=3R2iw2ZTqZSrMPa2f=czoEjwSW5wKqUWQ@mail.gmail.com>
	<20140624183550.GB1258@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20140624183550.GB1258@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 24, 2014 at 11:35 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/24, Kees Cook wrote:
>> On Tue, Jun 24, 2014 at 9:52 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >> @@ -1142,6 +1168,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>> >>  {
>> >>       int retval;
>> >>       struct task_struct *p;
>> >> +     unsigned long irqflags;
>> >>
>> >>       if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
>> >>               return ERR_PTR(-EINVAL);
>> >> @@ -1196,7 +1223,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>> >>               goto fork_out;
>> >>
>> >>       ftrace_graph_init_task(p);
>> >> -     get_seccomp_filter(p);
>> >>
>> >>       rt_mutex_init_task(p);
>> >>
>> >> @@ -1434,7 +1460,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>> >>               p->parent_exec_id = current->self_exec_id;
>> >>       }
>> >>
>> >> -     spin_lock(&current->sighand->siglock);
>> >> +     spin_lock_irqsave(&current->sighand->siglock, irqflags);
>> >> +
>> >> +     /*
>> >> +      * Copy seccomp details explicitly here, in case they were changed
>> >> +      * before holding tasklist_lock.
>> >> +      */
>> >> +     copy_seccomp(p);
>> >>
>> >>       /*
>> >>        * Process group and session signals need to be delivered to just the
>> >> @@ -1446,7 +1478,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>> >>       */
>> >>       recalc_sigpending();
>> >>       if (signal_pending(current)) {
>> >> -             spin_unlock(&current->sighand->siglock);
>> >> +             spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
>> >>               write_unlock_irq(&tasklist_lock);
>> >>               retval = -ERESTARTNOINTR;
>> >>               goto bad_fork_free_pid;
>> >> @@ -1486,7 +1518,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>> >>       }
>> >>
>> >>       total_forks++;
>> >> -     spin_unlock(&current->sighand->siglock);
>> >> +     spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
>> >>       write_unlock_irq(&tasklist_lock);
>> >>       proc_fork_connector(p);
>> >>       cgroup_post_fork(p);
>> >
>> > It seems that the only change copy_process() needs is copy_seccomp() under the locks.
>> > Everythinh else (irqflags games) looks obviously unneeded?
>>
>> I got irq lock dep warnings without these changes.
>
> With or without your patches? Could you show the waring?

It seems it's only needed in seccomp itself (I can drop the changes in
kernel/fork.c). I get no warnings in that case. If I also remove irq
handling from seccomp, I see:

[   17.444328]
[   17.445031] =================================
[   17.445031] [ INFO: inconsistent lock state ]
[   17.445031] 3.16.0-rc2+ #289 Not tainted
[   17.445031] ---------------------------------
[   17.445031] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[   17.445031] seccomp_bpf_tes/1987 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   17.445031]  (&(&sighand->siglock)->rlock){?.....}, at:
[<ffffffff9e2fb7e5>] do_seccomp.part.7+0x25/0xc0
[   17.445031] {IN-HARDIRQ-W} state was registered at:
[   17.445031]   [<ffffffff9e2a422a>] mark_irqflags+0x19a/0x1b0
[   17.445031]   [<ffffffff9e2a4542>] __lock_acquire+0x302/0x9e0
[   17.445031]   [<ffffffff9e2a5325>] lock_acquire+0x95/0x1e0
[   17.445031]   [<ffffffff9ebda204>] _raw_spin_lock+0x34/0x50
[   17.445031]   [<ffffffff9e263e70>] __lock_task_sighand+0xa0/0x230
[   17.445031]   [<ffffffff9e2652cf>] send_sigqueue+0x3f/0x280
[   17.445031]   [<ffffffff9e2781e3>] posix_timer_event+0x83/0x140
[   17.445031]   [<ffffffff9e2782f2>] posix_timer_fn+0x52/0xd0
[   17.445031]   [<ffffffff9e27d3bc>] __run_hrtimer+0x7c/0x420
[   17.445031]   [<ffffffff9e27de27>] hrtimer_interrupt+0x107/0x260
[   17.445031]   [<ffffffff9e235aa6>] local_apic_timer_interrupt+0x36/0x60
[   17.445031]   [<ffffffff9e235f1e>] smp_apic_timer_interrupt+0x3e/0x60
[   17.445031]   [<ffffffff9ebdbf2f>] apic_timer_interrupt+0x6f/0x80
[   17.445031]   [<ffffffff9e20d99a>] arch_cpu_idle+0xa/0x10
[   17.445031]   [<ffffffff9e29d587>] cpuidle_idle_call+0x157/0x3d0
[   17.445031]   [<ffffffff9e29d945>] cpu_idle_loop+0x145/0x370
[   17.445031]   [<ffffffff9e29dbc6>] cpu_startup_entry+0x56/0x60
[   17.445031]   [<ffffffff9e234544>] start_secondary+0xd4/0xe0
[   17.445031] irq event stamp: 243
[   17.445031] hardirqs last  enabled at (243): [<ffffffff9e2b9d00>]
__call_rcu.constprop.63+0x70/0x120
[   17.445031] hardirqs last disabled at (242): [<ffffffff9e2b9cd2>]
__call_rcu.constprop.63+0x42/0x120
[   17.445031] softirqs last  enabled at (50): [<ffffffff9e256310>]
__do_softirq+0x1d0/0x4d0
[   17.445031] softirqs last disabled at (21): [<ffffffff9e2568be>]
irq_exit+0x8e/0xb0
[   17.445031]
[   17.445031] other info that might help us debug this:
[   17.445031]  Possible unsafe locking scenario:
[   17.445031]
[   17.445031]        CPU0
[   17.445031]        ----
[   17.445031]   lock(&(&sighand->siglock)->rlock);
[   17.445031]   <Interrupt>
[   17.445031]     lock(&(&sighand->siglock)->rlock);
[   17.445031]
[   17.445031]  *** DEADLOCK ***
[   17.445031]
[   17.445031] no locks held by seccomp_bpf_tes/1987.
[   17.445031]
[   17.445031] stack backtrace:
[   17.445031] CPU: 0 PID: 1987 Comm: seccomp_bpf_tes Not tainted
3.16.0-rc2+ #289
[   17.445031] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Bochs 01/01/2011
[   17.445031]  ffffffff9f71dd90 ffff88007878bc48 ffffffff9ebc4fb4
0000000000000007
[   17.445031]  ffff880077fb3570 ffff88007878bca8 ffffffff9ebbad0d
0000000000000000
[   17.445031]  0000000000000001 00007fff00000001 ffff88007878bd70
ffff88007878bd18
[   17.445031] Call Trace:
[   17.445031]  [<ffffffff9ebc4fb4>] dump_stack+0x4e/0x68
[   17.445031]  [<ffffffff9ebbad0d>] print_usage_bug+0x1f1/0x202
[   17.445031]  [<ffffffff9e2a26e0>] ? check_usage_forwards+0x150/0x150
[   17.445031]  [<ffffffff9ebbad8a>] mark_lock_irq+0x6c/0x137
[   17.445031]  [<ffffffff9e2a3ff5>] mark_lock+0x125/0x1c0
[   17.445031]  [<ffffffff9e2a41c8>] mark_irqflags+0x138/0x1b0
[   17.445031]  [<ffffffff9e2a4542>] __lock_acquire+0x302/0x9e0
[   17.445031]  [<ffffffff9e383a0c>] ? create_object+0x21c/0x2d0
[   17.445031]  [<ffffffff9e2a5325>] lock_acquire+0x95/0x1e0
[   17.445031]  [<ffffffff9e2fb7e5>] ? do_seccomp.part.7+0x25/0xc0
[   17.445031]  [<ffffffff9e2a5e55>] ? trace_hardirqs_on_caller+0x105/0x1d0
[   17.445031]  [<ffffffff9ebda204>] _raw_spin_lock+0x34/0x50
[   17.445031]  [<ffffffff9e2fb7e5>] ? do_seccomp.part.7+0x25/0xc0
[   17.445031]  [<ffffffff9e27ffc5>] ? abort_creds+0x45/0x50
[   17.445031]  [<ffffffff9e2fb7e5>] do_seccomp.part.7+0x25/0xc0
[   17.445031]  [<ffffffff9e2fbf28>] do_seccomp+0x18/0x40
[   17.445031]  [<ffffffff9e2fc1df>] prctl_set_seccomp+0x2f/0x40
[   17.445031]  [<ffffffff9e26bce1>] SyS_prctl+0x141/0x4b0
[   17.445031]  [<ffffffff9e2f306c>] ? __audit_syscall_entry+0x8c/0xe0
[   17.445031]  [<ffffffff9e59556e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   17.445031]  [<ffffffff9ebdb012>] system_call_fastpath+0x16/0x1b


I'll drop the fork.c changes, and keep the seccomp.c irqflags.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
