From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [v5 5/5] Adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface
 support for ext4
Date: Tue, 28 Oct 2014 09:40:58 +1100
Message-ID: <20141027224058.GB16186@dastard>
References: <1414300973-1118-1-git-send-email-lixi@ddn.com>
 <1414300973-1118-6-git-send-email-lixi@ddn.com>
 <20141026215626.GC4317@dastard>
 <CAPTn0cAAbfnqYgnCEESZeY8XaK=DSGB673Srn_TVYxETG89_OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cAAbfnqYgnCEESZeY8XaK=DSGB673Srn_TVYxETG89_OQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 27, 2014 at 09:09:19AM +0800, Li Xi wrote:
> On Mon, Oct 27, 2014 at 5:56 AM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> > On Sun, Oct 26, 2014 at 01:22:53PM +0800, Li Xi wrote:
> >> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
> >> support for ext4. The interface is kept consistent with
> >> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.
> >
> > What you haven't mentioned is that you also changed the fsxattr
> > interface structure to add functionality and new behaviours that
> > isn't supported by XFS or existing applications that use the
> > interface.
> >
> > There is no need to modify the interface *at all* for ext4 to use
> > it. Fields that ext4 does not use can be zeroed on getxattr, and
> > ignored on setxattr - you do not need to add new fields to say what
> > fields are valid.
> Sorry, I don't want to change the interfaces either. But, the problem
> is that zero might be valid value for some fields. How can we
> distinguish an unsupported attribute and an attribute whose value
> is zero?

You don't. Userspace has no concept of what parts of the struct
fsxattr are valid or not, nor what are valid values the filesystem
will accept or reject.

> It is common case the only part of the fields are supported.
> So, for example, if we don't have valid flags, how can use space
> application tell kernel which attributes should be skipped when it
> tries to set only a part of atrributes?

It *doesn't*. Userspace requires the kernel to initialise the struct
fsxattr before it tries to modify anything, just like
fcntl(F_[GS]ETFL) and other similar "file flag change" syscall APIs.

IOWs, you have to initialise the struct fsxattr by calling
FS_IOC_FSGETXATTR before you call FS_IOC_FSSETXATTR. The
intialisation sets all the fields to the current (correct) values,
and hence when the set call is made all the fields then have the
same/correct values in them except for what the application changed.

E.g. this code from xfs_quota to clear the project ID on a given
file or directory:

	if ((fd = open(path, O_RDONLY|O_NOCTTY)) == -1) {
		// error handling ....
        } else if (xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx) < 0) {
		// error handling ....
        }

        fsx.fsx_projid = 0;
        fsx.fsx_xflags &= ~XFS_XFLAG_PROJINHERIT;
        if (xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx) < 0) {
		// error handling ....
        }
        close(fd);

This ensures that *only* the project ID and the specific project ID
inheritance flag is cleared, and none of the other inode flags or
state are modified....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
