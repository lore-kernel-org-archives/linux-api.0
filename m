From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.15 09/14] Provide cpu_opv system call
Date: Fri, 13 Oct 2017 14:50:33 +0000 (UTC)
Message-ID: <854849583.40647.1507906233368.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-10-mathieu.desnoyers@efficios.com> <20171013145710.4430583f@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171013145710.4430583f@alans-desktop>
Sender: linux-kernel-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.>
List-Id: linux-api@vger.kernel.org

----- On Oct 13, 2017, at 9:57 AM, One Thousand Gnomes gnomes@lxorguk.ukuu.org.uk wrote:

>> A maximum limit of 16 operations per cpu_opv syscall invocation is
>> enforced, so user-space cannot generate a too long preempt-off critical
>> section.
> 
> Except that all the operations could be going to mmapped I/O space and if
> I pick the right targets could take quite a long time to complete.

We could check whether a struct page belongs to mmapped I/O space, and return
EINVAL in that case.

> It's
> still only 16 operations - But 160ms is a lot worse than 10ms. In fact
> with compare_iter I could make it much much worse still as I get 2 x
> TMP_BUFLEN x 16 x worst case latency in my attack. That's enough to screw
> up plenty of things.

Would a check that ensures the page is not mmapped I/O space be sufficient
to take care of this ? If happen to know which API I need to look for, it
would be welcome.

> 
> So it seems to me at minimum it needs to be restricted to genuine RAM user
> pages, and in fact would be far far simpler code as well if it were
> limited to a single page for a given invocation or if like futexes you
> had to specifically create a per_cpu_opv mapping.

I've had requests to implement per-cpu ring buffers with memcpy + offset
pointer update restartable sequences. Having a memcpy operation which does not
require page-alignment allows cpu_opv() to be used as a single-stepping
fallback for those use-cases.

I'm open to consider simplifying the other operations such as compare, add,
bitwise ops, and shift ops by requiring that they target aligned content,
which would therefore fit within a single page. However, given that we already
want to support the unaligned memcpy operation, it does not add much extra
complexity to support unaligned accesses for the other cases. We could also
limit the "compare" operation to 1, 2, 4, 8 aligned bytes rather than being an
up-to-PAGE_SIZE compare, but it would limit its usefulness in case of structure
content comparison.

Thanks,

Mathieu


> 
> Alan

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
