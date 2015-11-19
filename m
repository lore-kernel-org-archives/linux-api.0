From: Dave Chinner <david@fromorbit.com>
Subject: Re: [v15 0/4] ext4: add project quota support
Date: Fri, 20 Nov 2015 08:47:27 +1100
Message-ID: <20151119214727.GC19199@dastard>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <43B1BB97-8D53-4D93-9B57-B5E2048F7E7A@dilger.ca>
 <CAPTn0cBp4d09u9XzQm2cXzd6kcE0+FDRX0b_H=xJBZT-i5eKcw@mail.gmail.com>
 <7360A48E-8576-49DB-878B-DFC2EFC83BC4@ddn.com>
 <20151108212830.GL19199@dastard>
 <81500210-A31E-45CE-A3AE-9F5D0A785954@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <81500210-A31E-45CE-A3AE-9F5D0A785954@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Shuichi Ihara <sihara@ddn.com>
Cc: Li Xi <pkuelelixi@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, =?utf-8?B?0JTQvNC40YLRgNC40Lkg0JzQvtC90LDRhdC+0LI=?= <dmonakhov@openvz.org>, Shuichi Ihara <ihashu@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 18, 2015 at 02:14:32PM +0000, Shuichi Ihara wrote:
> 
> 11/9/15, 6:28 AM , "Dave Chinner" <david@fromorbit.com> wrote:
> 
> >On Thu, Nov 05, 2015 at 03:13:10PM +0000, Shuichi Ihara wrote:
> >> Hello Ted, Andreas,
> >> 
> >> Shilong posted an email here a week ago below.
> >> http://lists.openwall.net/linux-ext4/2015/10/30/2
> >> 
> >> we identified 10 project quota related xfstest and ported them into ext4/xxx.
> >> test number are 304, 305, 299, 244, 196, 134, 108, 107, 106, 050 in xfs.
> >> 
> >> 
> >> We ported 9/10 tests into ext4/xxx
> >> ext4/050 ext4/106 ext4/107 ext4/108 ext4/196 ext4/244 ext4/299 ext4/400 ext4/401
> >
> >Please make them generic tests - the ext4 project quota
> >functioanlity should work with those tests being completely
> >unchanged except for a "_requires_project_quota()" function...
> 
> Right now, we enhanced quotatool to support project quota and above project quota tests in ext4 uses that interface.
> xfs uses own interface xfs_xx for project quota tests in xfs.
> what interface are you looking at if we move ext4's project quota tests into generic tests?

The project quota support in the generic quota tool should work XFS
as well as ext4. If it doesn't, then it's not a generic tool, right?
The whole point of having ext4 use the same userspace API as XFS is
so that all quotas can be managed with the one tool. Essentially, if
ext4 project quotas cannot be controlled by xfs_quota, then the ext4
code is not compatible with XFS and hence still needs work.

FWIW, if ext4 has implemented the kernel project quota interfaces
correctly, then it should not matter whether we use xfs_quota or the
generic quotatool because the kernel will translate the filesystem
information to whatever format the quota was requested in...

So, you should be able to simply use the xfs_quota tool in the tests
you make generic without needing any significant modification to the
tests to run them on ext4. Yes, that may mean you need to send a 5
line patch to make xfs_quota run on ext4, but that's trivial
compared to duplicating >10 tests and then having to maintain them
forever...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
