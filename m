From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Fri, 8 May 2015 16:19:09 -0700
Message-ID: <20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
	<20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
	<20150508172210.559830a9@gandalf.local.home>
	<554D428E.6020702@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <554D428E.6020702@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 8 May 2015 19:11:10 -0400 Chris Metcalf <cmetcalf@ezchip.com> wrote:

> On 5/8/2015 5:22 PM, Steven Rostedt wrote:
> > On Fri, 8 May 2015 14:18:24 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >> On Fri, 8 May 2015 13:58:41 -0400 Chris Metcalf <cmetcalf@ezchip.com> wrote:
> >>
> >>> A prctl() option (PR_SET_DATAPLANE) is added
> >> Dumb question: what does the term "dataplane" mean in this context?  I
> >> can't see the relationship between those words and what this patch
> >> does.
> > I was thinking the same thing. I haven't gotten around to searching
> > DATAPLANE yet.
> >
> > I would assume we want a name that is more meaningful for what is
> > happening.
> 
> The text in the commit message and the 0/6 cover letter do try to explain
> the concept.  The terminology comes, I think, from networking line cards,
> where the "dataplane" is the part of the application that handles all the
> fast path processing of network packets, and the "control plane" is the part
> that handles routing updates, etc., generally slow-path stuff.  I've probably
> just been using the terms so long they seem normal to me.
> 
> That said, what would be clearer?  NO_HZ_STRICT as a superset of
> NO_HZ_FULL?  Or move away from the NO_HZ terminology a bit; after all,
> we're talking about no interrupts of any kind, and maybe NO_HZ is too
> limited in scope?  So, NO_INTERRUPTS?  USERSPACE_ONLY?  Or look
> to vendors who ship bare-metal runtimes and call it BARE_METAL?
> Borrow the Tilera marketing name and call it ZERO_OVERHEAD?
> 
> Maybe BARE_METAL seems most plausible -- after DATAPLANE, to me,
> of course :-)

I like NO_INTERRUPTS.  Simple, direct.
