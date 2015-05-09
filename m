From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Sat, 9 May 2015 09:05:38 +0200
Message-ID: <20150509070538.GA9413@gmail.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
 <20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
 <20150508172210.559830a9@gandalf.local.home>
 <554D428E.6020702@ezchip.com>
 <20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 8 May 2015 19:11:10 -0400 Chris Metcalf <cmetcalf@ezchip.com> wrote:
> 
> > On 5/8/2015 5:22 PM, Steven Rostedt wrote:
> > > On Fri, 8 May 2015 14:18:24 -0700
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > >> On Fri, 8 May 2015 13:58:41 -0400 Chris Metcalf <cmetcalf@ezchip.com> wrote:
> > >>
> > >>> A prctl() option (PR_SET_DATAPLANE) is added
> > >> Dumb question: what does the term "dataplane" mean in this context?  I
> > >> can't see the relationship between those words and what this patch
> > >> does.
> > > I was thinking the same thing. I haven't gotten around to searching
> > > DATAPLANE yet.
> > >
> > > I would assume we want a name that is more meaningful for what is
> > > happening.
> > 
> > The text in the commit message and the 0/6 cover letter do try to explain
> > the concept.  The terminology comes, I think, from networking line cards,
> > where the "dataplane" is the part of the application that handles all the
> > fast path processing of network packets, and the "control plane" is the part
> > that handles routing updates, etc., generally slow-path stuff.  I've probably
> > just been using the terms so long they seem normal to me.
> > 
> > That said, what would be clearer?  NO_HZ_STRICT as a superset of
> > NO_HZ_FULL?  Or move away from the NO_HZ terminology a bit; after all,
> > we're talking about no interrupts of any kind, and maybe NO_HZ is too
> > limited in scope?  So, NO_INTERRUPTS?  USERSPACE_ONLY?  Or look
> > to vendors who ship bare-metal runtimes and call it BARE_METAL?
> > Borrow the Tilera marketing name and call it ZERO_OVERHEAD?
> > 
> > Maybe BARE_METAL seems most plausible -- after DATAPLANE, to me,
> > of course :-)

'baremetal' has uses in virtualization speak, so I think that would be 
confusing.

> I like NO_INTERRUPTS.  Simple, direct.

NO_HZ_PURE?

That's what it's really about: user-space wants to run exclusively, in 
pure user-mode, without any interrupts.

So I don't like 'NO_HZ_NO_INTERRUPTS' for a couple of reasons:

 - It is similar to a term we use in perf: PERF_PMU_CAP_NO_INTERRUPT.

 - Another reason is that 'NO_INTERRUPTS', in most existing uses in 
   the kernel generally relates to some sort of hardware weakness, 
   limitation, a negative property: that we try to limp along without 
   having a hardware interrupt and have to poll. In other driver code
   that uses variants of NO_INTERRUPT it appears to be similar. So I 
   think there's some confusion potential here.

 - Here the fact that we don't disturb user-space is an absolutely
   positive property, not a limitation, a kernel feature we work hard 
   to achieve. NO_HZ_PURE would convey that while NO_HZ_NO_INTERRUPTS 
   wouldn't.

 - NO_HZ_NO_INTERRUPTS has a double negation, and it's also too long,
   compared to NO_HZ_FULL or NO_HZ_PURE ;-) The term 'no HZ' already 
   expresses that we don't have periodic interruptions. We just 
   duplicate that information with NO_HZ_NO_INTERRUPTS, while 
   NO_HZ_FULL or NO_HZ_PURE qualifies it, makes it a stronger
   property - which is what we want I think.

So I think we should either rename NO_HZ_FULL to NO_HZ_PURE, or keep 
it at NO_HZ_FULL: because the intention of NO_HZ_FULL was always to be 
such a 'zero overhead' mode of operation, where if user-space runs, it 
won't get interrupted in any way.

There's no need to add yet another Kconfig variant - lets just enhance 
the current stuff and maybe rename it to NO_HZ_PURE to better express 
its intent.

Thanks,

	Ingo
