From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [CFT][PATCH 05/10] sysctl: Allow creating permanently empty directories.
Date: Thu, 14 May 2015 12:33:41 -0500
Message-ID: <87wq0bhxmy.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87pp63jcca.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 14 May 2015 12:30:45 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org


Add a magic sysctl table permanently_empty_table that when used to
create a directory forces that directory to be permanently empty.

Update the code to use make_empty_dir_inode when accessing permanently
empty directories.

Update the code to not allow adding to permanently empty directories.

Update /proc/sys/fs/binfmt_misc to be a permanently empty directory.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c  | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/sysctl.h |  3 +++
 kernel/sysctl.c        |  8 +-------
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index fea2561d773b..f9ade2caf438 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -19,6 +19,28 @@ static const struct inode_operations proc_sys_inode_operations;
 static const struct file_operations proc_sys_dir_file_operations;
 static const struct inode_operations proc_sys_dir_operations;
 
+/* Support for permanently empty directories */
+
+struct ctl_table permanently_empty_table[] = {
+	{ }
+};
+
+static bool is_empty_dir(struct ctl_table_header *head)
+{
+	return head->ctl_table[0].child == permanently_empty_table;
+}
+
+static void set_empty_dir(struct ctl_dir *dir)
+{
+	dir->header.ctl_table[0].child = permanently_empty_table;
+}
+
+static void clear_empty_dir(struct ctl_dir *dir)
+
+{
+	dir->header.ctl_table[0].child = NULL;
+}
+
 void proc_sys_poll_notify(struct ctl_table_poll *poll)
 {
 	if (!poll)
@@ -187,6 +209,17 @@ static int insert_header(struct ctl_dir *dir, struct ctl_table_header *header)
 	struct ctl_table *entry;
 	int err;
 
+	/* Is this a permanently empty directory? */
+	if (is_empty_dir(&dir->header))
+		return -EROFS;
+
+	/* Am I creating a permanently empty directory? */
+	if (header->ctl_table == permanently_empty_table) {
+		if (!RB_EMPTY_ROOT(&dir->root))
+			return -EINVAL;
+		set_empty_dir(dir);
+	}
+
 	dir->header.nreg++;
 	header->parent = dir;
 	err = insert_links(header);
@@ -202,6 +235,8 @@ fail:
 	erase_header(header);
 	put_links(header);
 fail_links:
+	if (header->ctl_table == permanently_empty_table)
+		clear_empty_dir(dir);
 	header->parent = NULL;
 	drop_sysctl_table(&dir->header);
 	return err;
@@ -419,6 +454,8 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 		inode->i_mode |= S_IFDIR;
 		inode->i_op = &proc_sys_dir_operations;
 		inode->i_fop = &proc_sys_dir_file_operations;
+		if (is_empty_dir(head))
+			make_empty_dir_inode(inode);
 	}
 out:
 	return inode;
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 795d5fea5697..71fd81994a82 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -188,6 +188,9 @@ struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 void unregister_sysctl_table(struct ctl_table_header * table);
 
 extern int sysctl_init(void);
+
+extern struct ctl_table permanently_empty_table[];
+
 #else /* CONFIG_SYSCTL */
 static inline struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
 {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2082b1a88fb9..92f41a43875e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1531,12 +1531,6 @@ static struct ctl_table vm_table[] = {
 	{ }
 };
 
-#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
-static struct ctl_table binfmt_misc_table[] = {
-	{ }
-};
-#endif
-
 static struct ctl_table fs_table[] = {
 	{
 		.procname	= "inode-nr",
@@ -1690,7 +1684,7 @@ static struct ctl_table fs_table[] = {
 	{
 		.procname	= "binfmt_misc",
 		.mode		= 0555,
-		.child		= binfmt_misc_table,
+		.child		= permanently_empty_table,
 	},
 #endif
 	{
-- 
2.2.1

