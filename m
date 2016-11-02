From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [4.9-rc3] BUG: unable to handle kernel paging request at ffffc900144dfc60
Date: Wed, 2 Nov 2016 07:05:35 -0700
Message-ID: <CALCETrVYVYoxiN0ZYAtZF_6bwxHbhKmy-Rvny+u6PH0_7oVdPA@mail.gmail.com>
References: <cover.1475257877.git.luto@kernel.org> <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
 <201611012336.IAC18714.VLMOQSHOFtOFJF@I-love.SAKURA.ne.jp>
 <CA+55aFzphURPFzAvU4z6Moy7ZmimcwPuUdYU8bj9z0J+S8X1rw@mail.gmail.com> <201611021950.FEJ34368.HFFJOOMLtQOVSF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201611021950.FEJ34368.HFFJOOMLtQOVSF-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 2, 2016 at 3:50 AM, Tetsuo Handa
<penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org> wrote:
> Linus Torvalds wrote:
>> On Tue, Nov 1, 2016 at 8:36 AM, Tetsuo Handa
>> <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org> wrote:
>> >
>> > I got an Oops with khungtaskd. This kernel was built with CONFIG_THREA=
D_INFO_IN_TASK=3Dy .
>> > Is this same reason?
>>
>> CONFIG_THREAD_INFO_IN_TASK is always set on x86, but I assume you also
>> did VMAP_STACK
>
> Yes. And I wrote a reproducer.
>
> ---------- Reproducer start ----------
> #include <unistd.h>
> #include <stdlib.h>
>
> int main(int argc, char *argv[])
> {
>         if (fork() =3D=3D 0)
>                 _exit(0);
>         sleep(1);
>         system("echo t > /proc/sysrq-trigger");
>         return 0;
> }
> ---------- Reproducer end ----------
>
> ---------- Serial console log start ----------
> [  328.528734] a.out           x
> [  328.529293] BUG: unable to handle kernel
> [  328.530655] paging request at ffffc90001f43e18
> [  328.531837] IP: [<ffffffff81026feb>] thread_saved_pc+0xb/0x20
> [  328.533512] PGD 7f4c0067
> [  328.533972] PUD 7f4c1067
> [  328.535065] PMD 74cba067
> [  328.535296] PTE 0
>
> [  328.537173] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  328.538698] Modules linked in: ip6t_rpfilter ip6t_REJECT nf_reject_ipv=
6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_i=
pv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_nat ebtable_broute bri=
dge stp llc ebtable_filter ebtables ip6table_mangle ip6table_raw ip6table_f=
ilter ip6_tables iptable_mangle iptable_raw iptable_filter coretemp pcspkr =
sg i2c_piix4 shpchp vmw_vmci ip_tables sd_mod ata_generic pata_acpi serio_r=
aw mptspi vmwgfx scsi_transport_spi drm_kms_helper ahci syscopyarea sysfill=
rect sysimgblt mptscsih e1000 fb_sys_fops libahci ttm drm mptbase ata_piix =
i2c_core libata
> [  328.552465] CPU: 0 PID: 4299 Comm: sh Tainted: G        W       4.9.0-=
rc3+ #83
> [  328.554403] Hardware name: VMware, Inc. VMware Virtual Platform/440BX =
Desktop Reference Platform, BIOS 6.00 07/02/2015
> [  328.556939] task: ffff8800792b5380 task.stack: ffffc90001f58000
> [  328.558686] RIP: 0010:[<ffffffff81026feb>]  [<ffffffff81026feb>] threa=
d_saved_pc+0xb/0x20
> [  328.560926] RSP: 0018:ffffc90001f5bd28  EFLAGS: 00010202
> [  328.562603] RAX: ffffc90001f43de8 RBX: ffff88007826d380 RCX: 000000000=
0000006
> [  328.564507] RDX: 0000000000000000 RSI: ffffffff8197f2d1 RDI: ffff88007=
826d380
> [  328.566437] RBP: ffffc90001f5bd28 R08: 0000000000000001 R09: 000000000=
0000001
> [  328.568354] R10: 0000000000000001 R11: 0000000000000004 R12: 000000000=
0000007
> [  328.570266] R13: ffff88007826d638 R14: ffff88007826d380 R15: 000000000=
0000002
> [  328.572197] FS:  00007ff7b501e740(0000) GS:ffff88007c200000(0000) knlG=
S:0000000000000000
> [  328.574303] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  328.576006] CR2: ffffc90001f43e18 CR3: 000000007894c000 CR4: 000000000=
01406f0
> [  328.577995] Stack:
> [  328.579024]  ffffc90001f5bd50 ffffffff810974c0 ffffc90001f5bd50 ffff88=
007826d380
> [  328.581219]  0000000000000000 ffffc90001f5bd88 ffffffff81097767 ffffff=
ff810976b0
> [  328.583300]  ffffffff81c74e60 0000000000000074 0000000000000000 000000=
0000000007
> [  328.585404] Call Trace:
> [  328.586531]  [<ffffffff810974c0>] sched_show_task+0x50/0x240
> [  328.588184]  [<ffffffff81097767>] show_state_filter+0xb7/0x190
> [  328.589860]  [<ffffffff810976b0>] ? sched_show_task+0x240/0x240
> [  328.591553]  [<ffffffff813fd4fb>] sysrq_handle_showstate+0xb/0x20
> [  328.593304]  [<ffffffff813fdce6>] __handle_sysrq+0x136/0x220
> [  328.594992]  [<ffffffff813fdbb0>] ? __sysrq_get_key_op+0x30/0x30
> [  328.596678]  [<ffffffff813fe1f1>] write_sysrq_trigger+0x41/0x50
> [  328.598386]  [<ffffffff81249c88>] proc_reg_write+0x38/0x70
> [  328.600038]  [<ffffffff811dc802>] __vfs_write+0x32/0x140
> [  328.601604]  [<ffffffff810dc797>] ? rcu_read_lock_sched_held+0x87/0x90
> [  328.603365]  [<ffffffff810dcb2a>] ? rcu_sync_lockdep_assert+0x2a/0x50
> [  328.605111]  [<ffffffff811e0279>] ? __sb_start_write+0x189/0x240
> [  328.606735]  [<ffffffff811dd642>] ? vfs_write+0x182/0x1b0
> [  328.608278]  [<ffffffff811dd570>] vfs_write+0xb0/0x1b0
> [  328.609777]  [<ffffffff81002240>] ? syscall_trace_enter+0x1b0/0x240
> [  328.611513]  [<ffffffff811dea13>] SyS_write+0x53/0xc0
> [  328.612989]  [<ffffffff81353b63>] ? __this_cpu_preempt_check+0x13/0x20
> [  328.614757]  [<ffffffff81002511>] do_syscall_64+0x61/0x1d0
> [  328.616329]  [<ffffffff816a4aa4>] entry_SYSCALL64_slow_path+0x25/0x25
> [  328.618057] Code: 55 48 8b bf d0 01 00 00 be 00 00 00 02 48 89 e5 e8 6=
b 58 3f 00 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 8b 87 e0 15 00 00 48 89 e=
5 <48> 8b 40 30 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
> [  328.624402] RIP  [<ffffffff81026feb>] thread_saved_pc+0xb/0x20
> [  328.626124]  RSP <ffffc90001f5bd28>
> [  328.627375] CR2: ffffc90001f43e18
> [  328.628646] ---[ end trace 70b31f25a2ce0c0c ]---
> ---------- Serial console log end ----------
>
>> Considering that we just print out  a useless hex number, not even a
>> symbol, and there's a big question mark whether this even makes sense
>> anyway, I suspect we should just remove it all.  The real information
>> would have come later as part of "show_stack()", which seems to be
>> doing the proper  try_get_task_stack().
>>
>> So I _think_ the fix is to just remove this. Perhaps something like
>> the attached? Adding scheduler people since this is in their code..
>
> That is not sufficient, for another Oops occurs inside stack_not_used().
> Since I don't want to break stack_not_used(), can we tolerate nested
> try_get_task_stack() usage and protect the whole sched_show_task()?
>
> ----------------------------------------
> >From 9cf83a0a8c48d281434b040694835743940a88b2 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> Date: Wed, 2 Nov 2016 19:31:07 +0900
> Subject: [PATCH] sched: Fix oops in sched_show_task()
>
> When CONFIG_VMAP_STACK=3Dy, it is possible that an exited thread remains =
in

Nit: It's CONFIG_THREAD_INFO_IN_TASK=3Dy that does this.

This patch looks fine to me.  Linus, your patch also looks almost good
(I think the lines you deleted were spaced like that to preserve
output alignment, which may or may not matter), and maybe it would
make sense to apply both.
