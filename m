From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/36] fs: add new vfs_poll and file_can_poll helpers
Date: Mon, 22 Jan 2018 21:12:19 +0100
Message-ID: <20180122201243.31610-13-hch@lst.de>
References: <20180122201243.31610-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180122201243.31610-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

These abstract out calls to the poll method in preparation for changes
in how we poll.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/staging/comedi/drivers/serial2002.c |  4 ++--
 drivers/vfio/virqfd.c                       |  2 +-
 drivers/vhost/vhost.c                       |  2 +-
 fs/eventpoll.c                              |  5 ++---
 fs/select.c                                 | 23 ++++++++---------------
 include/linux/poll.h                        | 12 ++++++++++++
 mm/memcontrol.c                             |  2 +-
 net/9p/trans_fd.c                           | 18 ++++--------------
 virt/kvm/eventfd.c                          |  2 +-
 9 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index a557be8a5076..5e2a2dc372e0 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -121,7 +121,7 @@ static void serial2002_tty_read_poll_wait(struct file *f, int timeout)
 		long elapsed;
 		__poll_t mask;
 
-		mask = f->f_op->poll(f, &table.pt);
+		mask = vfs_poll(f, &table.pt);
 		if (mask & (POLLRDNORM | POLLRDBAND | POLLIN |
 			    POLLHUP | POLLERR)) {
 			break;
@@ -144,7 +144,7 @@ static int serial2002_tty_read(struct file *f, int timeout)
 
 	result = -1;
 	if (!IS_ERR(f)) {
-		if (f->f_op->poll) {
+		if (file_can_poll(f)) {
 			serial2002_tty_read_poll_wait(f, timeout);
 
 			if (kernel_read(f, &ch, 1, &pos) == 1)
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index 8cc4b48ff127..ef539a07a08c 100644
--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -166,7 +166,7 @@ int vfio_virqfd_enable(void *opaque,
 	init_waitqueue_func_entry(&virqfd->wait, virqfd_wakeup);
 	init_poll_funcptr(&virqfd->pt, virqfd_ptable_queue_proc);
 
-	events = irqfd.file->f_op->poll(irqfd.file, &virqfd->pt);
+	events = vfs_poll(irqfd.file, &virqfd->pt);
 
 	/*
 	 * Check if there was an event already pending on the eventfd
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3bbeabff505a..b6311dc74d71 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -209,7 +209,7 @@ int vhost_poll_start(struct vhost_poll *poll, struct file *file)
 	if (poll->wqh)
 		return 0;
 
-	mask = file->f_op->poll(file, &poll->table);
+	mask = vfs_poll(file, &poll->table);
 	if (mask)
 		vhost_poll_wakeup(&poll->wait, 0, 0, poll_to_key(mask));
 	if (mask & POLLERR) {
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 42e35a6977c9..7d65f628810e 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -882,8 +882,7 @@ static unsigned int ep_item_poll(const struct epitem *epi, poll_table *pt,
 
 	pt->_key = epi->event.events;
 	if (!is_file_epoll(epi->ffd.file))
-		return epi->ffd.file->f_op->poll(epi->ffd.file, pt) &
-		       epi->event.events;
+		return vfs_poll(epi->ffd.file, pt) & epi->event.events;
 
 	ep = epi->ffd.file->private_data;
 	poll_wait(epi->ffd.file, &ep->poll_wait, pt);
@@ -2015,7 +2014,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 
 	/* The target file descriptor must support poll */
 	error = -EPERM;
-	if (!tf.file->f_op->poll)
+	if (!file_can_poll(tf.file))
 		goto error_tgt_fput;
 
 	/* Check if EPOLLWAKEUP is allowed */
diff --git a/fs/select.c b/fs/select.c
index 2ad66647f340..e96f1342c2f6 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -502,14 +502,10 @@ static int do_select(int n, fd_set_bits *fds, struct timespec64 *end_time)
 					continue;
 				f = fdget(i);
 				if (f.file) {
-					const struct file_operations *f_op;
-					f_op = f.file->f_op;
-					mask = DEFAULT_POLLMASK;
-					if (f_op->poll) {
-						wait_key_set(wait, in, out,
-							     bit, busy_flag);
-						mask = (*f_op->poll)(f.file, wait);
-					}
+					wait_key_set(wait, in, out, bit,
+						     busy_flag);
+					mask = vfs_poll(f.file, wait);
+
 					fdput(f);
 					if ((mask & POLLIN_SET) && (in & bit)) {
 						res_in |= bit;
@@ -818,13 +814,10 @@ static inline __poll_t do_pollfd(struct pollfd *pollfd, poll_table *pwait,
 
 	/* userland u16 ->events contains POLL... bitmap */
 	filter = demangle_poll(pollfd->events) | POLLERR | POLLHUP;
-	mask = DEFAULT_POLLMASK;
-	if (f.file->f_op->poll) {
-		pwait->_key = filter | busy_flag;
-		mask = f.file->f_op->poll(f.file, pwait);
-		if (mask & busy_flag)
-			*can_busy_poll = true;
-	}
+	pwait->_key = filter | busy_flag;
+	mask = vfs_poll(f.file, pwait);
+	if (mask & busy_flag)
+		*can_busy_poll = true;
 
 	/* Mask out unneeded events. */
 	mask &= filter;
diff --git a/include/linux/poll.h b/include/linux/poll.h
index a4b465fa2ca0..7afd259c570f 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -73,6 +73,18 @@ static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
 	pt->_key   = ~(__poll_t)0; /* all events enabled */
 }
 
+static inline bool file_can_poll(struct file *file)
+{
+	return file->f_op->poll;
+}
+
+static inline __poll_t vfs_poll(struct file *file, struct poll_table_struct *pt)
+{
+	if (unlikely(!file->f_op->poll))
+		return DEFAULT_POLLMASK;
+	return file->f_op->poll(file, pt);
+}
+
 struct poll_table_entry {
 	struct file *filp;
 	__poll_t key;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9011997d8a5c..284e69f345f8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3928,7 +3928,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	if (ret)
 		goto out_put_css;
 
-	efile.file->f_op->poll(efile.file, &event->pt);
+	vfs_poll(efile.file, &event->pt);
 
 	spin_lock(&memcg->event_list_lock);
 	list_add(&event->list, &memcg->event_list);
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index d6f7f7cb79c4..74df034726f8 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -231,7 +231,7 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 static __poll_t
 p9_fd_poll(struct p9_client *client, struct poll_table_struct *pt, int *err)
 {
-	__poll_t ret, n;
+	__poll_t ret;
 	struct p9_trans_fd *ts = NULL;
 
 	if (client && client->status == Connected)
@@ -243,19 +243,9 @@ p9_fd_poll(struct p9_client *client, struct poll_table_struct *pt, int *err)
 		return POLLERR;
 	}
 
-	if (!ts->rd->f_op->poll)
-		ret = DEFAULT_POLLMASK;
-	else
-		ret = ts->rd->f_op->poll(ts->rd, pt);
-
-	if (ts->rd != ts->wr) {
-		if (!ts->wr->f_op->poll)
-			n = DEFAULT_POLLMASK;
-		else
-			n = ts->wr->f_op->poll(ts->wr, pt);
-		ret = (ret & ~POLLOUT) | (n & ~POLLIN);
-	}
-
+	ret = vfs_poll(ts->rd, pt);
+	if (ts->rd != ts->wr)
+		ret = (vfs_poll(ts->wr, pt) & ~POLLIN) | (ret & ~POLLOUT);
 	return ret;
 }
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index a334399fafec..df8a23cbf457 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -397,7 +397,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	 * Check if there was an event already pending on the eventfd
 	 * before we registered, and trigger it as if we didn't miss it.
 	 */
-	events = f.file->f_op->poll(f.file, &irqfd->pt);
+	events = vfs_poll(f.file, &irqfd->pt);
 
 	if (events & POLLIN)
 		schedule_work(&irqfd->inject);
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
