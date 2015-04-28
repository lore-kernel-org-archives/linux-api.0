From: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v14 3/4] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Tue, 28 Apr 2015 10:01:07 +0800
Message-ID: <CAPTn0cAHOHP060cW8k0-HnyfKdVaUwAVOyLZU43AXtECK6_EaA@mail.gmail.com>
References: <1429728997-21464-1-git-send-email-lixi@ddn.com>
	<1429728997-21464-4-git-send-email-lixi@ddn.com>
	<20150426232033.GQ15810@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150426232033.GQ15810@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Dave,

I ran xfstests on the kernel with this series of patches.
Unfortunately, 5 test suits failed. But I don't think they are caused
by this patch. Following is the result. Please let me know if there is
any problem about it.

Output of xfstests:

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 vm15 4.0.0+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb2
MOUNT_OPTIONS -- /dev/sdb2 /mnt/scratch

generic/001 3s ... 2s
generic/002 0s ... 0s
generic/003 10s ... 10s
generic/004     [not run] xfs_io flink support is missing
generic/005 0s ... 0s
generic/006 1s ... 0s
generic/007 0s ... 0s
generic/008     [not run] xfs_io fzero support is missing
generic/009     [not run] xfs_io fzero support is missing
generic/010 1s ... 0s
generic/011 1s ... 0s
generic/012     [not run] xfs_io fpunch support is missing
generic/013 92s ... 90s
generic/014 3s ... 3s
generic/015 1s ... 1s
generic/016     [not run] xfs_io fpunch support is missing
generic/017     [not run] xfs_io fiemap support is missing
generic/018     [not run] xfs_io fiemap support is missing
generic/020 38s ... 31s
generic/021     [not run] xfs_io fpunch support is missing
generic/022     [not run] xfs_io fpunch support is missing
generic/023 1s ... 0s
generic/024 1s ... 0s
generic/025 0s ... 0s
generic/026 0s ... 0s
generic/027 57s ... 57s
generic/028 5s ... 5s
generic/053 1s ... 2s
generic/062 1s ... 2s
generic/068 60s ... 61s
generic/069 4s ... 3s
generic/070 13s ... 14s
generic/074 164s ... 162s
generic/075 87s ... 86s
generic/076 1s ... 1s
generic/077     [not run] fsgqa user not defined.
generic/079 1s ... 1s
generic/083 36s ... 39s
generic/088 1s ... 0s
generic/089 4s ... 4s
generic/091 62s ... 62s
generic/093     [not run] not suitable for this OS: Linux
generic/097     [not run] not suitable for this OS: Linux
generic/099     [not run] not suitable for this OS: Linux
generic/100 12s ... 12s
generic/105 0s ... 0s
generic/112     [not run] fsx not built with AIO for this platform
generic/113     [not run] aio-stress not built for this platform
generic/117 15s ... 15s
generic/120 16s ... 16s
generic/123     [not run] fsgqa user not defined.
generic/124 4s ... 3s
generic/125     [not run] fsgqa user not defined.
generic/126 1s ... 0s
generic/127 1745s ... 1793s
generic/128     [not run] fsgqa user not defined.
generic/129 4s ... 4s
generic/130 13s ... 13s
generic/131 1s ... 1s
generic/132 40s ... 40s
generic/133 92s ... 94s
generic/135 1s ... 1s
generic/141 0s ... 1s
generic/169 1s ... 1s
generic/184 1s ... 0s
generic/192 40s ... 40s
generic/193     [not run] fsgqa user not defined.
generic/198     [not run] src/aio-dio-regress/aiodio_sparse2 not built
generic/204 6s ... 7s
generic/207     [not run] src/aio-dio-regress/aio-dio-extend-stat not built
generic/208     [not run]
src/aio-dio-regress/aio-dio-invalidate-failure not built
generic/209     [not run]
src/aio-dio-regress/aio-dio-invalidate-readahead not built
generic/210     [not run]
src/aio-dio-regress/aio-dio-subblock-eof-read not built
generic/211     [not run]
src/aio-dio-regress/aio-free-ring-with-bogus-nr-pages not built
generic/212     [not run]
src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer not
built
generic/213 0s ... 0s
generic/214 0s ... 0s
generic/215 2s ... 3s
generic/219     [not run] fsgqa user not defined.
generic/221 1s ... 1s
generic/223 14s ... 14s
generic/224 59s ... 61s
generic/225 18s ... 17s
generic/226 18s ... 19s
generic/228 1s ... 0s
generic/230     [not run] fsgqa user not defined.
generic/231     [not run] fsgqa user not defined.
generic/232 55s ... 52s
generic/233     [not run] fsgqa user not defined.
generic/234 9s ... 9s
generic/235     [not run] fsgqa user not defined.
generic/236 2s ... 1s
generic/237 1s ... 0s
generic/239     [not run]
src/aio-dio-regress/aio-dio-hole-filling-race not built
generic/240     [not run] src/aio-dio-regress/aiodio_sparse2 not built
generic/241     [not run] dbench not found
generic/245 0s ... 0s
generic/246 0s ... 0s
generic/247 24s ... 24s
generic/248 0s ... 0s
generic/249 2s ... 1s
generic/255     [not run] xfs_io fpunch support is missing
generic/256     [not run] xfs_io fpunch support is missing
generic/257 0s ... 0s
generic/258 1s ... 0s
generic/260     [not run] FITRIM not supported on /dev/sdb2
generic/263 93s ... 96s
generic/269 113s ... 112s
generic/270     [not run] fsgqa user not defined.
generic/273 44s ... 40s
generic/274 72s ... 70s
generic/275 32s ... 33s
generic/277 2s ... 1s
generic/280 2s ... 2s
generic/285 0s ... 0s
generic/286 6s ... 5s
generic/288     [not run] FITRIM not supported on /dev/sdb2
generic/294 1s ... 0s
generic/299     [not run]  utility required, skipped this test
generic/300     [not run] xfs_io fpunch support is missing
generic/306     - output mismatch (see
/root/work/quota/ext4_inode_field/xfstests.git/results//generic/306.out.bad)
    --- tests/generic/306.out    2014-07-16 10:19:26.196995657 +0800
    +++ /root/work/quota/ext4_inode_field/xfstests.git/results//generic/306.out.bad
   2015-04-27 22:40:13.365445316 +0800
    @@ -2,11 +2,9 @@
     == try to create new file
     touch: cannot touch 'SCRATCH_MNT/this_should_fail': Read-only file system
     == pwrite to null device
    -wrote 512/512 bytes at offset 0
    -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    +xfs_io: specified file ["/mnt/scratch/devnull"] is not on an XFS filesystem
     == pread from zero device
    ...
    (Run 'diff -u tests/generic/306.out
/root/work/quota/ext4_inode_field/xfstests.git/results//generic/306.out.bad'
 to see the entire diff)
generic/307 1s ... 2s
generic/308 0s ... 0s
generic/309 1s ... 1s
generic/310 62s ... 63s
generic/311 124s ... 129s
generic/312     [not run] this test requires $SCRATCH_DEV has 5368709120B space
generic/313 2s ... 2s
generic/314     [not run] fsgqa user not defined.
generic/315 0s ... 0s
generic/316     [not run] xfs_io fpunch support is missing
generic/317     [not run] fsgqa user not defined.
generic/318 1s ... 1s
generic/319 0s ... 1s
generic/320 65s ... 81s
generic/321 2s ... 2s
generic/322 1s ... 2s
shared/006 381s ... 386s
shared/032 8s ... 8s
shared/051 0s ... 1s
shared/272     [not run] not suitable for this filesystem type: xfs
shared/289     [not run] not suitable for this filesystem type: xfs
shared/298     [not run] xfs_io fiemap support is missing
xfs/001     [not run] mkfs.xfs doesn't have crc feature
xfs/002     [not run] mkfs.xfs doesn't have crc feature
xfs/003 0s ... 0s
xfs/004 1s ... 1s
xfs/005     [not run] mkfs.xfs doesn't have crc feature
xfs/006 3s ... 4s
xfs/007 1s ... 0s
xfs/008 0s ... 1s
xfs/009 0s ... 1s
xfs/010     [not run] mkfs.xfs doesn't have finobt feature
xfs/011 17s ... 17s
xfs/012 1s ... 1s
xfs/013     [not run] mkfs.xfs doesn't have finobt feature
xfs/014     [not run] fsgqa user not defined.
xfs/016 35s ... 37s
xfs/017 18s ... 18s
xfs/019 1s ... 1s
xfs/021 0s ... 1s
xfs/026     12s
xfs/027     12s
xfs/028     24s
xfs/029 0s ... 1s
xfs/030 9s ... 9s
xfs/031 7s ... 7s
xfs/033 6s ... 5s
xfs/034 1s ... 1s
xfs/035     [not run] No dump tape specified
xfs/040     [not run] Can't run srcdiff without KWORKAREA set
xfs/041 15s ... 17s
xfs/042 120s ... 123s
xfs/044     [not run] This test requires a valid $SCRATCH_LOGDEV
xfs/045 1s ... 1s
xfs/046     12s
xfs/047     23s
xfs/048 0s ... 0s
xfs/049 8s ... 8s
xfs/050 15s ... 15s
xfs/052 1s ... 2s
xfs/054 2s ... 3s
xfs/056     17s
xfs/057     [not run] Place holder for IRIX test 057
xfs/058     [not run] Place holder for IRIX test 058
xfs/059     [not run] xfsdump multi-stream support required
xfs/060     [not run] xfsdump multi-stream support required
xfs/061     12s
xfs/063     12s
xfs/064     77s
xfs/065     35s
xfs/066     25s
xfs/067 1s ... 1s
xfs/071 5s ... 5s
xfs/072 1s ... 1s
xfs/073 15s ... 22s
xfs/078 65s ... 66s
xfs/084 59s ... 59s
xfs/085 1s ... 1s
xfs/086 63s ... 65s
xfs/087 33s ... 34s
xfs/090     [not run] External volumes not in use, skipped this test
xfs/092 1s ... 1s
xfs/094     [not run] External volumes not in use, skipped this test
xfs/095     [not run] not suitable for this OS: Linux
xfs/096 3s ... 2s
xfs/103 1s ... 0s
xfs/104 96s ... 100s
xfs/108 6s ... 6s
xfs/109 29s ... 28s
xfs/110 12s ... 12s
xfs/116 1s ... 1s
xfs/118 1s ... 2s
xfs/119 4s ... 4s
xfs/121 6s ... 6s
xfs/122     [not run] Could not compile test program (see end of
/root/work/quota/ext4_inode_field/xfstests.git/results//xfs/122.full)
xfs/134 1s ... 1s
xfs/137 12s ... 12s
xfs/138 13s ... 14s
xfs/139 13s ... 13s
xfs/140 13s ... 13s
xfs/148     [not run] parallel repair binary xfs_prepair64 is not installed
xfs/149     [not run] parallel repair binary xfs_prepair is not installed
xfs/164 0s ... 0s
xfs/165 1s ... 0s
xfs/166 1s ... 0s
xfs/167     [not run] This test requires at least 10GB free on
/mnt/scratch to run
xfs/170 9s ... 10s
xfs/174 17s ... 19s
xfs/178 15s ... 15s
xfs/179 39s ... 41s
xfs/180     [not run] This test requires at least 10GB free on
/mnt/scratch to run
xfs/181 12s ... 13s
xfs/182 9s ... 9s
xfs/183 3s ... 3s
xfs/186 1s ... 2s
xfs/187 3s ... 2s
xfs/188 8s ... 7s
xfs/189     [not run] noattr2 mount option not supported on /dev/sdb2
xfs/190 1s ... 1s
xfs/191     [not run] no mkfs support for NFS v4 ACLs
xfs/194 1s ... 1s
xfs/195     [not run] fsgqa user not defined.
xfs/196 3s ... 4s
xfs/197     [not run] This test is only valid on 32 bit machines
xfs/199 1s ... 0s
xfs/200 1s ... 0s
xfs/201 2s ... 2s
xfs/202 1s ... 0s
xfs/203 0s ... 1s
xfs/205 2s ... 2s
xfs/206 31s ... 32s
xfs/216 10s ... 10s
xfs/217 128s ... 130s
xfs/220 1s ... 1s
xfs/222 1s ... 1s
xfs/227 493s ... 507s
xfs/229 134s ... [failed, exit status 23] - output mismatch (see
/root/work/quota/ext4_inode_field/xfstests.git/results//xfs/229.out.bad)
    --- tests/xfs/229.out    2014-07-16 10:19:26.215995657 +0800
    +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/229.out.bad
   2015-04-27 23:25:48.709093428 +0800
    @@ -1,4 +1,31 @@
     QA output created by 229
     generating 10 files
    +Write did not return correct amount
    +Write did not return correct amount
    +Write did not return correct amount
    +Write did not return correct amount
     comparing files
    ...
    (Run 'diff -u tests/xfs/229.out
/root/work/quota/ext4_inode_field/xfstests.git/results//xfs/229.out.bad'
 to see the entire diff)
xfs/238 1s ... 1s
xfs/242     [not run] zero command not supported
xfs/244 2s ... 2s
xfs/250     [failed, exit status 1] - output mismatch (see
/root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.out.bad)
    --- tests/xfs/250.out    2014-07-16 10:19:26.215995657 +0800
    +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.out.bad
   2015-04-27 23:26:15.137452337 +0800
    @@ -11,4 +11,4 @@
     *** preallocate large file
     *** unmount loop filesystem
     *** check loop filesystem
    -*** done
    +_check_xfs_filesystem: filesystem on /mnt/test/250.fs is
inconsistent (r) (see
/root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.full)
    ...
    (Run 'diff -u tests/xfs/250.out
/root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.out.bad'
 to see the entire diff)
xfs/252     [not run] xfs_io fpunch support is missing
xfs/253 2s ... 3s
xfs/259 33s ... 34s
xfs/261 1s ... 1s
xfs/262 1s ... 1s
xfs/266     [not run] requires xfsdump -D
xfs/278 1s ... 1s
xfs/279 8s ... 8s
xfs/281     [not run] xfsdump -K option required
xfs/282     [not run] xfsdump -K option required
xfs/283     [not run] xfsdump -K option required
xfs/287     2s
xfs/290     [not run] xfs_io zero support is missing
xfs/291 52s ... 54s
xfs/292 4s ... 4s
xfs/293 2s ... 2s
xfs/295 8s ... 7s
xfs/296     12s
xfs/297 306s ... 229s
xfs/298 6s ... 6s
xfs/299     [not run] mkfs.xfs doesn't have crc feature
xfs/300     [not run] SELinux not enabled
xfs/301     - output mismatch (see
/root/work/quota/ext4_inode_field/xfstests.git/results//xfs/301.out.bad)
    --- tests/xfs/301.out    2014-07-16 10:19:26.217995657 +0800
    +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/301.out.bad
   2015-04-27 23:33:33.629182381 +0800
    @@ -29,18 +29,21 @@
     Attribute "attr4" had a 10 byte value for DUMP_DIR/sub/biggg:
     some_text4
     EAs on restore
    +getfattr: /mnt/scratch/restoredir/dumpdir: No such file or directory
    +getfattr: /mnt/scratch/restoredir/dumpdir: No such file or directory
     User names
    -Attribute "attr5" had a 8 byte value for DUMP_DIR/dir:
    ...
    (Run 'diff -u tests/xfs/301.out
/root/work/quota/ext4_inode_field/xfstests.git/results//xfs/301.out.bad'
 to see the entire diff)
xfs/302     [failed, exit status 1] - output mismatch (see
/root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.out.bad)
    --- tests/xfs/302.out    2014-07-16 10:19:26.217995657 +0800
    +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.out.bad
   2015-04-27 23:33:46.102767709 +0800
    @@ -1,2 +1,4 @@
     QA output created by 302
     Silence is golden.
    +dump failed
    +(see /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.full
for details)
    ...
    (Run 'diff -u tests/xfs/302.out
/root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.out.bad'
 to see the entire diff)
xfs/303 0s ... 0s
xfs/304     [not run] mkfs.xfs doesn't have crc feature
xfs/305     [not run] mkfs.xfs doesn't have crc feature
xfs/306 76s ... 76s
Ran: generic/001 generic/002 generic/003 generic/005 generic/006
generic/007 generic/010 generic/011 generic/013 generic/014
generic/015 generic/020 generic/023 generic/024 generic/025
generic/026 generic/027 generic/028 generic/053 generic/062
generic/068 generic/069 generic/070 generic/074 generic/075
generic/076 generic/079 generic/083 generic/088 generic/089
generic/091 generic/100 generic/105 generic/117 generic/120
generic/124 generic/126 generic/127 generic/129 generic/130
generic/131 generic/132 generic/133 generic/135 generic/141
generic/169 generic/184 generic/192 generic/204 generic/213
generic/214 generic/215 generic/221 generic/223 generic/224
generic/225 generic/226 generic/228 generic/232 generic/234
generic/236 generic/237 generic/245 generic/246 generic/247
generic/248 generic/249 generic/257 generic/258 generic/263
generic/269 generic/273 generic/274 generic/275 generic/277
generic/280 generic/285 generic/286 generic/294 generic/306
generic/307 generic/308 generic/309 generic/310 generic/311
generic/313 generic/315 generic/318 generic/319 generic/320
generic/321 generic/322 shared/006 shared/032 shared/051 xfs/003
xfs/004 xfs/006 xfs/007 xfs/008 xfs/009 xfs/011 xfs/012 xfs/016
xfs/017 xfs/019 xfs/021 xfs/026 xfs/027 xfs/028 xfs/029 xfs/030
xfs/031 xfs/033 xfs/034 xfs/041 xfs/042 xfs/045 xfs/046 xfs/047
xfs/048 xfs/049 xfs/050 xfs/052 xfs/054 xfs/056 xfs/061 xfs/063
xfs/064 xfs/065 xfs/066 xfs/067 xfs/071 xfs/072 xfs/073 xfs/078
xfs/084 xfs/085 xfs/086 xfs/087 xfs/092 xfs/096 xfs/103 xfs/104
xfs/108 xfs/109 xfs/110 xfs/116 xfs/118 xfs/119 xfs/121 xfs/134
xfs/137 xfs/138 xfs/139 xfs/140 xfs/164 xfs/165 xfs/166 xfs/170
xfs/174 xfs/178 xfs/179 xfs/181 xfs/182 xfs/183 xfs/186 xfs/187
xfs/188 xfs/190 xfs/194 xfs/196 xfs/199 xfs/200 xfs/201 xfs/202
xfs/203 xfs/205 xfs/206 xfs/216 xfs/217 xfs/220 xfs/222 xfs/227
xfs/229 xfs/238 xfs/244 xfs/250 xfs/253 xfs/259 xfs/261 xfs/262
xfs/278 xfs/279 xfs/287 xfs/291 xfs/292 xfs/293 xfs/295 xfs/296
xfs/297 xfs/298 xfs/301 xfs/302 xfs/303 xfs/306
Not run: generic/004 generic/008 generic/009 generic/012 generic/016
generic/017 generic/018 generic/021 generic/022 generic/077
generic/093 generic/097 generic/099 generic/112 generic/113
generic/123 generic/125 generic/128 generic/193 generic/198
generic/207 generic/208 generic/209 generic/210 generic/211
generic/212 generic/219 generic/230 generic/231 generic/233
generic/235 generic/239 generic/240 generic/241 generic/255
generic/256 generic/260 generic/270 generic/288 generic/299
generic/300 generic/312 generic/314 generic/316 generic/317 shared/272
shared/289 shared/298 xfs/001 xfs/002 xfs/005 xfs/010 xfs/013 xfs/014
xfs/035 xfs/040 xfs/044 xfs/057 xfs/058 xfs/059 xfs/060 xfs/090
xfs/094 xfs/095 xfs/122 xfs/148 xfs/149 xfs/167 xfs/180 xfs/189
xfs/191 xfs/195 xfs/197 xfs/242 xfs/252 xfs/266 xfs/281 xfs/282
xfs/283 xfs/290 xfs/299 xfs/300 xfs/304 xfs/305
Failures: generic/306 xfs/229 xfs/250 xfs/301 xfs/302
Failed 5 of 206 tests

On Mon, Apr 27, 2015 at 7:20 AM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> On Thu, Apr 23, 2015 at 03:56:36AM +0900, Li Xi wrote:
>> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
>> support for ext4. The interface is kept consistent with
>> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.
>
> Have you run this patchthrough XFS testing to make sure everything
> sill works?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
