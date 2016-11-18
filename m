From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] statx: Ext4: Return enhanced file attributes [ver #2]
Date: Fri, 18 Nov 2016 16:20:45 +0000
Message-ID: <147948604541.5122.3541255475695384526.stgit@warthog.procyon.org.uk>
References: <147948603103.5122.1043337990092830185.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147948603103.5122.1043337990092830185.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Return enhanced file attributes from the Ext4 filesystem.  This includes
the following:

 (1) The inode creation time (i_crtime) as stx_btime, setting STATX_BTIME.

 (2) Certain FS_xxx_FL flags are mapped to stx_attribute flags.

This requires that all ext4 inodes have a getattr call, not just some of
them, so to this end, split the ext4_getattr() function and only call part
of it where appropriate.

Example output:

	[root@andromeda ~]# touch foo
	[root@andromeda ~]# chattr +ai foo
	[root@andromeda ~]# /tmp/test-statx foo
	statx(foo) = 0
	results=fff
	  Size: 0               Blocks: 0          IO Block: 4096    regular file
	Device: 08:12           Inode: 2101950     Links: 1
	Access: (0644/-rw-r--r--)  Uid:     0   Gid:     0
	Access: 2016-02-11 17:08:29.031795451+0000
	Modify: 2016-02-11 17:08:29.031795451+0000
	Change: 2016-02-11 17:11:11.987790114+0000
	 Birth: 2016-02-11 17:08:29.031795451+0000
	Attributes: 0000000000000030 (-------- -------- -------- -------- -------- -------- -------- --ai----)
	IO-blocksize: blksize=4096

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext4/ext4.h    |    2 ++
 fs/ext4/file.c    |    2 +-
 fs/ext4/inode.c   |   36 +++++++++++++++++++++++++++++++++---
 fs/ext4/namei.c   |    2 ++
 fs/ext4/symlink.c |    2 ++
 5 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 282a51b07c57..f65e4a560c4c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2485,6 +2485,8 @@ extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 				struct kstat *stat);
 extern void ext4_evict_inode(struct inode *);
 extern void ext4_clear_inode(struct inode *);
+extern int  ext4_file_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			      struct kstat *stat);
 extern int  ext4_sync_inode(handle_t *, struct inode *);
 extern void ext4_dirty_inode(struct inode *, int);
 extern int ext4_change_inode_journal_flag(struct inode *, int);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 2a822d30e73f..20bab4b0d6fc 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -705,7 +705,7 @@ const struct file_operations ext4_file_operations = {
 
 const struct inode_operations ext4_file_inode_operations = {
 	.setattr	= ext4_setattr,
-	.getattr	= ext4_getattr,
+	.getattr	= ext4_file_getattr,
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9c064727ed62..fd7d5f918cc3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5229,11 +5229,41 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
-	struct inode *inode;
-	unsigned long long delalloc_blocks;
+	struct inode *inode = d_inode(dentry);
+	struct ext4_inode *raw_inode;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int flags;
+
+	if (EXT4_FITS_IN_INODE(raw_inode, ei, i_crtime)) {
+		stat->result_mask |= STATX_BTIME;
+		stat->btime.tv_sec = ei->i_crtime.tv_sec;
+		stat->btime.tv_nsec = ei->i_crtime.tv_nsec;
+	}
+
+	ext4_get_inode_flags(ei);
+	flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
+	if (flags & EXT4_APPEND_FL)
+		stat->attributes |= STATX_ATTR_APPEND;
+	if (flags & EXT4_COMPR_FL)
+		stat->attributes |= STATX_ATTR_COMPRESSED;
+	if (flags & EXT4_ENCRYPT_FL)
+		stat->attributes |= STATX_ATTR_ENCRYPTED;
+	if (flags & EXT4_IMMUTABLE_FL)
+		stat->attributes |= STATX_ATTR_IMMUTABLE;
+	if (flags & EXT4_NODUMP_FL)
+		stat->attributes |= STATX_ATTR_NODUMP;
 
-	inode = d_inode(dentry);
 	generic_fillattr(inode, stat);
+	return 0;
+}
+
+int ext4_file_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		      struct kstat *stat)
+{
+	struct inode *inode = dentry->d_inode;
+	u64 delalloc_blocks;
+
+	ext4_getattr(mnt, dentry, stat);
 
 	/*
 	 * If there is inline data in the inode, the inode will normally not
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 104f8bfba718..e115281fb8c5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3882,6 +3882,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.tmpfile	= ext4_tmpfile,
 	.rename		= ext4_rename2,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
@@ -3890,6 +3891,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 
 const struct inode_operations ext4_special_inode_operations = {
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index 557b3b0d668c..209b833633e2 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -93,6 +93,7 @@ const struct inode_operations ext4_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= page_get_link,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 };
 
@@ -100,5 +101,6 @@ const struct inode_operations ext4_fast_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= simple_get_link,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 };
