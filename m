From: Jann Horn <jannh@google.com>
Subject: [PATCH v4 1/3] fs: hoist EFSCORRUPTED definition into uapi header
Date: Fri, 18 Jan 2019 17:14:38 +0100
Message-ID: <20190118161440.220134-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, jannh@google.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Pavel Machek <pavel@ucw.cz>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Multiple filesystems can already return EFSCORRUPTED errors to userspace;
however, so far, definitions of EFSCORRUPTED were in filesystem-private
headers.

I wanted to use EUCLEAN to indicate data corruption in the VFS layer;
Dave Chinner says that I should instead hoist the definitions of
EFSCORRUPTED into the UAPI header and then use EFSCORRUPTED.

This patch is marked for stable backport because it is a prerequisite for
the following patch.

Cc: stable@vger.kernel.org
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jann Horn <jannh@google.com>
---
 fs/ext2/ext2.h                   | 1 -
 fs/ext4/ext4.h                   | 1 -
 fs/xfs/xfs_linux.h               | 1 -
 include/linux/jbd2.h             | 1 -
 include/uapi/asm-generic/errno.h | 1 +
 5 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index e770cd100a6a..7fafc19e5aa0 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -369,7 +369,6 @@ struct ext2_inode {
  */
 #define	EXT2_VALID_FS			0x0001	/* Unmounted cleanly */
 #define	EXT2_ERROR_FS			0x0002	/* Errors detected */
-#define	EFSCORRUPTED			EUCLEAN	/* Filesystem is corrupted */
 
 /*
  * Mount flags
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 185a05d3257e..9397e97fc15b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3247,6 +3247,5 @@ extern const struct iomap_ops ext4_iomap_ops;
 #endif	/* __KERNEL__ */
 
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
-#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
 
 #endif	/* _EXT4_H */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index edbd5a210df2..36e5c6549f15 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -125,7 +125,6 @@ typedef __u32			xfs_nlink_t;
 
 #define ENOATTR		ENODATA		/* Attribute not found */
 #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
-#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
 
 #define SYNCHRONIZE()	barrier()
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 0f919d5fe84f..1d0da9c78216 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1640,6 +1640,5 @@ static inline tid_t  jbd2_get_latest_transaction(journal_t *journal)
 #endif	/* __KERNEL__ */
 
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
-#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
 
 #endif	/* _LINUX_JBD2_H */
diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
index cf9c51ac49f9..5ddebc1bf951 100644
--- a/include/uapi/asm-generic/errno.h
+++ b/include/uapi/asm-generic/errno.h
@@ -98,6 +98,7 @@
 #define	EINPROGRESS	115	/* Operation now in progress */
 #define	ESTALE		116	/* Stale file handle */
 #define	EUCLEAN		117	/* Structure needs cleaning */
+#define	EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
 #define	ENOTNAM		118	/* Not a XENIX named type file */
 #define	ENAVAIL		119	/* No XENIX semaphores available */
 #define	EISNAM		120	/* Is a named type file */
-- 
2.20.1.321.g9e740568ce-goog
