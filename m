From: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Fri, 11 Mar 2011 12:01:02 +0100 (CET)
Message-ID: <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <20110303072223.GA28133@elie> <87bp1sziqn.fsf@linux.vnet.ibm.com>
    <Pine.LNX.4.64.1103071515070.11152@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org, arnd@arndb.de, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
List-Id: linux-api@vger.kernel.org

Hello,

On Thu, March 10, 2011 20:31, Sage Weil wrote:
> It is frequently useful to sync a single file system, instead of all
> mounted file systems via sync(2):
>
>  - On machines with many mounts, it is not at all uncommon for some of
>    them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
>    those and may never get to the one you do care about (e.g., /).
>  - Some applications write lots of data to the file system and then
>    want to make sure it is flushed to disk.  Calling fsync(2) on each
>    file introduces unnecessary ordering constraints that result in a large
>    amount of sub-optimal writeback/flush/commit behavior by the file
>    system.
>
> There are currently two ways (that I know of) to sync a single super_block:
>
>  - BLKFLSBUF ioctl on the block device: That also invalidates the bdev
>    mapping, which isn't usually desirable, and doesn't work for non-block
>    file systems.
>  - 'mount -o remount,rw' will call sync_filesystem as an artifact of the
>    current implemention.  Relying on this little-known side effect for
>    something like data safety sounds foolish.
>
> Both of these approaches require root privileges, which some applications
> do not have (nor should they need?) given that sync(2) is an unprivileged
> operation.
>
> This patch introduces a new system call syncfs(2) that takes an fd and
> syncs only the file system it references.  Maybe someday we can
>
>  $ sync /some/path
>
> and not get
>
>  sync: ignoring all arguments
>
> The syscall is motivated by comments by Al and Christoph at the last LSF.
> syncfs(2) seems like an appropriate name given statfs(2).
>
> A similar ioctl was also proposed a while back, see
> 	http://marc.info/?l=linux-fsdevel&m=127970513829285&w=2

The patch there seems much more reasonable than introducing a whole
new systemcall just for 20 lines of kernel code. New system calls are
added too easily nowadays.

As an alternative to the ioctl, I propose extending sync_file_range()
instead. E.g. add a SYNC_FILE_MOUNT flag and use that, either on any
fd on the mount or the root dir fd. That syscall is non-standard and
close enough that it can implement this behaviour too.

Greetings,

Indan

---

Something like:

diff --git a/fs/sync.c b/fs/sync.c
index ba76b96..9fa073c 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -18,7 +18,7 @@
 #include "internal.h"

 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
-			SYNC_FILE_RANGE_WAIT_AFTER)
+			SYNC_FILE_RANGE_WAIT_AFTER|SYNC_FILE_MOUNT)

 /*
  * Do the filesystem syncing work. For simple filesystems
@@ -330,6 +330,15 @@ SYSCALL_DEFINE(sync_file_range)(int fd, loff_t offset, loff_t nbytes,
 	}

 	ret = 0;
+	if (flags & SYNC_FILE_MOUNT) {
+		struct super_block *sb;
+
+		sb = file->f_dentry->d_sb;
+		down_read(&sb->s_umount);
+		ret = sync_filesystem(sb);
+		up_read(&sb->s_umount);
+		goto out_put;
+	}
 	if (flags & SYNC_FILE_RANGE_WAIT_BEFORE) {
 		ret = filemap_fdatawait_range(mapping, offset, endbyte);
 		if (ret < 0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e38b50a..53e427e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -373,6 +373,7 @@ struct inodes_stat_t {
 #define SYNC_FILE_RANGE_WAIT_BEFORE	1
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
+#define SYNC_FILE_MOUNT 		8

 #ifdef __KERNEL__
