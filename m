From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: CONFIG_ISOLATION=y (was: [PATCH 0/6] support "dataplane" mode
 for nohz_full)
Date: Tue, 12 May 2015 13:48:09 +0200
Message-ID: <20150512114809.GL21418@twins.programming.kicks-ass.net>
References: <554D428E.6020702@ezchip.com>
 <20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
 <20150509070538.GA9413@gmail.com>
 <20150511085759.71deeb64@gandalf.local.home>
 <20150511171916.GN6776@linux.vnet.ibm.com>
 <20150511102744.9ebb2d05a7e8b457d03430bf@linux-foundation.org>
 <20150511173305.GC32512@lerouge>
 <20150511140009.1f7bcf07@gandalf.local.home>
 <5550F077.6030906@ezchip.com>
 <20150512091032.GA10138@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150512091032.GA10138-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 11:10:32AM +0200, Ingo Molnar wrote:
> 
> So I'd vote for Frederic's CONFIG_ISOLATION=y, mostly because this is 
> a high level kernel feature, so it won't conflict with isolation 
> concepts in lower level subsystems such as IOMMU isolation - and other 
> higher level features like scheduler isolation are basically another 
> partial implementation we want to merge with all this...
> 

But why do we need a CONFIG flag for something that has no content?

That is, I do not see anything much; except the 'I want to stay in
userspace and kill me otherwise' flag, and I'm not sure that warrants a
CONFIG flag like this.

Other than that, its all a combination of NOHZ_FULL and cpusets/isolcpus
and whatnot.
