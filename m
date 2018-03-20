From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/36] aio: add delayed cancel support
Date: Tue, 20 Mar 2018 16:20:22 +0100
Message-ID: <20180320152022.GB23920@lst.de>
References: <20180305212743.16664-1-hch@lst.de> <20180305212743.16664-8-hch@lst.de> <20180320031957.GJ7282@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180320031957.GJ7282@magnolia>
Sender: owner-linux-aio@kvack.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 19, 2018 at 08:19:57PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 05, 2018 at 01:27:14PM -0800, Christoph Hellwig wrote:
> > The upcoming aio poll support would like to be able to complete the
> > iocb inline from the cancellation context, but that would cause
> > a lock order reversal.  Add support for optionally moving the cancelation
> > outside the context lock to avoid this reversal.
> 
> I started to wonder which lock order reversal the commit message refers
> to?
> 
> I think the reason for adding delayed cancellations is that we want to
> be able to call io_cancel -> kiocb_cancel -> aio_poll_cancel ->
> aio_complete without double locking ctx_lock?

It is.  I've updated the commit message.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
