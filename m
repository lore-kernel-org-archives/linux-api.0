From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v10 2/3] arm/syscalls: Check address limit on user-mode return
Date: Tue, 18 Jul 2017 12:04:36 -0700
Message-ID: <CAJcbSZFr9KJTfGfiZo2fThoDkAE-D1OFf2YtELq4P6jX8syesQ@mail.gmail.com>
References: <20170615011203.144108-1-thgarnie@google.com> <20170615011203.144108-2-thgarnie@google.com>
 <1500388566.11612.74.camel@nxp.com> <CAJcbSZEr8HPBwH1oVaHqPzAY4MS_=yqMoqPhcauuKu3cikB3uQ@mail.gmail.com>
 <1500398311.12096.30.camel@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500398311.12096.30.camel@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leonard Crestez <leonard.crestez@nxp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, David Howells <dhowells@redhat.com>, Russell King <linux@armlinux.org.uk>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@ar>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 18, 2017 at 10:18 AM, Leonard Crestez
<leonard.crestez@nxp.com> wrote:
>
> On Tue, 2017-07-18 at 09:04 -0700, Thomas Garnier wrote:
> > On Tue, Jul 18, 2017 at 7:36 AM, Leonard Crestez <leonard.crestez@nxp.com> wrote:
> > >
> > > On Wed, 2017-06-14 at 18:12 -0700, Thomas Garnier wrote:
> > > >
> > > > Ensure the address limit is a user-mode segment before returning to
> > > > user-mode. Otherwise a process can corrupt kernel-mode memory and
> > > > elevate privileges [1].
> > > >
> > > > The set_fs function sets the TIF_SETFS flag to force a slow path on
> > > > return. In the slow path, the address limit is checked to be USER_DS if
> > > > needed.
> > > >
> > > > The TIF_SETFS flag is added to _TIF_WORK_MASK shifting _TIF_SYSCALL_WORK
> > > > for arm instruction immediate support. The global work mask is too big
> > > > to used on a single instruction so adapt ret_fast_syscall.
> > > >
> > > > @@ -571,6 +572,10 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
> > > >        * Update the trace code with the current status.
> > > >        */
> > > >       trace_hardirqs_off();
> > > > +
> > > > +     /* Check valid user FS if needed */
> > > > +     addr_limit_user_check();
> > > > +
> > > >       do {
> > > >               if (likely(thread_flags & _TIF_NEED_RESCHED)) {
> > > >                       schedule();
> > > This patch made it's way into linux-next next-20170717 and it seems to
> > > cause hangs when booting some boards over NFS (found via bisection). I
> > > don't know exactly what determines the issue but I can reproduce hangs
> > > if even if I just boot with init=/bin/bash and do stuff like
> > >
> > > # sleep 1 & sleep 1 & sleep 1 & wait; wait; wait; echo done!
> > >
> > > When this happens sysrq-t shows a sleep task hung in the 'R' state
> > > spinning in do_work_pending, so maybe there is a potential infinite
> > > loop here?
> > >
> > > The addr_limit_user_check at the start of do_work_pending will check
> > > for TIF_FSCHECK once and clear it but the function loops while
> > > (thread_flags & _TIF_WORK_MASK), so it if TIF_FSCHECK is set again then
> > > the loop will never terminate. Does this make sense?
>
> > Yes, it does. Thanks for looking into this.
>
> > > I added some instrumentation to check if TIF_FSCHECK can show up during
> > > the do_work_pending loop and the answer seems to be yes. I also tried
> > > to get a stack with a set_fs call from inside do_work_pending and got
> > > the following:
> > >
> > > [  227.582402] CPU: 0 PID: 829 Comm: sleep Not tainted 4.12.0-01057-g93af8f7-dirty #332
> > > [  227.590171] Hardware name: Freescale i.MX6 SoloLite (Device Tree)
> > > [  227.596275] Backtrace:
> > > [  227.598754] [] (dump_backtrace) from [] (show_stack+0x18/0x1c)
> > > [  227.606339]  r7:00000000 r6:60070113 r5:00000000 r4:c105a958
> > > [  227.612016] [] (show_stack) from [] (dump_stack+0xb4/0xe8)
> > > [  227.619258] [] (dump_stack) from [] (mydbg_set_fs+0x40/0x48)
> > > [  227.626671]  r9:c08cf35c r8:ee1cda7c r7:ee1e3dce r6:bf000000 r5:00000000 r4:ffffe000
> > > [  227.634433] [] (mydbg_set_fs) from [] (__probe_kernel_read+0x44/0xd0)
> > > [  227.642629] [] (__probe_kernel_read) from [] (do_alignment+0x8c/0x75c)
> > > [  227.650909]  r10:ef085000 r9:c08cf35c r8:00000001 r7:ee1e3dce r6:c011b84c r5:ee1cdbe0
> > > [  227.658748]  r4:00000000 r3:00000000
> > > [  227.662338] [] (do_alignment) from [] (do_DataAbort+0x40/0xc0)
> > > [  227.669921]  r10:ef085000 r9:ee1cc000 r8:ee1cdbe0 r7:ee1e3dce r6:c011b84c r5:00000001
> > > [  227.677760]  r4:c100dd3c
> > > [  227.680308] [] (do_DataAbort) from [] (__dabt_svc+0x64/0xa0)
> > > [  227.687714] Exception stack(0xee1cdbe0 to 0xee1cdc28)
> > > [  227.692780] dbe0: 9064a8c0 ee1e3de2 d82727d8 00000000 ee1b20c0 ee1e3dce 00000000 ef08572c
> > > [  227.700971] dc00: c0bb2034 c10c75ea ef085000 ee1cdc74 ee1cdc00 ee1cdc30 c01761a8 c08cf35c
> > > [  227.709158] dc20: 40070113 ffffffff
> > > [  227.712661]  r8:c0bb2034 r7:ee1cdc14 r6:ffffffff r5:40070113 r4:c08cf35c
> > > [  227.719382] [] (inet_gro_receive) from [] (dev_gro_receive+0x2f0/0x618)
> > > [  227.727746]  r10:ef085000 r9:00000001 r8:00000000 r7:ef085710 r6:c1008b88 r5:ee1b20c0
> > > [  227.735585]  r4:c1009f78
> > > [  227.738132] [] (dev_gro_receive) from [] (napi_gro_receive+0x78/0x1f4)
> > > [  227.746410]  r10:ef085000 r9:00000001 r8:c10d15ec r7:c100792c r6:ef085710 r5:c10c744e
> > > [  227.754249]  r4:ee1b20c0
> > > [  227.756801] [] (napi_gro_receive) from [] (fec_enet_rx_napi+0x39c/0x988)
> > > [  227.765253]  r9:00000001 r8:f0c8a960 r7:00000000 r6:00000000 r5:ef086000 r4:ee1b20c0
> > > [  227.773010] [] (fec_enet_rx_napi) from [] (net_rx_action+0x21c/0x474)
> > > [  227.781201]  r10:ee1cdd78 r9:c0fa7b80 r8:ef7dab80 r7:0000012c r6:00000040 r5:00000001
> > > [  227.789039]  r4:ef085710
> > > [  227.791593] [] (net_rx_action) from [] (__do_softirq+0x158/0x534)
> > > [  227.799437]  r10:00000008 r9:ee1cc000 r8:c10ce568 r7:c100792c r6:c10247bd r5:00000003
> > > [  227.807275]  r4:c100208c
> > > [  227.809824] [] (__do_softirq) from [] (irq_exit+0xec/0x168)
> > > [  227.817147]  r10:c1007ea0 r9:ef010400 r8:00000001 r7:00000000 r6:c1007d3c r5:00000000
> > > [  227.824984]  r4:c0fa534c
> > > [  227.827534] [] (irq_exit) from [] (__handle_domain_irq+0x74/0xe8)
> > > [  227.835377] [] (__handle_domain_irq) from [] (gic_handle_irq+0x58/0xbc)
> > > [  227.843742]  r9:f080b100 r8:c105ae80 r7:ee1cde80 r6:000003ff r5:000003eb r4:f080b10c
> > > [  227.851498] [] (gic_handle_irq) from [] (__irq_svc+0x70/0x98)
> > > [  227.858990] Exception stack(0xee1cde80 to 0xee1cdec8)
> > > [  227.864056] de80: ee7a1140 00000001 00000000 000012a9 ee7a1140 ee9d9f10 ee76edc0 ee9d9f60
> > > [  227.872248] dea0: 00000000 ee9d9f10 00000010 ee1cdeec ee1cdeb8 ee1cded0 c038a77c c0389688
> > > [  227.880434] dec0: 60070013 ffffffff
> > > [  227.883937]  r10:00000010 r9:ee1cc000 r8:00000000 r7:ee1cdeb4 r6:ffffffff r5:60070013
> > > [  227.891775]  r4:c0389688
> > > [  227.894327] [] (nfs_file_clear_open_context) from [] (nfs_file_release+0x54/0x60)
> > > [  227.903558]  r7:ee9a78a0 r6:ee68f010 r5:ee9d9f10 r4:ee76edc0
> > > [  227.909235] [] (nfs_file_release) from [] (__fput+0x94/0x1e0)
> > > [  227.916734] [] (__fput) from [] (____fput+0x10/0x14)
> > > [  227.923448]  r10:c10d4298 r9:00000000 r8:00000000 r7:ef2ed780 r6:ef2edc00 r5:c10d5180
> > > [  227.931286]  r4:ef2edbd4
> > > [  227.933839] [] (____fput) from [] (task_work_run+0xc8/0xec)
> > > [  227.941166] [] (task_work_run) from [] (do_work_pending+0x12c/0x1c4)
> > > [  227.949271]  r9:ee1cdfb0 r8:00000000 r7:00000000 r6:ee1cc000 r5:00000000 r4:00000000
> > > [  227.957029] [] (do_work_pending) from [] (slow_work_pending+0xc/0x20)
> > > [  227.965219]  r10:00000000 r9:ee1cc000 r8:c0107e24 r7:0000005b r6:b6f76568 r5:b6f741f0
> > > [  227.973058]  r4:b6f76904
> > >
> > > Maybe the reason this reproduces easily in this particular setup is
> > > that ethernet causes lots of alignment faults?
> > Can you try this change?
> >
> > diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
> > index 3a48b54c6405..bc6ad7789568 100644
> > --- a/arch/arm/kernel/signal.c
> > +++ b/arch/arm/kernel/signal.c
> > @@ -573,12 +573,11 @@ do_work_pending(struct pt_regs *regs, unsigned
> > int thread_flags, int syscall)
> >   */
> >   trace_hardirqs_off();
> >
> > - /* Check valid user FS if needed */
> > - addr_limit_user_check();
> > -
> >   do {
> >   if (likely(thread_flags & _TIF_NEED_RESCHED)) {
> >   schedule();
> > + } else if (thread_flags & _TIF_FSCHECK) {
> > + addr_limit_user_check();
> >   } else {
> >   if (unlikely(!user_mode(regs)))
> >   return 0;
>
> This does seem to work, it no longer hangs on boot in my setup. This is
> obviously only a very superficial test.
>
> The new location of this check seems weird, it's not clear why it
> should be on an else path. Perhaps it should be moved to right before
> where current_thread_info()->flags is fetched again?

I was hitting bug when I tried that.I think that's because you
basically let the signal handler do pending work before you check the
flag, that's not a good idea.

>
> The issue seems like it would affect arm64 as well.

Yes, I will propose a fix on each architecture.

>
> If the purpose is hardening against buggy kernel code doing bad set_fs
> calls shouldn't this flag also be checked before looking at
> TIF_NEED_RESCHED and calling schedule()?

I am not sure to be honest. I expected schedule to only schedule the
processor to another task which would be fine given only the current
task have a bogus fs. I will put it first in case there is an edge
case scenario I missed.

What do you think? Let me know and I will look at changes all
architectures and testing them.

Thanks!

>
> --
> Regards,
> Leonard




-- 
Thomas
