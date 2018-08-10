From: ebiederm@xmission.com (Eric W. Biederman)
Subject: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 09:05:22 -0500
Message-ID: <87d0uqpba5.fsf@xmission.com>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
        (David Howells's message of "Wed, 01 Aug 2018 16:23:56 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>, Miklos Szeredi <miklos@sze>
List-Id: linux-api@vger.kernel.org


There is a serious problem with mount options today that fsopen does not
address.  The problem is that mount options are ignored for block based
filesystems, and any other type of filesystem that follows the same
pattern.

The script below demonstrates this bug.  Showing this bug can cause the
ext4 "acl" "quota" and "user_xattr" options to be silently ignored.

fsopen has my nack until it addresses this issue.

I don't know if we can fix this in the context of sys_mount.  But we if
we are redoing the option parsing of how we mount filesystems this needs
to be fixed before we start worrying about bug compatibility.

Hopefully this report is simple and clear enough that we can at least
agree on the problem.

Eric

# cat ~/bin/bdev-loop0.sh
#!/bin/sh
set -x
set -e

LOOP=loop0

dd if=/dev/zero bs=1024 count=1048576 of=$LOOP-file
losetup /dev/$LOOP $LOOP-file
mkfs.ext4 /dev/$LOOP

mkdir $LOOP-noacl-noquota-nouser_xattr
mount -t ext4 /dev/$LOOP -o "noacl,noquota,nouser_xattr" $LOOP-noacl-noquota-nouser_xattr

mkdir $LOOP-acl-quota-user_xattr
mount -t ext4 /dev/$LOOP  -o "acl,quota,user_xattr" $LOOP-acl-quota-user_xattr

cat /proc/mounts | grep loop0


root@finagle:~# ~/bin/bdev-loop0.sh
+ set -e
+ LOOP=loop0
+ dd if=/dev/zero bs=1024 count=1048576 of=loop0-file
1048576+0 records in
1048576+0 records out
1073741824 bytes (1.1 GB) copied, 4.37645 s, 245 MB/s
+ losetup /dev/loop0 loop0-file
+ mkfs.ext4 /dev/loop0
mke2fs 1.41.12 (17-May-2010)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
65536 inodes, 262144 blocks
13107 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268435456
8 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376

Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 29 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
+ mkdir loop0-noacl-noquota-nouser_xattr
+ mount -t ext4 /dev/loop0 -o noacl,noquota,nouser_xattr loop0-noacl-noquota-nouser_xattr
+ mkdir loop0-acl-quota-user_xattr
+ mount -t ext4 /dev/loop0 -o acl,quota,user_xattr loop0-acl-quota-user_xattr
+ + grep loop0
cat /proc/mounts
/dev/loop0 /root/loop0-noacl-noquota-nouser_xattr ext4 rw,relatime,nouser_xattr,noacl 0 0
/dev/loop0 /root/loop0-acl-quota-user_xattr ext4 rw,relatime,nouser_xattr,noacl 0 0
