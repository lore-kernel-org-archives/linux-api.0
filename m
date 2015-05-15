From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Fri, 15 May 2015 11:10:30 -0400
Message-ID: <55560C66.3000909@ezchip.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com> <20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org> <20150508172210.559830a9@gandalf.local.home> <554D428E.6020702@ezchip.com> <20150508161909.308d60e21f6b83b897174276@linux-foundation.org> <20150509070538.GA9413@gmail.com> <20150511085759.71deeb64@gandalf.local.home> <20150512104622.GK21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150512104622.GK21418@twins.programming.kicks-ass.net>
Sender: linux-doc-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/12/2015 06:46 AM, Peter Zijlstra wrote:
> On Mon, May 11, 2015 at 08:57:59AM -0400, Steven Rostedt wrote:
>> Please lets get NO_HZ_FULL up to par. That should be the main focus.
>>
> ACK, much of this dataplane stuff is (useful) hacks working around the
> fact that nohz_full just isn't complete.

There are enough disjoint threads on this topic that I want
to just touch base here and see if you have been convinced
on other threads that there is stuff beyond the hacks here:
in particular

1. The basic "dataplane" mode to arrange to do extra work on
return to kernel space that normally isn't warranted, to avoid
future IPIs, and additionally to wait in the kernel until any timer
interrupts required by the kernel invocation itself are done; and

2. The "strict" mode to allow a task to tell the kernel it isn't
planning on making any more such calls, and have the kernel
help diagnose any resulting application bugs.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

