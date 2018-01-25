From: Benjamin LaHaise <ben@communityfibre.ca>
Subject: Re: aio poll, io_pgetevents and a new in-kernel poll API V4
Date: Thu, 25 Jan 2018 15:10:25 -0500
Message-ID: <20180125201025.GN23664@kvack.org>
References: <20180122201243.31610-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180122201243.31610-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 22, 2018 at 09:12:07PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds support for the IOCB_CMD_POLL operation to poll for the
> readyness of file descriptors using the aio subsystem.  The API is based
> on patches that existed in RHAS2.1 and RHEL3, which means it already is
> supported by libaio.  To implement the poll support efficiently new
> methods to poll are introduced in struct file_operations:  get_poll_head
> and poll_mask.  The first one returns a wait_queue_head to wait on
> (lifetime is bound by the file), and the second does a non-blocking
> check for the POLL* events.  This allows aio poll to work without
> any additional context switches, unlike epoll.

I implemented something similar back in December, but did so without
changing the in-kernel poll API.  See below for the patch that implements
it.  Is changing the in-kernel poll API really desirable given how many
drivers that will touch?

The tree with that as a work-in-progress is available at
git://git.kvack.org/~bcrl/aio-wip-20171215.git .  I have some time
scheduled right now to work on cleaning up that series which also includes
support for more aio options by making use of queue_work() to dispatch
operations that make use of helper threads.  The aio poll implementation
patch is below as an alternative approach.  It has passed some amount of
QA by Solace where we use it for a unified event loop with various
filesystem / block AIO combined with poll on TCP, unix domains sockets and
pipes.  Reworking cancellation was required to fix several lock
ordering issues that are impossible to address with the in-kernel aio
cancellation support.

		-ben


> To make the interface fully useful a new io_pgetevents system call is
> added, which atomically saves and restores the signal mask over the
> io_pgetevents system call.  It it the logical equivalent to pselect and
> ppoll for io_pgetevents.

That looks useful.  I'll have to look at this in detail.

		-ben


commit a299c474b19107122eae846b53f742d876f304f9
Author: Benjamin LaHaise <bcrl@kvack.org>
Date:   Fri Dec 15 13:19:23 2017 -0500

    aio: add aio poll implementation
    
    Some applications using AIO have a need to be able to poll on file
    descriptors.  This is typically the case with libraries using
    non-blocking operations inside of an application using an io_getevents()
    based main event loop.  This patch implements IOCB_CMD_POLL directly
    inside fs/aio.c using file_operations->poll() to insert a waiter.  This
    avoids the need to use helper threads, enabling completion events to be
    generated directly in interrupt or task context.

diff --git a/fs/aio.c b/fs/aio.c
index 3381b2e..23b9a06 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -43,6 +43,7 @@
 
 #include <asm/kmap_types.h>
 #include <linux/uaccess.h>
+#include <linux/interrupt.h>
 
 #include "internal.h"
 
