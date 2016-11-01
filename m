From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [4.9-rc3] BUG: unable to handle kernel paging request at ffffc900144dfc60
Date: Tue, 1 Nov 2016 23:36:24 +0900
Message-ID: <201611012336.IAC18714.VLMOQSHOFtOFJF@I-love.SAKURA.ne.jp>
References: <cover.1475257877.git.luto@kernel.org>
        <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: luto@kernel.org, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, brgerst@gmail.com, bp@alien8.de, jann@thejh.net, linux-api@vger.kernel.org, torvalds@linux-foundation.org, keescook@chromium.org, tycho.andersen@canonical.com
List-Id: linux-api@vger.kernel.org

Hello.

Andy Lutomirski wrote:
> Reporting these fields on a non-current task is dangerous.  If the
> task is in any state other than normal kernel code, they may contain
> garbage or even kernel addresses on some architectures.  (x86_64
> used to do this.  I bet lots of architectures still do.)  With
> CONFIG_THREAD_INFO_IN_TASK, it can OOPS, too.
> 
> As far as I know, there are no use programs that make any material
> use of these fields, so just get rid of them.
> 
> Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Cc: Tycho Andersen <tycho.andersen@canonical.com>
> Cc: Kees Cook <keescook@chromium.org>
> Reported-by: Jann Horn <jann@thejh.net>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  fs/proc/array.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 88c7de12197b..1bb1097e73b7 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -417,10 +417,11 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>  	mm = get_task_mm(task);
>  	if (mm) {
>  		vsize = task_vsize(mm);
> -		if (permitted) {
> -			eip = KSTK_EIP(task);
> -			esp = KSTK_ESP(task);
> -		}
> +		/*
> +		 * esp and eip are intentionally zeroed out.  There is no
> +		 * non-racy way to read them without freezing the task.
> +		 * Programs that need reliable values can use ptrace(2).
> +		 */
>  	}
>  
>  	get_task_comm(tcomm, task);
> -- 
> 2.7.4

I got an Oops with khungtaskd. This kernel was built with CONFIG_THREAD_INFO_IN_TASK=y .
Is this same reason?

