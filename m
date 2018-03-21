From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 05/28] fs: introduce new ->get_poll_head and ->poll_mask
 methods
Date: Wed, 21 Mar 2018 10:08:23 +0100
Message-ID: <20180321090823.GE14085@kroah.com>
References: <20180321074032.14211-1-hch@lst.de>
 <20180321074032.14211-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321074032.14211-6-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 08:40:09AM +0100, Christoph Hellwig wrote:
> ->get_poll_head returns the waitqueue that the poll operation is going
> to sleep on.  Note that this means we can only use a single waitqueue
> for the poll, unlike some current drivers that use two waitqueues for
> different events.  But now that we have keyed wakeups and heavily use
> those for poll there aren't that many good reason left to keep the
> multiple waitqueues, and if there are any ->poll is still around, the
> driver just won't support aio poll.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
