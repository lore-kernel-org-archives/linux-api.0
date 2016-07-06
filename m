From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH review 12/12] fs: Update i_[ug]id_(read|write) to translate relative to s_user_ns
Date: Wed,  6 Jul 2016 13:12:12 -0500
Message-ID: <20160706181212.16267-12-ebiederm@xmission.com>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
 <20160706181212.16267-1-ebiederm@xmission.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160706181212.16267-1-ebiederm@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: Seth Forshee <seth.forshee@canonical.com>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jann@thejh.net>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>

For filesystems mounted from a user namespace on-disk ids should
be translated relative to s_users_ns rather than init_user_ns.

When an id in the filesystem doesn't exist in s_user_ns the
associated id in the inode will be set to INVALID_[UG]ID, which
turns these into de facto "nobody" ids. This actually maps pretty
well into the way most code already works, and those places where
it didn't were fixed in previous patches. Moving forward vfs code
needs to be careful to handle instances where ids in inodes may
be invalid.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/fs.h | 50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index cb25ceb6d1ef..8aa9b72e0bc5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -831,31 +831,6 @@ static inline void i_size_write(struct inode *inode, loff_t i_size)
 #endif
 }
 
-/* Helper functions so that in most cases filesystems will
- * not need to deal directly with kuid_t and kgid_t and can
- * instead deal with the raw numeric values that are stored
- * in the filesystem.
- */
-static inline uid_t i_uid_read(const struct inode *inode)
-{
-	return from_kuid(&init_user_ns, inode->i_uid);
-}
-
-static inline gid_t i_gid_read(const struct inode *inode)
-{
-	return from_kgid(&init_user_ns, inode->i_gid);
-}
-
-static inline void i_uid_write(struct inode *inode, uid_t uid)
-{
-	inode->i_uid = make_kuid(&init_user_ns, uid);
-}
-
-static inline void i_gid_write(struct inode *inode, gid_t gid)
-{
-	inode->i_gid = make_kgid(&init_user_ns, gid);
-}
-
 static inline unsigned iminor(const struct inode *inode)
 {
 	return MINOR(inode->i_rdev);
@@ -1461,6 +1436,31 @@ struct super_block {
 	struct list_head	s_inodes;	/* all inodes */
 };
 
+/* Helper functions so that in most cases filesystems will
+ * not need to deal directly with kuid_t and kgid_t and can
+ * instead deal with the raw numeric values that are stored
+ * in the filesystem.
+ */
+static inline uid_t i_uid_read(const struct inode *inode)
+{
+	return from_kuid(inode->i_sb->s_user_ns, inode->i_uid);
+}
+
+static inline gid_t i_gid_read(const struct inode *inode)
+{
+	return from_kgid(inode->i_sb->s_user_ns, inode->i_gid);
+}
+
+static inline void i_uid_write(struct inode *inode, uid_t uid)
+{
+	inode->i_uid = make_kuid(inode->i_sb->s_user_ns, uid);
+}
+
+static inline void i_gid_write(struct inode *inode, gid_t gid)
+{
+	inode->i_gid = make_kgid(inode->i_sb->s_user_ns, gid);
+}
+
 extern struct timespec current_fs_time(struct super_block *sb);
 
 /*
-- 
2.8.3

