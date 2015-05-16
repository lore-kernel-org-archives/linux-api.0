From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [CFT][PATCH 02/10] mnt: Modify fs_fully_visible to deal with mount attributes
Date: Fri, 15 May 2015 21:06:56 -0500
Message-ID: <87h9rduvgf.fsf_-_@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<87siaxuvik.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87siaxuvik.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Fri, 15 May 2015 21:05:39 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk <mtk.manpages@gmail.com>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org


Ignore an existing mount if it's locked attributes are less permissive
than the new mounts attributes.

On success ensure the new mount locks all of the same attributes as
the old mount.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
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

