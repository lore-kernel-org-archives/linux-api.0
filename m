From: Jann Horn <jannh@google.com>
Subject: [PATCH v4 2/3] fs: don't let getdents return bogus names
Date: Fri, 18 Jan 2019 17:14:39 +0100
Message-ID: <20190118161440.220134-2-jannh@google.com>
References: <20190118161440.220134-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118161440.220134-1-jannh@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, jannh@google.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Pavel Machek <pavel@ucw.cz>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

When you e.g. run `find` on a directory for which getdents returns
"filenames" that contain slashes, `find` passes those "filenames" back to
the kernel, which then interprets them as paths. That could conceivably
cause userspace to do something bad when accessing something like an
untrusted USB stick, but I'm not aware of any specific example.

Instead of returning bogus filenames to userspace, return -EUCLEAN.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
---
I ordered this fix before the refactoring one so that it can easily be
backported.

changed in v2:
 - move bogus_dirent_name() out of the #ifdef (kbuild test robot)
changed in v3:
 - change calling convention (Al Viro)
 - comment fix
changed in v4:
 - use EFSCORRUPTED instead of EUCLEAN (Dave Chinner)

 arch/alpha/kernel/osf_sys.c |  4 ++++
 fs/readdir.c                | 35 +++++++++++++++++++++++++++++++++++
 include/linux/fs.h          |  2 ++
 3 files changed, 41 insertions(+)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 792586038808..db1c2144d477 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -40,6 +40,7 @@
 #include <linux/vfs.h>
 #include <linux/rcupdate.h>
 #include <linux/slab.h>
+#include <linux/fs.h>
 
 #include <asm/fpu.h>
 #include <asm/io.h>
@@ -117,6 +118,9 @@ osf_filldir(struct dir_context *ctx, const char *name, int namlen,
 	unsigned int reclen = ALIGN(NAME_OFFSET + namlen + 1, sizeof(u32));
 	unsigned int d_ino;
 
+	buf->error = check_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return -EFSCORRUPTED;
 	buf->error = -EINVAL;	/* only used if we fail */
 	if (reclen > buf->count)
 		return -EINVAL;
diff --git a/fs/readdir.c b/fs/readdir.c
index 2f6a4534e0df..58088510bb9c 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -64,6 +64,26 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
 }
 EXPORT_SYMBOL(iterate_dir);
 
+/*
+ * Most filesystems don't filter out bogus directory entry names, and userspace
+ * can get very confused by such names. Behave as if a filesystem error had
+ * happened while reading directory entries.
+ */
+int check_dirent_name(const char *name, int namlen)
+{
+	if (namlen == 0) {
+		pr_err_once("%s: filesystem returned bogus empty name\n",
+			    __func__);
+		return -EFSCORRUPTED;
+	}
+	if (memchr(name, '/', namlen)) {
+		pr_err_once("%s: filesystem returned bogus name '%*pEhp' (contains slash)\n",
+			    __func__, namlen, name);
+		return -EFSCORRUPTED;
+	}
+	return 0;
+}
+
 /*
  * Traditional linux readdir() handling..
  *
@@ -98,6 +118,9 @@ static int fillonedir(struct dir_context *ctx, const char *name, int namlen,
 
 	if (buf->result)
 		return -EINVAL;
+	buf->result = check_dirent_name(name, namlen);
+	if (unlikely(buf->result))
+		return -EFSCORRUPTED;
 	d_ino = ino;
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->result = -EOVERFLOW;
@@ -173,6 +196,9 @@ static int filldir(struct dir_context *ctx, const char *name, int namlen,
 	int reclen = ALIGN(offsetof(struct linux_dirent, d_name) + namlen + 2,
 		sizeof(long));
 
+	buf->error = check_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return -EFSCORRUPTED;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
@@ -259,6 +285,9 @@ static int filldir64(struct dir_context *ctx, const char *name, int namlen,
 	int reclen = ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
 		sizeof(u64));
 
+	buf->error = check_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return -EFSCORRUPTED;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
@@ -358,6 +387,9 @@ static int compat_fillonedir(struct dir_context *ctx, const char *name,
 
 	if (buf->result)
 		return -EINVAL;
+	buf->result = check_dirent_name(name, namlen);
+	if (unlikely(buf->result))
+		return -EFSCORRUPTED;
 	d_ino = ino;
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->result = -EOVERFLOW;
@@ -427,6 +459,9 @@ static int compat_filldir(struct dir_context *ctx, const char *name, int namlen,
 	int reclen = ALIGN(offsetof(struct compat_linux_dirent, d_name) +
 		namlen + 2, sizeof(compat_long_t));
 
+	buf->error = check_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return -EFSCORRUPTED;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 811c77743dad..e14329741e3a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1730,6 +1730,8 @@ struct dir_context {
 	loff_t pos;
 };
 
+int check_dirent_name(const char *name, int namlen);
+
 struct block_device_operations;
 
 /* These macros are for out of kernel modules to test that
-- 
2.20.1.321.g9e740568ce-goog
