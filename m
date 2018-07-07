From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH for 4.18 3/5] rseq: uapi: declare rseq_cs field as
 union, update includes
Date: Sat, 7 Jul 2018 16:06:45 +0100
Message-ID: <20180707150645.GD17271@n2100.armlinux.org.uk>
References: <20180705180601.18423-1-mathieu.desnoyers@efficios.com>
 <20180705180601.18423-4-mathieu.desnoyers@efficios.com>
 <1846432971.1245.1530892973439.JavaMail.zimbra@efficios.com>
 <436937568.1359.1530905019620.JavaMail.zimbra@efficios.com>
 <CA+55aFzz1CC6son0T2nD-Yqhy0_yC5nBer2XSH9kqe5x3N26Ug@mail.gmail.com>
 <1913049637.1366.1530905741745.JavaMail.zimbra@efficios.com>
 <131696830.1369.1530905931822.JavaMail.zimbra@efficios.com>
 <CA+55aFzuxGtPE2NnL9+K4=OQ=-9oAXSqX-mP_QiHpzBz7zrq6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzuxGtPE2NnL9+K4=OQ=-9oAXSqX-mP_QiHpzBz7zrq6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 06, 2018 at 12:56:58PM -0700, Linus Torvalds wrote:
> On Fri, Jul 6, 2018 at 12:38 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > Should I change all 4 bytes __get_user()/__put_user() in kernel/rseq.c
> > for get_user()/put_user() to ensure consistency ?
> 
> Probably.
> 
> *If* this actually turns out to be somethinig that shows up on
> profiles, it's almost certainly going to be the STAC/CLAC instructions
> ("perf report" tends to report them as three one-byte nop's because
> that's how they look before instruction replacement).
> 
> And then it's not __get/put_user() that will improve things, but doing a
> 
>         user_access_begin();
> 
>         .. do unsafe_get/put_user() ..
> 
>         user_access_end();
> 
> that will improve performance.
> 
> But it is *very* seldom useful. We have it in a handful of places in
> the kernel, and the most noticeable one is
> lib/{strnlen,strncpy_from}_user.c

Also, __get_user() is probably going to become the same as get_user()
when I finish the Spectre v1 ARM mitigations, because there'll be no
point in __get_user() being any different.  For those mitigations,
we're going to have to check the pointer against the address limit
inside __get_user() and NULL it out, just like get_user() does, which
makes the whole distinction between the two completely pointless.

Is this not also the case on other architectures affected by Spectre
variant 1, hmm?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 13.8Mbps down 630kbps up
According to speedtest.net: 13Mbps down 490kbps up
