From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] aio: implement io_pgetevents
Date: Fri, 18 May 2018 10:57:31 +0200
Message-ID: <20180518085731.GA24387@lst.de>
References: <20180502211448.18276-1-hch@lst.de> <20180502211448.18276-8-hch@lst.de> <20180518082837.GA3264@jamesdev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180518082837.GA3264@jamesdev>
Sender: linux-kernel-owner@vger.kernel.org
To: James Hogan <jhogan@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, May 18, 2018 at 09:28:38AM +0100, James Hogan wrote:
> Given this:
> 
> On Wed, May 02, 2018 at 11:14:48PM +0200, Christoph Hellwig wrote:
> > +struct __aio_sigset {
> > +	sigset_t __user	*sigmask;
> > +	size_t		sigsetsize;
> > +};
> 
> and:
> 
> > +asmlinkage long sys_io_pgetevents(aio_context_t ctx_id,
> > +				long min_nr,
> > +				long nr,
> > +				struct io_event __user *events,
> > +				struct timespec __user *timeout,
> > +				const struct __aio_sigset *sig);
> 
> The following paragraph in the commit message would appear to be
> misleading since __aio_sigset contains a size:
> 
> > Note that unlike many other signal related calls we do not pass a sigmask
> > size, as that would get us to 7 arguments, which aren't easily supported
> > by the syscall infrastructure.  It seems a lot less painful to just add a
> > new syscall variant in the unlikely case we're going to increase the
> > sigset size.
> 
> Is it possible to correct it before this gets merged?

True, the calling convention change based on feedback.  Al, is the
branch stable or you can edit this out?
