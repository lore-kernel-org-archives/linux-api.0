From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/36] fs: introduce new ->get_poll_head and ->poll_mask methods
Date: Wed, 17 Jan 2018 20:27:19 +0100
Message-ID: <20180117192742.710-14-hch@lst.de>
References: <20180117192742.710-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180117192742.710-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

->get_poll_head returns the waitqueue that the poll operation is going
to sleep on.  Note that this means we can only use a single waitqueue
for the poll, unlike some current drivers that use two waitqueues for
different events.  But now that we have keyed wakeups and heavily use
those for poll there aren't that many good reason left to keep the
multiple waitqueues, and if there are any ->poll is still around, the
driver just won't support aio poll.

->poll_mask is called before going to sleep to check for already pending
events, and after the wakeup to return the actual mask of events reported
by poll.  It can be called with the waitqueue lock held to gurantee
race free checking for events and to be called from the waitqueue
wake callback, but the legacy callers don't hold it yet.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/Locking |  7 ++++++-
 Documentation/filesystems/vfs.txt | 11 +++++++++++
 fs/select.c                       | 29 +++++++++++++++++++++++++++++
 include/linux/fs.h                |  2 ++
 include/linux/poll.h              | 19 +++++++++++++++----
 5 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 220bba28f72b..6d227f9d7bd9 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -440,6 +440,8 @@ prototypes:
 	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
 	int (*iterate) (struct file *, struct dir_context *);
 	__poll_t (*poll) (struct file *, struct poll_table_struct *);
+	struct wait_queue_head * (*get_poll_head)(struct file *, __poll_t);
+	__poll_t (*poll_mask) (struct file *, __poll_t);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
@@ -470,7 +472,7 @@ prototypes:
 };
 
 locking rules:
-	All may block.
+	All except for ->poll_mask may block.
 
 ->llseek() locking has moved from llseek to the individual llseek
 implementations.  If your fs is not using generic_file_llseek, you
@@ -498,6 +500,9 @@ in sys_read() and friends.
 the lease within the individual filesystem to record the result of the
 operation
 
+->poll_mask can be called with or without the waitqueue lock for the waitqueue
+returned from ->get_poll_head.
+
 --------------------------- dquot_operations -------------------------------
 prototypes:
 	int (*write_dquot) (struct dquot *);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index f608180ad59d..17e0355be7d1 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -857,6 +857,8 @@ struct file_operations {
 	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
 	int (*iterate) (struct file *, struct dir_context *);
 	__poll_t (*poll) (struct file *, struct poll_table_struct *);
+	struct wait_queue_head * (*get_poll_head)(struct file *, __poll_t);
+	__poll_t (*poll_mask) (struct file *, __poll_t);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
@@ -901,6 +903,15 @@ otherwise noted.
 	activity on this file and (optionally) go to sleep until there
 	is activity. Called by the select(2) and poll(2) system calls
 
+  get_poll_head: Returns the struct wait_queue_head that poll, select,
+  epoll or aio poll should wait on in case this instance only has single
+  waitqueue.  Can return NULL to indicate polling is not supported.
+
+  poll_mask: return the mask of POLL* values describing the file descriptor
+  state.  Called before going to sleep on the waitqueue returned by
+  get_poll_head, and after it has been woken.  If ->get_poll_head and
+  ->poll_mask are implemented ->poll does not need to be implement.
+
   unlocked_ioctl: called by the ioctl(2) system call.
 
   compat_ioctl: called by the ioctl(2) system call when 32 bit system calls
diff --git a/fs/select.c b/fs/select.c
index e96f1342c2f6..707abe79536b 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -34,6 +34,35 @@
 
 #include <linux/uaccess.h>
 
+__poll_t vfs_poll(struct file *file, struct poll_table_struct *pt)
+{
+	unsigned int events = poll_requested_events(pt), mask;
+	struct wait_queue_head *head;
+
+	if (unlikely(!file_can_poll(file)))
+		return DEFAULT_POLLMASK;
+
+	if (file->f_op->poll)
+		return file->f_op->poll(file, pt);
+
+	/*
+	 * Only get the poll head and do the first mask check if we are actually
+	 * going to sleep on this file:
+	 */
+	if (pt && pt->_qproc) {
+		head = vfs_get_poll_head(file, events);
+		if (!head)
+			return DEFAULT_POLLMASK;
+		mask = file->f_op->poll_mask(file, events);
+		if (mask)
+			return mask;
+
+		pt->_qproc(file, head, pt);
+	}
+
+	return file->f_op->poll_mask(file, events);
+}
+EXPORT_SYMBOL_GPL(vfs_poll);
 
 /*
  * Estimate expected accuracy in ns from a timeval.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 34c0434511c7..f7dd8eb1eb85 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1699,6 +1699,8 @@ struct file_operations {
 	int (*iterate) (struct file *, struct dir_context *);
 	int (*iterate_shared) (struct file *, struct dir_context *);
 	__poll_t (*poll) (struct file *, struct poll_table_struct *);
+	struct wait_queue_head * (*get_poll_head)(struct file *, __poll_t);
+	__poll_t (*poll_mask) (struct file *, __poll_t);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
diff --git a/include/linux/poll.h b/include/linux/poll.h
index 7afd259c570f..7ce8b7f902cd 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -75,16 +75,27 @@ static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
 
 static inline bool file_can_poll(struct file *file)
 {
-	return file->f_op->poll;
+	return file->f_op->poll ||
+		(file->f_op->get_poll_head && file->f_op->poll_mask);
 }
 
-static inline __poll_t vfs_poll(struct file *file, struct poll_table_struct *pt)
+static inline struct wait_queue_head *vfs_get_poll_head(struct file *file,
+		__poll_t events)
 {
-	if (unlikely(!file->f_op->poll))
+	if (unlikely(!file->f_op->get_poll_head || !file->f_op->poll_mask))
+		return NULL;
+	return file->f_op->get_poll_head(file, events);
+}
+
+static inline __poll_t vfs_poll_mask(struct file *file, __poll_t events)
+{
+	if (unlikely(!file->f_op->poll_mask))
 		return DEFAULT_POLLMASK;
-	return file->f_op->poll(file, pt);
+	return file->f_op->poll_mask(file, events) & events;
 }
 
+__poll_t vfs_poll(struct file *file, struct poll_table_struct *pt);
+
 struct poll_table_entry {
 	struct file *filp;
 	__poll_t key;
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
