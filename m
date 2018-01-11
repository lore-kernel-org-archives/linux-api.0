From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 03/32] fs: introduce new ->get_poll_head and ->poll_mask
 methods
Date: Thu, 11 Jan 2018 17:47:50 +0000
Message-ID: <20180111174750.GL13338@ZenIV.linux.org.uk>
References: <20180110155853.32348-1-hch@lst.de>
 <20180110155853.32348-4-hch@lst.de>
 <20180110210416.GH13338@ZenIV.linux.org.uk>
 <20180111113600.GA4120@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180111113600.GA4120@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 11, 2018 at 12:36:00PM +0100, Christoph Hellwig wrote:
> On Wed, Jan 10, 2018 at 09:04:16PM +0000, Al Viro wrote:
> > There's another problem with that - currently ->poll() may tell you "sod off,
> > I've got nothing for you to sleep on, eat your POLLHUP|POLLERR|something
> > and don't pester me again".  With your API that's hard to express sanely.
> 
> And what exactly can currently tell 'sod off' right now?  ->poll
> can only return the (E)POLL* mask.  But what would probably be sane
> is to do the same thing in vfs_poll I already do in aio poll:  call
> ->poll_mask a first time before calling poll_wait to clear any
> already pending events.  That way any early error gets instantly
> propagated.

static __poll_t
capi_poll(struct file *file, poll_table *wait)
{
        struct capidev *cdev = file->private_data;
        __poll_t mask = 0;

        if (!cdev->ap.applid)
                return POLLERR;

        poll_wait(file, &(cdev->recvwait), wait);
        mask = POLLOUT | POLLWRNORM;
        if (!skb_queue_empty(&cdev->recvqueue))
                mask |= POLLIN | POLLRDNORM;
        return mask;
}

and a bunch of similar beasts.  FWIW, I'm going through that zoo, looking for
existing patterns.

BTW, consider this:
static __poll_t sync_serial_poll(struct file *file, poll_table *wait)
{
        int dev = iminor(file_inode(file));
        __poll_t mask = 0;
        struct sync_port *port;
        DEBUGPOLL(
        static __poll_t prev_mask;
        );

        port = &ports[dev];

        if (!port->started)
                sync_serial_start_port(port);

        poll_wait(file, &port->out_wait_q, wait);
        poll_wait(file, &port->in_wait_q, wait);

        /* No active transfer, descriptors are available */
        if (port->output && !port->tr_running)
                mask |= POLLOUT | POLLWRNORM;
	...
}

Besides having two queues, note the one-time sync_serial_start_port()
there.  Where would you map such things?  First ->poll_mask()?

> Can't find anything in sysfs,

Large chunk of sysfs is in fs/kernfs/*.c; it's there.

> > Note, BTW, the places like wait->_qproc = NULL; in do_select() and its ilk.
> > Some of them are "don't bother putting me on any queues, I won't be sleeping
> > anyway".  Some are "I'm already on all queues I care about, I'm going to
> > sleep now and the query everything again once woken up".  It would be nice
> > to have the method splitup reflect that kind of logics...
> 
> Hmm.  ->poll_mask already is a simple 'are these events pending'
> method, and thuse should deal perfectly fine with both cases.  What
> additional split do you think would be helpful?

What I mean is that it would be nice to have do_select() and friends aware of that.
You are hiding the whole thing behind vfs_poll(); sure, we can't really exploit
that while we have the mix of converted and unconverted instances, but it would
be a nice payoff.

As for calling ->poll_mask() first...  Three method calls per descriptor on the
first pass?  Overhead might get painful...

FWIW, the problem with "sod off early" ones is not the cost of poll_wait() -
it's that sometimes we might not _have_ a queue to sleep on.  Hell knows, I need
to finish the walk through that zoo to see what's out there...  Pox on
drivers/media - that's where the bulk of instances is, and they are fairly
convoluted...

wait_on_event_..._key() might be a good idea; we probably want comments from
Peter on that one.  An interesting testcase would be tty - the amount of
threads sleeping on those queues is going to be large; can we combine
->read_wait and ->write_wait without serious PITA?  Another issue is
ldisc handling - the first thing tty_poll() is doing is
        ld = tty_ldisc_ref_wait(tty);
and it really waits for ldisc changes in progress to settle.  Hell knows
whether anything relies on that, but I wouldn't be surprised if it did -
tty handling is one of the areas where select(2)/poll(2) get non-trivial
use...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
