From: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v14 3/4] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Wed, 29 Apr 2015 13:49:08 +0800
Message-ID: <CAPTn0cBymWmQ5JKAPpFzqzivbEpjzY=s+M5O5bCsne7LbEeiLA@mail.gmail.com>
References: <1429728997-21464-1-git-send-email-lixi@ddn.com>
	<1429728997-21464-4-git-send-email-lixi@ddn.com>
	<20150426232033.GQ15810@dastard>
	<CAPTn0cAHOHP060cW8k0-HnyfKdVaUwAVOyLZU43AXtECK6_EaA@mail.gmail.com>
	<20150428044331.GV21261@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150428044331.GV21261@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Dave,

Thanks for the advices. I tried to run latest xfstests again. However,
the kernel crashed when runing generic/051 generic/054 and
generic/055. And please note that the kernel also crashed on original
linux-4.0 without any of my patches. Following is one of the dump
stack:

run fstests generic/055 at 2015-04-29 13:43:39
------------[ cut here ]------------
WARNING: CPU: 0 PID: 31915 at lib/list_debug.c:33 __list_add+0xbe/0xd0()
list_add corruption. prev->next should be next (ffffffff81e05018), but
was           (null). (prev=ffff8800d8ff3ca0).
Modules linked in: dm_flakey xfs exportfs libcrc32c nfsv3 nfs_acl
rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs fscache lockd grace
sunrpc ipv6 dm_mirror dm_region_hash dm_log dm_mod ppdev floppy
parport_pc parport microcode pcspkr virtio_balloon sg 8139too 8139cp
mii i2c_piix4 i2c_core ext4 jbd2 mbcache sr_mod cdrom sd_mod pata_acpi
ata_generic ata_piix virtio_pci virtio_ring virtio [last unloaded:
speedstep_lib]
CPU: 0 PID: 31915 Comm: kworker/0:0 Not tainted 4.0.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
Workqueue: events vmstat_shepherd
 0000000000000021 ffff8800db177bf8 ffffffff815ccaf6 0000000000000021
 ffff8800db177c48 ffff8800db177c38 ffffffff81059fc5 ffff8800db177c38
 ffffffff81a8d480 ffffffff81e05018 ffff8800d8ff3ca0 0000000000000000
Call Trace:
 [<ffffffff815ccaf6>] dump_stack+0x48/0x5a
 [<ffffffff81059fc5>] warn_slowpath_common+0x95/0xe0
 [<ffffffff8105a0c6>] warn_slowpath_fmt+0x46/0x70
 [<ffffffff812c04fe>] __list_add+0xbe/0xd0
 [<ffffffff810bb84b>] __internal_add_timer+0x9b/0x110
 [<ffffffff810bb8f9>] internal_add_timer+0x39/0x90
 [<ffffffff810bd8c9>] mod_timer+0xf9/0x1d0
 [<ffffffff810bd9b8>] add_timer+0x18/0x30
 [<ffffffff81071a22>] __queue_delayed_work+0x92/0x1a0
 [<ffffffff81071bcd>] queue_delayed_work_on+0x1d/0x40
 [<ffffffff81160d5c>] vmstat_shepherd+0x10c/0x120
 [<ffffffff810722ed>] process_one_work+0x14d/0x440
 [<ffffffff810726ff>] worker_thread+0x11f/0x3d0
 [<ffffffff815ccfaf>] ? __schedule+0x36f/0x800
 [<ffffffff810725e0>] ? process_one_work+0x440/0x440
 [<ffffffff810725e0>] ? process_one_work+0x440/0x440
 [<ffffffff810774ce>] kthread+0xce/0xf0
 [<ffffffff8104d96e>] ? __do_page_fault+0x17e/0x430
 [<ffffffff81077400>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815d1052>] ret_from_fork+0x42/0x70
 [<ffffffff81077400>] ? kthread_freezable_should_stop+0x70/0x70
