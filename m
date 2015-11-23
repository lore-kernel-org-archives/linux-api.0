From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [v15 0/4] ext4: add project quota support
Date: Tue, 24 Nov 2015 07:15:23 +1100
Message-ID: <20151123201522.GN19199@dastard>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <43B1BB97-8D53-4D93-9B57-B5E2048F7E7A@dilger.ca>
 <CAPTn0cBp4d09u9XzQm2cXzd6kcE0+FDRX0b_H=xJBZT-i5eKcw@mail.gmail.com>
 <7360A48E-8576-49DB-878B-DFC2EFC83BC4@ddn.com>
 <20151108212830.GL19199@dastard>
 <81500210-A31E-45CE-A3AE-9F5D0A785954@ddn.com>
 <20151119214727.GC19199@dastard>
 <20151123092523.GB23418@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151123092523.GB23418-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Shuichi Ihara <sihara-LfVdkaOWEx8@public.gmane.org>, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, =?utf-8?B?0JTQvNC40YLRgNC40Lkg0JzQvtC90LDRhdC+0LI=?= <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Shuichi Ihara <ihashu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 23, 2015 at 10:25:23AM +0100, Jan Kara wrote:
> On Fri 20-11-15 08:47:27, Dave Chinner wrote:
> > On Wed, Nov 18, 2015 at 02:14:32PM +0000, Shuichi Ihara wrote:
> > > 
> > > 11/9/15, 6:28 AM , "Dave Chinner" <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> > > 
> > > >On Thu, Nov 05, 2015 at 03:13:10PM +0000, Shuichi Ihara wrote:
> > > >> Hello Ted, Andreas,
> > > >> 
> > > >> Shilong posted an email here a week ago below.
> > > >> http://lists.openwall.net/linux-ext4/2015/10/30/2
> > > >> 
> > > >> we identified 10 project quota related xfstest and ported them into ext4/xxx.
> > > >> test number are 304, 305, 299, 244, 196, 134, 108, 107, 106, 050 in xfs.
> > > >> 
> > > >> 
> > > >> We ported 9/10 tests into ext4/xxx
> > > >> ext4/050 ext4/106 ext4/107 ext4/108 ext4/196 ext4/244 ext4/299 ext4/400 ext4/401
> > > >
> > > >Please make them generic tests - the ext4 project quota
> > > >functioanlity should work with those tests being completely
> > > >unchanged except for a "_requires_project_quota()" function...
> > > 
> > > Right now, we enhanced quotatool to support project quota and above project quota tests in ext4 uses that interface.
> > > xfs uses own interface xfs_xx for project quota tests in xfs.
> > > what interface are you looking at if we move ext4's project quota tests into generic tests?
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
> Yeah, last time I tried the only modification xfs_quota tool needed to work
> correctly with ext4 was to remove / modify the check for filesystem type
> in fs_table_initialise_mounts(). The question is how to properly deal with
> that. I don't think just removing the fs type check is the right way to go
> as that will have unexpected side effects for operations working on
> "all" filesystems - currently these are restricted to "all" *XFS*
> filesystems.
> 
> Maybe we can add a command line option which will disable the fs type check
> so that non-XFS filesystems can be handled. We used to have an option like
> this for xfs_io but it seems it got removed so I'm not sure we want to add
> that into xfs_quota though. Dave?

The option is still there in xfs_io, we just ignore it because
we do the detection automatically now via:

                if (!platform_test_xfs_fd(c))
                        flags |= IO_FOREIGN;

The rest of the libxcmd infrastructure handles enabling/disabling
the commands for foreign filesystems  via the
io/init.c::init_check_command() function, which does:

        if (file && !(ct->flags & CMD_FOREIGN_OK) &&
                                        (file->flags & IO_FOREIGN)) {
                fprintf(stderr,
        _("foreign file active, %s command is for XFS filesystems only\n"),
                        ct->name);
                return 0;
        }


It is trivial to add this to xfs_quota (ok, it's 20 lines of code)
and so allow the relevant commands the tests need to operate on
foreign filesystems.

> Another option would be to use generic quota-tools for project quota tests
> once the patches land. But that would require some more work on xfstests
> side and so far I didn't get an official submission of patches for
> quota-tools to support project quota.

Eventually, yes. But we don't have to wait for that to happen if we
use the xfs-quota tool to begin with.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
