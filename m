From: Laurent Vivier <laurent@vivier.eu>
Subject: [RFC v4 1/1] ns: add binfmt_misc to the user namespace
Date: Sat,  6 Oct 2018 21:35:46 +0200
Message-ID: <20181006193546.29340-2-laurent@vivier.eu>
References: <20181006193546.29340-1-laurent@vivier.eu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181006193546.29340-1-laurent@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrei Vagin <avagin@gmail.com>, linux-fsdevel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, Dmitry Safonov <dima@arista.com>, containers@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Laurent Vivier <laurent@vivier.eu>
List-Id: linux-api@vger.kernel.org

This patch allows to have a different binfmt_misc configuration
for each new user namespace. By default, the binfmt_misc configuration
is the one of the previous level, but if the binfmt_misc filesystem is
mounted in the new namespace a new empty binfmt instance is created and
used in this namespace.

For instance, using "unshare" we can start a chroot of an another
architecture and configure the binfmt_misc interpreter without being root
to run the binaries in this chroot.

Signed-off-by: Laurent Vivier <laurent@vivier.eu>
---
 fs/binfmt_misc.c               | 99 ++++++++++++++++++++++++----------
 include/linux/user_namespace.h | 13 +++++
 kernel/user.c                  | 13 +++++
 kernel/user_namespace.c        |  7 +++
 4 files changed, 104 insertions(+), 28 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index aa4a7a23ff99..1beefafcb416 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -38,9 +38,6 @@ enum {
 	VERBOSE_STATUS = 1 /* make it zero to save 400 bytes kernel memory */
 };
 
-static LIST_HEAD(entries);
-static int enabled = 1;
-
 enum {Enabled, Magic};
 #define MISC_FMT_PRESERVE_ARGV0 (1 << 31)
 #define MISC_FMT_OPEN_BINARY (1 << 30)
@@ -60,10 +57,7 @@ typedef struct {
 	struct file *interp_file;
 } Node;
 
-static DEFINE_RWLOCK(entries_lock);
 static struct file_system_type bm_fs_type;
-static struct vfsmount *bm_mnt;
-static int entry_count;
 
 /*
  * Max length of the register string.  Determined by:
@@ -80,18 +74,28 @@ static int entry_count;
  */
 #define MAX_REGISTER_LENGTH 1920
 
+static struct binfmt_namespace *binfmt_ns(struct user_namespace *ns)
+{
+	while (ns) {
+		if (ns->binfmt_ns)
+			return ns->binfmt_ns;
+		ns = ns->parent;
+	}
+	return NULL;
+}
+
 /*
  * Check if we support the binfmt
  * if we do, return the node, else NULL
  * locking is done in load_misc_binary
  */
