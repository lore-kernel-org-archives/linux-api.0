From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH review 01/12] fs: Refuse uid/gid changes which don't map into
	s_user_ns
Date: Wed,  6 Jul 2016 13:12:01 -0500
Message-ID: <20160706181212.16267-1-ebiederm@xmission.com>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <874m82bptc.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Add checks to notify_change to verify that uid and gid changes
will map into the superblock's user namespace. If they do not
fail with -EOVERFLOW.

This is mandatory so that fileystems don't have to even think
of dealing with ia_uid and ia_gid that

--EWB Moved the test from inode_change_ok to notify_change

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/attr.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/attr.c b/fs/attr.c
index 25b24d0f6c88..dd723578ddce 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -255,6 +255,17 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 	if (!(attr->ia_valid & ~(ATTR_KILL_SUID | ATTR_KILL_SGID)))
 		return 0;
 
+	/*
+	 * Verify that uid/gid changes are valid in the target
+	 * namespace of the superblock.
+	 */
+	if (ia_valid & ATTR_UID &&
+	    !kuid_has_mapping(inode->i_sb->s_user_ns, attr->ia_uid))
+		return -EOVERFLOW;
+	if (ia_valid & ATTR_GID &&
+	    !kgid_has_mapping(inode->i_sb->s_user_ns, attr->ia_gid))
+		return -EOVERFLOW;
+
 	error = security_inode_setattr(dentry, attr);
 	if (error)
 		return error;
-- 
2.8.3
