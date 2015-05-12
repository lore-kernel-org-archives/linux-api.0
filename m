From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: CONFIG_ISOLATION=y (was: [PATCH 0/6] support "dataplane" mode
 for nohz_full)
Date: Tue, 12 May 2015 14:39:12 +0200
Message-ID: <20150512123912.GO21418@twins.programming.kicks-ass.net>
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
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150512123440.GA16959-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 02:34:40PM +0200, Ingo Molnar wrote:
> Yes, that's what I meant: CONFIG_ISOLATION would trigger what is 
> NO_HZ_FULL today - we could possibly even remove CONFIG_NO_HZ_FULL as 
> an individual Kconfig option?

Ah, as a rename of nohz_full, sure that might work.
