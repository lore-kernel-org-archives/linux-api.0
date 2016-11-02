From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [4.9-rc3] BUG: unable to handle kernel paging request at ffffc900144dfc60
Date: Wed, 2 Nov 2016 19:50:29 +0900
Message-ID: <201611021950.FEJ34368.HFFJOOMLtQOVSF@I-love.SAKURA.ne.jp>
References: <cover.1475257877.git.luto@kernel.org>
        <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
        <201611012336.IAC18714.VLMOQSHOFtOFJF@I-love.SAKURA.ne.jp>
        <CA+55aFzphURPFzAvU4z6Moy7ZmimcwPuUdYU8bj9z0J+S8X1rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzphURPFzAvU4z6Moy7ZmimcwPuUdYU8bj9z0J+S8X1rw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, peterz@infradead.org, mingo@redhat.com
Cc: luto@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, brgerst@gmail.com, bp@alien8.de, jann@thejh.net, linux-api@vger.kernel.org, keescook@chromium.org, tycho.andersen@canonical.com
List-Id: linux-api@vger.kernel.org

Linus Torvalds wrote:
> On Tue, Nov 1, 2016 at 8:36 AM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> >
> > I got an Oops with khungtaskd. This kernel was built with CONFIG_THREAD_INFO_IN_TASK=y .
> > Is this same reason?
> 
> CONFIG_THREAD_INFO_IN_TASK is always set on x86, but I assume you also
> did VMAP_STACK

Yes. And I wrote a reproducer.

---------- Reproducer start ----------
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	if (fork() == 0)
		_exit(0);
	sleep(1);
	system("echo t > /proc/sysrq-trigger");
	return 0;
}
---------- Reproducer end ----------

---------- Serial console log start ----------
[  328.528734] a.out           x
[  328.529293] BUG: unable to handle kernel
[  328.530655] paging request at ffffc90001f43e18
[  328.531837] IP: [<ffffffff81026feb>] thread_saved_pc+0xb/0x20
[  328.533512] PGD 7f4c0067
[  328.533972] PUD 7f4c1067
[  328.535065] PMD 74cba067
[  328.535296] PTE 0

