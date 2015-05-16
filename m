From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 06/10] proc: Allow creating permanently empty directories that serve as mount points
Date: Fri, 15 May 2015 21:08:59 -0500
Message-ID: <87siaxtgsk.fsf_-_@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<87siaxuvik.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87siaxuvik.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Fri, 15 May 2015 21:05:39 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Add a new function proc_create_mount_point that when used to creates a
directory that can not be added to.

Add a new function is_empty_pde to test if a function is a mount
point.

Update the code to use make_empty_dir_inode when reporting
a permanently empty directory to the vfs.

Update the code to not allow adding to permanently empty directories.

Update /proc/openprom and /proc/fs/nfsd to be permanently empty directories.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/proc/generic.c  | 23 +++++++++++++++++++++++
 fs/proc/inode.c    |  4 ++++
 fs/proc/internal.h |  6 ++++++
 fs/proc/root.c     |  4 ++--
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index df6327a2b865..e5dee5c3188e 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -373,6 +373,10 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 		WARN(1, "create '/proc/%s' by hand\n", qstr.name);
 		return NULL;
 	}
+	if (is_empty_pde(*parent)) {
+		WARN(1, "attempt to add to permanently empty directory");
+		return NULL;
+	}
 
 	ent = kzalloc(sizeof(struct proc_dir_entry) + qstr.len + 1, GFP_KERNEL);
 	if (!ent)
@@ -455,6 +459,25 @@ struct proc_dir_entry *proc_mkdir(const char *name,
 }
 EXPORT_SYMBOL(proc_mkdir);
 
+struct proc_dir_entry *proc_create_mount_point(const char *name)
+{
+	umode_t mode = S_IFDIR | S_IRUGO | S_IXUGO;
+	struct proc_dir_entry *ent, *parent = NULL;
+
+	ent = __proc_create(&parent, name, mode, 2);
+	if (ent) {
+		ent->data = NULL;
+		ent->proc_fops = NULL;
+		ent->proc_iops = NULL;
+		if (proc_register(parent, ent) < 0) {
+			kfree(ent);
+			parent->nlink--;
+			ent = NULL;
+		}
+	}
+	return ent;
+}
+
 struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
 					struct proc_dir_entry *parent,
 					const struct file_operations *proc_fops,
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 8272aaba1bb0..e3eb5524639f 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -423,6 +423,10 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 		PROC_I(inode)->pde = de;
 
+		if (is_empty_pde(de)) {
+			make_empty_dir_inode(inode);
+			return inode;
+		}
 		if (de->mode) {
 			inode->i_mode = de->mode;
 			inode->i_uid = de->uid;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c835b94c0cd3..aa2781095bd1 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -191,6 +191,12 @@ static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
 }
 extern void pde_put(struct proc_dir_entry *);
 
+static inline bool is_empty_pde(const struct proc_dir_entry *pde)
+{
+	return S_ISDIR(pde->mode) && !pde->proc_iops;
+}
+struct proc_dir_entry *proc_create_mount_point(const char *name);
+
 /*
  * inode.c
  */
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 64e1ab64bde6..68feb0f70e63 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -179,10 +179,10 @@ void __init proc_root_init(void)
 #endif
 	proc_mkdir("fs", NULL);
 	proc_mkdir("driver", NULL);
-	proc_mkdir("fs/nfsd", NULL); /* somewhere for the nfsd filesystem to be mounted */
+	proc_create_mount_point("fs/nfsd"); /* somewhere for the nfsd filesystem to be mounted */
 #if defined(CONFIG_SUN_OPENPROMFS) || defined(CONFIG_SUN_OPENPROMFS_MODULE)
 	/* just give it a mountpoint */
-	proc_mkdir("openprom", NULL);
+	proc_create_mount_point("openprom");
 #endif
 	proc_tty_init();
 	proc_mkdir("bus", NULL);
-- 
2.2.1