---[ end trace 97c6b752be15ac57 ]---
XFS (sdb2): Mounting V4 Filesystem
XFS (sdb2): Ending clean mount
XFS (sdb2): Quotacheck needed: Please wait.
XFS (sdb2): Quotacheck: Done.
XFS (sdb2): xfs_log_force: error -5 returned.
XFS (sdb2): xfs_log_force: error -5 returned.
XFS (sdb2): xfs_log_force: error -5 returned.
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff810bbc88>] get_next_timer_interrupt+0x158/0x230
PGD d8e7a067 PUD db654067 PMD 0
Oops: 0000 [#1] SMP
Modules linked in: dm_flakey xfs exportfs libcrc32c nfsv3 nfs_acl
rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs fscache lockd grace
sunrpc ipv6 dm_mirror dm_region_hash dm_log dm_mod ppdev floppy
parport_pc parport microcode pcspkr virtio_balloon sg 8139too 8139cp
mii i2c_piix4 i2c_core ext4 jbd2 mbcache sr_mod cdrom sd_mod pata_acpi
ata_generic ata_piix virtio_pci virtio_ring virtio [last unloaded:
speedstep_lib]
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.0.0+ #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
task: ffffffff81a134a0 ti: ffffffff81a00000 task.ti: ffffffff81a00000
RIP: 0010:[<ffffffff810bbc88>]  [<ffffffff810bbc88>]
get_next_timer_interrupt+0x158/0x230
RSP: 0018:ffff88011fc03e48  EFLAGS: 00010013
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81e05008
RDX: 0000000000000001 RSI: 0000000000000011 RDI: ffffffff81e04ef8
RBP: ffff88011fc03ea8 R08: 0000000000000011 R09: 0000000001000551
R10: ffff88011fc03e60 R11: ffff88011fc03e78 R12: 0000000140055030
R13: 0000000100055031 R14: ffffffff81e03ec0 R15: 0000000000000040
FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 00000000d8d8f000 CR4: 00000000000006f0
Stack:
 ffff88011fc03e88 ffffffff810bbdf7 ffffffff81e04ef8 ffffffff81e052f8
 ffffffff81e056f8 ffffffff81e05af8 0000000000000000 ffff88011fc0f8a0
 0000000100055031 0000000000000000 ffff88011fc0bfc0 ffffffff81a00000
Call Trace:
 <IRQ>
 [<ffffffff810bbdf7>] ? call_timer_fn+0x47/0x110
 [<ffffffff810cdf1d>] tick_nohz_stop_sched_tick+0x1cd/0x310
 [<ffffffff810ce108>] __tick_nohz_idle_enter+0xa8/0x150
 [<ffffffff810ce1dd>] tick_nohz_irq_exit+0x2d/0x40
 [<ffffffff8105deaf>] irq_exit+0x9f/0xc0
 [<ffffffff815d34aa>] smp_apic_timer_interrupt+0x4a/0x59
 [<ffffffff815d1a3b>] apic_timer_interrupt+0x6b/0x70
 <EOI>
 [<ffffffff8100f100>] ? default_idle+0x20/0xb0
 [<ffffffff8100e74f>] arch_cpu_idle+0xf/0x20
 [<ffffffff810986a9>] cpuidle_idle_call+0x89/0x220
 [<ffffffff81078232>] ? __atomic_notifier_call_chain+0x12/0x20
 [<ffffffff81098975>] cpu_idle_loop+0x135/0x1f0
 [<ffffffff81098a43>] cpu_startup_entry+0x13/0x20
 [<ffffffff815c5e1c>] rest_init+0x7c/0x80
 [<ffffffff81b4e372>] start_kernel+0x3d8/0x3df
 [<ffffffff81b4ddb8>] ? set_init_arg+0x5d/0x5d
 [<ffffffff815cb906>] ? memblock_reserve+0x4c/0x51
 [<ffffffff81b4d5ad>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81b4d6e4>] x86_64_start_kernel+0x135/0x13c
Code: 00 48 89 45 c8 45 89 c8 41 83 e0 3f 44 89 c6 0f 1f 40 00 48 63
ce 48 c1 e1 04 48 8b 04 39 48 8d 0c 0f 48 39 c8 74 22 0f 1f 40 00 <f6>
40 18 01 75 10 48 8b 50 10 48 39 da 48 0f 48 da ba 01 00 00
RIP  [<ffffffff810bbc88>] get_next_timer_interrupt+0x158/0x230
 RSP <ffff88011fc03e48>
CR2: 0000000000000018

On Tue, Apr 28, 2015 at 12:43 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> On Tue, Apr 28, 2015 at 10:01:07AM +0800, Li Xi wrote:
>> Hi Dave,
>>
>> I ran xfstests on the kernel with this series of patches.
>> Unfortunately, 5 test suits failed. But I don't think they are caused
>> by this patch. Following is the result. Please let me know if there is
>> any problem about it.
>>
>> Output of xfstests:
>>
>> FSTYP         -- xfs (non-debug)
>> PLATFORM      -- Linux/x86_64 vm15 4.0.0+
>> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb2
>> MOUNT_OPTIONS -- /dev/sdb2 /mnt/scratch
>>
>> generic/001 3s ... 2s
>> generic/002 0s ... 0s
>> generic/003 10s ... 10s
>> generic/004     [not run] xfs_io flink support is missing
>> generic/005 0s ... 0s
>> generic/006 1s ... 0s
>> generic/007 0s ... 0s
>> generic/008     [not run] xfs_io fzero support is missing
>> generic/009     [not run] xfs_io fzero support is missing
>> generic/010 1s ... 0s
>> generic/011 1s ... 0s
>> generic/012     [not run] xfs_io fpunch support is missing
>> generic/013 92s ... 90s
>> generic/014 3s ... 3s
>> generic/015 1s ... 1s
>> generic/016     [not run] xfs_io fpunch support is missing
>> generic/017     [not run] xfs_io fiemap support is missing
>> generic/018     [not run] xfs_io fiemap support is missing
>
> You really need to update your xfsprogs install. You aren't testing
> half of what you need to be testing if you are missing basic
> functionality like fiemap support (which has been in xfs_io since
> 2011).
>
>> generic/020 38s ... 31s
>> generic/021     [not run] xfs_io fpunch support is missing
>> generic/022     [not run] xfs_io fpunch support is missing
>> generic/023 1s ... 0s
>> generic/024 1s ... 0s
>> generic/025 0s ... 0s
>> generic/026 0s ... 0s
>> generic/027 57s ... 57s
>> generic/028 5s ... 5s
>> generic/053 1s ... 2s
>> generic/062 1s ... 2s
>> generic/068 60s ... 61s
>> generic/069 4s ... 3s
>> generic/070 13s ... 14s
>> generic/074 164s ... 162s
>> generic/075 87s ... 86s
>> generic/076 1s ... 1s
>> generic/077     [not run] fsgqa user not defined.
>
> ANd if you don't have this user defined, then several quota tests
> don't get run.
>
>> generic/079 1s ... 1s
>> generic/083 36s ... 39s
>> generic/088 1s ... 0s
>> generic/089 4s ... 4s
>> generic/091 62s ... 62s
>> generic/093     [not run] not suitable for this OS: Linux
>> generic/097     [not run] not suitable for this OS: Linux
>> generic/099     [not run] not suitable for this OS: Linux
>> generic/100 12s ... 12s
>> generic/105 0s ... 0s
>> generic/112     [not run] fsx not built with AIO for this platform
>> generic/113     [not run] aio-stress not built for this platform
>
> Ouch. There's another whole class of functionality you aren't
> testing.
>
>> generic/299     [not run]  utility required, skipped this test
>> generic/300     [not run] xfs_io fpunch support is missing
>> generic/306     - output mismatch (see
>> /root/work/quota/ext4_inode_field/xfstests.git/results//generic/306.out.bad)
>>     --- tests/generic/306.out    2014-07-16 10:19:26.196995657 +0800
>>     +++ /root/work/quota/ext4_inode_field/xfstests.git/results//generic/306.out.bad
>>    2015-04-27 22:40:13.365445316 +0800
>>     @@ -2,11 +2,9 @@
>>      == try to create new file
>>      touch: cannot touch 'SCRATCH_MNT/this_should_fail': Read-only file system
>>      == pwrite to null device
>>     -wrote 512/512 bytes at offset 0
>>     -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>>     +xfs_io: specified file ["/mnt/scratch/devnull"] is not on an XFS filesystem
>>      == pread from zero device
>>     ...
>>     (Run 'diff -u tests/generic/306.out
>> /root/work/quota/ext4_inode_field/xfstests.git/results//generic/306.out.bad'
>>  to see the entire diff)
>
> That's caused by having a very old xfs_io.
>
>> xfs/229 134s ... [failed, exit status 23] - output mismatch (see
>> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/229.out.bad)
>>     --- tests/xfs/229.out    2014-07-16 10:19:26.215995657 +0800
>>     +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/229.out.bad
>>    2015-04-27 23:25:48.709093428 +0800
>>     @@ -1,4 +1,31 @@
>>      QA output created by 229
>>      generating 10 files
>>     +Write did not return correct amount
>>     +Write did not return correct amount
>>     +Write did not return correct amount
>>     +Write did not return correct amount
>>      comparing files
>
> Can't say that I've seen that one fail for a long time. I can't say
> anything useful about it, however, given how old your xfsprogs
> installation is.
>
>>     ...
>>     (Run 'diff -u tests/xfs/229.out
>> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/229.out.bad'
>>  to see the entire diff)
>> xfs/238 1s ... 1s
>> xfs/242     [not run] zero command not supported
>> xfs/244 2s ... 2s
>> xfs/250     [failed, exit status 1] - output mismatch (see
>> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.out.bad)
>>     --- tests/xfs/250.out    2014-07-16 10:19:26.215995657 +0800
>>     +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.out.bad
>>    2015-04-27 23:26:15.137452337 +0800
>>     @@ -11,4 +11,4 @@
>>      *** preallocate large file
>>      *** unmount loop filesystem
>>      *** check loop filesystem
>>     -*** done
>>     +_check_xfs_filesystem: filesystem on /mnt/test/250.fs is
>> inconsistent (r) (see
>> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.full)
>>     ...
>>     (Run 'diff -u tests/xfs/250.out
>> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/250.out.bad'
>>  to see the entire diff)
>
> Your xfstests is not up to date. This is fixed by commit ee6ad7f
> ("xfs/049: umount -d fails when kernel wins teardown race").
>
>> xfs/301     - output mismatch (see
>> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/301.out.bad)
>>     --- tests/xfs/301.out    2014-07-16 10:19:26.217995657 +0800
>>     +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/301.out.bad
>>    2015-04-27 23:33:33.629182381 +0800
>>     @@ -29,18 +29,21 @@
>>      Attribute "attr4" had a 10 byte value for DUMP_DIR/sub/biggg:
>>      some_text4
>>      EAs on restore
>>     +getfattr: /mnt/scratch/restoredir/dumpdir: No such file or directory
>>     +getfattr: /mnt/scratch/restoredir/dumpdir: No such file or directory
>>      User names
>>     -Attribute "attr5" had a 8 byte value for DUMP_DIR/dir:
>>     ...
>>     (Run 'diff -u tests/xfs/301.out
>
> $ ./lsqa.pl tests/xfs/301
> FS QA Test No. 301
>
> Verify multi-stream xfsdump/restore preserves extended attributes
>
> $
>
> Your xfsdump package is out of date and needs upgrading.
>
>> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/301.out.bad'
>>  to see the entire diff)
>> xfs/302     [failed, exit status 1] - output mismatch (see
>> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.out.bad)
>>     --- tests/xfs/302.out    2014-07-16 10:19:26.217995657 +0800
>>     +++ /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.out.bad
>>    2015-04-27 23:33:46.102767709 +0800
>>     @@ -1,2 +1,4 @@
>>      QA output created by 302
>>      Silence is golden.
>>     +dump failed
>>     +(see /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.full
>> for details)
>>     ...
>>     (Run 'diff -u tests/xfs/302.out
>> /root/work/quota/ext4_inode_field/xfstests.git/results//xfs/302.out.bad'
>>  to see the entire diff)
>
> Same again.
>
> You need to upgrade everything to current xfstests/xfsprogs/xfsdump
> and retest *everything*. That means rerunning all your ext4 testing,
> too, because you're not exercising all the cases where the
> interesting accounting bugs lie (i.e. in fallocate operations).
>
> I'd also suggest that you run the tests using MOUNT_OPTIONS="-o
> pquota" after setting up default configurations for TEST_MNT and
> SCRATCH_MNT so that you actually give the project quota code a
> significant amount of work to do, and do the same for ext4,
> otherwise you're not really testing it at all when you run xfstests
> on ext4....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
