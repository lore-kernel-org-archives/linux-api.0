From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/10] fs: Introduce RWF_NOWAIT and FMODE_AIO_NOWAIT
Date: Sat, 17 Jun 2017 04:53:53 -0700
Message-ID: <20170617115353.GA8320@infradead.org>
References: <20170615160002.17233-1-rgoldwyn@suse.de>
 <20170615160002.17233-5-rgoldwyn@suse.de>
 <20170617040944.GT31671@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170617040944.GT31671@ZenIV.linux.org.uk>
Sender: linux-block-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, akpm@linux-foundation.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 17, 2017 at 05:09:44AM +0100, Al Viro wrote:
> On Thu, Jun 15, 2017 at 10:59:56AM -0500, Goldwyn Rodrigues wrote:
> >  static inline int kiocb_set_rw_flags(struct kiocb *ki, int flags)
> >  {
> > -	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC)))
> > +	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT)))
> 
> Minor nit: that calls for something like
> 	if (unlikely(flags & ~RWF_ALL)
> >  		return -EOPNOTSUPP;
> 
> with corresponding definition.

Possibly.  Note _ALL is not correct - at least RWF_HIPRI is explicitly
defined a shint that can be ignored.

Maybe RWF_SUPPORTED.
