From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/31] net: add support for ->poll_mask in proto_ops
Date: Tue, 22 May 2018 13:30:48 +0200
Message-ID: <20180522113108.25713-12-hch@lst.de>
References: <20180522113108.25713-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180522113108.25713-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The socket file operations still implement ->poll until all protocols are
switched over.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/net.h |  1 +
 net/socket.c        | 48 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 2248a052061d..3fd9d8c16581 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -147,6 +147,7 @@ struct proto_ops {
 	int		(*getname)   (struct socket *sock,
 				      struct sockaddr *addr,
 				      int peer);
+	__poll_t	(*poll_mask) (struct socket *sock, __poll_t events);
 	__poll_t	(*poll)	     (struct file *file, struct socket *sock,
 				      struct poll_table_struct *wait);
 	int		(*ioctl)     (struct socket *sock, unsigned int cmd,
diff --git a/net/socket.c b/net/socket.c
index 571ee4005192..2d752e9eb3f9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -117,8 +117,10 @@ static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from);
 static int sock_mmap(struct file *file, struct vm_area_struct *vma);
 
 static int sock_close(struct inode *inode, struct file *file);
-static __poll_t sock_poll(struct file *file,
-			      struct poll_table_struct *wait);
+static struct wait_queue_head *sock_get_poll_head(struct file *file,
+		__poll_t events);
+static __poll_t sock_poll_mask(struct file *file, __poll_t);
+static __poll_t sock_poll(struct file *file, struct poll_table_struct *wait);
 static long sock_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
 static long compat_sock_ioctl(struct file *file,
@@ -141,6 +143,8 @@ static const struct file_operations socket_file_ops = {
 	.llseek =	no_llseek,
 	.read_iter =	sock_read_iter,
 	.write_iter =	sock_write_iter,
+	.get_poll_head = sock_get_poll_head,
+	.poll_mask =	sock_poll_mask,
 	.poll =		sock_poll,
 	.unlocked_ioctl = sock_ioctl,
 #ifdef CONFIG_COMPAT
@@ -1114,14 +1118,48 @@ int sock_create_lite(int family, int type, int protocol, struct socket **res)
 }
 EXPORT_SYMBOL(sock_create_lite);
 
+static struct wait_queue_head *sock_get_poll_head(struct file *file,
+		__poll_t events)
+{
+	struct socket *sock = file->private_data;
+
+	if (!sock->ops->poll_mask)
+		return NULL;
+	sock_poll_busy_loop(sock, events);
+	return sk_sleep(sock->sk);
+}
+
+static __poll_t sock_poll_mask(struct file *file, __poll_t events)
+{
+	struct socket *sock = file->private_data;
+
+	/*
+	 * We need to be sure we are in sync with the socket flags modification.
+	 *
+	 * This memory barrier is paired in the wq_has_sleeper.
+	 */
+	smp_mb();
+
+	/* this socket can poll_ll so tell the system call */
+	return sock->ops->poll_mask(sock, events) |
+		(sk_can_busy_loop(sock->sk) ? POLL_BUSY_LOOP : 0);
+}
+
 /* No kernel lock held - perfect */
 static __poll_t sock_poll(struct file *file, poll_table *wait)
 {
 	struct socket *sock = file->private_data;
-	__poll_t events = poll_requested_events(wait);
+	__poll_t events = poll_requested_events(wait), mask = 0;
 
-	sock_poll_busy_loop(sock, events);
-	return sock->ops->poll(file, sock, wait) | sock_poll_busy_flag(sock);
+	if (sock->ops->poll) {
+		sock_poll_busy_loop(sock, events);
+		mask = sock->ops->poll(file, sock, wait);
+	} else if (sock->ops->poll_mask) {
+		sock_poll_wait(file, sock_get_poll_head(file, events), wait);
+		mask = sock->ops->poll_mask(sock, events);
+	}
+
+	return mask | sock_poll_busy_flag(sock);
 }
 
 static int sock_mmap(struct file *file, struct vm_area_struct *vma)
-- 
2.17.0

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
