From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 06/21] pipe: Rearrange sequence in pipe_write() to
 preallocate slot
Date: Tue, 15 Oct 2019 22:48:43 +0100
Message-ID: <157117612345.15019.10880434751559609346.stgit@warthog.procyon.org.uk>
References: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Rearrange the sequence in pipe_write() so that the allocation of the new
buffer, the allocation of a ring slot and the attachment to the ring is
done under the pipe wait spinlock and then the lock is dropped and the
buffer can be filled.

The data copy needs to be done with the spinlock unheld and irqs enabled,
so the lock needs to be dropped first.  However, the reader can't progress
as we're holding pipe->mutex.

We also need to drop the lock as that would impact others looking at the
pipe waitqueue, such as poll(), the consumer and a future kernel message
writer.

We just abandon the preallocated slot if we get a copy error.  Future
writes may continue it and a future read will eventually recycle it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c |   53 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 0d25cb090a03..5a199b249191 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -386,7 +386,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *filp = iocb->ki_filp;
 	struct pipe_inode_info *pipe = filp->private_data;
-	unsigned int head, tail, buffers, mask;
+	unsigned int head, buffers, mask;
 	ssize_t ret = 0;
 	int do_wakeup = 0;
 	size_t total_len = iov_iter_count(from);
@@ -404,14 +404,13 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 	}
 
-	tail = pipe->tail;
 	head = pipe->head;
 	buffers = pipe->max_usage;
 	mask = pipe->ring_size - 1;
 
 	/* We try to merge small writes */
 	chars = total_len & (PAGE_SIZE-1); /* size of the last buffer */
-	if (head != tail && chars != 0) {
+	if (head != pipe->tail && chars != 0) {
 		struct pipe_buffer *buf = &pipe->bufs[(head - 1) & mask];
 		int offset = buf->offset + buf->len;
 
@@ -440,9 +439,9 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 			break;
 		}
 
-		tail = pipe->tail;
-		if (head - tail < buffers) {
-			struct pipe_buffer *buf = &pipe->bufs[head & mask];
+		head = pipe->head;
+		if (head - pipe->tail < buffers) {
+			struct pipe_buffer *buf;
 			struct page *page = pipe->tmp_page;
 			int copied;
 
@@ -454,40 +453,56 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 				}
 				pipe->tmp_page = page;
 			}
+
+			/* Allocate a slot in the ring in advance and attach an
+			 * empty buffer.  If we fault or otherwise fail to use
+			 * it, either the reader will consume it or it'll still
+			 * be there for the next write.
+			 */
+			spin_lock_irq(&pipe->wait.lock);
+
+			head = pipe->head;
+			pipe_commit_write(pipe, head + 1);
+
 			/* Always wake up, even if the copy fails. Otherwise
 			 * we lock up (O_NONBLOCK-)readers that sleep due to
 			 * syscall merging.
 			 * FIXME! Is this really true?
 			 */
-			do_wakeup = 1;
-			copied = copy_page_from_iter(page, 0, PAGE_SIZE, from);
-			if (unlikely(copied < PAGE_SIZE && iov_iter_count(from))) {
-				if (!ret)
-					ret = -EFAULT;
-				break;
-			}
-			ret += copied;
+			prelocked_wake_up_interruptible_sync_poll(
+				&pipe->wait, EPOLLIN | EPOLLRDNORM);
+
+			spin_unlock_irq(&pipe->wait.lock);
+			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 
 			/* Insert it into the buffer array */
+			buf = &pipe->bufs[head & mask];
 			buf->page = page;
 			buf->ops = &anon_pipe_buf_ops;
 			buf->offset = 0;
-			buf->len = copied;
+			buf->len = 0;
 			buf->flags = 0;
 			if (is_packetized(filp)) {
 				buf->ops = &packet_pipe_buf_ops;
 				buf->flags = PIPE_BUF_FLAG_PACKET;
 			}
-
-			head++;
-			pipe_commit_write(pipe, head);
 			pipe->tmp_page = NULL;
 
+			copied = copy_page_from_iter(page, 0, PAGE_SIZE, from);
+			if (unlikely(copied < PAGE_SIZE && iov_iter_count(from))) {
+				if (!ret)
+					ret = -EFAULT;
+				break;
+			}
+			ret += copied;
+			buf->offset = 0;
+			buf->len = copied;
+
 			if (!iov_iter_count(from))
 				break;
 		}
 
-		if (head - tail < buffers)
+		if (pipe->head - pipe->tail < buffers)
 			continue;
 
 		/* Wait for buffer space to become available. */
