From: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH v3] fuse: Add support for passthrough read/write
Date: Wed, 20 Jan 2016 15:20:34 -0800
Message-ID: <56A01642.7030806@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>, Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add support for filesystem passthrough read/write of files
when enabled in userspace through the option FUSE_PASSTHROUGH.

There are many FUSE based filesystems that perform checks or
enforce policy or perform some kind of decision making in certain
functions like the "open" call but simply act as a "passthrough"
when performing operations such as read or write.

When FUSE_PASSTHROUGH is enabled all the reads and writes
to the fuse mount point go directly to the passthrough filesystem
i.e a native filesystem that actually hosts the files rather than
through the fuse daemon. All requests that aren't read/write still
go thought the userspace code.

This allows for significantly better performance on read and writes.
The difference in performance between fuse and the native lower
filesystem is negligible.

There is also a significant cpu/power savings that is achieved which
is really important on embedded systems that use fuse for I/O.

Signed-off-by: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 fs/fuse/Makefile           |   2 +-
 fs/fuse/dev.c              |   4 ++
 fs/fuse/dir.c              |   3 ++
 fs/fuse/file.c             |  37 +++++++++++--
 fs/fuse/fuse_i.h           |  10 ++++
 fs/fuse/fuse_passthrough.h |  31 +++++++++++
 fs/fuse/inode.c            |   8 +++
 fs/fuse/passthrough.c      | 126 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fuse.h  |   3 +-
 9 files changed, 218 insertions(+), 6 deletions(-)
 create mode 100644 fs/fuse/fuse_passthrough.h
 create mode 100644 fs/fuse/passthrough.c

diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index e95eeb4..3805040 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -5,4 +5,4 @@
 obj-$(CONFIG_FUSE_FS) += fuse.o
 obj-$(CONFIG_CUSE) += cuse.o
 
-fuse-objs := dev.o dir.o file.o inode.o control.o
+fuse-objs := dev.o dir.o file.o inode.o control.o passthrough.o
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ebb5e37..5cc5385 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "fuse_passthrough.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -569,6 +570,8 @@ ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
 	if (!ret && args->out.argvar) {
 		BUG_ON(args->out.numargs != 1);
 		ret = req->out.args[0].size;
+		if (req->passthrough_filp != NULL)
+			args->out.passthrough_filp = req->passthrough_filp;
 	}
 	fuse_put_request(fc, req);
 
@@ -1934,6 +1937,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	err = copy_out_args(cs, &req->out, nbytes);
 	fuse_copy_finish(cs);
 
+	fuse_setup_passthrough(fc, req);
 	spin_lock(&fpq->lock);
 	clear_bit(FR_LOCKED, &req->flags);
 	if (!fpq->connected)
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 712601f..ef34298 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -428,6 +428,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	args.out.args[0].value = &outentry;
 	args.out.args[1].size = sizeof(outopen);
 	args.out.args[1].value = &outopen;
+	args.out.passthrough_filp = NULL;
 	err = fuse_simple_request(fc, &args);
 	if (err)
 		goto out_free_ff;
@@ -439,6 +440,8 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	ff->fh = outopen.fh;
 	ff->nodeid = outentry.nodeid;
 	ff->open_flags = outopen.open_flags;
+	if (args.out.passthrough_filp != NULL)
+		ff->passthrough_filp = args.out.passthrough_filp;
 	inode = fuse_iget(dir->i_sb, outentry.nodeid, outentry.generation,
 			  &outentry.attr, entry_attr_timeout(&outentry), 0);
 	if (!inode) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 570ca40..14b0c69 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "fuse_passthrough.h"
 
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -21,8 +22,10 @@
 static const struct file_operations fuse_direct_io_file_operations;
 
 static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
-			  int opcode, struct fuse_open_out *outargp)
+			  int opcode, struct fuse_open_out *outargp,
+			  struct file **passthrough_filpp)
 {
+	int ret_val;
 	struct fuse_open_in inarg;
 	FUSE_ARGS(args);
 
@@ -38,8 +41,14 @@ static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 	args.out.numargs = 1;
 	args.out.args[0].size = sizeof(*outargp);
 	args.out.args[0].value = outargp;
+	args.out.passthrough_filp = NULL;
 
-	return fuse_simple_request(fc, &args);
+	ret_val = fuse_simple_request(fc, &args);
+
+	if (args.out.passthrough_filp != NULL)
+		*passthrough_filpp = args.out.passthrough_filp;
+
+	return ret_val;
 }
 
 struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
@@ -50,6 +59,7 @@ struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
 	if (unlikely(!ff))
 		return NULL;
 
