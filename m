From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 10/10] mnt: Update fs_fully_visible to test for permanently empty directories
Date: Thu, 14 May 2015 12:37:02 -0500
Message-ID: <87382zhxhd.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87pp63jcca.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Thu, 14 May 2015 12:30:45 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


fs_fully_visible attempts to make fresh mounts of proc and sysfs give
the mounter no more access to proc and sysfs than if they could have
by creating a bind mount.  One aspect of proc and sysfs that makes
this particularly tricky is that there are other filesystems that
typically mount on top of proc and sysfs.  As those filesystems are
mounted on empty directories in practice it is safe to ignore them.
However testing to ensure filesystems are mounted on empty directories
has not been something the in kernel data structures have supported so
the current test for an empty directory which checks to see
if nlink <= 2 is a bit lacking.

proc and sysfs have recently been modified to use the new empty_dir
infrastructure to create all of their dedicated mount points.  Instead
of testing for S_ISDIR(inode->i_mode) && i_nlink <= 2 to see if a
directory is empty, test for is_empty_dir_inode(inode).  That small
change guaranteess mounts found on proc and sysfs really are safe to
ignore, because the directories are not only empty but nothing can
ever be added to them.  This guarantees there is nothing to worry
about when mounting proc and sysfs.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/namespace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 3ede0669b8d2..eccd925c6e82 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3220,9 +3220,8 @@ static bool fs_fully_visible(struct file_system_type *type, int *new_mnt_flags)
 			/* Only worry about locked mounts */
 			if (!(mnt->mnt.mnt_flags & MNT_LOCKED))
 				continue;
-			if (!S_ISDIR(inode->i_mode))
-				goto next;
-			if (inode->i_nlink > 2)
+			/* Is the directory permanetly empty? */
+			if (!is_empty_dir_inode(inode))
 				goto next;
 		}
 		/* Preserve the locked attributes */
-- 
2.2.1
