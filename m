From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 3/5] fs: Require designated initialization of structures
Date: Thu, 31 Jul 2014 16:47:46 -0700
Message-ID: <4f1751d0f5c25be383d09272d05dc7b24ea4f577.1406850006.git.josh@joshtriplett.org>
References: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>, Ingo Molnar <mingo@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Michal Marek <mmarek@suse.cz>, Neil Brown <neilb@suse.de>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-sparse@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Mark various filesystem structures with __designated_init.  Fix the one
and only instance of positional initialization of those structures.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ioctl.c         |  2 +-
 include/linux/fs.h | 45 +++++++++++++++++++++++----------------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 8ac3fad..2151968 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -174,7 +174,7 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 {
 	struct fiemap fiemap;
 	struct fiemap __user *ufiemap = (struct fiemap __user *) arg;
-	struct fiemap_extent_info fieinfo = { 0, };
+	struct fiemap_extent_info fieinfo = { };
 	struct inode *inode = file_inode(filp);
 	struct super_block *sb = inode->i_sb;
 	u64 len;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e11d60c..cec614b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -366,7 +366,7 @@ struct address_space_operations {
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *file,
 				sector_t *span);
 	void (*swap_deactivate)(struct file *file);
-};
+} __designated_init;
 
 extern const struct address_space_operations empty_aops;
 
@@ -401,7 +401,7 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	void			*private_data;	/* ditto */
-} __attribute__((aligned(sizeof(long))));
+} __designated_init __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
 	 * must be enforced here for CRIS, to let the least significant bit
@@ -444,7 +444,7 @@ struct block_device {
 	int			bd_fsfreeze_count;
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
-};
+} __designated_init;
 
 /*
  * Radix-tree tags, for tagging dirty and writeback pages within the pagecache
@@ -588,7 +588,7 @@ struct inode {
 #endif
 
 	void			*i_private; /* fs or device private pointer */
-};
+} __designated_init;
 
 static inline int inode_unhashed(struct inode *inode)
 {
@@ -719,7 +719,7 @@ struct fown_struct {
 	enum pid_type pid_type;	/* Kind of process group SIGIO should be sent to */
 	kuid_t uid, euid;	/* uid/euid of process setting the owner */
 	int signum;		/* posix.1b rt signal to be delivered on IO */
-};
+} __designated_init;
 
 /*
  * Track a single file's readahead state
@@ -733,7 +733,7 @@ struct file_ra_state {
 	unsigned int ra_pages;		/* Maximum readahead window */
 	unsigned int mmap_miss;		/* Cache miss stat for mmap accesses */
 	loff_t prev_pos;		/* Cache last read() position */
-};
+} __designated_init;
 
 /*
  * Check if @index falls in the readahead windows.
@@ -781,14 +781,15 @@ struct file {
 	struct list_head	f_tfile_llink;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
-} __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
+} __designated_init __attribute__((aligned(4)));
+/* lest something weird decides that 2 is OK */
 
 struct file_handle {
 	__u32 handle_bytes;
 	int handle_type;
 	/* file identifier */
 	unsigned char f_handle[0];
-};
+} __designated_init;
 
 static inline struct file *get_file(struct file *f)
 {
@@ -838,7 +839,7 @@ typedef struct files_struct *fl_owner_t;
 struct file_lock_operations {
 	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
 	void (*fl_release_private)(struct file_lock *);
-};
+} __designated_init;
 
 struct lock_manager_operations {
 	int (*lm_compare_owner)(struct file_lock *, struct file_lock *);
@@ -847,7 +848,7 @@ struct lock_manager_operations {
 	int (*lm_grant)(struct file_lock *, struct file_lock *, int);
 	void (*lm_break)(struct file_lock *);
 	int (*lm_change)(struct file_lock **, int);
-};
+} __designated_init;
 
 struct lock_manager {
 	struct list_head list;
@@ -909,7 +910,7 @@ struct file_lock {
 			int state;		/* state of grant or error if -ve */
 		} afs;
 	} fl_u;
-};
+} __designated_init;
 
 /* The following constant reflects the upper bound of the file/locking space */
 #ifndef OFFSET_MAX
@@ -1112,7 +1113,7 @@ struct fasync_struct {
 	struct fasync_struct	*fa_next; /* singly linked list */
 	struct file		*fa_file;
 	struct rcu_head		fa_rcu;
-};
+} __designated_init;
 
 #define FASYNC_MAGIC 0x4601
 
@@ -1170,7 +1171,7 @@ struct sb_writers {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	lock_map[SB_FREEZE_LEVELS];
 #endif
-};
+} __designated_init;
 
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
@@ -1258,7 +1259,7 @@ struct super_block {
 	struct list_lru		s_dentry_lru ____cacheline_aligned_in_smp;
 	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
 	struct rcu_head		rcu;
-};
+} __designated_init;
 
 extern struct timespec current_fs_time(struct super_block *sb);
 
@@ -1410,7 +1411,7 @@ struct fiemap_extent_info {
 	unsigned int fi_extents_max;	/* Size of fiemap_extent array */
 	struct fiemap_extent __user *fi_extents_start; /* Start of
 							fiemap_extent array */
-};
+} __designated_init;
 int fiemap_fill_next_extent(struct fiemap_extent_info *info, u64 logical,
 			    u64 phys, u64 len, u32 flags);
 int fiemap_check_flags(struct fiemap_extent_info *fieinfo, u32 fs_flags);
@@ -1441,7 +1442,7 @@ typedef int (*filldir_t)(void *, const char *, int, loff_t, u64, unsigned);
 struct dir_context {
 	const filldir_t actor;
 	loff_t pos;
-};
+} __designated_init;
 
 struct block_device_operations;
 
@@ -1484,7 +1485,7 @@ struct file_operations {
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
 	int (*show_fdinfo)(struct seq_file *m, struct file *f);
-};
+} __designated_init;
 
 struct inode_operations {
 	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
@@ -1520,7 +1521,7 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
-} ____cacheline_aligned;
+} __designated_init ____cacheline_aligned;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
@@ -1561,7 +1562,7 @@ struct super_operations {
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 	long (*nr_cached_objects)(struct super_block *, int);
 	long (*free_cached_objects)(struct super_block *, long, int);
-};
+} __designated_init;
 
 /*
  * Inode flags - they have no relation to superblock flags now
@@ -1771,7 +1772,7 @@ struct file_system_type {
 	struct lock_class_key i_lock_key;
 	struct lock_class_key i_mutex_key;
 	struct lock_class_key i_mutex_dir_key;
-};
+} __designated_init;
 
 #define MODULE_ALIAS_FS(NAME) MODULE_ALIAS("fs-" NAME)
 
@@ -2018,7 +2019,7 @@ struct filename {
 	const __user char	*uptr;	/* original userland pointer */
 	struct audit_names	*aname;
 	bool			separate; /* should "name" be freed? */
-};
+} __designated_init;
 
 extern long vfs_truncate(struct path *, loff_t);
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
@@ -2647,7 +2648,7 @@ static inline ino_t parent_ino(struct dentry *dentry)
 struct simple_transaction_argresp {
 	ssize_t size;
 	char data[0];
-};
+} __designated_init;
 
 #define SIMPLE_TRANSACTION_LIMIT (PAGE_SIZE - sizeof(struct simple_transaction_argresp))
 
-- 
2.0.1
