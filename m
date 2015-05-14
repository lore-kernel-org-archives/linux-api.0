From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 02/10] mnt: Modify fs_fully_visible to deal with mount
	attributes
Date: Thu, 14 May 2015 12:32:09 -0500
Message-ID: <87egmjjc9y.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87pp63jcca.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Thu, 14 May 2015 12:30:45 -0500")
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
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Ignore an existing mount if it's locked attributes are less permissive
than the new mounts attributes.

On success ensure the new mount locks all of the same attributes as
the old mount.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/namespace.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 8e7edaf60fe1..fccee9924e8c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2332,7 +2332,7 @@ unlock:
 	return err;
 }
 
-static bool fs_fully_visible(struct file_system_type *fs_type);
+static bool fs_fully_visible(struct file_system_type *fs_type, int *new_mnt_flags);
 
 /*
  * create a new mount for userspace and request it to be added into the
@@ -2366,7 +2366,7 @@ static int do_new_mount(struct path *path, const char *fstype, int flags,
 			mnt_flags |= MNT_NODEV | MNT_LOCK_NODEV;
 		}
 		if (type->fs_flags & FS_USERNS_VISIBLE) {
-			if (!fs_fully_visible(type))
+			if (!fs_fully_visible(type, &mnt_flags))
 				return -EPERM;
 		}
 	}
@@ -3170,9 +3170,10 @@ bool current_chrooted(void)
 	return chrooted;
 }
 
-static bool fs_fully_visible(struct file_system_type *type)
+static bool fs_fully_visible(struct file_system_type *type, int *new_mnt_flags)
 {
 	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
+	int new_flags = *new_mnt_flags;
 	struct mount *mnt;
 	bool visible = false;
 
@@ -3191,6 +3192,25 @@ static bool fs_fully_visible(struct file_system_type *type)
 		if (mnt->mnt.mnt_root != mnt->mnt.mnt_sb->s_root)
 			continue;
 
+		/* Verify the mount flags are equal to or more permissive
+		 * than the proposed new mount.
+		 */
+		if ((mnt->mnt.mnt_flags & MNT_LOCK_READONLY) &&
+		    !(new_flags & MNT_READONLY))
+			continue;
+		if ((mnt->mnt.mnt_flags & MNT_LOCK_NODEV) &&
+		    !(new_flags & MNT_NODEV))
+			continue;
+		if ((mnt->mnt.mnt_flags & MNT_LOCK_NOSUID) &&
+		    !(new_flags & MNT_NOSUID))
+			continue;
+		if ((mnt->mnt.mnt_flags & MNT_LOCK_NOEXEC) &&
+		    !(new_flags & MNT_NOEXEC))
+			continue;
+		if ((mnt->mnt.mnt_flags & MNT_LOCK_ATIME) &&
+		    ((mnt->mnt.mnt_flags & MNT_ATIME_MASK) != (new_flags & MNT_ATIME_MASK)))
+			continue;
+
 		/* This mount is not fully visible if there are any child mounts
 		 * that cover anything except for empty directories.
 		 */
@@ -3201,6 +3221,12 @@ static bool fs_fully_visible(struct file_system_type *type)
 			if (inode->i_nlink > 2)
 				goto next;
 		}
+		/* Preserve the locked attributes */
+		*new_mnt_flags |= mnt->mnt.mnt_flags & (MNT_LOCK_READONLY | \
+							MNT_LOCK_NODEV    | \
+							MNT_LOCK_NOSUID   | \
+							MNT_LOCK_NOEXEC   | \
+							MNT_LOCK_ATIME);
 		visible = true;
 		goto found;
 	next:	;
-- 
2.2.1