@@ -172,7 +173,7 @@ struct kioctx {
  * synchronize cancellation and completion - we only set it to KIOCB_CANCELLED
  * with xchg() or cmpxchg(), see batch_complete_aio() and kiocb_cancel().
  */
-#define KIOCB_CANCELLED		((void *) (~0ULL))
+#define KIOCB_CANCELLED		((void *) (~5ULL))
 
 struct aio_kiocb {
 	struct kiocb		common;
@@ -205,6 +206,13 @@ struct aio_kiocb {
 	aio_thread_work_fn_t	ki_work_fn;
 	struct work_struct	ki_work;
 #endif
+
+	unsigned long			ki_data;
+	struct poll_table_struct	poll;
+	struct tasklet_struct		tasklet;
+	int				wait_idx;
+	unsigned			events;
+	struct poll_table_entry		poll_wait[2];
 };
 
 /*------ sysctl variables----*/
@@ -212,7 +220,7 @@ struct aio_kiocb {
 unsigned long aio_nr;		/* current system wide number of aio requests */
 unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio requests */
 #if IS_ENABLED(CONFIG_AIO_THREAD)
-unsigned long aio_auto_threads;	/* Currently disabled by default */
+unsigned long aio_auto_threads = 1;	/* Currently disabled by default */
 #endif
 /*----end sysctl variables---*/
 
@@ -1831,6 +1839,213 @@ static ssize_t aio_write(struct aio_kiocb *kiocb, struct iocb *iocb, bool compat
 	return ret;
 }
 
+static int aio_poll_cancel_cb(struct kiocb *iocb, unsigned long data, int ret)
+{
+	struct aio_kiocb *req = container_of(iocb, struct aio_kiocb, common);
+	unsigned i;
+
+	for (i=0; i<req->wait_idx; i++) {
+		wait_queue_head_t *head = req->poll_wait[i].wait_address;
+		remove_wait_queue(head, &req->poll_wait[i].wait);
+	}
+
+	aio_complete(iocb, -EINTR, 0);
+	return 0;
+}
+
+static int aio_poll_cancel(struct kiocb *iocb, kiocb_cancel_cb_fn **cb_p,
+			   unsigned long *data_p)
+{
+	*cb_p = aio_poll_cancel_cb;
+	*data_p = 0;
+	return 0;
+}
+
+static int aio_poll_cancel_early(struct kiocb *iocb, kiocb_cancel_cb_fn **cb_p,
+				 unsigned long *data_p)
+{
+	return 0;
+}
+
+void aio_poll_tasklet(unsigned long data)
+{
+	struct aio_kiocb *req = (void *)data;
+	unsigned i;
+
+	for (i=0; i < req->wait_idx; i++) {
+		struct poll_table_entry *entry = &req->poll_wait[i];
+		if (!entry->wait_address)
+			continue;
+		BUG_ON(entry->wait.private != req);
+		remove_wait_queue(entry->wait_address, &entry->wait);
+	}
+	aio_complete(&req->common, req->events, 0);
+}
+
+static void aio_poll_work(struct work_struct *work)
+{
+	struct aio_kiocb *req = container_of(work, struct aio_kiocb, ki_work);
+	int ret;
+
+	ret = req->common.ki_filp->f_op->poll(req->common.ki_filp, NULL);
+	if (ret & req->poll._key) {
+		bit_spin_lock(0, &req->ki_data2);
+		req->events |= ret & req->poll._key;
+		bit_spin_unlock(0, &req->ki_data2);
+		aio_poll_tasklet((unsigned long)req);
+		return;
+	}
+	printk("poll sucks. FIXME! ret=%d\n", ret);
+}
+
+static int aio_poll_wake(wait_queue_entry_t *wait, unsigned mode, int sync,
+			 void *key)
+{
+	struct poll_table_entry *entry = container_of(wait, struct poll_table_entry, wait);
+	struct aio_kiocb *req = wait->private;
+	unsigned long events = (unsigned long)key;
+
+	if (!events) {
+		kiocb_cancel_fn *cancel, *old_cancel = req->ki_cancel;
+
+		/* If someone else is going to complete the poll, return. */
+		if (test_and_set_bit(1, &req->ki_data2))
+			return 0;
+		if (old_cancel == aio_poll_cancel ||
+		    old_cancel == aio_poll_cancel_early) {
+			cancel = cmpxchg(&req->ki_cancel, old_cancel, KIOCB_CANCELLED);
+			if (cancel == old_cancel) {
+				if (old_cancel == aio_poll_cancel)
+					queue_work(system_long_wq, &req->ki_work);
+			}
+		}
+		return 0;
+	}
+
+	events &= req->poll._key;
+	if (events) {
+		kiocb_cancel_fn *cancel, *old_cancel;
+		wait_queue_head_t *orig_head;
+		bool need_tasklet = false;
+		unsigned i;
+
+		bit_spin_lock(0, &req->ki_data2);
+		req->events |= events;
+		bit_spin_unlock(0, &req->ki_data2);
+
+		old_cancel = req->ki_cancel;
+		if (old_cancel != aio_poll_cancel &&
+		    old_cancel != aio_poll_cancel_early) {
+			printk("req(%p) cancel(%p) != aio_poll_cancel\n", req, old_cancel);
+			return 0;
+		}
+		cancel = cmpxchg(&req->ki_cancel, old_cancel, KIOCB_CANCELLED);
+		if (cancel != old_cancel) {
+			printk("req(%p) cancel(%p) != old_cancel(%p)\n",
+				req, cancel, old_cancel);
+			return 0;
+		}
+		if (cancel == aio_poll_cancel_early)
+			return 0;
+		orig_head = entry->wait_address;
+		BUG_ON(orig_head == NULL);
+
+		for (i=0; i < req->wait_idx; i++) {
+			wait_queue_head_t *head;
+			entry = &req->poll_wait[i];
+			head = entry->wait_address;
+			if (!head)
+				continue;
+			BUG_ON(entry->wait.private != req);
+			if (head == orig_head) {
+				entry->wait.private = NULL;
+				entry->wait_address = NULL;
+				__remove_wait_queue(head, &entry->wait);
+			} else if (spin_trylock(&head->lock)) {
+				entry->wait.private = NULL;
+				entry->wait_address = NULL;
+				__remove_wait_queue(head, &entry->wait);
+				spin_unlock(&head->lock);
+			} else
+				need_tasklet = true;
+		}
+		if (!need_tasklet) {
+			//printk("aio_poll_wake(%p): completing with events=%lu\n", req, events);
+			aio_complete(&req->common, events, 0);
+		} else
+			tasklet_schedule(&req->tasklet);
+	}
+
+	return 0;
+}
+
+void aio_poll_queue_proc(struct file *file, wait_queue_head_t *head,
+			 struct poll_table_struct *pt)
+{
+	struct aio_kiocb *req = container_of(pt, struct aio_kiocb, poll);
+	struct poll_table_entry *entry = &req->poll_wait[req->wait_idx];
+
+	if (req->wait_idx >= 2) {
+		req->ki_data = (unsigned long)(long)-EOVERFLOW;
+		return;
+	}
+	init_waitqueue_func_entry(&entry->wait, aio_poll_wake);
+	entry->wait.private = req;
+	entry->wait_address = head;
+	add_wait_queue(head, &entry->wait);
+	req->wait_idx++;
+}
+static long aio_poll(struct aio_kiocb *req, struct iocb *iocb, bool compat)
+{
+	kiocb_cancel_fn *cancel = aio_poll_cancel_early;
+	unsigned short mask = iocb->aio_buf;
+	bool doing_complete = false;
+	unsigned int ret;
+	unsigned i;
+
+	if (mask != iocb->aio_buf)
+		return -EINVAL;
+
+	if (!req->common.ki_filp->f_op->poll) {
+		return -EINVAL;
+	}
+
+	tasklet_init(&req->tasklet, aio_poll_tasklet, (unsigned long)req);
+	kiocb_set_cancel_fn(&req->common, aio_poll_cancel_early);
+	INIT_WORK(&req->ki_work, aio_poll_work);
+
+	req->ki_data = 0;
+	req->ki_data2 = 0;
+	init_poll_funcptr(&req->poll, aio_poll_queue_proc);
+	req->poll._key = mask;
+	ret = req->common.ki_filp->f_op->poll(req->common.ki_filp, &req->poll);
+
+	if (req->ki_data) {
+		doing_complete = true;
+		ret = req->ki_data;
+	} else if (ret & mask) {
+		doing_complete = true;
+		ret = ret & mask;
+	} else {
+		kiocb_cancel_fn *may_cancel = aio_poll_cancel;
+		cancel = cmpxchg(&req->ki_cancel, cancel, may_cancel);
+		if (cancel != aio_poll_cancel_early) {
+			doing_complete = true;
+			ret = -EINTR;
+		}
+	}
+
+	if (doing_complete) {
+		for (i=0; i < req->wait_idx; i++) {
+			struct poll_table_entry *entry = &req->poll_wait[i];
+			BUG_ON(entry->wait.private != req);
+			remove_wait_queue(entry->wait_address, &entry->wait);
+		}
+		aio_complete(&req->common, ret, 0);
+	}
+	return -EIOCBQUEUED;
+}
+
 typedef ssize_t (*aio_submit_fn_t)(struct aio_kiocb *req, struct iocb *iocb,
 				   bool compat);
 
@@ -1847,6 +2062,7 @@ struct submit_info {
 	[IOCB_CMD_PWRITE]	= { aio_write,	NEED_FD },
 	[IOCB_CMD_PREADV]	= { aio_read,	NEED_FD },
 	[IOCB_CMD_PWRITEV]	= { aio_write,	NEED_FD },
+	[IOCB_CMD_POLL]		= { aio_poll,	NEED_FD },
 };
 
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index a04adbc..6f48805 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -38,10 +38,10 @@ enum {
 	IOCB_CMD_PWRITE = 1,
 	IOCB_CMD_FSYNC = 2,
 	IOCB_CMD_FDSYNC = 3,
-	/* These two are experimental.
+	/* This was experimental.
 	 * IOCB_CMD_PREADX = 4,
-	 * IOCB_CMD_POLL = 5,
 	 */
+	IOCB_CMD_POLL = 5,
 	IOCB_CMD_NOOP = 6,
 	IOCB_CMD_PREADV = 7,
 	IOCB_CMD_PWRITEV = 8,

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
