From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 06/10] proc: Allow creating permanently empty directories.
Date: Thu, 14 May 2015 12:34:10 -0500
Message-ID: <87r3qjhxm5.fsf@x220.int.ebiederm.org>
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


Add a new function proc_mk_empty_dir that when used to creates
a directory that can not be added to.

Update the code to use make_empty_dir_inode when reporting
a permanently empty directory to the vfs.

Update the code to not allow adding to permanently empty directories.

Update /proc/openprom and /proc/fs/nfsd to be permanently empty directories.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/proc/generic.c  | 23 +++++++++++++++++++++++
 fs/proc/inode.c    |  3 +++
 fs/proc/internal.h |  1 +
 fs/proc/root.c     |  4 ++--
 4 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index df6327a2b865..e235c1544b22 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -373,6 +373,10 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 		WARN(1, "create '/proc/%s' by hand\n", qstr.name);
 		return NULL;
 	}
+	if (S_ISDIR((*parent)->mode) && ((*parent)->proc_fops == NULL)) {
+		WARN(1, "attempt to add to permanently empty directory");
+		return NULL;
+	}
 
 	ent = kzalloc(sizeof(struct proc_dir_entry) + qstr.len + 1, GFP_KERNEL);
 	if (!ent)
@@ -455,6 +459,25 @@ struct proc_dir_entry *proc_mkdir(const char *name,
 }
 EXPORT_SYMBOL(proc_mkdir);
 
+struct proc_dir_entry *proc_mk_empty_dir(const char *name)
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
index 8272aaba1bb0..b957ec618bda 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -445,6 +445,9 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 					inode->i_fop = &proc_reg_file_ops;
 			} else {
 				inode->i_fop = de->proc_fops;
+				if (S_ISDIR(inode->i_mode) &&
+				    (de->proc_fops == NULL))
+					make_empty_dir_inode(inode);
 			}
 		}
 	} else
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c835b94c0cd3..6bc2e7a12912 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -190,6 +190,7 @@ static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
 	return pde;
 }
 extern void pde_put(struct proc_dir_entry *);
+struct proc_dir_entry *proc_mk_empty_dir(const char *name);
 
 /*
  * inode.c
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 64e1ab64bde6..b031fc3991c3 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -179,10 +179,10 @@ void __init proc_root_init(void)
 #endif
 	proc_mkdir("fs", NULL);
 	proc_mkdir("driver", NULL);
-	proc_mkdir("fs/nfsd", NULL); /* somewhere for the nfsd filesystem to be mounted */
+	proc_mk_empty_dir("fs/nfsd"); /* somewhere for the nfsd filesystem to be mounted */
 #if defined(CONFIG_SUN_OPENPROMFS) || defined(CONFIG_SUN_OPENPROMFS_MODULE)
 	/* just give it a mountpoint */
-	proc_mkdir("openprom", NULL);
+	proc_mk_empty_dir("openprom");
 #endif
 	proc_tty_init();
 	proc_mkdir("bus", NULL);
-- 
2.2.1
