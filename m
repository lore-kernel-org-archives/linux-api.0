From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH review 07/11] vfs: Don't create inodes with a uid or gid unknown to the vfs
Date: Sat,  2 Jul 2016 12:20:31 -0500
Message-ID: <20160702172035.19568-7-ebiederm@xmission.com>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160702172035.19568-1-ebiederm@xmission.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160702172035.19568-1-ebiederm@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

It is expected that filesystems can not represent uids and gids from
outside of their user namespace.  Keep things simple by not even
trying to create filesystem nodes with non-sense uids and gids.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namei.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 840201c4c290..629823f19a6a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2814,16 +2814,22 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
  *  1. We can't do it if child already exists (open has special treatment for
  *     this case, but since we are inlined it's OK)
  *  2. We can't do it if dir is read-only (done in permission())
- *  3. We should have write and exec permissions on dir
- *  4. We can't do it if dir is immutable (done in permission())
+ *  3. We can't do it if the fs can't represent the fsuid or fsgid.
+ *  4. We should have write and exec permissions on dir
+ *  5. We can't do it if dir is immutable (done in permission())
  */
 static inline int may_create(struct inode *dir, struct dentry *child)
 {
+	struct user_namespace *s_user_ns;
 	audit_inode_child(dir, child, AUDIT_TYPE_CHILD_CREATE);
 	if (child->d_inode)
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
+	s_user_ns = dir->i_sb->s_user_ns;
+	if (!kuid_has_mapping(s_user_ns, current_fsuid()) ||
+	    !kgid_has_mapping(s_user_ns, current_fsgid()))
+		return -EOVERFLOW;
 	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
 }
 
-- 
2.8.3

