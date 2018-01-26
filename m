From: Christoph Hellwig <hch@lst.de>
Subject: Re: aio poll, io_pgetevents and a new in-kernel poll API V4
Date: Fri, 26 Jan 2018 13:31:23 +0100
Message-ID: <20180126123123.GA6985@lst.de>
References: <20180122201243.31610-1-hch@lst.de> <20180125201025.GN23664@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180125201025.GN23664@kvack.org>
Sender: owner-linux-aio@kvack.org
To: Benjamin LaHaise <ben@communityfibre.ca>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 25, 2018 at 03:10:25PM -0500, Benjamin LaHaise wrote:
> I implemented something similar back in December, but did so without
> changing the in-kernel poll API.  See below for the patch that implements
> it.  Is changing the in-kernel poll API really desirable given how many
> drivers that will touch?

I had various previous versions that did not touch the driver API,
but there are a couple issues with that:

 (1) you cannot make the API race free.  With the existing convoluted
     poll_table_struct-based API you can't check for pending items
     before adding yourself to the waitqueue in a race free manner.
 (2) you cannot make the submit non-blocking without deferring to
     a workqueue or similar and thus incurring another context switch
 (3) you cannot deliver events from the wakeup callback, incurring
     another context switch, this time in the wakeup path that actually
     matters for some applications
 (3) the in-kernel poll API really is broken to start with and needs
     to be fixed anyway.  I'd rather rely on that instead of working
     around decades old cruft that has no reason to exist.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
