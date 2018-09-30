From: Laurent Vivier <laurent@vivier.eu>
Subject: [RFC 2/2] binfmt_misc: move data to binfmt_namespace
Date: Mon,  1 Oct 2018 01:46:28 +0200
Message-ID: <20180930234628.25528-3-laurent@vivier.eu>
References: <20180930234628.25528-1-laurent@vivier.eu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180930234628.25528-1-laurent@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>, Dmitry Safonov <dima@arista.com>, Andrei Vagin <avagin@openvz.org>, containers@lists.linux-foundation.org, Laurent Vivier <laurent@vivier.eu>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Laurent Vivier <laurent@vivier.eu>
---
 fs/binfmt_misc.c                 | 50 +++++++++++++++++---------------
 include/linux/binfmt_namespace.h | 12 ++++++++
 kernel/binfmt_namespace.c        | 11 +++++++
 3 files changed, 49 insertions(+), 24 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index aa4a7a23ff99..c6148b2bdd19 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -25,6 +25,7 @@
 #include <linux/syscalls.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
+#include <linux/binfmt_namespace.h>
 
 #include "internal.h"
 
@@ -38,9 +39,6 @@ enum {
 	VERBOSE_STATUS = 1 /* make it zero to save 400 bytes kernel memory */
 };
 
-static LIST_HEAD(entries);
-static int enabled = 1;
-
 enum {Enabled, Magic};
 #define MISC_FMT_PRESERVE_ARGV0 (1 << 31)
 #define MISC_FMT_OPEN_BINARY (1 << 30)
@@ -60,10 +58,7 @@ typedef struct {
 	struct file *interp_file;
 } Node;
 
-static DEFINE_RWLOCK(entries_lock);
 static struct file_system_type bm_fs_type;
-static struct vfsmount *bm_mnt;
-static int entry_count;
 
 /*
  * Max length of the register string.  Determined by:
@@ -91,7 +86,7 @@ static Node *check_file(struct linux_binprm *bprm)
 	struct list_head *l;
 
 	/* Walk all the registered handlers. */
