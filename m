From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/6] vfs: cap dedupe request structure size at PAGE_SIZE
Date: Mon, 12 Sep 2016 18:16:20 -0700
Message-ID: <20160913011620.GC23422@birch.djwong.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
 <147216785429.525.1965983896010934181.stgit@birch.djwong.org>
 <20160905145549.GA7662@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160905145549.GA7662-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 05, 2016 at 07:55:49AM -0700, Christoph Hellwig wrote:
> This really should go into 4.8 (and the previous patch probably as
> well), and I've said that a couple of times, and you tried a few times
> to send it to Al at least.
> 
> Al, do you want to pick it up or should Darrick send it straight to
> Linus?

Ping?  Anyone?

--D

> On Thu, Aug 25, 2016 at 04:30:54PM -0700, Darrick J. Wong wrote:
> > Kirill A. Shutemov reports that the kernel doesn't try to cap dest_count
> > in any way, and uses the number to allocate kernel memory.  This causes
> > high order allocation warnings in the kernel log if someone passes in a
> > big enough value.  We should clamp the allocation at PAGE_SIZE to avoid
> > stressing the VM.
> > 
> > The two existing users of the dedupe ioctl never send more than 120
> > requests, so we can safely clamp dest_range at PAGE_SIZE, because with
> > 4k pages we can handle up to 127 dedupe candidates.  Given the max
> > extent length of 16MB, we can end up doing 2GB of IO which is plenty.
> > 
> > Reported-by: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> > Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/ioctl.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > 
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 26aba09..c415668 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -582,6 +582,10 @@ static int ioctl_file_dedupe_range(struct file *file, void __user *arg)
> >  	}
> >  
> >  	size = offsetof(struct file_dedupe_range __user, info[count]);
> > +	if (size > PAGE_SIZE) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> >  
> >  	same = memdup_user(argp, size);
> >  	if (IS_ERR(same)) {
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
> > http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---
