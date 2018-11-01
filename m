From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.21 03/16] mm: Replace BUG_ON() by WARN_ON() in
 vm_unmap_ram()
Date: Thu, 1 Nov 2018 15:57:53 -0400 (EDT)
Message-ID: <278477314.3995.1541102273591.JavaMail.zimbra@efficios.com>
References: <20181101095844.24462-1-mathieu.desnoyers@efficios.com> <20181101095844.24462-4-mathieu.desnoyers@efficios.com> <alpine.DEB.2.21.1811011320160.1642@nanos.tec.linutronix.de> <20181101144623.61d43102@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101144623.61d43102@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michae
List-Id: linux-api@vger.kernel.org

----- On Nov 1, 2018, at 7:46 PM, rostedt rostedt@goodmis.org wrote:

> On Thu, 1 Nov 2018 13:21:12 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>> Mathieu,
>> 
>> On Thu, 1 Nov 2018, Mathieu Desnoyers wrote:
>> 
>> > It is encouraged to warn and return rather than use BUG_ON() when
>> > the condition can be recovered from in ways that are more graceful than
>> > halting the whole system.
>> 
>> You're failing to desribe how that graceful recovery works.
>> 
> 
> I think the graceful recovery is to simply return:
> 
>	if (WARN_ON(cond))
>		return;
> 
> is better than just
> 
>	BUG_ON(cond);
> 
> As that's what Linus made pretty clear at the Maintainer's Summit.

That's it. For an unmap function, this basically boils down to
print a warning and leak the memory on internal unmap error.

I will update the commit message describing this behavior.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
