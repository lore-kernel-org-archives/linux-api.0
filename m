From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 32/32] aio: implement io_pgetevents
Date: Mon, 15 Jan 2018 09:53:10 +0100
Message-ID: <20180115085310.GB32532@lst.de>
References: <20180110155853.32348-1-hch@lst.de> <20180110155853.32348-33-hch@lst.de> <x49k1wmdcxn.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <x49k1wmdcxn.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 12, 2018 at 03:44:52PM -0500, Jeff Moyer wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > This is the io_getevents equivalent of ppoll/pselect and allows to
> > properly mix signals and aio completions (especially with IOCB_CMD_POLL)
> > and atomically executes the following sequence:
> >
> > 	sigset_t origmask;
> >
> > 	pthread_sigmask(SIG_SETMASK, &sigmask, &origmask);
> > 	ret = io_getevents(ctx, min_nr, nr, events, timeout);
> > 	pthread_sigmask(SIG_SETMASK, &origmask, NULL);
> >
> > Note that unlike many other signal related calls we do not pass a sigmask
> > size, as that would get us to 7 arguments, which aren't easily supported
> > by the syscall infrastructure.  It seems a lot less painful to just add a
> > new syscall variant in the unlikely case we're going to increase the
> > sigset size.
> 
> pselect, as an example, crams the sigmask and size together.  Why not
> just do that?  libaio can take care of setting that up.

Yes, I could try that.  It's just another double indirection for no
good reason.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
