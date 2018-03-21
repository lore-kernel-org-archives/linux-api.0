From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 8/9] aio: implement io_pgetevents
Date: Wed, 21 Mar 2018 15:39:12 +0100
Message-ID: <20180321143912.GA7246@kroah.com>
References: <20180321073232.13366-1-hch@lst.de>
 <20180321073232.13366-9-hch@lst.de>
 <20180321092443.GQ14085@kroah.com>
 <20180321092925.GA7265@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321092925.GA7265@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 10:29:26AM +0100, Christoph Hellwig wrote:
> On Wed, Mar 21, 2018 at 10:24:43AM +0100, Greg KH wrote:
> > On Wed, Mar 21, 2018 at 08:32:31AM +0100, Christoph Hellwig wrote:
> > > This is the io_getevents equivalent of ppoll/pselect and allows to
> > > properly mix signals and aio completions (especially with IOCB_CMD_POLL)
> > > and atomically executes the following sequence:
> > > 
> > > 	sigset_t origmask;
> > > 
> > > 	pthread_sigmask(SIG_SETMASK, &sigmask, &origmask);
> > > 	ret = io_getevents(ctx, min_nr, nr, events, timeout);
> > > 	pthread_sigmask(SIG_SETMASK, &origmask, NULL);
> > > 
> > > Note that unlike many other signal related calls we do not pass a sigmask
> > > size, as that would get us to 7 arguments, which aren't easily supported
> > > by the syscall infrastructure.  It seems a lot less painful to just add a
> > > new syscall variant in the unlikely case we're going to increase the
> > > sigset size.
> > 
> > Do we have a manpage for this new syscall and maybe a test program for
> > it so we can exercise it as part of the kselftests?
> 
> The man page and test cases where submitted to libaio:
> 
> http://git.infradead.org/users/hch/libaio.git/shortlog/refs/heads/aio-poll
> 
> In the meantime the man page apparently moved to man-pages, I'll do that
> work once we make some forward progress.

Great!

> > And do we really need a compat thunk for a new syscall?  Ugh, I guess
> > it's needed due to the long mess, right?  No way to just define it the
> > same way for both arch sizes?
> 
> Not without making it a pain to use.  It should be a drop-in enhancement
> to the existing aio abis, which all work on these types.

Ok, make sense, thanks.

greg k-h

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
