From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [v14 3/4] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Tue, 28 Apr 2015 14:43:31 +1000
Message-ID: <20150428044331.GV21261@dastard>
References: <1429728997-21464-1-git-send-email-lixi@ddn.com>
 <1429728997-21464-4-git-send-email-lixi@ddn.com>
 <20150426232033.GQ15810@dastard>
 <CAPTn0cAHOHP060cW8k0-HnyfKdVaUwAVOyLZU43AXtECK6_EaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cAHOHP060cW8k0-HnyfKdVaUwAVOyLZU43AXtECK6_EaA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 28, 2015 at 10:01:07AM +0800, Li Xi wrote:
> Hi Dave,
> 
> I ran xfstests on the kernel with this series of patches.
> Unfortunately, 5 test suits failed. But I don't think they are caused
> by this patch. Following is the result. Please let me know if there is
> any problem about it.
> 
> Output of xfstests:
> 
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 vm15 4.0.0+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb2
> MOUNT_OPTIONS -- /dev/sdb2 /mnt/scratch
> 
> generic/001 3s ... 2s
> generic/002 0s ... 0s
> generic/003 10s ... 10s
> generic/004     [not run] xfs_io flink support is missing
> generic/005 0s ... 0s
> generic/006 1s ... 0s
> generic/007 0s ... 0s
> generic/008     [not run] xfs_io fzero support is missing
> generic/009     [not run] xfs_io fzero support is missing
> generic/010 1s ... 0s
> generic/011 1s ... 0s
> generic/012     [not run] xfs_io fpunch support is missing
> generic/013 92s ... 90s
> generic/014 3s ... 3s
> generic/015 1s ... 1s
> generic/016     [not run] xfs_io fpunch support is missing
> generic/017     [not run] xfs_io fiemap support is missing
> generic/018     [not run] xfs_io fiemap support is missing

You really need to update your xfsprogs install. You aren't testing
half of what you need to be testing if you are missing basic
functionality like fiemap support (which has been in xfs_io since
2011).

> generic/020 38s ... 31s
> generic/021     [not run] xfs_io fpunch support is missing
> generic/022     [not run] xfs_io fpunch support is missing
> generic/023 1s ... 0s
> generic/024 1s ... 0s
> generic/025 0s ... 0s
> generic/026 0s ... 0s
> generic/027 57s ... 57s
> generic/028 5s ... 5s
> generic/053 1s ... 2s
> generic/062 1s ... 2s
> generic/068 60s ... 61s
> generic/069 4s ... 3s
> generic/070 13s ... 14s
> generic/074 164s ... 162s
> generic/075 87s ... 86s
> generic/076 1s ... 1s
> generic/077     [not run] fsgqa user not defined.

ANd if you don't have this user defined, then several quota tests
don't get run.

> generic/079 1s ... 1s
> generic/083 36s ... 39s
> generic/088 1s ... 0s
> generic/089 4s ... 4s
> generic/091 62s ... 62s
> generic/093     [not run] not suitable for this OS: Linux
> generic/097     [not run] not suitable for this OS: Linux
> generic/099     [not run] not suitable for this OS: Linux
> generic/100 12s ... 12s
> generic/105 0s ... 0s
> generic/112     [not run] fsx not built with AIO for this platform
> generic/113     [not run] aio-stress not built for this platform

Ouch. There's another whole class of functionality you aren't
testing.

