From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/9] aio: remove an outdated comment in aio_complete
Date: Wed, 21 Mar 2018 10:17:52 +0100
Message-ID: <20180321091752.GA6983@lst.de>
References: <20180321073232.13366-1-hch@lst.de> <20180321073232.13366-3-hch@lst.de> <20180321091420.GJ14085@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321091420.GJ14085@kroah.com>
Sender: owner-linux-aio@kvack.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 10:14:20AM +0100, Greg KH wrote:
> > diff --git a/fs/aio.c b/fs/aio.c
> > index 03d59593912d..41fc8ce6bc7f 100644
> > --- a/fs/aio.c
> > +++ b/fs/aio.c
> > @@ -1088,6 +1088,8 @@ static void aio_complete(struct kiocb *kiocb, long res, long res2)
> >  	unsigned tail, pos, head;
> >  	unsigned long	flags;
> >  
> > +	BUG_ON(is_sync_kiocb(kiocb));
> 
> Is this BUG_ON even needed anymore?  Does it ever trip in any "regular"
> use, or is it only there for when a developer does something dumb?  If
> "dumb", then we should keep it, otherwise we might be able to just drop
> it.

Probably not event needed anymore.  is_sync_kiocb checks that
ki_complete is non-NULL, and aio_complete is static in aio.c now, so
it is almost impossibly to hit.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
