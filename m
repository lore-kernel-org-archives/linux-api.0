From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: CONFIG_ISOLATION=y (was: [PATCH 0/6] support "dataplane" mode
 for nohz_full)
Date: Tue, 12 May 2015 17:36:31 +0200
Message-ID: <20150512153630.GA27864@lerouge>
References: <20150509070538.GA9413@gmail.com>
 <20150511085759.71deeb64@gandalf.local.home>
 <20150511171916.GN6776@linux.vnet.ibm.com>
 <20150511102744.9ebb2d05a7e8b457d03430bf@linux-foundation.org>
 <20150511173305.GC32512@lerouge>
 <20150511140009.1f7bcf07@gandalf.local.home>
 <5550F077.6030906@ezchip.com>
 <20150512091032.GA10138@gmail.com>
 <20150512114809.GL21418@twins.programming.kicks-ass.net>
 <20150512123440.GA16959@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150512123440.GA16959@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Chris Metcalf <cmetcalf@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, paulmck@linux.vnet.ibm.com, Gilad Ben Yossef <giladb@ezchip.com>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 02:34:40PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, May 12, 2015 at 11:10:32AM +0200, Ingo Molnar wrote:
> > > 
> > > So I'd vote for Frederic's CONFIG_ISOLATION=y, mostly because this 
> > > is a high level kernel feature, so it won't conflict with 
> > > isolation concepts in lower level subsystems such as IOMMU 
> > > isolation - and other higher level features like scheduler 
> > > isolation are basically another partial implementation we want to 
> > > merge with all this...
> > 
> > But why do we need a CONFIG flag for something that has no content?
> > 
> > That is, I do not see anything much; except the 'I want to stay in 
> > userspace and kill me otherwise' flag, and I'm not sure that 
> > warrants a CONFIG flag like this.
> > 
> > Other than that, its all a combination of NOHZ_FULL and 
> > cpusets/isolcpus and whatnot.
> 
> Yes, that's what I meant: CONFIG_ISOLATION would trigger what is 
> NO_HZ_FULL today - we could possibly even remove CONFIG_NO_HZ_FULL as 
> an individual Kconfig option?

Right, we could return to what we had previously: CONFIG_NO_HZ. A config
that enables dynticks-idle by default and allows full dynticks if nohz_full=
boot option is passed (or something driven by higher level isolation interface).

Because eventually, distros enable NO_HZ_FULL so that their 0.0001% users
can use it. Well at least Red Hat does.

> 
> CONFIG_ISOLATION=y would express the guarantee from the kernel that 
> it's possible for user-space to configure itself to run undisturbed - 
> instead of the current inconsistent set of options and facilities.
> 
> A bit like CONFIG_PREEMPT_RT is more than just preemptable spinlocks, 
> it also tries to offer various facilities and tune the defaults to 
> turn the kernel hard-rt.
> 
> Does that make sense to you?

Right although distros tend to want features to be enabled dynamically
so that they have a single kernel to maintain. Things like PREEMPT_RT
really need to be a different kernel because fundamental primitives like
spinlocks must be implemented statically.

But isolation can be a boot-enabled, or even runtime-enabled, as it's only
about timer,irq,task affinity. Full Nohz is more complicated but it can
be runtime toggled in the future.

So we can bring CONFIG_CPU_ISOLATION, at least for distros that are really
not interested in that so they can disable it. CONFIG_CPU_ISOLATION=y would
bring an ability which is default-disabled and driven dynamically through whatever
interface.
