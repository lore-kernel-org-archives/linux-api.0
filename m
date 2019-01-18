From: Jann Horn <jannh@google.com>
Subject: [PATCH v4 3/3] fs: let filldir_t return bool instead of an error code
Date: Fri, 18 Jan 2019 17:14:40 +0100
Message-ID: <20190118161440.220134-3-jannh@google.com>
References: <20190118161440.220134-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118161440.220134-1-jannh@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, jannh@google.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Pavel Machek <pavel@ucw.cz>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

As Al Viro pointed out, many filldir_t functions return error codes, but
all callers of filldir_t functions just check whether the return value is
non-zero (to determine whether to continue reading the directory); more
precise errors have to be signalled via struct dir_context.
Change all filldir_t functions to return bool instead of int.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jann Horn <jannh@google.com>
---
 arch/alpha/kernel/osf_sys.c | 12 +++----
 fs/afs/dir.c                | 30 +++++++++--------
 fs/ecryptfs/file.c          | 13 ++++----
 fs/exportfs/expfs.c         |  8 ++---
 fs/fat/dir.c                |  8 ++---
 fs/gfs2/export.c            |  6 ++--
 fs/nfsd/nfs4recover.c       |  8 ++---
 fs/nfsd/vfs.c               |  6 ++--
 fs/ocfs2/dir.c              | 10 +++---
 fs/ocfs2/journal.c          | 14 ++++----
 fs/overlayfs/readdir.c      | 24 +++++++-------
 fs/readdir.c                | 64 ++++++++++++++++++-------------------
 fs/reiserfs/xattr.c         | 20 ++++++------
 fs/xfs/scrub/dir.c          |  8 ++---
 fs/xfs/scrub/parent.c       |  4 +--
 include/linux/fs.h          | 10 +++---
 16 files changed, 125 insertions(+), 120 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index db1c2144d477..14e5ae0dac50 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -108,7 +108,7 @@ struct osf_dirent_callback {
 	int error;
 };
 
