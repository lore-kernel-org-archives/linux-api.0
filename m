From: Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH 1/7] locking/rwsem: don't resched at the end of
 optimistic spinning
Date: Mon, 04 Aug 2014 14:12:34 -0700
Message-ID: <1407186754.11985.7.camel@j-VirtualBox>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
	 <1407119782-41119-2-git-send-email-Waiman.Long@hp.com>
	 <20140804075528.GI9918@twins.programming.kicks-ass.net>
	 <53DFD2B3.3090101@hp.com> <20140804204824.GT3935@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140804204824.GT3935@laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org

On Mon, 2014-08-04 at 22:48 +0200, Peter Zijlstra wrote:
> On Mon, Aug 04, 2014 at 02:36:35PM -0400, Waiman Long wrote:
> > On 08/04/2014 03:55 AM, Peter Zijlstra wrote:
> > >On Sun, Aug 03, 2014 at 10:36:16PM -0400, Waiman Long wrote:
> > >>For a fully preemptive kernel, a call to preempt_enable() could
> > >>potentially trigger a task rescheduling event. In the case of rwsem
> > >>optimistic spinning, the task has either gotten the lock or is going
> > >>to sleep soon. So there is no point to do rescheduling here.
> > >Uh what? Why shouldn't we preempt if we've gotten the lock? What if a
> > >FIFO task just woke up?
> > 
> > I didn't mean that we shouldn't preempt if there is a higher priority task.
> > I am sure that there will be other preemption points along the way that a
> > higher priority task can take over the CPU. I just want to say that doing it
> > here may not be the best place especially if the task is going to sleep
> > soon.
> > 
> > If you think this patch does not make sense, I can remove it as other
> > patches in the set has no dependency on this one.
> 
> Yeah, its actively harmful, you delay preemption by an unspecified
> amount of time in case of the spin-acquire. We've had such bugs in -rt
> and they're not fun.
> 
> Basically the only time you should use no_resched is if the very next
> statement is schedule().

Right, we actually added an extra resched check at essentially the same
point in the mutex spinning code  :)
