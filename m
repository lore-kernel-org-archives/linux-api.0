From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: CONFIG_ISOLATION=y
Date: Tue, 12 May 2015 17:05:36 -0400
Message-ID: <55526B20.10409@ezchip.com>
References: <20150508172210.559830a9@gandalf.local.home> <554D428E.6020702@ezchip.com> <20150508161909.308d60e21f6b83b897174276@linux-foundation.org> <20150509070538.GA9413@gmail.com> <20150511085759.71deeb64@gandalf.local.home> <20150511171916.GN6776@linux.vnet.ibm.com> <20150511102744.9ebb2d05a7e8b457d03430bf@linux-foundation.org> <20150511173305.GC32512@lerouge> <20150511140009.1f7bcf07@gandalf.local.home> <5550F077.6030906@ezchip.com> <20150512091032.GA10138@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150512091032.GA10138@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, paulmck@linux.vnet.ibm.com, Gilad Ben Yossef <giladb@ezchip.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/12/2015 05:10 AM, Ingo Molnar wrote:
> * Chris Metcalf <cmetcalf@ezchip.com> wrote:
>
>> - ISOLATION (Frederic).  I like this but it conflicts with other uses
>>    of "isolation" in the kernel: cgroup isolation, lru page isolation,
>>    iommu isolation, scheduler isolation (at least it's a superset of
>>    that one), etc.  Also, we're not exactly isolating a task - often
>>    a "dataplane" app consists of a bunch of interacting threads in
>>    userspace, so not exactly isolated.  So perhaps it's too confusing.
> So I'd vote for Frederic's CONFIG_ISOLATION=y, mostly because this is
> a high level kernel feature, so it won't conflict with isolation
> concepts in lower level subsystems such as IOMMU isolation - and other
> higher level features like scheduler isolation are basically another
> partial implementation we want to merge with all this...
>
> nohz, RCU tricks, watchdog defaults, isolcpus and various other
> measures to keep these CPUs and workloads as isolated as possible
> are (or should become) components of this high level concept.
>
> Ideally CONFIG_ISOLATION=y would be a kernel feature that has almost
> zero overhead on normal workloads and on non-isolated CPUs, so that
> Linux distributions can enable it.

Using CONFIG_CPU_ISOLATION to capture all this stuff instead of
making CONFIG_NO_HZ_FULL do it seems plausible for naming.
However, this feels like just bombing the current naming to this
new name, right?  I'd like to argue that this is orthogonal to adding
new isolation functionality into no_hz_full, as my patch series has
been doing.  Perhaps we can defer this to a follow-up patch series?
I'm happy to do the work but I'm not sure we want to bundle all
that churn into the current patch series under consideration.
I can use cpu_isolation_xxx for naming in the current patch series
so we don't have to come back and bomb that later.

> Enabling CONFIG_ISOLATION=y should be the only 'kernel config' step
> needed: just like cpusets, the configuration of isolated CPUs should
> be a completely boot option free excercise that can be dynamically
> done and undone by the administrator via an intuitive interface.

Eventually isolation can be runtime-enabled, but for now I think
it makes sense to be boot-enabled.  As Frederic suggested, we
can arrange full nohz to be runtime toggled in the future.
I agree that it should be reasonable to compile it in by default.

On 05/12/2015 07:48 AM, Peter Zijlstra wrote:
> But why do we need a CONFIG flag for something that has no content?
>
> That is, I do not see anything much; except the 'I want to stay in
> userspace and kill me otherwise' flag, and I'm not sure that warrants a
> CONFIG flag like this.
>
> Other than that, its all a combination of NOHZ_FULL and cpusets/isolcpus
> and whatnot.

There are three major pieces here - one is the STRICT piece
that you allude to, but there is also the piece where we quiesce
tasks in the kernel until no timer interrupts are pending, and the
piece that allows easy debugging of stray IRQs etc to isolated cpus.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

