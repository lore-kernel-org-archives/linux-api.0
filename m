From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [REVIEW][PATCH 2/2] mnt: fs_fully_visible enforce noexec and nosuid
	if !SB_I_NOEXEC
Date: Fri, 10 Jul 2015 11:18:17 -0500
Message-ID: <87bnfkyoja.fsf_-_@x220.int.ebiederm.org>
References: <87381eyz26.fsf@x220.int.ebiederm.org>
	<CA+55aFysKDXr2HEwNzm3z9QOw=E4ZeWcvYQ-xLhy5_k+rGbeRg@mail.gmail.com>
	<87pp4eqktr.fsf@x220.int.ebiederm.org>
	<CA+55aFw-DK-xDC-3HYa=BMX8WNyQgT9O01tihrAS9+-7PPj_jA@mail.gmail.com>
	<20150704231118.GT17109@ZenIV.linux.org.uk>
	<87mvz4yomp.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87mvz4yomp.fsf_-_-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Fri, 10 Jul 2015 11:16:14 -0500")
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
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ivan Delalande <colona-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org


The filesystems proc and sysfs do not have executable files do not
have exectuable files today and portions of userspace break if we do
enforce nosuid and noexec consistency of nosuid and noexec flags
between previous mounts and new mounts of proc and sysfs.

Add the code to enforce consistency of the nosuid and noexec flags,
and use the presence of SB_I_NOEXEC to signal that there is no need to
bother.

This results in a completely userspace invisible change that makes it
clear fs_fully_visible can only skip the enforcement of noexec and
nosuid because it is known the filesystems in question do not support
executables.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/namespace.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c7cb8a526c05..ce428cadd41f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3194,6 +3194,8 @@ static bool fs_fully_visible(struct file_system_type *type, int *new_mnt_flags)
 	down_read(&namespace_sem);
 	list_for_each_entry(mnt, &ns->list, mnt_list) {
 		struct mount *child;
+		int mnt_flags;
+
 		if (mnt->mnt.mnt_sb->s_type != type)
 			continue;
 
@@ -3203,17 +3205,30 @@ static bool fs_fully_visible(struct file_system_type *type, int *new_mnt_flags)
 		if (mnt->mnt.mnt_root != mnt->mnt.mnt_sb->s_root)
 			continue;
 
+		/* Read the mount flags and filter out flags that
+		 * may safely be ignored.
+		 */
+		mnt_flags = mnt->mnt.mnt_flags;
+		if (mnt->mnt.mnt_sb->s_iflags & SB_I_NOEXEC)
+			mnt_flags &= ~(MNT_LOCK_NOSUID | MNT_LOCK_NOEXEC);
+
 		/* Verify the mount flags are equal to or more permissive
 		 * than the proposed new mount.
 		 */
-		if ((mnt->mnt.mnt_flags & MNT_LOCK_READONLY) &&
+		if ((mnt_flags & MNT_LOCK_READONLY) &&
 		    !(new_flags & MNT_READONLY))
 			continue;
-		if ((mnt->mnt.mnt_flags & MNT_LOCK_NODEV) &&
+		if ((mnt_flags & MNT_LOCK_NODEV) &&
 		    !(new_flags & MNT_NODEV))
 			continue;
-		if ((mnt->mnt.mnt_flags & MNT_LOCK_ATIME) &&
-		    ((mnt->mnt.mnt_flags & MNT_ATIME_MASK) != (new_flags & MNT_ATIME_MASK)))
+		if ((mnt_flags & MNT_LOCK_NOSUID) &&
+		    !(new_flags & MNT_NOSUID))
+			continue;
+		if ((mnt_flags & MNT_LOCK_NOEXEC) &&
+		    !(new_flags & MNT_NOEXEC))
+			continue;
+		if ((mnt_flags & MNT_LOCK_ATIME) &&
+		    ((mnt_flags & MNT_ATIME_MASK) != (new_flags & MNT_ATIME_MASK)))
 			continue;
 
 		/* This mount is not fully visible if there are any
@@ -3223,16 +3238,18 @@ static bool fs_fully_visible(struct file_system_type *type, int *new_mnt_flags)
 		list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
 			struct inode *inode = child->mnt_mountpoint->d_inode;
 			/* Only worry about locked mounts */
-			if (!(mnt->mnt.mnt_flags & MNT_LOCKED))
+			if (!(mnt_flags & MNT_LOCKED))
 				continue;
 			/* Is the directory permanetly empty? */
 			if (!is_empty_dir_inode(inode))
 				goto next;
 		}
 		/* Preserve the locked attributes */
-		*new_mnt_flags |= mnt->mnt.mnt_flags & (MNT_LOCK_READONLY | \
-							MNT_LOCK_NODEV    | \
-							MNT_LOCK_ATIME);
+		*new_mnt_flags |= mnt_flags & (MNT_LOCK_READONLY | \
+					       MNT_LOCK_NODEV    | \
+					       MNT_LOCK_NOSUID   | \
+					       MNT_LOCK_NOEXEC   | \
+					       MNT_LOCK_ATIME);
 		visible = true;
 		goto found;
 	next:	;
-- 
2.2.1
