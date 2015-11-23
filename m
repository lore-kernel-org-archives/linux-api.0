From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [v15 0/4] ext4: add project quota support
Date: Mon, 23 Nov 2015 13:50:14 +1100
Message-ID: <20151123025014.GK19199@dastard>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <43B1BB97-8D53-4D93-9B57-B5E2048F7E7A@dilger.ca>
 <CAPTn0cBp4d09u9XzQm2cXzd6kcE0+FDRX0b_H=xJBZT-i5eKcw@mail.gmail.com>
 <7360A48E-8576-49DB-878B-DFC2EFC83BC4@ddn.com>
 <20151108212830.GL19199@dastard>
 <81500210-A31E-45CE-A3AE-9F5D0A785954@ddn.com>
 <20151119214727.GC19199@dastard>
 <951D56EE-D6DD-47BA-8AFA-A7D43E96D1E4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <951D56EE-D6DD-47BA-8AFA-A7D43E96D1E4-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: Shuichi Ihara <sihara-LfVdkaOWEx8@public.gmane.org>, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, =?utf-8?B?0JTQvNC40YLRgNC40Lkg0JzQvtC90LDRhdC+0LI=?= <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Shuichi Ihara <ihashu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 22, 2015 at 06:45:24PM -0700, Andreas Dilger wrote:
> On Nov 19, 2015, at 2:47 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> > 
> > On Wed, Nov 18, 2015 at 02:14:32PM +0000, Shuichi Ihara wrote:
> >> 
> >> 11/9/15, 6:28 AM , "Dave Chinner" <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> >> 
> >>> On Thu, Nov 05, 2015 at 03:13:10PM +0000, Shuichi Ihara wrote:
> >>>> Hello Ted, Andreas,
> >>>> 
> >>>> Shilong posted an email here a week ago below.
> >>>> http://lists.openwall.net/linux-ext4/2015/10/30/2
> >>>> 
> >>>> we identified 10 project quota related xfstest and ported them into ext4/xxx.
> >>>> test number are 304, 305, 299, 244, 196, 134, 108, 107, 106, 050 in xfs.
> >>>> 
> >>>> 
> >>>> We ported 9/10 tests into ext4/xxx
> >>>> ext4/050 ext4/106 ext4/107 ext4/108 ext4/196 ext4/244 ext4/299 ext4/400 ext4/401
> >>> 
> >>> Please make them generic tests - the ext4 project quota
> >>> functioanlity should work with those tests being completely
> >>> unchanged except for a "_requires_project_quota()" function...
> >> 
> >> Right now, we enhanced quotatool to support project quota and above project quota tests in ext4 uses that interface.
> >> xfs uses own interface xfs_xx for project quota tests in xfs.
> >> what interface are you looking at if we move ext4's project quota tests into generic tests?
> > 
> > The project quota support in the generic quota tool should work XFS
> > as well as ext4. If it doesn't, then it's not a generic tool, right?
> > The whole point of having ext4 use the same userspace API as XFS is
> > so that all quotas can be managed with the one tool. Essentially, if
> > ext4 project quotas cannot be controlled by xfs_quota, then the ext4
> > code is not compatible with XFS and hence still needs work.
> > 
> > FWIW, if ext4 has implemented the kernel project quota interfaces
> > correctly, then it should not matter whether we use xfs_quota or the
> > generic quotatool because the kernel will translate the filesystem
> > information to whatever format the quota was requested in...
> > 
> > So, you should be able to simply use the xfs_quota tool in the tests
> > you make generic without needing any significant modification to the
> > tests to run them on ext4. Yes, that may mean you need to send a 5
> > line patch to make xfs_quota run on ext4, but that's trivial
> > compared to duplicating >10 tests and then having to maintain them
> > forever...
> 
> I think it also makes sense to have tests for the generic quota tools,
> which is what current ext4 users will have installed, and not just
> xfs_quota.  This applies to both ext4 and xfs using the generic quota
> tools with the new interface.

Yes, I said as much: "... it should not matter whether we use
xfs_quota or the generic quotatool ....". I've been saying that tool
compability is an absolute requirement for the ext4 project quota
implementation from the very start - I'm not about to say it doesn't
matter now.

Yes, eventually we need to have tests for the generic quotatool,
but only having generic quotatool tests run only on ext4 does not
prove anything about the compatibility of the new ext4 kernel code
with the pre-existing quota tools and kernel APIs.

> In that light, it makes sense to add
> new tests that use the new quota tools, in addition to testing xfs_quota
> on XFS and ext4.

The first step is not "duplicate all the tests with different
infrastructure as new one-filesystem-only specific tests".  We need
to ensure the APIs are compatible *before merging the kernel code*,
and these tests do no do that.

IOWs, like all the other tests we've made generic for kernel
functionality we've moved from XFS to generic code, the steps are:

	1. move the tests from tests/xfs to tests/generic
	2. make the xfs specific utilities work on non XFS
	   filesystems and, if necessary, use the new generic kernel
	   API.
	3. make the tests also run and passwork on non-XFS filesystems

	[ at this point we can say the new ext4 kernel code is good to
	  commit ]

	4. factor the generic tests so that the test core is
	   independent of the infrastructure that needs testing
	5. Duplicate the generic tests *as generic tests* using the
	   different tools that need testing /or/ make the
	   tooling selectable by environment/config file
	   variables.

After step 5, we should have tests that run on multiple filesystems
using multiple tools, and they all give the same results. The tests
as proposed don't provide us with any guarantee that the generic
quota tool will work on XFS, nor that ext4 has an API that is
compatible with XFS.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