> generic/299     [not run]  utility required, skipped this test
> generic/300     [not run] xfs_io fpunch support is missing
> generic/306     - output mismatch (see
> /root/work/quota/ext4_inode_field/xfstests.git/results//generic/306.out.bad)
>     --- tests/generic/306.out    2014-07-16 10:19:26.196995657 +0800
>     +++ /root/work/quota/ext4_inode_field/xfstests.git/results//generic/306.out.bad
>    2015-04-27 22:40:13.365445316 +0800
>     @@ -2,11 +2,9 @@
>      == try to create new file
>      touch: cannot touch 'SCRATCH_MNT/this_should_fail': Read-only file system
>      == pwrite to null device
>     -wrote 512/512 bytes at offset 0
>     -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>     +xfs_io: specified file ["/mnt/scratch/devnull"] is not on an XFS filesystem
>      == pread from zero device
>     ...
>     (Run 'diff -u tests/generic/306.out
> /root/work/quota/ext4_inode_field/xfstests.git/results//generic/306.out.bad'
>  to see the entire diff)

That's caused by having a very old xfs_io.

> xfs/229 134s ... [failed, exit status 23] - output mismatch (see
> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/229.out.bad)
>     --- tests/xfs/229.out    2014-07-16 10:19:26.215995657 +0800
>     +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/229.out.bad
>    2015-04-27 23:25:48.709093428 +0800
>     @@ -1,4 +1,31 @@
>      QA output created by 229
>      generating 10 files
>     +Write did not return correct amount
>     +Write did not return correct amount
>     +Write did not return correct amount
>     +Write did not return correct amount
>      comparing files

Can't say that I've seen that one fail for a long time. I can't say
anything useful about it, however, given how old your xfsprogs
installation is.

>     ...
>     (Run 'diff -u tests/xfs/229.out
> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/229.out.bad'
>  to see the entire diff)
> xfs/238 1s ... 1s
> xfs/242     [not run] zero command not supported
> xfs/244 2s ... 2s
> xfs/250     [failed, exit status 1] - output mismatch (see
> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.out.bad)
>     --- tests/xfs/250.out    2014-07-16 10:19:26.215995657 +0800
>     +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.out.bad
>    2015-04-27 23:26:15.137452337 +0800
>     @@ -11,4 +11,4 @@
>      *** preallocate large file
>      *** unmount loop filesystem
>      *** check loop filesystem
>     -*** done
>     +_check_xfs_filesystem: filesystem on /mnt/test/250.fs is
> inconsistent (r) (see
> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.full)
>     ...
>     (Run 'diff -u tests/xfs/250.out
> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.out.bad'
>  to see the entire diff)

Your xfstests is not up to date. This is fixed by commit ee6ad7f
("xfs/049: umount -d fails when kernel wins teardown race").

> xfs/301     - output mismatch (see
> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/301.out.bad)
>     --- tests/xfs/301.out    2014-07-16 10:19:26.217995657 +0800
>     +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/301.out.bad
>    2015-04-27 23:33:33.629182381 +0800
>     @@ -29,18 +29,21 @@
>      Attribute "attr4" had a 10 byte value for DUMP_DIR/sub/biggg:
>      some_text4
>      EAs on restore
>     +getfattr: /mnt/scratch/restoredir/dumpdir: No such file or directory
>     +getfattr: /mnt/scratch/restoredir/dumpdir: No such file or directory
>      User names
>     -Attribute "attr5" had a 8 byte value for DUMP_DIR/dir:
>     ...
>     (Run 'diff -u tests/xfs/301.out

$ ./lsqa.pl tests/xfs/301
FS QA Test No. 301

Verify multi-stream xfsdump/restore preserves extended attributes

$

Your xfsdump package is out of date and needs upgrading.

> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/301.out.bad'
>  to see the entire diff)
> xfs/302     [failed, exit status 1] - output mismatch (see
> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.out.bad)
>     --- tests/xfs/302.out    2014-07-16 10:19:26.217995657 +0800
>     +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.out.bad
>    2015-04-27 23:33:46.102767709 +0800
>     @@ -1,2 +1,4 @@
>      QA output created by 302
>      Silence is golden.
>     +dump failed
>     +(see /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.full
> for details)
>     ...
>     (Run 'diff -u tests/xfs/302.out
> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.out.bad'
>  to see the entire diff)

Same again.

You need to upgrade everything to current xfstests/xfsprogs/xfsdump
and retest *everything*. That means rerunning all your ext4 testing,
too, because you're not exercising all the cases where the
interesting accounting bugs lie (i.e. in fallocate operations).

I'd also suggest that you run the tests using MOUNT_OPTIONS="-o
pquota" after setting up default configurations for TEST_MNT and
SCRATCH_MNT so that you actually give the project quota code a
significant amount of work to do, and do the same for ext4,
otherwise you're not really testing it at all when you run xfstests
on ext4....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
