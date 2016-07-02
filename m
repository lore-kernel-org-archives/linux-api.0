From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH review 04/11] fs: Check for invalid i_uid in may_follow_link()
Date: Sat,  2 Jul 2016 12:20:28 -0500
Message-ID: <20160702172035.19568-4-ebiederm@xmission.com>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160702172035.19568-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160702172035.19568-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Filesystem uids which don't map into a user namespace may result
in inode->i_uid being INVALID_UID. A symlink and its parent
could have different owners in the filesystem can both get
mapped to INVALID_UID, which may result in following a symlink
when this would not have otherwise been permitted when protected
symlinks are enabled.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/namei.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 757a32725d92..8701bd9a5270 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -901,6 +901,7 @@ static inline int may_follow_link(struct nameidata *nd)
 {
 	const struct inode *inode;
 	const struct inode *parent;
+	kuid_t puid;
 
 	if (!sysctl_protected_symlinks)
 		return 0;
@@ -916,7 +917,8 @@ static inline int may_follow_link(struct nameidata *nd)
 		return 0;
 
 	/* Allowed if parent directory and link owner match. */
-	if (uid_eq(parent->i_uid, inode->i_uid))
+	puid = parent->i_uid;
+	if (uid_valid(puid) && uid_eq(puid, inode->i_uid))
 		return 0;
 
 	if (nd->flags & LOOKUP_RCU)
-- 
2.8.3
