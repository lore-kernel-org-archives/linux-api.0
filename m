From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 09/14] pipe: Add notification lossage handling [ver #3]
Date: Wed, 15 Jan 2020 13:31:56 +0000
Message-ID: <157909511604.20155.1902245459684441811.stgit@warthog.procyon.org.uk>
References: <157909503552.20155.3030058841911628518.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <157909503552.20155.3030058841911628518.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add handling for loss of notifications by having read() insert a
loss-notification message after it has read the pipe buffer that was last
in the ring when the loss occurred.

Lossage can come about either by running out of notification descriptors or
by running out of space in the pipe ring.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c                        |   28 ++++++++++++++++++++++++++++
 include/linux/pipe_fs_i.h        |    7 +++++++
 kernel/watch_queue.c             |    2 ++
 samples/watch_queue/watch_test.c |    3 +++
 4 files changed, 40 insertions(+)

diff --git a/fs/pipe.c b/fs/pipe.c
index 05d0b02ed08d..423aafca4338 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -311,6 +311,30 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 		unsigned int tail = pipe->tail;
 		unsigned int mask = pipe->ring_size - 1;
 
+#ifdef CONFIG_WATCH_QUEUE
+		if (pipe->note_loss) {
+			struct watch_notification n;
+
+			if (total_len < 8) {
+				if (ret == 0)
+					ret = -ENOBUFS;
+				break;
+			}
+
+			n.type = WATCH_TYPE_META;
+			n.subtype = WATCH_META_LOSS_NOTIFICATION;
+			n.info = watch_sizeof(n);
+			if (copy_to_iter(&n, sizeof(n), to) != sizeof(n)) {
+				if (ret == 0)
+					ret = -EFAULT;
+				break;
+			}
+			ret += sizeof(n);
+			total_len -= sizeof(n);
+			pipe->note_loss = false;
+		}
+#endif
+
 		if (!pipe_empty(head, tail)) {
 			struct pipe_buffer *buf = &pipe->bufs[tail & mask];
 			size_t chars = buf->len;
@@ -352,6 +376,10 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 			if (!buf->len) {
 				pipe_buf_release(pipe, buf);
 				spin_lock_irq(&pipe->wait.lock);
+#ifdef CONFIG_WATCH_QUEUE
+				if (buf->flags & PIPE_BUF_FLAG_LOSS)
+					pipe->note_loss = true;
+#endif
 				tail++;
 				pipe->tail = tail;
 				spin_unlock_irq(&pipe->wait.lock);
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index f86ae087aaca..810eb2b1efc6 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -9,6 +9,9 @@
 #define PIPE_BUF_FLAG_GIFT	0x04	/* page is a gift */
 #define PIPE_BUF_FLAG_PACKET	0x08	/* read() as a packet */
 #define PIPE_BUF_FLAG_WHOLE	0x10	/* read() must return entire buffer or error */
+#ifdef CONFIG_WATCH_QUEUE
+#define PIPE_BUF_FLAG_LOSS	0x20	/* Message loss happened after this buffer */
+#endif
 
 /**
  *	struct pipe_buffer - a linux kernel pipe buffer
@@ -33,6 +36,7 @@ struct pipe_buffer {
  *	@wait: reader/writer wait point in case of empty/full pipe
  *	@head: The point of buffer production
  *	@tail: The point of buffer consumption
+ *	@note_loss: The next read() should insert a data-lost message
  *	@max_usage: The maximum number of slots that may be used in the ring
  *	@ring_size: total number of buffers (should be a power of 2)
  *	@nr_accounted: The amount this pipe accounts for in user->pipe_bufs
@@ -55,6 +59,9 @@ struct pipe_inode_info {
 	unsigned int tail;
 	unsigned int max_usage;
 	unsigned int ring_size;
+#ifdef CONFIG_WATCH_QUEUE
+	bool note_loss;
+#endif
 	unsigned int nr_accounted;
 	unsigned int readers;
 	unsigned int writers;
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index a01f2fed0983..d48f422f391a 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -132,6 +132,8 @@ static bool post_one_notification(struct watch_queue *wqueue,
 	return done;
 
 lost:
+	buf = &pipe->bufs[(head - 1) & mask];
+	buf->flags |= PIPE_BUF_FLAG_LOSS;
 	goto out;
 }
 
diff --git a/samples/watch_queue/watch_test.c b/samples/watch_queue/watch_test.c
index 924e13a49c37..0eaff5dc04c3 100644
--- a/samples/watch_queue/watch_test.c
+++ b/samples/watch_queue/watch_test.c
@@ -120,6 +120,9 @@ static void consumer(int fd)
 					       (n.n.info & WATCH_INFO_ID) >>
 					       WATCH_INFO_ID__SHIFT);
 					break;
+				case WATCH_META_LOSS_NOTIFICATION:
+					printf("-- LOSS --\n");
+					break;
 				default:
 					printf("other meta record\n");
 					break;
