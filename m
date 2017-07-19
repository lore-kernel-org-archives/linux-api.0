From: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v10 2/3] arm/syscalls: Check
 address limit on user-mode return
Date: Wed, 19 Jul 2017 19:35:43 +0100
Message-ID: <20170719183543.GT31807@n2100.armlinux.org.uk>
References: <20170615011203.144108-1-thgarnie@google.com>
 <20170615011203.144108-2-thgarnie@google.com>
 <1500388566.11612.74.camel@nxp.com>
 <CAJcbSZEr8HPBwH1oVaHqPzAY4MS_=yqMoqPhcauuKu3cikB3uQ@mail.gmail.com>
 <1500398311.12096.30.camel@nxp.com>
 <CAJcbSZFr9KJTfGfiZo2fThoDkAE-D1OFf2YtELq4P6jX8syesQ@mail.gmail.com>
 <1500476300.22834.13.camel@nxp.com>
 <20170719170614.GS31807@n2100.armlinux.org.uk>
 <CAJcbSZHi6454skNpG8ecMnq90LdUfcxy2RYZD+7og1C1PeypvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJcbSZHi6454skNpG8ecMnq90LdUfcxy2RYZD+7og1C1PeypvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Octavian Purdila <octavian.purdila-3arQi8VN3Tc@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Leonard Crestez <leonard.crestez-3arQi8VN3Tc@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 19, 2017 at 10:20:35AM -0700, Thomas Garnier wrote:
> On Wed, Jul 19, 2017 at 10:06 AM, Russell King - ARM Linux
> <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org> wrote:
> > On Wed, Jul 19, 2017 at 05:58:20PM +0300, Leonard Crestez wrote:
> > Probably best to revert.  I stopped looking at these patches during
> > the discussion, as the discussion seemed to be mainly around other
> > architectures, and I thought we had ARM settled.
> >
> > Looking at this patch now, there's several things I'm not happy with.
> >
> > The effect of adding a the new TIF flag for FSCHECK amongst the other
> > flags is that we end up overflowing the 8-bit constant, and have to
> > split the tests, meaning more instructions in the return path.  Eg:
> >
> > -       tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
> > +       tst     r1, #_TIF_SYSCALL_WORK
> > +       bne     fast_work_pending
> > +       tst     r1, #_TIF_WORK_MASK
> >         bne     fast_work_pending
> >
> > should be written:
> >
> >         tst     r1, #_TIF_SYSCALL_WORK
> >         tsteq   r1, #_TIF_WORK_MASK
> >         bne     fast_work_pending
> >
> > and:
> >
> > -       tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
> > +       tst     r1, #_TIF_SYSCALL_WORK
> > +       bne     fast_work_pending
> > +       tst     r1, #_TIF_WORK_MASK
> >
> > should be:
> >
> >         tst     r1, #_TIF_SYSCALL_WORK
> >         tsteq   r1, #_TIF_WORK_MASK
> >
> > There's no need for extra branches.
> >
> > Now, the next issue is that I don't think this TIF-flag approach is
> > good for ARM - alignment faults can happen any time due to misaligned
> > packets in the networking code, and we really don't want to be doing
> > this check in a place that we can loop.
> >
> > My original suggestion for ARM was to do the address limit check after
> > all work had been processed, with interrupts disabled (so no
> > possibility of this kind of loop happening.)  However, that seems to
> > have been replaced with this TIF approach, which is going to cause
> > loops - I suspect if the probes code is enabled, this will suffer
> > the same problem.  Remember, the various probes stuff can walk
> > userspace stacks, which means they'll be using set_fs().
> >
> > I don't see why we've ended up with this (imho) sub-standard TIF-flag
> > approach, and I think it's going to be very problematical.
> >
> > Can we please go back to the approach I suggested back in March for
> > ARM that doesn't suffer from this problem?
> 
> During the extensive thread discussion, Linus asked to move away from
> architecture specific changes to this work flag system. I am glad to
> fix the assembly as you asked on a separate patch.

Well, for the record, I don't think you've got to the bottom of the
"infinite loop" potential of Linus' approach.

Eg, perf will likely trigger this same issue.  Eg, perf record -a -g
will attempt to record the callchain both in kernel space and userspace
each time a perf interrupt happens.  If the perf interrupt frequency is
sufficiently high that we have multiple interrupts during the execution
of do_work_pending() and its called functions, then that will turn this
into an infinite loop yet again.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
