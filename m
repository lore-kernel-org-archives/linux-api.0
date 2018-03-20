From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/36] fs: introduce new ->get_poll_head and
	->poll_mask methods
Date: Tue, 20 Mar 2018 16:39:00 +0100
Message-ID: <20180320153900.GA24355@lst.de>
References: <20180305212743.16664-1-hch@lst.de> <20180305212743.16664-14-hch@lst.de> <20180320032938.GK7282@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180320032938.GK7282@magnolia>
Sender: owner-linux-aio@kvack.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 19, 2018 at 08:29:38PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 05, 2018 at 01:27:20PM -0800, Christoph Hellwig wrote:
> > ->get_poll_head returns the waitqueue that the poll operation is going
> > to sleep on.  Note that this means we can only use a single waitqueue
> > for the poll, unlike some current drivers that use two waitqueues for
> > different events.  But now that we have keyed wakeups and heavily use
> > those for poll there aren't that many good reason left to keep the
> > multiple waitqueues, and if there are any ->poll is still around, the
> > driver just won't support aio poll.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I've been wondering, how does a regular filesystem connect with this?

In general, it doesn't.  In Unix regular files aren't pollable.

> Also, does anything implement get_poll_head?  It looks to me like an aio
> poll provider has to provide both...

Yes.  Everyone who implements ->poll_mask also needs to implement
get_poll_head.  For sockets we just happen to be able to use a generic
implementation in net/socket.c for most of them.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
