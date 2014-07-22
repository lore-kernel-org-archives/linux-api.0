From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Tue, 22 Jul 2014 04:31:14 +0200
Message-ID: <1405996274.5177.25.camel@marge.simpson.net>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
	 <8761iq3bp3.fsf@tassilo.jf.intel.com> <871tte3bjw.fsf@tassilo.jf.intel.com>
	 <CFF29A00.9D44A%dvhart@linux.intel.com>
	 <CFF29E4A.9D44E%dvhart@linux.intel.com>
	 <alpine.DEB.2.10.1407212025130.20847@nanos> <20140721212740.GS3935@laptop>
	 <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
	 <alpine.DEB.2.10.1407212344130.20847@nanos>
	 <CFF2E3D6.9D525%dvhart@linux.intel.com>
	 <alpine.DEB.2.10.1407220047490.20847@nanos>
	 <20140721213457.46623e2f@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20140721213457.46623e2f@gandalf.local.home>
Sender: linux-doc-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Robert Haas <robertmhaas@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, 2014-07-21 at 21:34 -0400, Steven Rostedt wrote:

> I was telling Robert that if futexes get optimistic spinning, he should
> reconsider their use of userspace spinlocks in favor of this, because
> I'm pretty sure that they will see a great improvement.

My (dated) experience with pgsql says you're likely right.

Once upon a time, preempting a userspace spinlock owner caused pgsql to
collapse into a quivering heap.  The scheduler trying to hand the CPU
back to a preempted task instead of selecting what was strictly speaking
the most deserving task afterward (LAST_BUDDY) let pgsql+oltp scale nice
and flat instead of self destructing, but the root cause of collapse was
spinners lacking knowledge.   With spin done in kernel, you can know
when spinning is a waste of perfectly good cycles.

-Mike

