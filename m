From: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH v2 fixed line wrap mangling] fuse: Add support for fuse stacked
 I/O
Date: Thu, 14 Jan 2016 11:01:38 -0800
Message-ID: <5697F092.9070003@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add support for filesystem stacked read/write of files
when enabled through a userspace init option of FUSE_STACKED_IO.

When FUSE_STACKED_IO is enabled all the reads and writes
to the fuse mount point go directly to the native filesystem
rather than through the fuse daemon. All requests that aren't
read/write still go thought the userspace code.

Mmaped I/O is still not supported through stacking and can be
added in.

This allows for significantly better performance on read and writes.
The difference in performance  between fuse and the native lower
filesystem is negligible.

There is also a significant cpu/power savings that is achieved which
is really important on embedded systems that use fuse for I/O

Signed-off-by: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 fs/fuse/Makefile          |   2 +-
 fs/fuse/dev.c             |   4 ++
 fs/fuse/dir.c             |   3 ++
 fs/fuse/file.c            |  37 +++++++++++++--
 fs/fuse/fuse_i.h          |  10 ++++
 fs/fuse/fuse_stacked.h    |  31 +++++++++++++
 fs/fuse/inode.c           |   5 ++
 fs/fuse/stacked_io.c      | 113 ++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fuse.h |   3 +-
 9 files changed, 202 insertions(+), 6 deletions(-)
 create mode 100644 fs/fuse/fuse_stacked.h
 create mode 100644 fs/fuse/stacked_io.c

diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index e95eeb4..d4f3a26 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -5,4 +5,4 @@
 obj-$(CONFIG_FUSE_FS) += fuse.o
 obj-$(CONFIG_CUSE) += cuse.o
 
-fuse-objs := dev.o dir.o file.o inode.o control.o
+fuse-objs := dev.o dir.o file.o inode.o control.o stacked_io.o
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ebb5e37..ccef1a2 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "fuse_stacked.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -569,6 +570,8 @@ ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
 	if (!ret && args->out.argvar) {
 		BUG_ON(args->out.numargs != 1);
 		ret = req->out.args[0].size;
+		if (req->private_lower_rw_file != NULL)
+			args->out.lower_filp = req->private_lower_rw_file;
 	}
 	fuse_put_request(fc, req);
 
@@ -1934,6 +1937,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	err = copy_out_args(cs, &req->out, nbytes);
 	fuse_copy_finish(cs);
 
+	fuse_setup_stacked_io(fc, req);
 	spin_lock(&fpq->lock);
 	clear_bit(FR_LOCKED, &req->flags);
 	if (!fpq->connected)
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 5e2e087..856a2e4 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -428,6 +428,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	args.out.args[0].value = &outentry;
 	args.out.args[1].size = sizeof(outopen);
 	args.out.args[1].value = &outopen;
+	args.out.lower_filp = NULL;
 	err = fuse_simple_request(fc, &args);
 	if (err)
 		goto out_free_ff;
@@ -439,6 +440,8 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	ff->fh = outopen.fh;
 	ff->nodeid = outentry.nodeid;
 	ff->open_flags = outopen.open_flags;
+	if (args.out.lower_filp != NULL)
+		ff->rw_lower_file = args.out.lower_filp;
 	inode = fuse_iget(dir->i_sb, outentry.nodeid, outentry.generation,
 			  &outentry.attr, entry_attr_timeout(&outentry), 0);
 	if (!inode) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 47f1811..80b1ad7 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "fuse_stacked.h"
 
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -21,8 +22,10 @@
 static const struct file_operations fuse_direct_io_file_operations;
 
 static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
-			  int opcode, struct fuse_open_out *outargp)
+			  int opcode, struct fuse_open_out *outargp,
+			  struct file **lower_filepp)
 {
+	int ret_val;
 	struct fuse_open_in inarg;
 	FUSE_ARGS(args);
 
@@ -38,8 +41,14 @@ static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 	args.out.numargs = 1;
 	args.out.args[0].size = sizeof(*outargp);
 	args.out.args[0].value = outargp;
+	args.out.lower_filp = NULL;
 
-	return fuse_simple_request(fc, &args);
+	ret_val = fuse_simple_request(fc, &args);
+
+	if (args.out.lower_filp != NULL)
+		*lower_filepp = args.out.lower_filp;
+
+	return ret_val;
 }
 
 struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
