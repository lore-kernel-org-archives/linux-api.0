From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able
 ring buffer
Date: Fri, 31 May 2019 10:35:42 +0200
Message-ID: <20190531083542.GL2623@hirez.programming.kicks-ass.net>
References: <20190528231218.GA28384@kroah.com>
 <20190528162603.GA24097@kroah.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
 <4031.1559064620@warthog.procyon.org.uk>
 <31936.1559146000@warthog.procyon.org.uk>
 <20190529231112.GB3164@kroah.com>
 <20190530095039.GA5137@andrea>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190530095039.GA5137@andrea>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Parri <andrea.parri@amarulasolutions.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: linux-api@vger.kernel.org

On Thu, May 30, 2019 at 11:50:39AM +0200, Andrea Parri wrote:
> > > Looking at the perf ring buffer, there appears to be a missing barrier in
> > > perf_aux_output_end():
> > > 
> > > 	rb->user_page->aux_head = rb->aux_head;
> > > 
> > > should be:
> > > 
> > > 	smp_store_release(&rb->user_page->aux_head, rb->aux_head);
> > > 
> > > It should also be using smp_load_acquire().  See
> > > Documentation/core-api/circular-buffers.rst
> > > 
> > > And a (partial) patch has been proposed: https://lkml.org/lkml/2018/5/10/249
> > 
> > So, if that's all that needs to be fixed, can you use the same
> > buffer/code if that patch is merged?
> 
> That's about one year old...: let me add the usual suspects in Cc:  ;-)
> since I'm not sure what the plan was (or if I'm missing something) ...

The AUX crud is 'special' and smp_store_release() doesn't really help in
many cases. Notable, AUX is typically used in combination with a
hardware writer. The driver is in charge of odering here, the generic
code doesn't know what the appropriate barrier (if any) is and would
have to resort to the most expensive/heavy one available.

Also see the comment right above this function:

 "It is the
  pmu driver's responsibility to observe ordering rules of the hardware,
  so that all the data is externally visible before this is called."
