From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v3 3/3] vfs: add a new ioctl for fetching the superblock's errseq_t
Date: Fri,  7 Feb 2020 12:04:23 -0500
Message-ID: <20200207170423.377931-4-jlayton@kernel.org>
References: <20200207170423.377931-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200207170423.377931-1-jlayton@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, andres@anarazel.de, willy@infradead.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

Some time ago, the PostgreSQL developers mentioned that they'd like a
way to tell whether there have been any writeback errors on a given
filesystem without having to forcibly sync out all buffered writes.

Now that we have a per-sb errseq_t that tracks whether any inode on the
filesystem might have failed writeback, we can present that to userland
applications via a new interface. Add a new generic fs ioctl for that
purpose. This just reports the current state of the errseq_t counter
with the SEEN bit masked off.

Cc: Andres Freund <andres@anarazel.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ioctl.c              |  4 ++++
 include/linux/errseq.h  |  1 +
 include/uapi/linux/fs.h |  1 +
 lib/errseq.c            | 33 +++++++++++++++++++++++++++++++--
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 7c9a5df5a597..41e991cec4c3 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -705,6 +705,10 @@ static int do_vfs_ioctl(struct file *filp, unsigned int fd,
 	case FS_IOC_FIEMAP:
 		return ioctl_fiemap(filp, argp);
 
+	case FS_IOC_GETFSERR:
+		return put_user(errseq_scrape(&inode->i_sb->s_wb_err),
+				(unsigned int __user *)argp);
+
 	case FIGETBSZ:
 		/* anon_bdev filesystems may not have a block size */
 		if (!inode->i_sb->s_blocksize)
diff --git a/include/linux/errseq.h b/include/linux/errseq.h
index fc2777770768..de165623fa86 100644
--- a/include/linux/errseq.h
+++ b/include/linux/errseq.h
@@ -9,6 +9,7 @@ typedef u32	errseq_t;
 
 errseq_t errseq_set(errseq_t *eseq, int err);
 errseq_t errseq_sample(errseq_t *eseq);
+errseq_t errseq_scrape(errseq_t *eseq);
 int errseq_check(errseq_t *eseq, errseq_t since);
 int errseq_check_and_advance(errseq_t *eseq, errseq_t *since);
 #endif
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 379a612f8f1d..c39b37fba7f9 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -214,6 +214,7 @@ struct fsxattr {
 #define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
 #define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
 #define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
+#define FS_IOC_GETFSERR			_IOR('e', 1, unsigned int)
 
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
diff --git a/lib/errseq.c b/lib/errseq.c
index 81f9e33aa7e7..8ded0920eed3 100644
--- a/lib/errseq.c
+++ b/lib/errseq.c
@@ -108,7 +108,7 @@ errseq_t errseq_set(errseq_t *eseq, int err)
 EXPORT_SYMBOL(errseq_set);
 
 /**
- * errseq_sample() - Grab current errseq_t value.
+ * errseq_sample() - Grab current errseq_t value (or 0 if it hasn't been seen)
  * @eseq: Pointer to errseq_t to be sampled.
  *
  * This function allows callers to initialise their errseq_t variable.
@@ -117,7 +117,7 @@ EXPORT_SYMBOL(errseq_set);
  * see it the next time it checks for an error.
  *
  * Context: Any context.
- * Return: The current errseq value.
+ * Return: The current errseq value or 0 if it wasn't previously seen
  */
 errseq_t errseq_sample(errseq_t *eseq)
 {
@@ -130,6 +130,35 @@ errseq_t errseq_sample(errseq_t *eseq)
 }
 EXPORT_SYMBOL(errseq_sample);
 
+/**
+ * errseq_scrape() - Grab current errseq_t value
+ * @eseq: Pointer to errseq_t to be sampled.
+ *
+ * This function allows callers to scrape the current value of an errseq_t.
+ * Unlike errseq_sample, this will always return the current value with
+ * the SEEN flag unset, even when the value has not yet been seen.
+ *
+ * Context: Any context.
+ * Return: The current errseq value with ERRSEQ_SEEN masked off
+ */
+errseq_t errseq_scrape(errseq_t *eseq)
+{
+	errseq_t old = READ_ONCE(*eseq);
+
+	/*
+	 * For the common case of no errors ever having been set, we can skip
+	 * marking the SEEN bit. Once an error has been set, the value will
+	 * never go back to zero.
+	 */
+	if (old != 0) {
+		errseq_t new = old | ERRSEQ_SEEN;
+		if (old != new)
+			cmpxchg(eseq, old, new);
+	}
+	return old & ~ERRSEQ_SEEN;
+}
+EXPORT_SYMBOL(errseq_scrape);
+
 /**
  * errseq_check() - Has an error occurred since a particular sample point?
  * @eseq: Pointer to errseq_t value to be checked.
-- 
2.24.1
