From: Leonard Crestez <leonard.crestez-3arQi8VN3Tc@public.gmane.org>
Subject: Re: [PATCH v10 2/3] arm/syscalls: Check address limit on user-mode
 return
Date: Tue, 18 Jul 2017 17:36:06 +0300
Message-ID: <1500388566.11612.74.camel@nxp.com>
References: <20170615011203.144108-1-thgarnie@google.com>
         <20170615011203.144108-2-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170615011203.144108-2-thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marin>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Octavian Purdila <octavian.purdila-3arQi8VN3Tc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2017-06-14 at 18:12 -0700, Thomas Garnier wrote:
> Ensure the address limit is a user-mode segment before returning to
> user-mode. Otherwise a process can corrupt kernel-mode memory and
> elevate privileges [1].
> 
> The set_fs function sets the TIF_SETFS flag to force a slow path on
> return. In the slow path, the address limit is checked to be USER_DS if
> needed.
> 
> The TIF_SETFS flag is added to _TIF_WORK_MASK shifting _TIF_SYSCALL_WORK
> for arm instruction immediate support. The global work mask is too big
> to used on a single instruction so adapt ret_fast_syscall.
> 
> [1] https://bugs.chromium.org/p/project-zero/issues/detail?id=990
> 
> Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> v10 redesigns the change to use work flags on set_fs as recommended by
> Linus and agreed by others.
> 
> Based on next-20170609
> ---
>  arch/arm/include/asm/thread_info.h | 15 +++++++++------
>  arch/arm/include/asm/uaccess.h     |  2 ++
>  arch/arm/kernel/entry-common.S     |  9 +++++++--
>  arch/arm/kernel/signal.c           |  5 +++++
>  4 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
> index 776757d1604a..1d468b527b7b 100644
> --- a/arch/arm/include/asm/thread_info.h
> +++ b/arch/arm/include/asm/thread_info.h
> @@ -139,10 +139,11 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
>  #define TIF_NEED_RESCHED	1	/* rescheduling necessary */
>  #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
>  #define TIF_UPROBE		3	/* breakpointed or singlestepping */
> -#define TIF_SYSCALL_TRACE	4	/* syscall trace active */
> -#define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
> -#define TIF_SYSCALL_TRACEPOINT	6	/* syscall tracepoint instrumentation */
> -#define TIF_SECCOMP		7	/* seccomp syscall filtering active */
> +#define TIF_FSCHECK		4	/* Check FS is USER_DS on return */
> +#define TIF_SYSCALL_TRACE	5	/* syscall trace active */
> +#define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
> +#define TIF_SYSCALL_TRACEPOINT	7	/* syscall tracepoint instrumentation */
> +#define TIF_SECCOMP		8	/* seccomp syscall filtering active */
>  
>  #define TIF_NOHZ		12	/* in adaptive nohz mode */
>  #define TIF_USING_IWMMXT	17
> @@ -153,6 +154,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
>  #define _TIF_UPROBE		(1 << TIF_UPROBE)
> +#define _TIF_FSCHECK		(1 << TIF_FSCHECK)
>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>  #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
>  #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
> @@ -166,8 +168,9 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
>  /*
>   * Change these and you break ASM code in entry-common.S
>   */
> -#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
> -				 _TIF_NOTIFY_RESUME | _TIF_UPROBE)
> +#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING |	\
> +				 _TIF_NOTIFY_RESUME | _TIF_UPROBE |	\
> +				 _TIF_FSCHECK)
>  
>  #endif /* __KERNEL__ */
>  #endif /* __ASM_ARM_THREAD_INFO_H */
> diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
> index 2577405d082d..6cc882223e34 100644
> --- a/arch/arm/include/asm/uaccess.h
> +++ b/arch/arm/include/asm/uaccess.h
> @@ -77,6 +77,8 @@ static inline void set_fs(mm_segment_t fs)
>  {
>  	current_thread_info()->addr_limit = fs;
>  	modify_domain(DOMAIN_KERNEL, fs ? DOMAIN_CLIENT : DOMAIN_MANAGER);
> +	/* On user-mode return, check fs is correct */
> +	set_thread_flag(TIF_FSCHECK);
>  }
>  
>  #define segment_eq(a, b)	((a) == (b))
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index eb5cd77bf1d8..e33c32d56193 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -41,7 +41,9 @@ ret_fast_syscall:
>   UNWIND(.cantunwind	)
>  	disable_irq_notrace			@ disable interrupts
>  	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
> -	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
> +	tst	r1, #_TIF_SYSCALL_WORK
> +	bne	fast_work_pending
> +	tst	r1, #_TIF_WORK_MASK
>  	bne	fast_work_pending
>  
>  	/* perform architecture specific actions before user return */
> @@ -67,12 +69,15 @@ ret_fast_syscall:
>  	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
>  	disable_irq_notrace			@ disable interrupts
>  	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
> -	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
> +	tst	r1, #_TIF_SYSCALL_WORK
> +	bne	fast_work_pending
> +	tst	r1, #_TIF_WORK_MASK
>  	beq	no_work_pending
>   UNWIND(.fnend		)
>  ENDPROC(ret_fast_syscall)
>  
>  	/* Slower path - fall through to work_pending */
> +fast_work_pending:
>  #endif
>  
>  	tst	r1, #_TIF_SYSCALL_WORK
> diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
> index 7b8f2141427b..3a48b54c6405 100644
> --- a/arch/arm/kernel/signal.c
> +++ b/arch/arm/kernel/signal.c
> @@ -14,6 +14,7 @@
>  #include 
>  #include 
>  #include 
> +#include 
>  
>  #include 
>  #include 
> @@ -571,6 +572,10 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
>  	 * Update the trace code with the current status.
>  	 */
>  	trace_hardirqs_off();
> +
> +	/* Check valid user FS if needed */
> +	addr_limit_user_check();
> +
>  	do {
>  		if (likely(thread_flags & _TIF_NEED_RESCHED)) {
>  			schedule();

This patch made it's way into linux-next next-20170717 and it seems to
cause hangs when booting some boards over NFS (found via bisection). I
don't know exactly what determines the issue but I can reproduce hangs
if even if I just boot with init=/bin/bash and do stuff like

# sleep 1 & sleep 1 & sleep 1 & wait; wait; wait; echo done!

When this happens sysrq-t shows a sleep task hung in the 'R' state
spinning in do_work_pending, so maybe there is a potential infinite
loop here?

The addr_limit_user_check at the start of do_work_pending will check
for TIF_FSCHECK once and clear it but the function loops while
(thread_flags & _TIF_WORK_MASK), so it if TIF_FSCHECK is set again then
the loop will never terminate. Does this make sense?

I added some instrumentation to check if TIF_FSCHECK can show up during
the do_work_pending loop and the answer seems to be yes. I also tried
to get a stack with a set_fs call from inside do_work_pending and got
the following:

[  227.582402] CPU: 0 PID: 829 Comm: sleep Not tainted 4.12.0-01057-g93af8f7-dirty #332
[  227.590171] Hardware name: Freescale i.MX6 SoloLite (Device Tree)
[  227.596275] Backtrace: 
[  227.598754] [<c010cbb4>] (dump_backtrace) from [<c010ce60>] (show_stack+0x18/0x1c)
[  227.606339]  r7:00000000 r6:60070113 r5:00000000 r4:c105a958
[  227.612016] [<c010ce48>] (show_stack) from [<c0493498>] (dump_stack+0xb4/0xe8)
[  227.619258] [<c04933e4>] (dump_stack) from [<c010c350>] (mydbg_set_fs+0x40/0x48)
[  227.626671]  r9:c08cf35c r8:ee1cda7c r7:ee1e3dce r6:bf000000 r5:00000000 r4:ffffe000
[  227.634433] [<c010c310>] (mydbg_set_fs) from [<c021f0b8>] (__probe_kernel_read+0x44/0xd0)
[  227.642629] [<c021f074>] (__probe_kernel_read) from [<c011b8d8>] (do_alignment+0x8c/0x75c)
[  227.650909]  r10:ef085000 r9:c08cf35c r8:00000001 r7:ee1e3dce r6:c011b84c r5:ee1cdbe0
[  227.658748]  r4:00000000 r3:00000000
[  227.662338] [<c011b84c>] (do_alignment) from [<c0101394>] (do_DataAbort+0x40/0xc0)
[  227.669921]  r10:ef085000 r9:ee1cc000 r8:ee1cdbe0 r7:ee1e3dce r6:c011b84c r5:00000001
[  227.677760]  r4:c100dd3c
[  227.680308] [<c0101354>] (do_DataAbort) from [<c010da44>] (__dabt_svc+0x64/0xa0)
[  227.687714] Exception stack(0xee1cdbe0 to 0xee1cdc28)
[  227.692780] dbe0: 9064a8c0 ee1e3de2 d82727d8 00000000 ee1b20c0 ee1e3dce 00000000 ef08572c
[  227.700971] dc00: c0bb2034 c10c75ea ef085000 ee1cdc74 ee1cdc00 ee1cdc30 c01761a8 c08cf35c
[  227.709158] dc20: 40070113 ffffffff
[  227.712661]  r8:c0bb2034 r7:ee1cdc14 r6:ffffffff r5:40070113 r4:c08cf35c
[  227.719382] [<c08cf16c>] (inet_gro_receive) from [<c084a8ec>] (dev_gro_receive+0x2f0/0x618)
[  227.727746]  r10:ef085000 r9:00000001 r8:00000000 r7:ef085710 r6:c1008b88 r5:ee1b20c0
[  227.735585]  r4:c1009f78
[  227.738132] [<c084a5fc>] (dev_gro_receive) from [<c084ac8c>] (napi_gro_receive+0x78/0x1f4)
[  227.746410]  r10:ef085000 r9:00000001 r8:c10d15ec r7:c100792c r6:ef085710 r5:c10c744e
[  227.754249]  r4:ee1b20c0
[  227.756801] [<c084ac14>] (napi_gro_receive) from [<c06a2784>] (fec_enet_rx_napi+0x39c/0x988)
[  227.765253]  r9:00000001 r8:f0c8a960 r7:00000000 r6:00000000 r5:ef086000 r4:ee1b20c0
[  227.773010] [<c06a23e8>] (fec_enet_rx_napi) from [<c084a3a4>] (net_rx_action+0x21c/0x474)
[  227.781201]  r10:ee1cdd78 r9:c0fa7b80 r8:ef7dab80 r7:0000012c r6:00000040 r5:00000001
[  227.789039]  r4:ef085710
[  227.791593] [<c084a188>] (net_rx_action) from [<c012f2d4>] (__do_softirq+0x158/0x534)
[  227.799437]  r10:00000008 r9:ee1cc000 r8:c10ce568 r7:c100792c r6:c10247bd r5:00000003
[  227.807275]  r4:c100208c
[  227.809824] [<c012f17c>] (__do_softirq) from [<c012fa68>] (irq_exit+0xec/0x168)
[  227.817147]  r10:c1007ea0 r9:ef010400 r8:00000001 r7:00000000 r6:c1007d3c r5:00000000
[  227.824984]  r4:c0fa534c
[  227.827534] [<c012f97c>] (irq_exit) from [<c01883f4>] (__handle_domain_irq+0x74/0xe8)
[  227.835377] [<c0188380>] (__handle_domain_irq) from [<c01015fc>] (gic_handle_irq+0x58/0xbc)
[  227.843742]  r9:f080b100 r8:c105ae80 r7:ee1cde80 r6:000003ff r5:000003eb r4:f080b10c
[  227.851498] [<c01015a4>] (gic_handle_irq) from [<c010daf0>] (__irq_svc+0x70/0x98)
[  227.858990] Exception stack(0xee1cde80 to 0xee1cdec8)
[  227.864056] de80: ee7a1140 00000001 00000000 000012a9 ee7a1140 ee9d9f10 ee76edc0 ee9d9f60
[  227.872248] dea0: 00000000 ee9d9f10 00000010 ee1cdeec ee1cdeb8 ee1cded0 c038a77c c0389688
[  227.880434] dec0: 60070013 ffffffff
[  227.883937]  r10:00000010 r9:ee1cc000 r8:00000000 r7:ee1cdeb4 r6:ffffffff r5:60070013
[  227.891775]  r4:c0389688
[  227.894327] [<c038a6f8>] (nfs_file_clear_open_context) from [<c03860e8>] (nfs_file_release+0x54/0x60)
[  227.903558]  r7:ee9a78a0 r6:ee68f010 r5:ee9d9f10 r4:ee76edc0
[  227.909235] [<c0386094>] (nfs_file_release) from [<c0276cb4>] (__fput+0x94/0x1e0)
[  227.916734] [<c0276c20>] (__fput) from [<c0276e60>] (____fput+0x10/0x14)
[  227.923448]  r10:c10d4298 r9:00000000 r8:00000000 r7:ef2ed780 r6:ef2edc00 r5:c10d5180
[  227.931286]  r4:ef2edbd4
[  227.933839] [<c0276e50>] (____fput) from [<c014c534>] (task_work_run+0xc8/0xec)
[  227.941166] [<c014c46c>] (task_work_run) from [<c010c484>] (do_work_pending+0x12c/0x1c4)
[  227.949271]  r9:ee1cdfb0 r8:00000000 r7:00000000 r6:ee1cc000 r5:00000000 r4:00000000
[  227.957029] [<c010c358>] (do_work_pending) from [<c0107c90>] (slow_work_pending+0xc/0x20)
[  227.965219]  r10:00000000 r9:ee1cc000 r8:c0107e24 r7:0000005b r6:b6f76568 r5:b6f741f0
[  227.973058]  r4:b6f76904

Maybe the reason this reproduces easily in this particular setup is
that ethernet causes lots of alignment faults?

--
Regards,
Leonard
