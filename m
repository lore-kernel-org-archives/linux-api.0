From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Date: Fri, 26 Sep 2014 08:22:21 +1000
Message-ID: <20140925222221.GI4945@dastard>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
 <1411567470-31799-5-git-send-email-lixi@ddn.com>
 <20140924162507.GC27000@quack.suse.cz>
 <20140924162634.GA16886@infradead.org>
 <20140924170105.GE27000@quack.suse.cz>
 <20140925075912.GG4758@dastard>
 <20140925134136.GE4592@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140925134136.GE4592-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 25, 2014 at 09:41:37AM -0400, Theodore Ts'o wrote:
> On Thu, Sep 25, 2014 at 05:59:12PM +1000, Dave Chinner wrote:
> > > Also I'm afraid we may quickly run out of
> > > 32 available flags in xflags so we'd need to extend that. But all this
> > > seems to be doable.
> > 
> > The struct fsxattr was designed to be extensible - it has unused
> > padding and enough space in the flags field to allow us to
> > conditionally use that padding....
> 
> I agree that it would be useful for ext4 to support as much of the
> XFS_IOC_GETXATTR/XFS_IOC_SETATTR as would make sense for ext4, and to
> use that to set/get the project ID.  (And that we should probably do
> that as a separate set of patches that we could potentially go into
> ext4 ahead of the project quota while it is undergoing testing and
> review.)
> 
> A few questions of Dave and other XFS folks:
> 
> 1) If we only implement a partial set of the flags or other
> functionality, are there going to be tools that get confused?  i.e.,
> are there any userspace programs that will test for whether the ioctl
> is supported, and then assume that some minimal set of functionality
> must be implemented?

No, I don't think they will get confused.

The use of the flags is get/modify/set just like other flag setting
functions. The extsize and projid fields are condition on the
relevant flag being set on return from a get (i.e. projid is only
valid if XFS_XFLAG_PROJID[_INHERIT] is set), and those fields are
only considered valid on set if those flags are set by the
application (or remain set as a result of the getxattr).

Hence the applications that use the getxattr/setxattr interface
correctly shouldn't care what set of flags and values the filesystem
supports other than the specific flags the application needs the
filesystem to understand.

> 2) Unless I'm missing something, there is nothing that enforces that
> fsx_pad must be zero.  I assume that means that the only way you can
> expand use of fields into that space is via a flag bit being consumed?

Yup, that's exactly what I meant by "conditionally use the padding".
Even if the padding was guaranteed to be zero, I'd strongly
recommend a flag bit to indicate the application understands that
the padding region has actual meaning to guard against buggy
applications.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