+	ff->passthrough_filp = NULL;
 	ff->fc = fc;
 	ff->reserved_req = fuse_request_alloc(0);
 	if (unlikely(!ff->reserved_req)) {
@@ -117,6 +127,7 @@ int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		 bool isdir)
 {
 	struct fuse_file *ff;
+	struct file *passthrough_filp = NULL;
 	int opcode = isdir ? FUSE_OPENDIR : FUSE_OPEN;
 
 	ff = fuse_file_alloc(fc);
@@ -129,10 +140,12 @@ int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		struct fuse_open_out outarg;
 		int err;
 
-		err = fuse_send_open(fc, nodeid, file, opcode, &outarg);
+		err = fuse_send_open(fc, nodeid, file, opcode, &outarg,
+				     &(passthrough_filp));
 		if (!err) {
 			ff->fh = outarg.fh;
 			ff->open_flags = outarg.open_flags;
+			ff->passthrough_filp = passthrough_filp;
 
 		} else if (err != -ENOSYS || isdir) {
 			fuse_file_free(ff);
@@ -252,6 +265,8 @@ void fuse_release_common(struct file *file, int opcode)
 	if (unlikely(!ff))
 		return;
 
+	fuse_passthrough_release(ff);
+
 	req = ff->reserved_req;
 	fuse_prepare_release(ff, file->f_flags, opcode);
 
@@ -896,8 +911,10 @@ out:
 
 static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
+	ssize_t ret_val;
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_file *ff = iocb->ki_filp->private_data;
 
 	/*
 	 * In auto invalidate mode, always update attributes on read.
@@ -912,7 +929,12 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			return err;
 	}
 
-	return generic_file_read_iter(iocb, to);
+	if (ff && ff->passthrough_filp)
+		ret_val = fuse_passthrough_read_iter(iocb, to);
+	else
+		ret_val = generic_file_read_iter(iocb, to);
+
+	return ret_val;
 }
 
 static void fuse_write_fill(struct fuse_req *req, struct fuse_file *ff,
@@ -1144,6 +1166,7 @@ static ssize_t fuse_perform_write(struct file *file,
 static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
+	struct fuse_file *ff = file->private_data;
 	struct address_space *mapping = file->f_mapping;
 	ssize_t written = 0;
 	ssize_t written_buffered = 0;
@@ -1177,8 +1200,14 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (err)
 		goto out;
 
+	if (ff && ff->passthrough_filp) {
+		written = fuse_passthrough_write_iter(iocb, from);
+		goto out;
+	}
+
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		loff_t pos = iocb->ki_pos;
+
 		written = generic_file_direct_write(iocb, from, pos);
 		if (written < 0 || !iov_iter_count(from))
 			goto out;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 4051131..2f4d986 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -157,6 +157,9 @@ struct fuse_file {
 
 	/** Has flock been performed on this file? */
 	bool flock:1;
+
+	/* the read write file */
+	struct file *passthrough_filp;
 };
 
 /** One input argument of a request */
@@ -236,6 +239,7 @@ struct fuse_args {
 		unsigned argvar:1;
 		unsigned numargs;
 		struct fuse_arg args[2];
+		struct file *passthrough_filp;
 	} out;
 };
 
