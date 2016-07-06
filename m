From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH review 07/12] vfs: Don't create inodes with a uid or gid unknown to the vfs
Date: Wed,  6 Jul 2016 13:12:07 -0500
Message-ID: <20160706181212.16267-7-ebiederm@xmission.com>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
 <20160706181212.16267-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160706181212.16267-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

It is expected that filesystems can not represent uids and gids from
outside of their user namespace.  Keep things simple by not even
trying to create filesystem nodes with non-sense uids and gids.

Acked-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
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
