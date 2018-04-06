From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 3/6] aio: refactor read/write iocb setup
Date: Fri, 6 Apr 2018 13:28:48 +0100
Message-ID: <20180406122848.GA30522@ZenIV.linux.org.uk>
References: <20180328072639.16885-1-hch@lst.de>
 <20180328072639.16885-4-hch@lst.de>
 <20180406032146.GV30522@ZenIV.linux.org.uk>
 <20180406071011.GA21308@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180406071011.GA21308@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 06, 2018 at 09:10:11AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 06, 2018 at 04:21:46AM +0100, Al Viro wrote:
> > On Wed, Mar 28, 2018 at 09:26:36AM +0200, Christoph Hellwig wrote:
> > > +		struct inode *inode = file_inode(file);
> > > +
> > >  		req->ki_flags |= IOCB_WRITE;
> > >  		file_start_write(file);
> > > -		ret = aio_ret(req, call_write_iter(file, req, &iter));
> > > +		ret = aio_rw_ret(req, call_write_iter(file, req, &iter));
> > >  		/*
> > > -		 * We release freeze protection in aio_complete().  Fool lockdep
> > > -		 * by telling it the lock got released so that it doesn't
> > > -		 * complain about held lock when we return to userspace.
> > > +		 * We release freeze protection in aio_complete_rw().  Fool
> > > +		 * lockdep by telling it the lock got released so that it
> > > +		 * doesn't complain about held lock when we return to userspace.
> > >  		 */
> > > -		if (S_ISREG(file_inode(file)->i_mode))
> > > -			__sb_writers_release(file_inode(file)->i_sb, SB_FREEZE_WRITE);
> > > +		if (S_ISREG(inode->i_mode))
> > 
> > ... and that's another use-after-free, since we might've already done fput() of
> > that sucker by that point.
> 
> Indeed.  Not in any way new in this patch, this is an existing issue
> dating way back that needs to be fixed, which will be rather annoying
> without taking an extra reference to the inode or at least sb.

New, actually - mainline has get_file()/fput() around the equivalent area.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
