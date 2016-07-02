From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH review 11/11] fs: Update i_[ug]id_(read|write) to translate
	relative to s_user_ns
Date: Sat,  2 Jul 2016 12:20:35 -0500
Message-ID: <20160702172035.19568-11-ebiederm@xmission.com>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	<20160702172035.19568-1-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160702172035.19568-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

For filesystems mounted from a user namespace on-disk ids should
be translated relative to s_users_ns rather than init_user_ns.

When an id in the filesystem doesn't exist in s_user_ns the
associated id in the inode will be set to INVALID_[UG]ID, which
turns these into de facto "nobody" ids. This actually maps pretty
well into the way most code already works, and those places where
it didn't were fixed in previous patches. Moving forward vfs code
needs to be careful to handle instances where ids in inodes may
be invalid.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
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
