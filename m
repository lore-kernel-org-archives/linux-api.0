From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/7] vfs: vfs: Define new syscalls preadv2,pwritev2
Date: Sat, 27 Feb 2016 09:58:21 +0100
Message-ID: <20160227085821.GD4255@lst.de>
References: <1456160876-14560-1-git-send-email-hch@lst.de> <1456160876-14560-3-git-send-email-hch@lst.de> <x4937sfm97n.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x4937sfm97n.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, axboe@fb.com, milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Feb 26, 2016 at 04:51:24PM -0500, Jeff Moyer wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > From: Milosz Tanski <milosz@adfin.com>
> >
> > New syscalls that take an flag argument. This change does not add any
> > specific flags.
> 
> So, it looks like file systems that don't implement read_iter/write_iter
> won't get the flags argument passed along.  I don't think that's a big
> deal, as such file systems seem to be in-memory file systems, but I
> think it warrants mention in the changelog.

Ok.

> Also, I think you added a stray newline below:
> 
> > +static long do_compat_pwritev64(unsigned long fd,
> >  				   const struct compat_iovec __user *vec,
> > -				   unsigned long vlen, loff_t pos)
> > +				   unsigned long vlen, loff_t pos, int flags)
> >  {
> >  	struct fd f;
> >  	ssize_t ret;
> >  
> >  	if (pos < 0)
> >  		return -EINVAL;
> > +
> >  	f = fdget(fd);
> >  	if (!f.file)
> >  		return -EBADF;
> >  	ret = -ESPIPE;
> >  	if (f.file->f_mode & FMODE_PWRITE)
> > -		ret = compat_writev(f.file, vec, vlen, &pos);
> > +		ret = compat_writev(f.file, vec, vlen, &pos, flags);
> >  	fdput(f);
> >  	return ret;
> >  }

Yeah, no real need to add it, although the new version is defintively
more readable.
