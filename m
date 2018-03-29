From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/30] aio: add delayed cancel support
Date: Thu, 29 Mar 2018 10:53:05 +0200
Message-ID: <20180329085305.GA22215@lst.de>
References: <20180328072926.17131-1-hch@lst.de> <20180328072926.17131-8-hch@lst.de> <20180328163526.GV30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180328163526.GV30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 28, 2018 at 05:35:26PM +0100, Al Viro wrote:
> >  	ret = vfs_fsync(req->file, req->datasync);
> > -	fput(req->file);
> > -	aio_complete(container_of(req, struct aio_kiocb, fsync), ret, 0);
> > +	if (aio_complete(iocb, ret, 0, 0))
> > +		fput(file);
> 
> IDGI.
> 	1) can aio_complete() ever return false here?

It won't.  But sometimes checking the return value and sometimes not
seems like a bad pattern.

> 	2) do we ever have aio_kiocb that would not have an associated
> struct file * that needs to be dropped on successful aio_complete()?  AFAICS,
> rw, fsync and poll variants all have one, and I'm not sure what kind of
> async IO *could* be done without an opened file.

All have a file assoiated at least right now.  As mentioned last time
finding a struct to pass that file would be rather annoying, so we'd either
have to pass it explicitly, or do something nasty like duplicating the
pointer in the aio_kiocb in addition to struct kiocb.  Which might not
be that bad after all, as it would only bloat the aio_kiocb and not
struct kiocb used on stack all over.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
