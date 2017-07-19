From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [kernel-hardening] Re: [PATCH v10 2/3] arm/syscalls: Check
 address limit on user-mode return
Date: Wed, 19 Jul 2017 11:50:39 -0700
Message-ID: <CAJcbSZHMzrc8-VMQFXtacj7jYB9OqsqD92fXfQpL_DmomFK9Ow@mail.gmail.com>
References: <20170615011203.144108-1-thgarnie@google.com> <20170615011203.144108-2-thgarnie@google.com>
 <1500388566.11612.74.camel@nxp.com> <CAJcbSZEr8HPBwH1oVaHqPzAY4MS_=yqMoqPhcauuKu3cikB3uQ@mail.gmail.com>
 <1500398311.12096.30.camel@nxp.com> <CAJcbSZFr9KJTfGfiZo2fThoDkAE-D1OFf2YtELq4P6jX8syesQ@mail.gmail.com>
 <1500476300.22834.13.camel@nxp.com> <20170719170614.GS31807@n2100.armlinux.org.uk>
 <CAJcbSZHi6454skNpG8ecMnq90LdUfcxy2RYZD+7og1C1PeypvQ@mail.gmail.com> <20170719183543.GT31807@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170719183543.GT31807@n2100.armlinux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Octavian Purdila <octavian.purdila@nxp.com>, "H . Peter Anvin" <hpa@zytor.com>, Miroslav Benes <mbenes@suse.cz>, Chris Metcalf <cmetcalf@mellanox.com>, Pratyush Anand <panand@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Leonard Crestez <leonard.crestez@nxp.com>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Petr Mladek <pmladek@suse.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 19, 2017 at 11:35 AM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Wed, Jul 19, 2017 at 10:20:35AM -0700, Thomas Garnier wrote:
>> On Wed, Jul 19, 2017 at 10:06 AM, Russell King - ARM Linux
>> <linux@armlinux.org.uk> wrote:
>> > On Wed, Jul 19, 2017 at 05:58:20PM +0300, Leonard Crestez wrote:
>> > Probably best to revert.  I stopped looking at these patches during
>> > the discussion, as the discussion seemed to be mainly around other
>> > architectures, and I thought we had ARM settled.
>> >
>> > Looking at this patch now, there's several things I'm not happy with.
>> >
>> > The effect of adding a the new TIF flag for FSCHECK amongst the other
>> > flags is that we end up overflowing the 8-bit constant, and have to
>> > split the tests, meaning more instructions in the return path.  Eg:
>> >
>> > -       tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
>> > +       tst     r1, #_TIF_SYSCALL_WORK
>> > +       bne     fast_work_pending
>> > +       tst     r1, #_TIF_WORK_MASK
>> >         bne     fast_work_pending
>> >
>> > should be written:
>> >
>> >         tst     r1, #_TIF_SYSCALL_WORK
>> >         tsteq   r1, #_TIF_WORK_MASK
>> >         bne     fast_work_pending
>> >
>> > and:
>> >
>> > -       tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
>> > +       tst     r1, #_TIF_SYSCALL_WORK
>> > +       bne     fast_work_pending
>> > +       tst     r1, #_TIF_WORK_MASK
>> >
>> > should be:
>> >
>> >         tst     r1, #_TIF_SYSCALL_WORK
>> >         tsteq   r1, #_TIF_WORK_MASK
>> >
>> > There's no need for extra branches.
>> >
>> > Now, the next issue is that I don't think this TIF-flag approach is
>> > good for ARM - alignment faults can happen any time due to misaligned
>> > packets in the networking code, and we really don't want to be doing
>> > this check in a place that we can loop.
>> >
>> > My original suggestion for ARM was to do the address limit check after
>> > all work had been processed, with interrupts disabled (so no
>> > possibility of this kind of loop happening.)  However, that seems to
>> > have been replaced with this TIF approach, which is going to cause
>> > loops - I suspect if the probes code is enabled, this will suffer
>> > the same problem.  Remember, the various probes stuff can walk
>> > userspace stacks, which means they'll be using set_fs().
>> >
>> > I don't see why we've ended up with this (imho) sub-standard TIF-flag
>> > approach, and I think it's going to be very problematical.
>> >
>> > Can we please go back to the approach I suggested back in March for
>> > ARM that doesn't suffer from this problem?
>>
>> During the extensive thread discussion, Linus asked to move away from
>> architecture specific changes to this work flag system. I am glad to
>> fix the assembly as you asked on a separate patch.
>
> Well, for the record, I don't think you've got to the bottom of the
> "infinite loop" potential of Linus' approach.
>
> Eg, perf will likely trigger this same issue.  Eg, perf record -a -g
> will attempt to record the callchain both in kernel space and userspace
> each time a perf interrupt happens.  If the perf interrupt frequency is
> sufficiently high that we have multiple interrupts during the execution
> of do_work_pending() and its called functions, then that will turn this
> into an infinite loop yet again.

Do you think it applies to the patch I just sent? The other approach
is to check at the entrance, ignore _TIF_FSCHECK on the loop and clear
it on exit.

>
> --
> RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
> according to speedtest.net.



-- 
Thomas
