From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 30/32] aio: add delayed cancel support
Date: Thu, 11 Jan 2018 14:43:58 +0100
Message-ID: <20180111134358.GA5926@lst.de>
References: <20180110155853.32348-1-hch@lst.de> <20180110155853.32348-31-hch@lst.de> <x49y3l52uda.fsf@segfault.boston.devel.redhat.com> <x49r2qx2t3k.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <x49r2qx2t3k.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 10, 2018 at 06:26:39PM -0500, Jeff Moyer wrote:
> >> The upcoming aio poll support would like to be able to complete the
> >> iocb inline from the cancellation context, but that would cause
> >> a lock order reversal.  Add support for optionally moving the cancelation
> >> outside the context lock to avoid this reversal.
> >>
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >
> > Acked-by: Jeff Moyer <jmoyer@redhat.com>
> 
> Actually, let's move these two defines:
> 
> #define AIO_IOCB_DELAYED_CANCEL (1 << 0)
> #define AIO_IOCB_CANCELLED      (1 << 1)
> 
> to include/linux/aio.h so that drivers outside of fs/aio.c can make use
> of them.

struct aio_kiocb is private to aio.c, so just exposing them won't
do anything useful.  If we really need these elsewhere we'll need
to come up with a proper interface.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