@@ -374,6 +378,9 @@ struct fuse_req {
 
 	/** Request is stolen from fuse_file->reserved_req */
 	struct file *stolen_file;
+
+	/** fuse passthrough file  */
+	struct file *passthrough_filp;
 };
 
 struct fuse_iqueue {
@@ -531,6 +538,9 @@ struct fuse_conn {
 	/** write-back cache policy (default is write-through) */
 	unsigned writeback_cache:1;
 
+	/** passthrough IO. */
+	unsigned passthrough:1;
+
 	/*
 	 * The following bitfields are only for optimization purposes
 	 * and hence races in setting them will not cause malfunction
diff --git a/fs/fuse/fuse_passthrough.h b/fs/fuse/fuse_passthrough.h
new file mode 100644
index 0000000..62f12c1
--- /dev/null
+++ b/fs/fuse/fuse_passthrough.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2015-2016, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _FS_FUSE_PASSTHROUGH_H
+#define _FS_FUSE_PASSTHROUGH_H
+
+#include "fuse_i.h"
+
+#include <linux/fuse.h>
+#include <linux/file.h>
+
+void fuse_setup_passthrough(struct fuse_conn *fc, struct fuse_req *req);
+
+ssize_t fuse_passthrough_read_iter(struct kiocb *iocb, struct iov_iter *to);
+
+ssize_t fuse_passthrough_write_iter(struct kiocb *iocb, struct iov_iter *from);
+
+void fuse_passthrough_release(struct fuse_file *ff);
+
+#endif /* _FS_FUSE_PASSTHROUGH_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 2913db2..33ec874 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -860,6 +860,7 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 		fc->conn_error = 1;
 	else {
 		unsigned long ra_pages;
+		struct super_block *sb = fc->sb;
 
 		process_init_limits(fc, arg);
 
@@ -898,6 +899,13 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 				fc->async_dio = 1;
 			if (arg->flags & FUSE_WRITEBACK_CACHE)
 				fc->writeback_cache = 1;
+			if (arg->flags & FUSE_PASSTHROUGH) {
+				fc->passthrough = 1;
+				/* Prevent further stacking */
+				sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
+				pr_info("FUSE: Pass through is enabled [%s : %d]!\n",
+					current->comm, current->pid);
+			}
 			if (arg->time_gran && arg->time_gran <= 1000000000)
 				fc->sb->s_time_gran = arg->time_gran;
 		} else {
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
new file mode 100644
index 0000000..222dc6f
--- /dev/null
+++ b/fs/fuse/passthrough.c
@@ -0,0 +1,126 @@
+/*
+ * Copyright (c) 2015-2016, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include "fuse_passthrough.h"
+
+#include <linux/aio.h>
+#include <linux/fs_stack.h>
+
+void fuse_setup_passthrough(struct fuse_conn *fc, struct fuse_req *req)
+{
+	int daemon_fd, fs_stack_depth;
+	unsigned open_out_index;
+	struct file *passthrough_filp;
+	struct inode *passthrough_inode;
+	struct super_block *passthrough_sb;
+	struct fuse_open_out *open_out;
+
+	req->passthrough_filp = NULL;
+
+	if (!(fc->passthrough))
+		return;
+
+	if ((req->in.h.opcode != FUSE_OPEN) &&
+	    (req->in.h.opcode != FUSE_CREATE))
+		return;
+
+	open_out_index = req->in.numargs - 1;
+
+	BUG_ON(open_out_index != 0 && open_out_index != 1);
+	BUG_ON(req->out.args[open_out_index].size != sizeof(*open_out));
+
+	open_out = req->out.args[open_out_index].value;
+
+	daemon_fd = (int)open_out->passthrough_fd;
+	if (daemon_fd < 0)
+		return;
+
+	passthrough_filp = fget_raw(daemon_fd);
+	if (!passthrough_filp)
+		return;
+
+	passthrough_inode = file_inode(passthrough_filp);
+	passthrough_sb = passthrough_inode->i_sb;
+	fs_stack_depth = passthrough_sb->s_stack_depth + 1;
+
+	/* If we reached the stacking limit go through regular io */
+	if (fs_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
+		pr_err("FUSE: maximum fs stacking depth exceeded, cannot use passthrough for this file\n");
+		return;
+	}
+	req->passthrough_filp = passthrough_filp;
+}
+
+static ssize_t fuse_passthrough_read_write_iter(struct kiocb *iocb,
+					    struct iov_iter *iter, int do_write)
+{
+	ssize_t ret_val;
+	struct fuse_file *ff;
+	struct file *fuse_file, *passthrough_filp;
+	struct inode *fuse_inode, *passthrough_inode;
+
+	ff = iocb->ki_filp->private_data;
+	fuse_file = iocb->ki_filp;
+	passthrough_filp = ff->passthrough_filp;
+
+	/* lock passthrough file to prevent it from being released */
+	get_file(passthrough_filp);
+	iocb->ki_filp = passthrough_filp;
+	fuse_inode = fuse_file->f_path.dentry->d_inode;
+	passthrough_inode = file_inode(passthrough_filp);
+
+	if (do_write) {
+		if (!passthrough_filp->f_op->write_iter)
+			return -EIO;
+		ret_val = passthrough_filp->f_op->write_iter(iocb, iter);
+
+		if (ret_val >= 0 || ret_val == -EIOCBQUEUED) {
+			fsstack_copy_inode_size(fuse_inode, passthrough_inode);
+			fsstack_copy_attr_times(fuse_inode, passthrough_inode);
+		}
+	} else {
+		if (!passthrough_filp->f_op->read_iter)
+			return -EIO;
+		ret_val = passthrough_filp->f_op->read_iter(iocb, iter);
+		if (ret_val >= 0 || ret_val == -EIOCBQUEUED)
+			fsstack_copy_attr_atime(fuse_inode, passthrough_inode);
+	}
+
+	iocb->ki_filp = fuse_file;
+
+	/* unlock passthrough file */
+	fput(passthrough_filp);
+
+	return ret_val;
+}
+
+ssize_t fuse_passthrough_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	return fuse_passthrough_read_write_iter(iocb, to, 0);
+}
+
+ssize_t fuse_passthrough_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	return fuse_passthrough_read_write_iter(iocb, from, 1);
+}
+
+void fuse_passthrough_release(struct fuse_file *ff)
+{
+	if (!(ff->passthrough_filp))
+		return;
+
+	/* Release the passthrough file. */
+	fput(ff->passthrough_filp);
+	ff->passthrough_filp = NULL;
+}
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index c9aca04..a08933a 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -250,6 +250,7 @@ struct fuse_file_lock {
 #define FUSE_ASYNC_DIO		(1 << 15)
 #define FUSE_WRITEBACK_CACHE	(1 << 16)
 #define FUSE_NO_OPEN_SUPPORT	(1 << 17)
+#define FUSE_PASSTHROUGH	(1 << 18)
 
 /**
  * CUSE INIT request/reply flags
@@ -480,7 +481,7 @@ struct fuse_create_in {
 struct fuse_open_out {
 	uint64_t	fh;
 	uint32_t	open_flags;
-	uint32_t	padding;
+	int32_t         passthrough_fd;
 };
 
 struct fuse_release_in {
-- 
1.8.2.1


-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
-- 
fuse-devel mailing list
To unsubscribe or subscribe, visit https://lists.sourceforge.net/lists/listinfo/fuse-devel