-static int
+static bool
 osf_filldir(struct dir_context *ctx, const char *name, int namlen,
 	    loff_t offset, u64 ino, unsigned int d_type)
 {
@@ -120,14 +120,14 @@ osf_filldir(struct dir_context *ctx, const char *name, int namlen,
 
 	buf->error = check_dirent_name(name, namlen);
 	if (unlikely(buf->error))
-		return -EFSCORRUPTED;
+		return false;
 	buf->error = -EINVAL;	/* only used if we fail */
 	if (reclen > buf->count)
-		return -EINVAL;
+		return false;
 	d_ino = ino;
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->error = -EOVERFLOW;
-		return -EOVERFLOW;
+		return false;
 	}
 	if (buf->basep) {
 		if (put_user(offset, buf->basep))
@@ -144,10 +144,10 @@ osf_filldir(struct dir_context *ctx, const char *name, int namlen,
 	dirent = (void __user *)dirent + reclen;
 	buf->dirent = dirent;
 	buf->count -= reclen;
-	return 0;
+	return true;
 Efault:
 	buf->error = -EFAULT;
-	return -EFAULT;
+	return false;
 }
 
 SYSCALL_DEFINE4(osf_getdirentries, unsigned int, fd,
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 8a2562e3a316..84d74cc25127 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -26,10 +26,12 @@ static int afs_dir_open(struct inode *inode, struct file *file);
 static int afs_readdir(struct file *file, struct dir_context *ctx);
 static int afs_d_revalidate(struct dentry *dentry, unsigned int flags);
 static int afs_d_delete(const struct dentry *dentry);
-static int afs_lookup_one_filldir(struct dir_context *ctx, const char *name, int nlen,
-				  loff_t fpos, u64 ino, unsigned dtype);
-static int afs_lookup_filldir(struct dir_context *ctx, const char *name, int nlen,
-			      loff_t fpos, u64 ino, unsigned dtype);
+static bool afs_lookup_one_filldir(struct dir_context *ctx, const char *name,
+				  int nlen, loff_t fpos, u64 ino,
+				  unsigned int dtype);
+static bool afs_lookup_filldir(struct dir_context *ctx, const char *name,
+			      int nlen, loff_t fpos, u64 ino,
+			      unsigned int dtype);
 static int afs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		      bool excl);
 static int afs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode);
@@ -493,7 +495,7 @@ static int afs_readdir(struct file *file, struct dir_context *ctx)
  * - if afs_dir_iterate_block() spots this function, it'll pass the FID
  *   uniquifier through dtype
  */
-static int afs_lookup_one_filldir(struct dir_context *ctx, const char *name,
+static bool afs_lookup_one_filldir(struct dir_context *ctx, const char *name,
 				  int nlen, loff_t fpos, u64 ino, unsigned dtype)
 {
 	struct afs_lookup_one_cookie *cookie =
@@ -509,16 +511,16 @@ static int afs_lookup_one_filldir(struct dir_context *ctx, const char *name,
 
 	if (cookie->name.len != nlen ||
 	    memcmp(cookie->name.name, name, nlen) != 0) {
-		_leave(" = 0 [no]");
-		return 0;
+		_leave(" = true [no]");
+		return true;
 	}
 
 	cookie->fid.vnode = ino;
 	cookie->fid.unique = dtype;
 	cookie->found = 1;
 
-	_leave(" = -1 [found]");
-	return -1;
+	_leave(" = false [found]");
+	return false;
 }
 
 /*
@@ -561,12 +563,12 @@ static int afs_do_lookup_one(struct inode *dir, struct dentry *dentry,
  * - if afs_dir_iterate_block() spots this function, it'll pass the FID
  *   uniquifier through dtype
  */
-static int afs_lookup_filldir(struct dir_context *ctx, const char *name,
+static bool afs_lookup_filldir(struct dir_context *ctx, const char *name,
 			      int nlen, loff_t fpos, u64 ino, unsigned dtype)
 {
 	struct afs_lookup_cookie *cookie =
 		container_of(ctx, struct afs_lookup_cookie, ctx);
-	int ret;
+	bool ret;
 
 	_enter("{%s,%u},%s,%u,,%llu,%u",
 	       cookie->name.name, cookie->name.len, name, nlen,
@@ -588,11 +590,11 @@ static int afs_lookup_filldir(struct dir_context *ctx, const char *name,
 		cookie->fids[0].unique	= dtype;
 		cookie->found = 1;
 		if (cookie->one_only)
-			return -1;
+			return false;
 	}
 
-	ret = cookie->nr_fids >= 50 ? -1 : 0;
-	_leave(" = %d", ret);
+	ret = cookie->nr_fids < 50;
+	_leave(" = %d", (int)ret);
 	return ret;
 }
 
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index b76a9853325e..79af7e199ae5 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -67,7 +67,7 @@ struct ecryptfs_getdents_callback {
 };
 
 /* Inspired by generic filldir in fs/readdir.c */
-static int
+static bool
 ecryptfs_filldir(struct dir_context *ctx, const char *lower_name,
 		 int lower_namelen, loff_t offset, u64 ino, unsigned int d_type)
 {
@@ -76,6 +76,7 @@ ecryptfs_filldir(struct dir_context *ctx, const char *lower_name,
 	size_t name_size;
 	char *name;
 	int rc;
+	bool emit_success;
 
 	buf->filldir_called++;
 	rc = ecryptfs_decode_and_decrypt_filename(&name, &name_size,
@@ -86,7 +87,7 @@ ecryptfs_filldir(struct dir_context *ctx, const char *lower_name,
 			ecryptfs_printk(KERN_DEBUG,
 					"%s: Error attempting to decode and decrypt filename [%s]; rc = [%d]\n",
 					__func__, lower_name, rc);
-			return rc;
+			return false;
 		}
 
 		/* Mask -EINVAL errors as these are most likely due a plaintext
@@ -95,16 +96,16 @@ ecryptfs_filldir(struct dir_context *ctx, const char *lower_name,
 		 * the "lost+found" dentry in the root directory of an Ext4
 		 * filesystem.
 		 */
-		return 0;
+		return true;
 	}
 
 	buf->caller->pos = buf->ctx.pos;
-	rc = !dir_emit(buf->caller, name, name_size, ino, d_type);
+	emit_success = dir_emit(buf->caller, name, name_size, ino, d_type);
 	kfree(name);
-	if (!rc)
+	if (emit_success)
 		buf->entries_written++;
 
-	return rc;
+	return emit_success;
 }
 
 /**
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index c69927bed4ef..9f159861fb24 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -247,21 +247,21 @@ struct getdents_callback {
  * A rather strange filldir function to capture
  * the name matching the specified inode number.
  */
-static int filldir_one(struct dir_context *ctx, const char *name, int len,
+static bool filldir_one(struct dir_context *ctx, const char *name, int len,
 			loff_t pos, u64 ino, unsigned int d_type)
 {
 	struct getdents_callback *buf =
 		container_of(ctx, struct getdents_callback, ctx);
-	int result = 0;
+	bool read_more = true;
 
 	buf->sequence++;
 	if (buf->ino == ino && len <= NAME_MAX) {
 		memcpy(buf->name, name, len);
 		buf->name[len] = '\0';
 		buf->found = 1;
-		result = -1;
+		read_more = false;
 	}
-	return result;
+	return read_more;
 }
 
 /**
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 9d01db37183f..89d623ef5259 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -706,7 +706,7 @@ static int fat_readdir(struct file *file, struct dir_context *ctx)
 }
 
 #define FAT_IOCTL_FILLDIR_FUNC(func, dirent_type)			   \
-static int func(struct dir_context *ctx, const char *name, int name_len,   \
+static bool func(struct dir_context *ctx, const char *name, int name_len,  \
 			     loff_t offset, u64 ino, unsigned int d_type)  \
 {									   \
 	struct fat_ioctl_filldir_callback *buf =			   \
@@ -715,7 +715,7 @@ static int func(struct dir_context *ctx, const char *name, int name_len,   \
 	struct dirent_type __user *d2 = d1 + 1;				   \
 									   \
 	if (buf->result)						   \
-		return -EINVAL;						   \
+		return false;						   \
 	buf->result++;							   \
 									   \
 	if (name != NULL) {						   \
@@ -751,10 +751,10 @@ static int func(struct dir_context *ctx, const char *name, int name_len,   \
 		    put_user(short_len, &d1->d_reclen))			   \
 			goto efault;					   \
 	}								   \
-	return 0;							   \
+	return true;							   \
 efault:									   \
 	buf->result = -EFAULT;						   \
-	return -EFAULT;							   \
+	return false;							   \
 }
 
 FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, __fat_dirent)
diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index a332f3cd925e..20a619c14f60 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -69,7 +69,7 @@ struct get_name_filldir {
 	char *name;
 };
 
-static int get_name_filldir(struct dir_context *ctx, const char *name,
+static bool get_name_filldir(struct dir_context *ctx, const char *name,
 			    int length, loff_t offset, u64 inum,
 			    unsigned int type)
 {
@@ -77,12 +77,12 @@ static int get_name_filldir(struct dir_context *ctx, const char *name,
 		container_of(ctx, struct get_name_filldir, ctx);
 
 	if (inum != gnfd->inum.no_addr)
-		return 0;
+		return true;
 
 	memcpy(gnfd->name, name, length);
 	gnfd->name[length] = 0;
 
-	return 1;
+	return false;
 }
 
 static int gfs2_get_name(struct dentry *parent, char *name,
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 5188f9f70c78..bcec773cf660 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -250,7 +250,7 @@ struct nfs4_dir_ctx {
 	struct list_head names;
 };
 
-static int
+static bool
 nfsd4_build_namelist(struct dir_context *__ctx, const char *name, int namlen,
 		loff_t offset, u64 ino, unsigned int d_type)
 {
@@ -259,14 +259,14 @@ nfsd4_build_namelist(struct dir_context *__ctx, const char *name, int namlen,
 	struct name_list *entry;
 
 	if (namlen != HEXDIR_LEN - 1)
-		return 0;
+		return true;
 	entry = kmalloc(sizeof(struct name_list), GFP_KERNEL);
 	if (entry == NULL)
-		return -ENOMEM;
+		return false;
 	memcpy(entry->name, name, HEXDIR_LEN - 1);
 	entry->name[HEXDIR_LEN - 1] = '\0';
 	list_add(&entry->list, &ctx->names);
-	return 0;
+	return true;
 }
 
 static int
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 9824e32b2f23..4df9479f2cab 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1831,7 +1831,7 @@ struct readdir_data {
 	int		full;
 };
 
-static int nfsd_buffered_filldir(struct dir_context *ctx, const char *name,
+static bool nfsd_buffered_filldir(struct dir_context *ctx, const char *name,
 				 int namlen, loff_t offset, u64 ino,
 				 unsigned int d_type)
 {
@@ -1843,7 +1843,7 @@ static int nfsd_buffered_filldir(struct dir_context *ctx, const char *name,
 	reclen = ALIGN(sizeof(struct buffered_dirent) + namlen, sizeof(u64));
 	if (buf->used + reclen > PAGE_SIZE) {
 		buf->full = 1;
-		return -EINVAL;
+		return false;
 	}
 
 	de->namlen = namlen;
@@ -1853,7 +1853,7 @@ static int nfsd_buffered_filldir(struct dir_context *ctx, const char *name,
 	memcpy(de->name, name, namlen);
 	buf->used += reclen;
 
-	return 0;
+	return true;
 }
 
 static __be32 nfsd_buffered_readdir(struct file *file, nfsd_filldir_t func,
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index c121abbdfc7d..0eebf587e792 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2060,7 +2060,7 @@ struct ocfs2_empty_dir_priv {
 	unsigned seen_other;
 	unsigned dx_dir;
 };
-static int ocfs2_empty_dir_filldir(struct dir_context *ctx, const char *name,
+static bool ocfs2_empty_dir_filldir(struct dir_context *ctx, const char *name,
 				   int name_len, loff_t pos, u64 ino,
 				   unsigned type)
 {
@@ -2080,7 +2080,7 @@ static int ocfs2_empty_dir_filldir(struct dir_context *ctx, const char *name,
 	 */
 	if (name_len == 1 && !strncmp(".", name, 1) && pos == 0) {
 		p->seen_dot = 1;
-		return 0;
+		return true;
 	}
 
 	if (name_len == 2 && !strncmp("..", name, 2) &&
@@ -2088,13 +2088,13 @@ static int ocfs2_empty_dir_filldir(struct dir_context *ctx, const char *name,
 		p->seen_dot_dot = 1;
 
 		if (p->dx_dir && p->seen_dot)
-			return 1;
+			return false;
 
-		return 0;
+		return true;
 	}
 
 	p->seen_other = 1;
-	return 1;
+	return false;
 }
 
 static int ocfs2_empty_dir_dx(struct inode *inode,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 46fd3ef2cf21..11b3c38d22e5 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -2036,7 +2036,7 @@ struct ocfs2_orphan_filldir_priv {
 	enum ocfs2_orphan_reco_type orphan_reco_type;
 };
 
-static int ocfs2_orphan_filldir(struct dir_context *ctx, const char *name,
+static bool ocfs2_orphan_filldir(struct dir_context *ctx, const char *name,
 				int name_len, loff_t pos, u64 ino,
 				unsigned type)
 {
@@ -2045,21 +2045,21 @@ static int ocfs2_orphan_filldir(struct dir_context *ctx, const char *name,
 	struct inode *iter;
 
 	if (name_len == 1 && !strncmp(".", name, 1))
-		return 0;
+		return true;
 	if (name_len == 2 && !strncmp("..", name, 2))
-		return 0;
+		return true;
 
 	/* do not include dio entry in case of orphan scan */
 	if ((p->orphan_reco_type == ORPHAN_NO_NEED_TRUNCATE) &&
 			(!strncmp(name, OCFS2_DIO_ORPHAN_PREFIX,
 			OCFS2_DIO_ORPHAN_PREFIX_LEN)))
-		return 0;
+		return true;
 
 	/* Skip bad inodes so that recovery can continue */
 	iter = ocfs2_iget(p->osb, ino,
 			  OCFS2_FI_FLAG_ORPHAN_RECOVERY, 0);
 	if (IS_ERR(iter))
-		return 0;
+		return true;
 
 	if (!strncmp(name, OCFS2_DIO_ORPHAN_PREFIX,
 			OCFS2_DIO_ORPHAN_PREFIX_LEN))
@@ -2069,7 +2069,7 @@ static int ocfs2_orphan_filldir(struct dir_context *ctx, const char *name,
 	 * happen concurrently with unlink/rename */
 	if (OCFS2_I(iter)->ip_next_orphan) {
 		iput(iter);
-		return 0;
+		return true;
 	}
 
 	trace_ocfs2_orphan_filldir((unsigned long long)OCFS2_I(iter)->ip_blkno);
@@ -2078,7 +2078,7 @@ static int ocfs2_orphan_filldir(struct dir_context *ctx, const char *name,
 	OCFS2_I(iter)->ip_next_orphan = p->head;
 	p->head = iter;
 
-	return 0;
+	return true;
 }
 
 static int ocfs2_queue_orphans(struct ocfs2_super *osb,
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index cc8303a806b4..e72b84a4b470 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -173,7 +173,7 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
 	return p;
 }
 
-static int ovl_cache_entry_add_rb(struct ovl_readdir_data *rdd,
+static bool ovl_cache_entry_add_rb(struct ovl_readdir_data *rdd,
 				  const char *name, int len, u64 ino,
 				  unsigned int d_type)
 {
@@ -182,19 +182,19 @@ static int ovl_cache_entry_add_rb(struct ovl_readdir_data *rdd,
 	struct ovl_cache_entry *p;
 
 	if (ovl_cache_entry_find_link(name, len, &newp, &parent))
-		return 0;
+		return true;
 
 	p = ovl_cache_entry_new(rdd, name, len, ino, d_type);
 	if (p == NULL) {
 		rdd->err = -ENOMEM;
-		return -ENOMEM;
+		return false;
 	}
 
 	list_add_tail(&p->l_node, rdd->list);
 	rb_link_node(&p->node, parent, newp);
 	rb_insert_color(&p->node, rdd->root);
 
-	return 0;
+	return true;
 }
 
 static int ovl_fill_lowest(struct ovl_readdir_data *rdd,
@@ -253,7 +253,7 @@ static void ovl_cache_put(struct ovl_dir_file *od, struct dentry *dentry)
 	}
 }
 
-static int ovl_fill_merge(struct dir_context *ctx, const char *name,
+static bool ovl_fill_merge(struct dir_context *ctx, const char *name,
 			  int namelen, loff_t offset, u64 ino,
 			  unsigned int d_type)
 {
@@ -526,7 +526,7 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 	goto out;
 }
 
-static int ovl_fill_plain(struct dir_context *ctx, const char *name,
+static bool ovl_fill_plain(struct dir_context *ctx, const char *name,
 			  int namelen, loff_t offset, u64 ino,
 			  unsigned int d_type)
 {
@@ -538,11 +538,11 @@ static int ovl_fill_plain(struct dir_context *ctx, const char *name,
 	p = ovl_cache_entry_new(rdd, name, namelen, ino, d_type);
 	if (p == NULL) {
 		rdd->err = -ENOMEM;
-		return -ENOMEM;
+		return false;
 	}
 	list_add_tail(&p->l_node, rdd->list);
 
-	return 0;
+	return true;
 }
 
 static int ovl_dir_read_impure(struct path *path,  struct list_head *list,
@@ -644,7 +644,7 @@ struct ovl_readdir_translate {
 	int xinobits;
 };
 
-static int ovl_fill_real(struct dir_context *ctx, const char *name,
+static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 			   int namelen, loff_t offset, u64 ino,
 			   unsigned int d_type)
 {
@@ -980,7 +980,7 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list)
 	inode_unlock(upper->d_inode);
 }
 
-static int ovl_check_d_type(struct dir_context *ctx, const char *name,
+static bool ovl_check_d_type(struct dir_context *ctx, const char *name,
 			  int namelen, loff_t offset, u64 ino,
 			  unsigned int d_type)
 {
@@ -989,12 +989,12 @@ static int ovl_check_d_type(struct dir_context *ctx, const char *name,
 
 	/* Even if d_type is not supported, DT_DIR is returned for . and .. */
 	if (!strncmp(name, ".", namelen) || !strncmp(name, "..", namelen))
-		return 0;
+		return true;
 
 	if (d_type != DT_UNKNOWN)
 		rdd->d_type_supported = true;
 
-	return 0;
+	return true;
 }
 
 /*
diff --git a/fs/readdir.c b/fs/readdir.c
index 58088510bb9c..83b552263a5a 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -108,7 +108,7 @@ struct readdir_callback {
 	int result;
 };
 
-static int fillonedir(struct dir_context *ctx, const char *name, int namlen,
+static bool fillonedir(struct dir_context *ctx, const char *name, int namlen,
 		      loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct readdir_callback *buf =
@@ -117,14 +117,14 @@ static int fillonedir(struct dir_context *ctx, const char *name, int namlen,
 	unsigned long d_ino;
 
 	if (buf->result)
-		return -EINVAL;
+		return false;
 	buf->result = check_dirent_name(name, namlen);
 	if (unlikely(buf->result))
-		return -EFSCORRUPTED;
+		return false;
 	d_ino = ino;
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->result = -EOVERFLOW;
-		return -EOVERFLOW;
+		return false;
 	}
 	buf->result++;
 	dirent = buf->dirent;
@@ -138,10 +138,10 @@ static int fillonedir(struct dir_context *ctx, const char *name, int namlen,
 		__copy_to_user(dirent->d_name, name, namlen) ||
 		__put_user(0, dirent->d_name + namlen))
 		goto efault;
-	return 0;
+	return true;
 efault:
 	buf->result = -EFAULT;
-	return -EFAULT;
+	return false;
 }
 
 SYSCALL_DEFINE3(old_readdir, unsigned int, fd,
@@ -186,7 +186,7 @@ struct getdents_callback {
 	int error;
 };
 
-static int filldir(struct dir_context *ctx, const char *name, int namlen,
+static bool filldir(struct dir_context *ctx, const char *name, int namlen,
 		   loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct linux_dirent __user * dirent;
@@ -198,19 +198,19 @@ static int filldir(struct dir_context *ctx, const char *name, int namlen,
 
 	buf->error = check_dirent_name(name, namlen);
 	if (unlikely(buf->error))
-		return -EFSCORRUPTED;
+		return false;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
-		return -EINVAL;
+		return false;
 	d_ino = ino;
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->error = -EOVERFLOW;
-		return -EOVERFLOW;
+		return false;
 	}
 	dirent = buf->previous;
 	if (dirent) {
 		if (signal_pending(current))
-			return -EINTR;
+			return false;
 		if (__put_user(offset, &dirent->d_off))
 			goto efault;
 	}
@@ -229,10 +229,10 @@ static int filldir(struct dir_context *ctx, const char *name, int namlen,
 	dirent = (void __user *)dirent + reclen;
 	buf->current_dir = dirent;
 	buf->count -= reclen;
-	return 0;
+	return true;
 efault:
 	buf->error = -EFAULT;
-	return -EFAULT;
+	return false;
 }
 
 SYSCALL_DEFINE3(getdents, unsigned int, fd,
@@ -276,7 +276,7 @@ struct getdents_callback64 {
 	int error;
 };
 
-static int filldir64(struct dir_context *ctx, const char *name, int namlen,
+static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
 		     loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct linux_dirent64 __user *dirent;
@@ -287,14 +287,14 @@ static int filldir64(struct dir_context *ctx, const char *name, int namlen,
 
 	buf->error = check_dirent_name(name, namlen);
 	if (unlikely(buf->error))
-		return -EFSCORRUPTED;
+		return false;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
-		return -EINVAL;
+		return false;
 	dirent = buf->previous;
 	if (dirent) {
 		if (signal_pending(current))
-			return -EINTR;
+			return false;
 		if (__put_user(offset, &dirent->d_off))
 			goto efault;
 	}
@@ -315,10 +315,10 @@ static int filldir64(struct dir_context *ctx, const char *name, int namlen,
 	dirent = (void __user *)dirent + reclen;
 	buf->current_dir = dirent;
 	buf->count -= reclen;
-	return 0;
+	return true;
 efault:
 	buf->error = -EFAULT;
-	return -EFAULT;
+	return false;
 }
 
 int ksys_getdents64(unsigned int fd, struct linux_dirent64 __user *dirent,
@@ -376,7 +376,7 @@ struct compat_readdir_callback {
 	int result;
 };
 
-static int compat_fillonedir(struct dir_context *ctx, const char *name,
+static bool compat_fillonedir(struct dir_context *ctx, const char *name,
 			     int namlen, loff_t offset, u64 ino,
 			     unsigned int d_type)
 {
@@ -389,11 +389,11 @@ static int compat_fillonedir(struct dir_context *ctx, const char *name,
 		return -EINVAL;
 	buf->result = check_dirent_name(name, namlen);
 	if (unlikely(buf->result))
-		return -EFSCORRUPTED;
+		return false;
 	d_ino = ino;
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->result = -EOVERFLOW;
-		return -EOVERFLOW;
+		return false;
 	}
 	buf->result++;
 	dirent = buf->dirent;
@@ -407,10 +407,10 @@ static int compat_fillonedir(struct dir_context *ctx, const char *name,
 		__copy_to_user(dirent->d_name, name, namlen) ||
 		__put_user(0, dirent->d_name + namlen))
 		goto efault;
-	return 0;
+	return true;
 efault:
 	buf->result = -EFAULT;
-	return -EFAULT;
+	return false;
 }
 
 COMPAT_SYSCALL_DEFINE3(old_readdir, unsigned int, fd,
@@ -449,8 +449,8 @@ struct compat_getdents_callback {
 	int error;
 };
 
-static int compat_filldir(struct dir_context *ctx, const char *name, int namlen,
-		loff_t offset, u64 ino, unsigned int d_type)
+static bool compat_filldir(struct dir_context *ctx, const char *name,
+		int namlen, loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct compat_linux_dirent __user * dirent;
 	struct compat_getdents_callback *buf =
@@ -461,19 +461,19 @@ static int compat_filldir(struct dir_context *ctx, const char *name, int namlen,
 
 	buf->error = check_dirent_name(name, namlen);
 	if (unlikely(buf->error))
-		return -EFSCORRUPTED;
+		return false;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
-		return -EINVAL;
+		return false;
 	d_ino = ino;
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->error = -EOVERFLOW;
-		return -EOVERFLOW;
+		return false;
 	}
 	dirent = buf->previous;
 	if (dirent) {
 		if (signal_pending(current))
-			return -EINTR;
+			return false;
 		if (__put_user(offset, &dirent->d_off))
 			goto efault;
 	}
@@ -492,10 +492,10 @@ static int compat_filldir(struct dir_context *ctx, const char *name, int namlen,
 	dirent = (void __user *)dirent + reclen;
 	buf->current_dir = dirent;
 	buf->count -= reclen;
-	return 0;
+	return true;
 efault:
 	buf->error = -EFAULT;
-	return -EFAULT;
+	return false;
 }
 
 COMPAT_SYSCALL_DEFINE3(getdents, unsigned int, fd,
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 32d8986c26fb..0d56b2a3adad 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -189,7 +189,7 @@ struct reiserfs_dentry_buf {
 	struct dentry *dentries[8];
 };
 
-static int
+static bool
 fill_with_dentries(struct dir_context *ctx, const char *name, int namelen,
 		   loff_t offset, u64 ino, unsigned int d_type)
 {
@@ -200,16 +200,16 @@ fill_with_dentries(struct dir_context *ctx, const char *name, int namelen,
 	WARN_ON_ONCE(!inode_is_locked(d_inode(dbuf->xadir)));
 
 	if (dbuf->count == ARRAY_SIZE(dbuf->dentries))
-		return -ENOSPC;
+		return false;
 
 	if (name[0] == '.' && (namelen < 2 ||
 			       (namelen == 2 && name[1] == '.')))
-		return 0;
+		return true;
 
 	dentry = lookup_one_len(name, dbuf->xadir, namelen);
 	if (IS_ERR(dentry)) {
 		dbuf->err = PTR_ERR(dentry);
-		return PTR_ERR(dentry);
+		return false;
 	} else if (d_really_is_negative(dentry)) {
 		/* A directory entry exists, but no file? */
 		reiserfs_error(dentry->d_sb, "xattr-20003",
@@ -218,11 +218,11 @@ fill_with_dentries(struct dir_context *ctx, const char *name, int namelen,
 			       dentry, dbuf->xadir);
 		dput(dentry);
 		dbuf->err = -EIO;
-		return -EIO;
+		return false;
 	}
 
 	dbuf->dentries[dbuf->count++] = dentry;
-	return 0;
+	return true;
 }
 
 static void
@@ -780,7 +780,7 @@ struct listxattr_buf {
 	struct dentry *dentry;
 };
 
-static int listxattr_filler(struct dir_context *ctx, const char *name,
+static bool listxattr_filler(struct dir_context *ctx, const char *name,
 			    int namelen, loff_t offset, u64 ino,
 			    unsigned int d_type)
 {
@@ -796,19 +796,19 @@ static int listxattr_filler(struct dir_context *ctx, const char *name,
 						    name);
 		if (!handler /* Unsupported xattr name */ ||
 		    (handler->list && !handler->list(b->dentry)))
-			return 0;
+			return true;
 		size = namelen + 1;
 		if (b->buf) {
 			if (b->pos + size > b->size) {
 				b->pos = -ERANGE;
-				return -ERANGE;
+				return false;
 			}
 			memcpy(b->buf + b->pos, name, namelen);
 			b->buf[b->pos + namelen] = 0;
 		}
 		b->pos += size;
 	}
-	return 0;
+	return true;
 }
 
 /*
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index cd3e4d768a18..e57069a299fa 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -100,7 +100,7 @@ xchk_dir_check_ftype(
  * we check the inode number to make sure it's sane, then we check that
  * we can look up this filename.  Finally, we check the ftype.
  */
-STATIC int
+STATIC bool
 xchk_dir_actor(
 	struct dir_context	*dir_iter,
 	const char		*name,
@@ -170,13 +170,13 @@ xchk_dir_actor(
 		goto out;
 out:
 	/*
-	 * A negative error code returned here is supposed to cause the
+	 * Returning false here causes the
 	 * dir_emit caller (xfs_readdir) to abort the directory iteration
 	 * and return zero to xchk_directory.
 	 */
 	if (error == 0 && sdc->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return -EFSCORRUPTED;
-	return error;
+		return false;
+	return !error;
 }
 
 /* Scrub a directory btree record. */
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 1c9d7c7f64f5..9b6d9d416039 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -45,7 +45,7 @@ struct xchk_parent_ctx {
 };
 
 /* Look for a single entry in a directory pointing to an inode. */
-STATIC int
+STATIC bool
 xchk_parent_actor(
 	struct dir_context	*dc,
 	const char		*name,
@@ -59,7 +59,7 @@ xchk_parent_actor(
 	spc = container_of(dc, struct xchk_parent_ctx, dc);
 	if (spc->ino == ino)
 		spc->nlink++;
-	return 0;
+	return true;
 }
 
 /* Count the number of dentries in the parent dir that point to this inode. */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e14329741e3a..1d6300c41d92 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1720,9 +1720,11 @@ int fiemap_check_flags(struct fiemap_extent_info *fieinfo, u32 fs_flags);
  * the kernel specify what kind of dirent layout it wants to have.
  * This allows the kernel to read directories into kernel space or
  * to have different dirent layouts depending on the binary type.
+ * Returns true if the provided entry has been consumed and the
+ * filldir function should be called again for the next entry.
  */
 struct dir_context;
-typedef int (*filldir_t)(struct dir_context *, const char *, int, loff_t, u64,
+typedef bool (*filldir_t)(struct dir_context *, const char *, int, loff_t, u64,
 			 unsigned);
 
 struct dir_context {
@@ -3469,17 +3471,17 @@ static inline bool dir_emit(struct dir_context *ctx,
 			    const char *name, int namelen,
 			    u64 ino, unsigned type)
 {
-	return ctx->actor(ctx, name, namelen, ctx->pos, ino, type) == 0;
+	return ctx->actor(ctx, name, namelen, ctx->pos, ino, type);
 }
 static inline bool dir_emit_dot(struct file *file, struct dir_context *ctx)
 {
 	return ctx->actor(ctx, ".", 1, ctx->pos,
-			  file->f_path.dentry->d_inode->i_ino, DT_DIR) == 0;
+			  file->f_path.dentry->d_inode->i_ino, DT_DIR);
 }
 static inline bool dir_emit_dotdot(struct file *file, struct dir_context *ctx)
 {
 	return ctx->actor(ctx, "..", 2, ctx->pos,
-			  parent_ino(file->f_path.dentry), DT_DIR) == 0;
+			  parent_ino(file->f_path.dentry), DT_DIR);
 }
 static inline bool dir_emit_dots(struct file *file, struct dir_context *ctx)
 {
-- 
2.20.1.321.g9e740568ce-goog
