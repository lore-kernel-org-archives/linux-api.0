From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 3/6] quota: mangle statfs result according to project
 quota usage and limits
Date: Wed, 11 Feb 2015 18:11:49 +0300
Message-ID: <20150211151149.6717.10971.stgit@buzz>
References: <20150211151146.6717.62017.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150211151146.6717.62017.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, Dave Chinner <david@fromorbit.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>, Dmitry Monakhov <dmonakhov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Li Xi <pkuelelixi@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

This patch updates amount of available space and inodes returned by
vfs_statfs() according to project quota for this directory.
This works only if sysctl fs.protected_projects = 1.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/quota/dquot.c         |   56 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/statfs.c              |    5 +++-
 include/linux/quotaops.h |    5 ++++
 3 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index afa5f67..e3dfac8 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -65,6 +65,7 @@
 #include <linux/stat.h>
 #include <linux/tty.h>
 #include <linux/file.h>
+#include <linux/statfs.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/init.h>
@@ -1242,15 +1243,20 @@ static void flush_warnings(struct dquot_warn *warn)
 	}
 }
 
-static int ignore_hardlimit(struct dquot *dquot)
+static bool sb_ignore_hardlimit(struct super_block *sb, int type)
 {
-	struct mem_dqinfo *info = &sb_dqopt(dquot->dq_sb)->info[dquot->dq_id.type];
+	struct mem_dqinfo *info = sb_dqinfo(sb, type);
 
 	return capable(CAP_SYS_RESOURCE) &&
 	       (info->dqi_format->qf_fmt_id != QFMT_VFS_OLD ||
 		!(info->dqi_flags & DQF_ROOT_SQUASH));
 }
 
+static bool ignore_hardlimit(struct dquot *dquot)
+{
+	return sb_ignore_hardlimit(dquot->dq_sb, dquot->dq_id.type);
+}
+
 /* needs dq_data_lock */
 static int check_idq(struct dquot *dquot, qsize_t inodes,
 		     struct dquot_warn *warn)
@@ -2022,6 +2028,52 @@ int dquot_file_open(struct inode *inode, struct file *file)
 }
 EXPORT_SYMBOL(dquot_file_open);
 
+void dquot_mangle_statfs(const struct path *path, struct kstatfs *buf)
+{
+	struct inode *inode = path->dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	u64 blimit = 0, ilimit = 0, busage, iusage;
+	struct dquot **dquots;
+
+	if (!sysctl_protected_projects ||
+	    !sb_has_quota_limits_enabled(sb, PRJQUOTA) ||
+	    sb_ignore_hardlimit(sb, PRJQUOTA))
+		return;
+
+	dquots = i_dquot(inode);
+	if (!dquots[PRJQUOTA])
+		return;
+
+	spin_lock(&dq_data_lock);
+	if (dquots[PRJQUOTA]) {
+		struct mem_dqblk *dm = &(dquots[PRJQUOTA]->dq_dqb);
+
+		blimit = dm->dqb_bsoftlimit ?: dm->dqb_bhardlimit;
+		busage = dm->dqb_curspace + dm->dqb_rsvspace;
+		ilimit = dm->dqb_isoftlimit ?: dm->dqb_ihardlimit;
+		iusage = dm->dqb_curinodes;
+	}
+	spin_unlock(&dq_data_lock);
+
+	if (blimit) {
+		u64 bavail = (blimit <= busage) ? 0 :
+			div64_long(blimit - busage, buf->f_bsize);
+
+		if (buf->f_bavail > bavail)
+			buf->f_bavail = bavail;
+	}
+
+	if (ilimit) {
+		u64 iavail = (ilimit <= iusage) ? 0 : (ilimit - iusage);
+
+		if (buf->f_ffree > iavail) {
+			/* Cut count of "free" inodes but keep "used" */
+			buf->f_files -= buf->f_ffree - iavail;
+			buf->f_ffree = iavail;
+		}
+	}
+}
+
 /*
  * Turn quota off on a device. type == -1 ==> quotaoff for all types (umount)
  */
diff --git a/fs/statfs.c b/fs/statfs.c
index 083dc0a..3fa6192 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -7,6 +7,7 @@
 #include <linux/statfs.h>
 #include <linux/security.h>
 #include <linux/uaccess.h>
+#include <linux/quotaops.h>
 #include "internal.h"
 
 static int flags_by_mnt(int mnt_flags)
@@ -68,8 +69,10 @@ int vfs_statfs(struct path *path, struct kstatfs *buf)
 	int error;
 
 	error = statfs_by_dentry(path->dentry, buf);
-	if (!error)
+	if (!error) {
 		buf->f_flags = calculate_f_flags(path->mnt);
+		dquot_mangle_statfs(path, buf);
+	}
 	return error;
 }
 EXPORT_SYMBOL(vfs_statfs);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index ba54745..42fe4d9 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -85,6 +85,7 @@ int dquot_commit_info(struct super_block *sb, int type);
 int dquot_mark_dquot_dirty(struct dquot *dquot);
 
 int dquot_file_open(struct inode *inode, struct file *file);
+void dquot_mangle_statfs(const struct path *path, struct kstatfs *buf);
 
 int dquot_enable(struct inode *inode, int type, int format_id,
 	unsigned int flags);
@@ -275,6 +276,10 @@ static inline int dquot_resume(struct super_block *sb, int type)
 
 #define dquot_file_open		generic_file_open
 
+static inline void dquot_mangle_statfs(struct path *path, struct kstatfs *buf)
+{
+}
+
 static inline int dquot_writeback_dquots(struct super_block *sb, int type)
 {
 	return 0;
