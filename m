From: Ingo Molnar <mingo@kernel.org>
Subject: CONFIG_ISOLATION=y (was: [PATCH 0/6] support "dataplane" mode for
 nohz_full)
Date: Tue, 12 May 2015 11:10:32 +0200
Message-ID: <20150512091032.GA10138@gmail.com>
References: <20150508172210.559830a9@gandalf.local.home>
 <554D428E.6020702@ezchip.com>
 <20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
 <20150509070538.GA9413@gmail.com>
 <20150511085759.71deeb64@gandalf.local.home>
 <20150511171916.GN6776@linux.vnet.ibm.com>
 <20150511102744.9ebb2d05a7e8b457d03430bf@linux-foundation.org>
 <20150511173305.GC32512@lerouge>
 <20150511140009.1f7bcf07@gandalf.local.home>
 <5550F077.6030906@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5550F077.6030906@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, paulmck@linux.vnet.ibm.com, Gilad Ben Yossef <giladb@ezchip.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


* Chris Metcalf <cmetcalf@ezchip.com> wrote:

> - ISOLATION (Frederic).  I like this but it conflicts with other uses
>   of "isolation" in the kernel: cgroup isolation, lru page isolation,
>   iommu isolation, scheduler isolation (at least it's a superset of
>   that one), etc.  Also, we're not exactly isolating a task - often
>   a "dataplane" app consists of a bunch of interacting threads in
>   userspace, so not exactly isolated.  So perhaps it's too confusing.

So I'd vote for Frederic's CONFIG_ISOLATION=y, mostly because this is 
a high level kernel feature, so it won't conflict with isolation 
concepts in lower level subsystems such as IOMMU isolation - and other 
higher level features like scheduler isolation are basically another 
partial implementation we want to merge with all this...

nohz, RCU tricks, watchdog defaults, isolcpus and various other 
measures to keep these CPUs and workloads as isolated as possible
are (or should become) components of this high level concept.

Ideally CONFIG_ISOLATION=y would be a kernel feature that has almost 
zero overhead on normal workloads and on non-isolated CPUs, so that 
Linux distributions can enable it.

Enabling CONFIG_ISOLATION=y should be the only 'kernel config' step 
needed: just like cpusets, the configuration of isolated CPUs should 
be a completely boot option free excercise that can be dynamically 
done and undone by the administrator via an intuitive interface.

Thanks,

	Ingo
