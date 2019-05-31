From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able
 ring buffer
Date: Fri, 31 May 2019 10:47:14 +0200
Message-ID: <20190531084714.GL2677@hirez.programming.kicks-ass.net>
References: <20190528231218.GA28384@kroah.com>
 <20190528162603.GA24097@kroah.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
 <4031.1559064620@warthog.procyon.org.uk>
 <31936.1559146000@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <31936.1559146000@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 29, 2019 at 05:06:40PM +0100, David Howells wrote:

> Looking at the perf ring buffer, there appears to be a missing barrier in
> perf_aux_output_end():
> 
> 	rb->user_page->aux_head = rb->aux_head;
> 
> should be:
> 
> 	smp_store_release(&rb->user_page->aux_head, rb->aux_head);

I've answered that in another email; the aux bit is 'magic'.

> It should also be using smp_load_acquire().  See
> Documentation/core-api/circular-buffers.rst

We use the control dependency instead, as described in the comment of
perf_output_put_handle():

	 *   kernel				user
	 *
	 *   if (LOAD ->data_tail) {		LOAD ->data_head
	 *			(A)		smp_rmb()	(C)
	 *	STORE $data			LOAD $data
	 *	smp_wmb()	(B)		smp_mb()	(D)
	 *	STORE ->data_head		STORE ->data_tail
	 *   }
	 *
	 * Where A pairs with D, and B pairs with C.
	 *
	 * In our case (A) is a control dependency that separates the load of
	 * the ->data_tail and the stores of $data. In case ->data_tail
	 * indicates there is no room in the buffer to store $data we do not.
	 *
	 * D needs to be a full barrier since it separates the data READ
	 * from the tail WRITE.
	 *
	 * For B a WMB is sufficient since it separates two WRITEs, and for C
	 * an RMB is sufficient since it separates two READs.

Userspace can choose to use smp_load_acquire() over the first smp_rmb()
if that is efficient for the architecture (for w ahole bunch of archs
load-acquire would end up using mb() while rmb() is adequate and
cheaper).