@@ -50,6 +59,7 @@ struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
 	if (unlikely(!ff))
 		return NULL;
 
+	ff->rw_lower_file = NULL;
 	ff->fc = fc;
 	ff->reserved_req = fuse_request_alloc(0);
 	if (unlikely(!ff->reserved_req)) {
@@ -117,6 +127,7 @@ int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		 bool isdir)
 {
 	struct fuse_file *ff;
+	struct file *lower_file;
 	int opcode = isdir ? FUSE_OPENDIR : FUSE_OPEN;
 
 	ff = fuse_file_alloc(fc);
@@ -129,10 +140,12 @@ int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		struct fuse_open_out outarg;
 		int err;
 
-		err = fuse_send_open(fc, nodeid, file, opcode, &outarg);
+		err = fuse_send_open(fc, nodeid, file, opcode, &outarg,
+				     &(lower_file));
 		if (!err) {
 			ff->fh = outarg.fh;
 			ff->open_flags = outarg.open_flags;
+			ff->rw_lower_file = lower_file;
 
 		} else if (err != -ENOSYS || isdir) {
 			fuse_file_free(ff);
@@ -252,6 +265,8 @@ void fuse_release_common(struct file *file, int opcode)
 	if (unlikely(!ff))
 		return;
 
+	fuse_stacked_release(ff);
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
+	if (ff && ff->rw_lower_file)
+		ret_val = fuse_stacked_read_iter(iocb, to);
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
 
+	if (ff && ff->rw_lower_file) {
+		written = fuse_stacked_write_iter(iocb, from);
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
index ce394b5..3b9d3e3 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -157,6 +157,9 @@ struct fuse_file {
 
 	/** Has flock been performed on this file? */
 	bool flock:1;
+
+	/* the read write file */
+	struct file *rw_lower_file;
 };
 
 /** One input argument of a request */
@@ -236,6 +239,7 @@ struct fuse_args {
 		unsigned argvar:1;
 		unsigned numargs;
 		struct fuse_arg args[2];
+		struct file *lower_filp;
 	} out;
 };
 
@@ -374,6 +378,9 @@ struct fuse_req {
 
 	/** Request is stolen from fuse_file->reserved_req */
 	struct file *stolen_file;
+
+	/** fuse stacked_io lower file  */
+	struct file *private_lower_rw_file;
 };
 
 struct fuse_iqueue {
@@ -531,6 +538,9 @@ struct fuse_conn {
 	/** write-back cache policy (default is write-through) */
 	unsigned writeback_cache:1;
 
+	/** Stacked IO. */
+	unsigned stacked_io:1;
+
 	/*
 	 * The following bitfields are only for optimization purposes
 	 * and hence races in setting them will not cause malfunction
diff --git a/fs/fuse/fuse_stacked.h b/fs/fuse/fuse_stacked.h
new file mode 100644
index 0000000..e56d7be
--- /dev/null
+++ b/fs/fuse/fuse_stacked.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2015, The Linux Foundation. All rights reserved.
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
+#ifndef _FS_FUSE_STACKED_H
+#define _FS_FUSE_STACKED_H
+
+#include "fuse_i.h"
+
+#include <linux/fuse.h>
+#include <linux/file.h>
+
+void fuse_setup_stacked_io(struct fuse_conn *fc, struct fuse_req *req);
+
+ssize_t fuse_stacked_read_iter(struct kiocb *iocb, struct iov_iter *to);
+
+ssize_t fuse_stacked_write_iter(struct kiocb *iocb, struct iov_iter *from);
+
+void fuse_stacked_release(struct fuse_file *ff);
+
+#endif /* _FS_FUSE_STACKED_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 2913db2..bfc4f3f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -898,6 +898,11 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 				fc->async_dio = 1;
 			if (arg->flags & FUSE_WRITEBACK_CACHE)
 				fc->writeback_cache = 1;
+			if (arg->flags & FUSE_STACKED_IO) {
+				fc->stacked_io = 1;
+				pr_info("FUSE: Stacked io is enabled [%s : %d]!\n",
+					current->comm, current->pid);
+			}
 			if (arg->time_gran && arg->time_gran <= 1000000000)
 				fc->sb->s_time_gran = arg->time_gran;
 		} else {
diff --git a/fs/fuse/stacked_io.c b/fs/fuse/stacked_io.c
new file mode 100644
index 0000000..07a72302
--- /dev/null
+++ b/fs/fuse/stacked_io.c
@@ -0,0 +1,113 @@
+/*
+ * Copyright (c) 2015, The Linux Foundation. All rights reserved.
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
+#include "fuse_stacked.h"
+
+#include <linux/aio.h>
+#include <linux/fs_stack.h>
+
+void fuse_setup_stacked_io(struct fuse_conn *fc, struct fuse_req *req)
+{
+	int daemon_fd;
+	struct file *rw_lower_file = NULL;
+	struct fuse_open_out *open_out;
+	int open_out_index;
+
+	req->private_lower_rw_file = NULL;
+
+	if (!(fc->stacked_io))
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
+	daemon_fd = (int)open_out->lower_fd;
+	if (daemon_fd < 0)
+		return;
+
+	rw_lower_file = fget_raw(daemon_fd);
+	if (!rw_lower_file)
+		return;
+	req->private_lower_rw_file = rw_lower_file;
+}
+
+static ssize_t fuse_stacked_read_write_iter(struct kiocb *iocb,
+					    struct iov_iter *iter, int do_write)
+{
+	ssize_t ret_val;
+	struct fuse_file *ff;
+	struct file *fuse_file, *lower_file;
+	struct inode *fuse_inode, *lower_inode;
+
+	ff = iocb->ki_filp->private_data;
+	fuse_file = iocb->ki_filp;
+	lower_file = ff->rw_lower_file;
+
+	/* lock lower file to prevent it from being released */
+	get_file(lower_file);
+	iocb->ki_filp = lower_file;
+	fuse_inode = fuse_file->f_path.dentry->d_inode;
+	lower_inode = file_inode(lower_file);
+
+	if (do_write) {
+		if (!lower_file->f_op->write_iter)
+			return -EIO;
+		ret_val = lower_file->f_op->write_iter(iocb, iter);
+
+		if (ret_val >= 0 || ret_val == -EIOCBQUEUED) {
+			fsstack_copy_inode_size(fuse_inode, lower_inode);
+			fsstack_copy_attr_times(fuse_inode, lower_inode);
+		}
+	} else {
+		if (!lower_file->f_op->read_iter)
+			return -EIO;
+		ret_val = lower_file->f_op->read_iter(iocb, iter);
+		if (ret_val >= 0 || ret_val == -EIOCBQUEUED)
+			fsstack_copy_attr_atime(fuse_inode, lower_inode);
+	}
+
+	iocb->ki_filp = fuse_file;
+	fput(lower_file);
+	/* unlock lower file */
+
+	return ret_val;
+}
+
+ssize_t fuse_stacked_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	return fuse_stacked_read_write_iter(iocb, to, 0);
+}
+
+ssize_t fuse_stacked_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	return fuse_stacked_read_write_iter(iocb, from, 1);
+}
+
+void fuse_stacked_release(struct fuse_file *ff)
+{
+	if (!(ff->rw_lower_file))
+		return;
+
+	/* Release the lower file. */
+	fput(ff->rw_lower_file);
+	ff->rw_lower_file = NULL;
+}
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 5974fae..16061d2 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -253,6 +253,7 @@ struct fuse_file_lock {
 #define FUSE_ASYNC_DIO		(1 << 15)
 #define FUSE_WRITEBACK_CACHE	(1 << 16)
 #define FUSE_NO_OPEN_SUPPORT	(1 << 17)
+#define FUSE_STACKED_IO		(1 << 18)
 
 /**
  * CUSE INIT request/reply flags
@@ -484,7 +485,7 @@ struct fuse_create_in {
 struct fuse_open_out {
 	uint64_t	fh;
 	uint32_t	open_flags;
-	uint32_t	padding;
+	int32_t         lower_fd;/* lower layer file descriptor */
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