-	list_for_each(l, &entries) {
+	list_for_each(l, &binfmt_ns(entries)) {
 		Node *e = list_entry(l, Node, list);
 		char *s;
 		int j;
@@ -135,15 +130,15 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	int fd_binary = -1;
 
 	retval = -ENOEXEC;
-	if (!enabled)
+	if (!binfmt_ns(enabled))
 		return retval;
 
 	/* to keep locking time low, we copy the interpreter string */
-	read_lock(&entries_lock);
+	read_lock(&binfmt_ns(entries_lock));
 	fmt = check_file(bprm);
 	if (fmt)
 		dget(fmt->dentry);
-	read_unlock(&entries_lock);
+	read_unlock(&binfmt_ns(entries_lock));
 	if (!fmt)
 		return retval;
 
@@ -613,15 +608,15 @@ static void kill_node(Node *e)
 {
 	struct dentry *dentry;
 
-	write_lock(&entries_lock);
+	write_lock(&binfmt_ns(entries_lock));
 	list_del_init(&e->list);
-	write_unlock(&entries_lock);
+	write_unlock(&binfmt_ns(entries_lock));
 
 	dentry = e->dentry;
 	drop_nlink(d_inode(dentry));
 	d_drop(dentry);
 	dput(dentry);
-	simple_release_fs(&bm_mnt, &entry_count);
+	simple_release_fs(&binfmt_ns(bm_mnt), &binfmt_ns(entry_count));
 }
 
 /* /<entry> */
@@ -716,7 +711,8 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	if (!inode)
 		goto out2;
 
-	err = simple_pin_fs(&bm_fs_type, &bm_mnt, &entry_count);
+	err = simple_pin_fs(&bm_fs_type, &binfmt_ns(bm_mnt),
+			    &binfmt_ns(entry_count));
 	if (err) {
 		iput(inode);
 		inode = NULL;
@@ -730,7 +726,8 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 		if (IS_ERR(f)) {
 			err = PTR_ERR(f);
 			pr_notice("register: failed to install interpreter file %s\n", e->interpreter);
-			simple_release_fs(&bm_mnt, &entry_count);
+			simple_release_fs(&binfmt_ns(bm_mnt),
+					  &binfmt_ns(entry_count));
 			iput(inode);
 			inode = NULL;
 			goto out2;
@@ -743,9 +740,9 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	inode->i_fop = &bm_entry_operations;
 
 	d_instantiate(dentry, inode);
-	write_lock(&entries_lock);
-	list_add(&e->list, &entries);
-	write_unlock(&entries_lock);
+	write_lock(&binfmt_ns(entries_lock));
+	list_add(&e->list, &binfmt_ns(entries));
+	write_unlock(&binfmt_ns(entries_lock));
 
 	err = 0;
 out2:
@@ -770,7 +767,7 @@ static const struct file_operations bm_register_operations = {
 static ssize_t
 bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	char *s = enabled ? "enabled\n" : "disabled\n";
+	char *s = binfmt_ns(enabled) ? "enabled\n" : "disabled\n";
 
 	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
@@ -784,19 +781,20 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 	switch (res) {
 	case 1:
 		/* Disable all handlers. */
-		enabled = 0;
+		binfmt_ns(enabled) = 0;
 		break;
 	case 2:
 		/* Enable all handlers. */
-		enabled = 1;
+		binfmt_ns(enabled) = 1;
 		break;
 	case 3:
 		/* Delete all handlers. */
 		root = file_inode(file)->i_sb->s_root;
 		inode_lock(d_inode(root));
 
-		while (!list_empty(&entries))
-			kill_node(list_first_entry(&entries, Node, list));
+		while (!list_empty(&binfmt_ns(entries)))
+			kill_node(list_first_entry(&binfmt_ns(entries),
+						   Node, list));
 
 		inode_unlock(d_inode(root));
 		break;
@@ -838,7 +836,10 @@ static int bm_fill_super(struct super_block *sb, void *data, int silent)
 static struct dentry *bm_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	return mount_single(fs_type, flags, data, bm_fill_super);
+	struct binfmt_namespace *binfmt_ns =  current->nsproxy->binfmt_ns;
+
+	return mount_ns(fs_type, flags, data, binfmt_ns, binfmt_ns->user_ns,
+			bm_fill_super);
 }
 
 static struct linux_binfmt misc_format = {
@@ -849,6 +850,7 @@ static struct linux_binfmt misc_format = {
 static struct file_system_type bm_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "binfmt_misc",
+	.fs_flags	= FS_USERNS_MOUNT,
 	.mount		= bm_mount,
 	.kill_sb	= kill_litter_super,
 };
diff --git a/include/linux/binfmt_namespace.h b/include/linux/binfmt_namespace.h
index 8688869ee254..550357ab4f62 100644
--- a/include/linux/binfmt_namespace.h
+++ b/include/linux/binfmt_namespace.h
@@ -7,12 +7,24 @@ extern struct user_namespace init_user_ns;
 
 struct binfmt_namespace {
 	struct kref kref;
+
+	struct list_head entries;
+	rwlock_t entries_lock;
+	int enabled;
+	struct vfsmount *bm_mnt;
+	int entry_count;
+
+	/* user_ns which owns the binfmt_misc ns */
+
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
+
 	struct ns_common ns;
 } __randomize_layout;
 extern struct binfmt_namespace init_binfmt_ns;
 
+#define binfmt_ns(a) (current->nsproxy->binfmt_ns->a)
+
 #ifdef CONFIG_BINFMT_NS
 static inline void get_binfmt_ns(struct binfmt_namespace *ns)
 {
diff --git a/kernel/binfmt_namespace.c b/kernel/binfmt_namespace.c
index 63a80bcd70df..22be49beee08 100644
--- a/kernel/binfmt_namespace.c
+++ b/kernel/binfmt_namespace.c
@@ -48,6 +48,12 @@ static struct binfmt_namespace *clone_binfmt_ns(struct user_namespace *user_ns,
 	if (err)
 		goto fail_free;
 
+	INIT_LIST_HEAD(&ns->entries);
+	ns->enabled = 1;
+	rwlock_init(&ns->entries_lock);
+	ns->bm_mnt = NULL;
+	ns->entry_count = 0;
+
 	ns->ucounts = ucounts;
 	ns->ns.ops = &binfmtns_operations;
 	ns->user_ns = get_user_ns(user_ns);
@@ -140,6 +146,9 @@ const struct proc_ns_operations binfmtns_operations = {
 struct binfmt_namespace init_binfmt_ns = {
 	.kref = KREF_INIT(2),
 	.user_ns = &init_user_ns,
+	.enabled = 1,
+	.entry_count = 0,
+	.bm_mnt = NULL,
 	.ns.inum = PROC_BINFMT_INIT_INO,
 #ifdef CONFIG_BINFMT_NS
 	.ns.ops = &binfmtns_operations,
@@ -148,6 +157,8 @@ struct binfmt_namespace init_binfmt_ns = {
 
 static int __init binfmt_ns_init(void)
 {
+	INIT_LIST_HEAD(&init_binfmt_ns.entries);
+	rwlock_init(&init_binfmt_ns.entries_lock);
 	return 0;
 }
 subsys_initcall(binfmt_ns_init);
-- 
2.17.1