[  328.537173] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  328.538698] Modules linked in: ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_raw iptable_filter coretemp pcspkr sg i2c_piix4 shpchp vmw_vmci ip_tables sd_mod ata_generic pata_acpi serio_raw mptspi vmwgfx scsi_transport_spi drm_kms_helper ahci syscopyarea sysfillrect sysimgblt mptscsih e1000 fb_sys_fops libahci ttm drm mptbase ata_piix i2c_core libata
[  328.552465] CPU: 0 PID: 4299 Comm: sh Tainted: G        W       4.9.0-rc3+ #83
[  328.554403] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
[  328.556939] task: ffff8800792b5380 task.stack: ffffc90001f58000
[  328.558686] RIP: 0010:[<ffffffff81026feb>]  [<ffffffff81026feb>] thread_saved_pc+0xb/0x20
[  328.560926] RSP: 0018:ffffc90001f5bd28  EFLAGS: 00010202
[  328.562603] RAX: ffffc90001f43de8 RBX: ffff88007826d380 RCX: 0000000000000006
[  328.564507] RDX: 0000000000000000 RSI: ffffffff8197f2d1 RDI: ffff88007826d380
[  328.566437] RBP: ffffc90001f5bd28 R08: 0000000000000001 R09: 0000000000000001
[  328.568354] R10: 0000000000000001 R11: 0000000000000004 R12: 0000000000000007
[  328.570266] R13: ffff88007826d638 R14: ffff88007826d380 R15: 0000000000000002
[  328.572197] FS:  00007ff7b501e740(0000) GS:ffff88007c200000(0000) knlGS:0000000000000000
[  328.574303] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  328.576006] CR2: ffffc90001f43e18 CR3: 000000007894c000 CR4: 00000000001406f0
[  328.577995] Stack:
[  328.579024]  ffffc90001f5bd50 ffffffff810974c0 ffffc90001f5bd50 ffff88007826d380
[  328.581219]  0000000000000000 ffffc90001f5bd88 ffffffff81097767 ffffffff810976b0
[  328.583300]  ffffffff81c74e60 0000000000000074 0000000000000000 0000000000000007
[  328.585404] Call Trace:
[  328.586531]  [<ffffffff810974c0>] sched_show_task+0x50/0x240
[  328.588184]  [<ffffffff81097767>] show_state_filter+0xb7/0x190
[  328.589860]  [<ffffffff810976b0>] ? sched_show_task+0x240/0x240
[  328.591553]  [<ffffffff813fd4fb>] sysrq_handle_showstate+0xb/0x20
[  328.593304]  [<ffffffff813fdce6>] __handle_sysrq+0x136/0x220
[  328.594992]  [<ffffffff813fdbb0>] ? __sysrq_get_key_op+0x30/0x30
[  328.596678]  [<ffffffff813fe1f1>] write_sysrq_trigger+0x41/0x50
[  328.598386]  [<ffffffff81249c88>] proc_reg_write+0x38/0x70
[  328.600038]  [<ffffffff811dc802>] __vfs_write+0x32/0x140
[  328.601604]  [<ffffffff810dc797>] ? rcu_read_lock_sched_held+0x87/0x90
[  328.603365]  [<ffffffff810dcb2a>] ? rcu_sync_lockdep_assert+0x2a/0x50
[  328.605111]  [<ffffffff811e0279>] ? __sb_start_write+0x189/0x240
[  328.606735]  [<ffffffff811dd642>] ? vfs_write+0x182/0x1b0
[  328.608278]  [<ffffffff811dd570>] vfs_write+0xb0/0x1b0
[  328.609777]  [<ffffffff81002240>] ? syscall_trace_enter+0x1b0/0x240
[  328.611513]  [<ffffffff811dea13>] SyS_write+0x53/0xc0
[  328.612989]  [<ffffffff81353b63>] ? __this_cpu_preempt_check+0x13/0x20
[  328.614757]  [<ffffffff81002511>] do_syscall_64+0x61/0x1d0
[  328.616329]  [<ffffffff816a4aa4>] entry_SYSCALL64_slow_path+0x25/0x25
[  328.618057] Code: 55 48 8b bf d0 01 00 00 be 00 00 00 02 48 89 e5 e8 6b 58 3f 00 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 8b 87 e0 15 00 00 48 89 e5 <48> 8b 40 30 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
[  328.624402] RIP  [<ffffffff81026feb>] thread_saved_pc+0xb/0x20
[  328.626124]  RSP <ffffc90001f5bd28>
[  328.627375] CR2: ffffc90001f43e18
[  328.628646] ---[ end trace 70b31f25a2ce0c0c ]---
---------- Serial console log end ----------

> Considering that we just print out  a useless hex number, not even a
> symbol, and there's a big question mark whether this even makes sense
> anyway, I suspect we should just remove it all.  The real information
> would have come later as part of "show_stack()", which seems to be
> doing the proper  try_get_task_stack().
> 
> So I _think_ the fix is to just remove this. Perhaps something like
> the attached? Adding scheduler people since this is in their code..

That is not sufficient, for another Oops occurs inside stack_not_used().
Since I don't want to break stack_not_used(), can we tolerate nested
try_get_task_stack() usage and protect the whole sched_show_task()?

----------------------------------------
>From 9cf83a0a8c48d281434b040694835743940a88b2 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 2 Nov 2016 19:31:07 +0900
Subject: [PATCH] sched: Fix oops in sched_show_task()

When CONFIG_VMAP_STACK=y, it is possible that an exited thread remains in
the task list after its stack pointer was already set to NULL. Therefore,
thread_saved_pc() and stack_not_used() in sched_show_task() will trigger
NULL pointer dereference if an attempt to dump such thread's traces
(e.g. SysRq-t, khungtaskd) is made.

Since show_stack() in sched_show_task() calls try_get_task_stack() and
sched_show_task() is called from interrupt context, calling
try_get_task_stack() from sched_show_task() will be safe as well.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/sched/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 42d4027..9abf66b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5192,6 +5192,8 @@ void sched_show_task(struct task_struct *p)
 	int ppid;
 	unsigned long state = p->state;
 
+	if (!try_get_task_stack(p))
+		return;
 	if (state)
 		state = __ffs(state) + 1;
 	printk(KERN_INFO "%-15.15s %c", p->comm,
@@ -5221,6 +5223,7 @@ void sched_show_task(struct task_struct *p)
 
 	print_worker_info(KERN_INFO, p);
 	show_stack(p, NULL);
+	put_task_stack(p);
 }
 
 void show_state_filter(unsigned long state_filter)
-- 
1.8.3.1
