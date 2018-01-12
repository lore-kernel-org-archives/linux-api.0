From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/32] fs: introduce new ->get_poll_head and
	->poll_mask methods
Date: Fri, 12 Jan 2018 10:06:59 +0100
Message-ID: <20180112090659.GB24190@lst.de>
References: <20180110155853.32348-1-hch@lst.de> <20180110155853.32348-4-hch@lst.de> <20180110210416.GH13338@ZenIV.linux.org.uk> <20180111113600.GA4120@lst.de> <20180111174750.GL13338@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180111174750.GL13338@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 11, 2018 at 05:47:50PM +0000, Al Viro wrote:
> Besides having two queues, note the one-time sync_serial_start_port()
> there.  Where would you map such things?  First ->poll_mask()?

->get_poll_mask.  These sorts of calls are the prime reason why
the events argument is passed to it.

> 
> > Can't find anything in sysfs,
> 
> Large chunk of sysfs is in fs/kernfs/*.c; it's there.

Still can't find it - there is exactly one poll implementation in there,
and it's not a forwarder.

> > Hmm.  ->poll_mask already is a simple 'are these events pending'
> > method, and thuse should deal perfectly fine with both cases.  What
> > additional split do you think would be helpful?
> 
> What I mean is that it would be nice to have do_select() and friends aware of that.
> You are hiding the whole thing behind vfs_poll(); sure, we can't really exploit
> that while we have the mix of converted and unconverted instances, but it would
> be a nice payoff.

Yes.  I think we can actually get rid of vfs_poll again rather soon,
the prime reason for it was to isolate non-core callers.  But most
of them should use better primitives anyway, and even until then we
can get rid of vfs_poll for the core to make things cleaner.

> As for calling ->poll_mask() first...  Three method calls per descriptor on the
> first pass?  Overhead might get painful...

I would have said no until a about a week ago.  But with branch prediction
on indirect branches basically gone on x86 now it's not going to get
better.  That beeing said we already do three method calls for the aio
poll case and it hasn't been an issue.

> FWIW, the problem with "sod off early" ones is not the cost of poll_wait() -
> it's that sometimes we might not _have_ a queue to sleep on.  Hell knows, I need
> to finish the walk through that zoo to see what's out there...  Pox on
> drivers/media - that's where the bulk of instances is, and they are fairly
> convoluted...

I've seen a few instances that return errors before poll_wait, but
most of them seemed buggy.

> wait_on_event_..._key() might be a good idea; we probably want comments from
> Peter on that one.  An interesting testcase would be tty - the amount of
> threads sleeping on those queues is going to be large; can we combine
> ->read_wait and ->write_wait without serious PITA?  Another issue is
> ldisc handling - the first thing tty_poll() is doing is
>         ld = tty_ldisc_ref_wait(tty);
> and it really waits for ldisc changes in progress to settle.  Hell knows
> whether anything relies on that, but I wouldn't be surprised if it did -
> tty handling is one of the areas where select(2)/poll(2) get non-trivial
> use...

Yes. I'll look into it.

In the meantime I think that poll_mask semantics are a big improvement
for the common case, and they enable doing aio poll.  So I'd rather
move ahead and fix any details of method signatures once we're down
to just the hard cases instead of trying to do everything at once.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
