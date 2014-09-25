From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Date: Thu, 25 Sep 2014 15:52:13 +0200
Message-ID: <20140925135213.GB15352@quack.suse.cz>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
 <1411567470-31799-5-git-send-email-lixi@ddn.com>
 <20140924162507.GC27000@quack.suse.cz>
 <20140924162634.GA16886@infradead.org>
 <20140924170105.GE27000@quack.suse.cz>
 <20140925075912.GG4758@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140925075912.GG4758@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 25-09-14 17:59:12, Dave Chinner wrote:
> On Wed, Sep 24, 2014 at 07:01:05PM +0200, Jan Kara wrote:
> > On Wed 24-09-14 09:26:34, Christoph Hellwig wrote:
> > > On Wed, Sep 24, 2014 at 06:25:07PM +0200, Jan Kara wrote:
> > > > On Wed 24-09-14 22:04:30, Li Xi wrote:
> > > > > This patch adds ioctl interface for setting/getting project of ext4.
> > > >   The patch looks good to me. I was just wondering whether it won't be
> > > > useful to add an ioctl() which isn't ext4 specific. We could just extend
> > > > ->setattr() to allow setting of project ID (most filesystems would just
> > > > return -EOPNOTSUPP but ext4 and xfs could do the right thing) and then call
> > > > ->setattr from the generic ioctl. That way userspace won't have to care
> > > > about filesystem type when setting project ID... What do others think?
> > > 
> > > Absolutely.  In general I also wonder why this patch doesn't implement
> > > the full XFS API.  Maybe there is a reason it was considered and
> > > rejected, but it would be helpful to document why.
> >   Do you mean full get/setfsxattr API?
> 
> That's a good start.
> 
> The bigger issue in my mind is that we already have a fully featured
> quota API that supports project quotas and userspace tools available
> that manipulate it. xfstests already uses those tools and API
> for testing project quotas.
  Well, the VFS quota API is trivially extended by adding additional quota
type so I don't really see about which reinventing of quota API are you
speaking here...

> This whole patchset reinvents all the quota APIs, and will require
> adding support in userspace, and hence require re-inventing all the
> test infrastructure we already have because it won't be compatible
> with the existing project quota test code.
  Well, quota-tools will have to extended to know about the new quota type.
Yes. But that's easy to do. I think teaching xfs quota tools to work with
ext4 will be a bigger project plus I don't think I want to force sysadmins
which are used to work with quota-tools to switch to other utilities just
because of project quotas.

Regarding xfstests - I've checked and most of the project quota tests in
xfs directory aren't directly usable for ext4 anyway because of other
functionality ext4 doesn't support. So we'll need to distill the least
common denominator from them anyway...

> >   That basically contains project ID,
> > flags (those that are currently get/set with FS_IOC_GETFLAGS/SETFLAGS), and
> > extent size hint right?
> 
> It's a different set of flag definitions. We translate the interface
> XFS_XFLAG_* values to/from the inode on-disk XFS_DIFLAG_* inode values, just
> like we translate the VFS FS_*_FL flags that get passed through the
> FS_IOC_GETFLAGS/SETFLAGS ioctl.
> 
> > That seems workable and it would also make setting
> > of PROJINHERIT flag fs agnostic. Only we would have to create some generic
> > flags namespace and merge into that ext4 flags and have a translation
> > function for the old ext4 flags.
> 
> The XFS_XFLAGS_* are already filesystem agnostic - they are flags
> that are only used for interfacing with userspace and hence only
> exist at the ioctl copy in/out layer.....
> 
> > Also I'm afraid we may quickly run out of
> > 32 available flags in xflags so we'd need to extend that. But all this
> > seems to be doable.
> 
> The struct fsxattr was designed to be extensible - it has unused
> padding and enough space in the flags field to allow us to
> conditionally use that padding....
  Yeah, this should all be easy.

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
