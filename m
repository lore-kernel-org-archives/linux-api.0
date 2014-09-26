From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Date: Fri, 26 Sep 2014 08:01:28 -0400
Message-ID: <20140926120128.GA21376@thunk.org>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
 <1411567470-31799-5-git-send-email-lixi@ddn.com>
 <20140924162507.GC27000@quack.suse.cz>
 <20140924162634.GA16886@infradead.org>
 <20140924170105.GE27000@quack.suse.cz>
 <20140925075912.GG4758@dastard>
 <20140925135213.GB15352@quack.suse.cz>
 <20140925224225.GJ4945@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140925224225.GJ4945@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, adilger@dilger.ca, linux-api@vger.kernel.org, xfs@oss.sgi.com, dmonakhov@openvz.org, viro@zeniv.linux.org.uk, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Sep 26, 2014 at 08:42:25AM +1000, Dave Chinner wrote:
> Look, I have no problems with extending the existing quota
> interfaces to support project quotas, but that should be a
> *secondary* improvement as userspace tools are updated. The
> primary goal needs to be "works identically to XFS" and so it needs
> to implement the interfaces that are currently used for management
> so that we can actually test that it does work identically.

I think we're getting a bit too hung up on which is the "primary" and
which is the "secondary" interfaces.  The reality is that we should
make both interfaces work.  An example of this is how we handle the
xfs-specific ioctls that are also exposed via the fallocate(2) system
call.

It's not particularly important to me which is the "primary" interface
just because it's been around for 10 years.  Which should implement
*both* so that users are used to using xfs_io(8) or fallocate(1) can
do what they want.

Similarly, if some users are more used to the quotatools interface
(which has been around for quite a long time, BTW, if we're trying to
count primacy by years of availability to Linux users), and some users
that are used to using xfs_quota, both should work.

Cheers,

						- Ted
