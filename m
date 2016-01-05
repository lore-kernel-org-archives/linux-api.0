From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH 1/3] getcpu_cache system call: cache CPU number of
 running thread
Date: Tue, 5 Jan 2016 17:49:32 +0000 (UTC)
Message-ID: <1898145417.338189.1452016172868.JavaMail.zimbra@efficios.com>
References: <1451977320-4886-1-git-send-email-mathieu.desnoyers@efficios.com> <1451977320-4886-2-git-send-email-mathieu.desnoyers@efficios.com> <20160105120400.GD10705@arm.com> <1079064730.338115.1452015105259.JavaMail.zimbra@efficios.com> <20160105174017.GY19062@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160105174017.GY19062@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Jan 5, 2016, at 12:40 PM, Russell King - ARM Linux linux@arm.linux.org.uk wrote:

> On Tue, Jan 05, 2016 at 05:31:45PM +0000, Mathieu Desnoyers wrote:
>> For instance, an application could create a linked list or hash map
>> of thread control structures, which could contain the current CPU
>> number of each thread. A dispatch thread could then traverse or
>> lookup this structure to see on which CPU each thread is running and
>> do work queue dispatch or scheduling decisions accordingly.
> 
> So, what happens if the linked list is walked from thread X, and we
> discover that thread Y is allegedly running on CPU1.  We decide that
> we want to dispatch some work on that thread due to it being on CPU1,
> so we send an event to thread Y.
> 
> Thread Y becomes runnable, and the scheduler decides to schedule the
> thread on CPU3 instead of CPU1.
> 
> My point is that the above idea is inherently racy.  The only case
> where it isn't racy is when thread Y is bound to CPU1, and so can't
> move - but then you'd know that thread Y is on CPU1 and there
> wouldn't be a need for the inherent complexity suggested above.

I agree that this is inherently racy. The goal of such a scheme would
be to make statistically better dispatch decisions based on the
assumption that migration is not performed too often.

> 
> The behaviour I've seen on ARM from the scheduler (on a quad CPU
> platform, observing the system activity with top reporting the last
> CPU number used by each thread) is that threads often migrate
> between CPUs - especially in the case of (eg) one or two threads
> running in a quad-CPU system.

That seems rather odd. I have no doubt that this might be happening
right now, but having the scheduler do frequent migrations don't
appear to be in the best interest of access locality.

> 
> Given that, I'm really not sure what the use of reading and making
> decisions on the current CPU number would be within a program -
> unless the thread is bound to a particular CPU or group of CPUs,
> it seems that you can't rely on being on the reported CPU by the
> time the system call returns.

I completely agree that you can't rely on that information, but it
seems rather odd that migration would happen so often that it would
make this information statistically irrelevant.

Perhaps others could shed some light on this scheduler behavior ?

Thanks!

Mathieu

> 
> --
> RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
> according to speedtest.net.

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