[  580.778495] Out of memory: Kill process 10206 (a.out) score 998 or sacrifice child
[  580.778499] Killed process 10206 (a.out) total-vm:4176kB, anon-rss:80kB, file-rss:0kB, shmem-rss:0kB
[  580.797408] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  580.802963] a.out           x[  580.803660] BUG: unable to handle kernel 
paging request at ffffc900144dfc60
[  580.807153] IP: [<ffffffff81026feb>] thread_saved_pc+0xb/0x20
[  580.809313] PGD 7f4c0067 [  580.809875] PUD 7f4c1067 
PMD 47df1067 [  580.811690] PTE 0
[  580.812998] 
[  580.814155] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  580.816139] Modules linked in: ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_nat ebtable_broute bridge stp llc[  580.821830] oom_reaper: reaped process 10206 (a.out), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[  580.822492] Out of memory: Kill process 10208 (a.out) score 998 or sacrifice child
[  580.822496] Killed process 10208 (a.out) total-vm:4176kB, anon-rss:80kB, file-rss:0kB, shmem-rss:0kB
[  580.824895] oom_reaper: reaped process 10208 (a.out), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[  580.833682]  ebtable_filter ebtables[  580.834453] Out of memory: Kill process 10210 (a.out) score 998 or sacrifice child
[  580.834458] Killed process 10210 (a.out) total-vm:4176kB, anon-rss:80kB, file-rss:0kB, shmem-rss:0kB
[  580.839762]  ip6table_mangle ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_raw iptable_filter coretemp pcspkr sg i2c_piix4 vmw_vmci shpchp ip_tables sd_mod ata_generic pata_acpi serio_raw vmwgfx drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ahci e1000 mptspi libahci drm scsi_transport_spi mptscsih mptbase i2c_core ata_piix libata
[  580.850620] CPU: 2 PID: 45 Comm: khungtaskd Tainted: G        W       4.9.0-rc3+ #83
[  580.853526] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[  580.856842] task: ffff88007b54b7c0 task.stack: ffffc900004c0000
[  580.859169] RIP: 0010:[<ffffffff81026feb>]  [<ffffffff81026feb>] thread_saved_pc+0xb/0x20
[  580.862264] RSP: 0018:ffffc900004c3db8  EFLAGS: 00010202
[  580.864343] RAX: ffffc900144dfc30 RBX: ffff8800438e1c00 RCX: 0000000000000000
[  580.867439] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8800438e1c00
[  580.869910] RBP: ffffc900004c3db8 R08: 0000000000000001 R09: 0000000000000001
[  580.872963] R10: 0000000000000000 R11: 0000000000aaaaaa R12: 0000000000000007
[  580.875522] R13: 000000000000028a R14: 00000000003ffa8a R15: ffff8800438e1eb8
[  580.877387] oom_reaper: reaped process 10210 (a.out), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[  580.878738] Out of memory: Kill process 10212 (a.out) score 998 or sacrifice child
[  580.878743] Killed process 10212 (a.out) total-vm:4176kB, anon-rss:80kB, file-rss:0kB, shmem-rss:0kB
[  580.887239] FS:  0000000000000000(0000) GS:ffff88007c600000(0000) knlGS:0000000000000000
[  580.890017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  580.892628] CR2: ffffc900144dfc60 CR3: 0000000001c0c000 CR4: 00000000001406e0
[  580.895101] Stack:
[  580.896443]  ffffc900004c3de0 ffffffff810974c0 0000000000000000 ffff8800438e1c00
[  580.899033]  ffff8800438e1c00 ffffc900004c3e40 ffffffff8112a500 ffffffff8112a32d
[  580.904306]  000000000000003c ffff8800438e1c00 0000000000000003 000000010003e000
[  580.907040] Call Trace:
[  580.908547]  [<ffffffff810974c0>] sched_show_task+0x50/0x240
[  580.911435] oom_reaper: reaped process 10212 (a.out), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[  580.912449] Out of memory: Kill process 10214 (a.out) score 998 or sacrifice child
[  580.912453] Killed process 10214 (a.out) total-vm:4176kB, anon-rss:80kB, file-rss:0kB, shmem-rss:0kB
[  580.919432] oom_reaper: reaped process 10214 (a.out), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[  580.920256] Out of memory: Kill process 10216 (a.out) score 998 or sacrifice child
[  580.920259] Killed process 10216 (a.out) total-vm:4176kB, anon-rss:80kB, file-rss:0kB, shmem-rss:0kB
[  580.928793]  [<ffffffff8112a500>] watchdog+0x3d0/0x4f0
[  580.930774]  [<ffffffff8112a32d>] ? watchdog+0x1fd/0x4f0
[  580.932785]  [<ffffffff8112a130>] ? check_memalloc_stalling_tasks+0x820/0x820
[  580.935649]  [<ffffffff81089b4d>] kthread+0xfd/0x120
[  580.937594]  [<ffffffff81089a50>] ? kthread_park+0x60/0x60
[  580.939693]  [<ffffffff81089a50>] ? kthread_park+0x60/0x60
[  580.941743]  [<ffffffff816a4c57>] ret_from_fork+0x27/0x40
[  580.944608] Code: 55 48 8b bf d0 01 00 00 be 00 00 00 02 48 89 e5 e8 6b 58 3f 00 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 8b 87 e0 15 00 00 48 89 e5 <48> 8b 40 30 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 
[  580.952519] RIP  [<ffffffff81026feb>] thread_saved_pc+0xb/0x20
[  580.954654]  RSP <ffffc900004c3db8>
[  580.956272] CR2: ffffc900144dfc60
[  580.957861] ---[ end trace cd024114d281cfa4 ]---
[  580.959662] BUG: sleeping function called from invalid context at ./include/linux/sched.h:3138
[  580.962350] in_atomic(): 0, irqs_disabled(): 1, pid: 45, name: khungtaskd
[  580.964610] INFO: lockdep is turned off.
[  580.966236] irq event stamp: 88
[  580.967682] hardirqs last  enabled at (87): [  580.968588] [<ffffffff816a4075>] _raw_spin_unlock_irqrestore+0x55/0x70
[  580.970766] hardirqs last disabled at (88): [  580.971654] [<ffffffff8169ddb1>] __schedule+0x91/0x730
[  580.973574] softirqs last  enabled at (66): [  580.974607] [<ffffffff8106d422>] __do_softirq+0x192/0x220
[  580.976628] softirqs last disabled at (59): [  580.977528] [<ffffffff8106d754>] irq_exit+0xc4/0x100
[  580.979345] Preemption disabled at:[  580.980073] [<ffffffff810d1a7f>] wake_up_klogd+0xf/0x70
[  580.981951] CPU: 2 PID: 45 Comm: khungtaskd Tainted: G      D W       4.9.0-rc3+ #83
[  580.984297] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[  580.987279]  ffffc900004c3e50 ffffffff813372bf 0000000000000000 ffff88007b54b7c0
[  580.989759]  ffffc900004c3e88 ffffffff8108fa2c ffffffff819799f2 0000000000000c42
[  580.992259]  0000000000000000 ffff88007b54b7c0 0000000000000000 ffffc900004c3eb0
[  580.994701] Call Trace:
[  580.995988]  [<ffffffff813372bf>] dump_stack+0x67/0x98
[  580.997835]  [<ffffffff8108fa2c>] ___might_sleep+0x16c/0x260
[  581.000291]  [<ffffffff8108fb65>] __might_sleep+0x45/0x80
[  581.002552]  [<ffffffff8107823e>] exit_signals+0x2e/0x2f0
[  581.004411]  [<ffffffff8108b991>] ? blocking_notifier_call_chain+0x11/0x20
[  581.006760]  [<ffffffff8106bbe6>] do_exit+0xb6/0xb10
[  581.008646]  [<ffffffff816a6627>] rewind_stack_do_exit+0x17/0x20
[  608.732005] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [vmtoolsd:2075]
