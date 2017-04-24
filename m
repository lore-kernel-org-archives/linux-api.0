From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [patch v4 resend 1/2] procfs: fdinfo -- Extend information about epoll target files
Date: Mon, 24 Apr 2017 18:39:27 +0300
Message-ID: <20170424154423.436491881@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=epoll-fdinfo-2
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Since it is possbile to have same number in tfd field (say
file added, closed, then nother file dup'ed to same number
and added back) it is imposible to distinguish such target
files solely by their numbers.

Strictly speaking regular applications don't need to recognize
these targets at all but for checkpoint/restore sake we need
to collect targets to be able to push them back on restore
stage in a proper order.

Thus lets add file position, inode and device number where
this target lays. This three fields can be used as a primary
key for sorting, and together with kcmp help CRIU can find
out an exact file target (from the whole set of processes
being checkpointed).

Signed-off-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
CC: Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
CC: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
---
 Documentation/filesystems/proc.txt |    6 +++++-
 fs/eventpoll.c                     |    8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

Index: linux-ml.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-ml.git.orig/Documentation/filesystems/proc.txt
+++ linux-ml.git/Documentation/filesystems/proc.txt
@@ -1779,12 +1779,16 @@ pair provide additional information part
 	pos:	0
 	flags:	02
 	mnt_id:	9
-	tfd:        5 events:       1d data: ffffffffffffffff
+	tfd:        5 events:       1d data: ffffffffffffffff pos:0 ino:61af sdev:7
 
 	where 'tfd' is a target file descriptor number in decimal form,
 	'events' is events mask being watched and the 'data' is data
 	associated with a target [see epoll(7) for more details].
 
+	The 'pos' is current offset of the target file in decimal form
+	[see lseek(2)], 'ino' and 'sdev' are inode and device numbers
+	where target file resides, all in hex format.
+
 	Fsnotify files
 	~~~~~~~~~~~~~~
 	For inotify files the format is the following
Index: linux-ml.git/fs/eventpoll.c
===================================================================
--- linux-ml.git.orig/fs/eventpoll.c
+++ linux-ml.git/fs/eventpoll.c
@@ -883,10 +883,14 @@ static void ep_show_fdinfo(struct seq_fi
 	mutex_lock(&ep->mtx);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
+		struct inode *inode = file_inode(epi->ffd.file);
 
-		seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
+		seq_printf(m, "tfd: %8d events: %8x data: %16llx "
+			   " pos:%lli ino:%lx sdev:%x\n",
 			   epi->ffd.fd, epi->event.events,
-			   (long long)epi->event.data);
+			   (long long)epi->event.data,
+			   (long long)epi->ffd.file->f_pos,
+			   inode->i_ino, inode->i_sb->s_dev);
 		if (seq_has_overflowed(m))
 			break;
 	}