-static Node *check_file(struct linux_binprm *bprm)
+static Node *check_file(struct binfmt_namespace *ns, struct linux_binprm *bprm)
 {
 	char *p = strrchr(bprm->interp, '.');
 	struct list_head *l;
 
 	/* Walk all the registered handlers. */
-	list_for_each(l, &entries) {
+	list_for_each(l, &ns->entries) {
 		Node *e = list_entry(l, Node, list);
 		char *s;
 		int j;
@@ -133,17 +137,18 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	struct file *interp_file = NULL;
 	int retval;
 	int fd_binary = -1;
+	struct binfmt_namespace *ns = binfmt_ns(current_user_ns());
 
 	retval = -ENOEXEC;
-	if (!enabled)
+	if (!ns->enabled)
 		return retval;
 
 	/* to keep locking time low, we copy the interpreter string */
-	read_lock(&entries_lock);
-	fmt = check_file(bprm);
+	read_lock(&ns->entries_lock);
+	fmt = check_file(ns, bprm);
 	if (fmt)
 		dget(fmt->dentry);
-	read_unlock(&entries_lock);
+	read_unlock(&ns->entries_lock);
 	if (!fmt)
 		return retval;
 
@@ -609,19 +614,19 @@ static void bm_evict_inode(struct inode *inode)
 	kfree(e);
 }
 
-static void kill_node(Node *e)
+static void kill_node(struct binfmt_namespace *ns, Node *e)
 {
 	struct dentry *dentry;
 
-	write_lock(&entries_lock);
+	write_lock(&ns->entries_lock);
 	list_del_init(&e->list);
-	write_unlock(&entries_lock);
+	write_unlock(&ns->entries_lock);
 
 	dentry = e->dentry;
 	drop_nlink(d_inode(dentry));
 	d_drop(dentry);
 	dput(dentry);
-	simple_release_fs(&bm_mnt, &entry_count);
+	simple_release_fs(&ns->bm_mnt, &ns->entry_count);
 }
 
 /* /<entry> */
@@ -651,6 +656,9 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 	struct dentry *root;
 	Node *e = file_inode(file)->i_private;
 	int res = parse_command(buffer, count);
+	struct binfmt_namespace *ns;
+
+	ns = binfmt_ns(file->f_path.dentry->d_sb->s_user_ns);
 
 	switch (res) {
 	case 1:
@@ -667,7 +675,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 		inode_lock(d_inode(root));
 
 		if (!list_empty(&e->list))
-			kill_node(e);
+			kill_node(ns, e);
 
 		inode_unlock(d_inode(root));
 		break;
@@ -693,6 +701,7 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	struct inode *inode;
 	struct super_block *sb = file_inode(file)->i_sb;
 	struct dentry *root = sb->s_root, *dentry;
+	struct binfmt_namespace *ns;
 	int err = 0;
 
 	e = create_entry(buffer, count);
@@ -716,7 +725,9 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	if (!inode)
 		goto out2;
 
-	err = simple_pin_fs(&bm_fs_type, &bm_mnt, &entry_count);
+	ns = binfmt_ns(file->f_path.dentry->d_sb->s_user_ns);
+	err = simple_pin_fs(&bm_fs_type, &ns->bm_mnt,
+			    &ns->entry_count);
 	if (err) {
 		iput(inode);
 		inode = NULL;
@@ -725,12 +736,16 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 
 	if (e->flags & MISC_FMT_OPEN_FILE) {
 		struct file *f;
+		const struct cred *old_cred;
 
+		old_cred = override_creds(file->f_cred);
 		f = open_exec(e->interpreter);
+		revert_creds(old_cred);
 		if (IS_ERR(f)) {
 			err = PTR_ERR(f);
 			pr_notice("register: failed to install interpreter file %s\n", e->interpreter);
-			simple_release_fs(&bm_mnt, &entry_count);
+			simple_release_fs(&ns->bm_mnt,
+					  &ns->entry_count);
 			iput(inode);
 			inode = NULL;
 			goto out2;
@@ -743,9 +758,9 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	inode->i_fop = &bm_entry_operations;
 
 	d_instantiate(dentry, inode);
-	write_lock(&entries_lock);
-	list_add(&e->list, &entries);
-	write_unlock(&entries_lock);
+	write_lock(&ns->entries_lock);
+	list_add(&e->list, &ns->entries);
+	write_unlock(&ns->entries_lock);
 
 	err = 0;
 out2:
@@ -770,7 +785,9 @@ static const struct file_operations bm_register_operations = {
 static ssize_t
 bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	char *s = enabled ? "enabled\n" : "disabled\n";
+	struct binfmt_namespace *ns =
+				binfmt_ns(file->f_path.dentry->d_sb->s_user_ns);
+	char *s = ns->enabled ? "enabled\n" : "disabled\n";
 
 	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
@@ -778,25 +795,28 @@ bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
+	struct binfmt_namespace *ns;
 	int res = parse_command(buffer, count);
 	struct dentry *root;
 
+	ns = binfmt_ns(file->f_path.dentry->d_sb->s_user_ns);
 	switch (res) {
 	case 1:
 		/* Disable all handlers. */
-		enabled = 0;
+		ns->enabled = 0;
 		break;
 	case 2:
 		/* Enable all handlers. */
-		enabled = 1;
+		ns->enabled = 1;
 		break;
 	case 3:
 		/* Delete all handlers. */
 		root = file_inode(file)->i_sb->s_root;
 		inode_lock(d_inode(root));
 
-		while (!list_empty(&entries))
-			kill_node(list_first_entry(&entries, Node, list));
+		while (!list_empty(&ns->entries))
+			kill_node(ns, list_first_entry(&ns->entries,
+						       Node, list));
 
 		inode_unlock(d_inode(root));
 		break;
@@ -838,7 +858,29 @@ static int bm_fill_super(struct super_block *sb, void *data, int silent)
 static struct dentry *bm_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	return mount_single(fs_type, flags, data, bm_fill_super);
+	struct user_namespace *ns = current_user_ns();
+
+	/* create a new binfmt namespace
+	 * if we are not in the first user namespace
+	 * but the binfmt namespace is the first one
+	 */
+	if (ns->binfmt_ns == NULL) {
+		struct binfmt_namespace *new_ns;
+
+		new_ns = kmalloc(sizeof(struct binfmt_namespace),
+				 GFP_KERNEL);
+		if (new_ns == NULL)
+			return ERR_PTR(-ENOMEM);
+		INIT_LIST_HEAD(&new_ns->entries);
+		new_ns->enabled = 1;
+		rwlock_init(&new_ns->entries_lock);
+		new_ns->bm_mnt = NULL;
+		new_ns->entry_count = 0;
+		ns->binfmt_ns = new_ns;
+	}
+
+	return mount_ns(fs_type, flags, data, ns, ns,
+			bm_fill_super);
 }
 
 static struct linux_binfmt misc_format = {
@@ -849,6 +891,7 @@ static struct linux_binfmt misc_format = {
 static struct file_system_type bm_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "binfmt_misc",
+	.fs_flags	= FS_USERNS_MOUNT,
 	.mount		= bm_mount,
 	.kill_sb	= kill_litter_super,
 };
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index d6b74b91096b..5c6e7e63b97e 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -52,6 +52,16 @@ enum ucount_type {
 	UCOUNT_COUNTS,
 };
 
+#if IS_ENABLED(CONFIG_BINFMT_MISC)
+struct binfmt_namespace {
+	struct list_head entries;
+	rwlock_t entries_lock;
+	int enabled;
+	struct vfsmount *bm_mnt;
+	int entry_count;
+} __randomize_layout;
+#endif
+
 struct user_namespace {
 	struct uid_gid_map	uid_map;
 	struct uid_gid_map	gid_map;
@@ -76,6 +86,9 @@ struct user_namespace {
 #endif
 	struct ucounts		*ucounts;
 	int ucount_max[UCOUNT_COUNTS];
+#if IS_ENABLED(CONFIG_BINFMT_MISC)
+	struct binfmt_namespace *binfmt_ns;
+#endif
 } __randomize_layout;
 
 struct ucounts {
diff --git a/kernel/user.c b/kernel/user.c
index 0df9b1640b2a..912916d435aa 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -19,6 +19,16 @@
 #include <linux/user_namespace.h>
 #include <linux/proc_ns.h>
 
+#if IS_ENABLED(CONFIG_BINFMT_MISC)
+static struct binfmt_namespace init_binfmt_ns = {
+	.entries = LIST_HEAD_INIT(init_binfmt_ns.entries),
+	.enabled = 1,
+	.entries_lock = __RW_LOCK_UNLOCKED(init_binfmt_ns.entries_lock),
+	.bm_mnt = NULL,
+	.entry_count = 0,
+};
+#endif
+
 /*
  * userns count is 1 for root user, 1 for init_uts_ns,
  * and 1 for... ?
@@ -66,6 +76,9 @@ struct user_namespace init_user_ns = {
 	.persistent_keyring_register_sem =
 	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
 #endif
+#if IS_ENABLED(CONFIG_BINFMT_MISC)
+	.binfmt_ns = &init_binfmt_ns,
+#endif
 };
 EXPORT_SYMBOL_GPL(init_user_ns);
 
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index e5222b5fb4fe..da4950282ea1 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -140,6 +140,10 @@ int create_user_ns(struct cred *new)
 	if (!setup_userns_sysctls(ns))
 		goto fail_keyring;
 
+#if IS_ENABLED(CONFIG_BINFMT_MISC)
+	ns->binfmt_ns = NULL;
+#endif
+
 	set_cred_user_ns(new, ns);
 	return 0;
 fail_keyring:
@@ -195,6 +199,9 @@ static void free_user_ns(struct work_struct *work)
 			kfree(ns->projid_map.forward);
 			kfree(ns->projid_map.reverse);
 		}
+#if IS_ENABLED(CONFIG_BINFMT_MISC)
+		kfree(ns->binfmt_ns);
+#endif
 		retire_userns_sysctls(ns);
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 		key_put(ns->persistent_keyring_register);
-- 
2.17.1
