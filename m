From: Leonard Crestez <leonard.crestez-3arQi8VN3Tc@public.gmane.org>
Subject: Re: [PATCH v10 2/3] arm/syscalls: Check address limit on user-mode
 return
Date: Wed, 19 Jul 2017 17:58:20 +0300
Message-ID: <1500476300.22834.13.camel@nxp.com>
References: <20170615011203.144108-1-thgarnie@google.com>
         <20170615011203.144108-2-thgarnie@google.com>
         <1500388566.11612.74.camel@nxp.com>
         <CAJcbSZEr8HPBwH1oVaHqPzAY4MS_=yqMoqPhcauuKu3cikB3uQ@mail.gmail.com>
         <1500398311.12096.30.camel@nxp.com>
         <CAJcbSZFr9KJTfGfiZo2fThoDkAE-D1OFf2YtELq4P6jX8syesQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJcbSZFr9KJTfGfiZo2fThoDkAE-D1OFf2YtELq4P6jX8syesQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2017-07-18 at 12:04 -0700, Thomas Garnier wrote:
> On Tue, Jul 18, 2017 at 10:18 AM, Leonard Crestez <leonard.crestez-3arQi8VN3Tc@public.gmane.org> wrote:
> > On Tue, 2017-07-18 at 09:04 -0700, Thomas Garnier wrote:
> > > On Tue, Jul 18, 2017 at 7:36 AM, Leonard Crestez <leonard.crestez-3arQi8VN3Tc@public.gmane.org> wrote:
> > > > On Wed, 2017-06-14 at 18:12 -0700, Thomas Garnier wrote:
> > > > > 
> > > > > Ensure the address limit is a user-mode segment before returning to
> > > > > user-mode. Otherwise a process can corrupt kernel-mode memory and
> > > > > elevate privileges [1].
> > > > > 
> > > > > The set_fs function sets the TIF_SETFS flag to force a slow path on
> > > > > return. In the slow path, the address limit is checked to be USER_DS if
> > > > > needed.
> > > > > 
> > > > > The TIF_SETFS flag is added to _TIF_WORK_MASK shifting _TIF_SYSCALL_WORK
> > > > > for arm instruction immediate support. The global work mask is too big
> > > > > to used on a single instruction so adapt ret_fast_syscall.
> > > > > 
> > > > > @@ -571,6 +572,10 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
> > > > >        * Update the trace code with the current status.
> > > > >        */
> > > > >       trace_hardirqs_off();
> > > > > +
> > > > > +     /* Check valid user FS if needed */
> > > > > +     addr_limit_user_check();
> > > > > +
> > > > >       do {
> > > > >               if (likely(thread_flags & _TIF_NEED_RESCHED)) {
> > > > >                       schedule();
> > > > This patch made it's way into linux-next next-20170717 and it seems to
> > > > cause hangs when booting some boards over NFS (found via bisection). I
> > > > don't know exactly what determines the issue but I can reproduce hangs
> > > > if even if I just boot with init=/bin/bash and do stuff like
> > > > 
> > > > # sleep 1 & sleep 1 & sleep 1 & wait; wait; wait; echo done!
> > > > 
> > > > When this happens sysrq-t shows a sleep task hung in the 'R' state
> > > > spinning in do_work_pending, so maybe there is a potential infinite
> > > > loop here?
> > > > 
> > > > The addr_limit_user_check at the start of do_work_pending will check
> > > > for TIF_FSCHECK once and clear it but the function loops while
> > > > (thread_flags & _TIF_WORK_MASK), so it if TIF_FSCHECK is set again then
> > > > the loop will never terminate. Does this make sense?
> > > 
> > > Yes, it does. Thanks for looking into this.
> > > 
> > > Can you try this change?
> > > 
> > > diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
> > > index 3a48b54c6405..bc6ad7789568 100644
> > > --- a/arch/arm/kernel/signal.c
> > > +++ b/arch/arm/kernel/signal.c
> > > @@ -573,12 +573,11 @@ do_work_pending(struct pt_regs *regs, unsigned
> > > int thread_flags, int syscall)
> > >   */
> > >   trace_hardirqs_off();
> > > 
> > > - /* Check valid user FS if needed */
> > > - addr_limit_user_check();
> > > -
> > >   do {
> > >   if (likely(thread_flags & _TIF_NEED_RESCHED)) {
> > >   schedule();
> > > + } else if (thread_flags & _TIF_FSCHECK) {
> > > + addr_limit_user_check();
> > >   } else {
> > >   if (unlikely(!user_mode(regs)))
> > >   return 0;
> > This does seem to work, it no longer hangs on boot in my setup. This is
> > obviously only a very superficial test.
> > 
> > The new location of this check seems weird, it's not clear why it
> > should be on an else path. Perhaps it should be moved to right before
> > where current_thread_info()->flags is fetched again?

> I was hitting bug when I tried that.I think that's because you
> basically let the signal handler do pending work before you check the
> flag, that's not a good idea.

> > If the purpose is hardening against buggy kernel code doing bad set_fs
> > calls shouldn't this flag also be checked before looking at
> > TIF_NEED_RESCHED and calling schedule()?
> I am not sure to be honest. I expected schedule to only schedule the
> processor to another task which would be fine given only the current
> task have a bogus fs. I will put it first in case there is an edge
> case scenario I missed.
> 
> What do you think? Let me know and I will look at changes all
> architectures and testing them.

I don't know and I'd rather not guess on security issues. It's better
if someone else reviews the code.

Unless there is a very quick fix maybe this series should be removed or
reverted from linux-next? A diagnosis of "system calls can sometimes
hang on return" seems serious even for linux-next. Since it happens
very rarely in most setups I can easily imagine somebody spending a lot
of time digging at this.

--
Regards,
Leonard
