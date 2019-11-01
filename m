From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 08/11] pipe: Rearrange sequence in pipe_write() to
 preallocate slot [ver #3]
Date: Fri, 01 Nov 2019 17:35:15 +0000
Message-ID: <157262971590.13142.1426435250123334464.stgit@warthog.procyon.org.uk>
References: <157262963995.13142.5568934007158044624.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157262963995.13142.5568934007158044624.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
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

 fs/pipe.c |   51 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index c16950e36ded..ce77ac0d8901 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -387,7 +387,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 {
 =09struct file *filp =3D iocb->ki_filp;
 =09struct pipe_inode_info *pipe =3D filp->private_data;
-=09unsigned int head, tail, max_usage, mask;
+=09unsigned int head, max_usage, mask;
 =09ssize_t ret =3D 0;
 =09int do_wakeup =3D 0;
 =09size_t total_len =3D iov_iter_count(from);
@@ -405,14 +405,13 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 =09=09goto out;
 =09}
=20
-=09tail =3D pipe->tail;
 =09head =3D pipe->head;
 =09max_usage =3D pipe->max_usage;
 =09mask =3D pipe->ring_size - 1;
=20
 =09/* We try to merge small writes */
 =09chars =3D total_len & (PAGE_SIZE-1); /* size of the last buffer */
-=09if (!pipe_empty(head, tail) && chars !=3D 0) {
+=09if (!pipe_empty(head, pipe->tail) && chars !=3D 0) {
 =09=09struct pipe_buffer *buf =3D &pipe->bufs[(head - 1) & mask];
 =09=09int offset =3D buf->offset + buf->len;
=20
@@ -441,8 +440,8 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 =09=09=09break;
 =09=09}
=20
-=09=09tail =3D pipe->tail;
-=09=09if (!pipe_full(head, tail, max_usage)) {
+=09=09head =3D pipe->head;
+=09=09if (!pipe_full(head, pipe->tail, max_usage)) {
 =09=09=09struct pipe_buffer *buf =3D &pipe->bufs[head & mask];
 =09=09=09struct page *page =3D pipe->tmp_page;
 =09=09=09int copied;
@@ -455,40 +454,56 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 =09=09=09=09}
 =09=09=09=09pipe->tmp_page =3D page;
 =09=09=09}
+
+=09=09=09/* Allocate a slot in the ring in advance and attach an
+=09=09=09 * empty buffer.  If we fault or otherwise fail to use
+=09=09=09 * it, either the reader will consume it or it'll still
+=09=09=09 * be there for the next write.
+=09=09=09 */
+=09=09=09spin_lock_irq(&pipe->wait.lock);
+
+=09=09=09head =3D pipe->head;
+=09=09=09pipe->head =3D head + 1;
+
 =09=09=09/* Always wake up, even if the copy fails. Otherwise
 =09=09=09 * we lock up (O_NONBLOCK-)readers that sleep due to
 =09=09=09 * syscall merging.
 =09=09=09 * FIXME! Is this really true?
 =09=09=09 */
-=09=09=09do_wakeup =3D 1;
-=09=09=09copied =3D copy_page_from_iter(page, 0, PAGE_SIZE, from);
-=09=09=09if (unlikely(copied < PAGE_SIZE && iov_iter_count(from))) {
-=09=09=09=09if (!ret)
-=09=09=09=09=09ret =3D -EFAULT;
-=09=09=09=09break;
-=09=09=09}
-=09=09=09ret +=3D copied;
+=09=09=09wake_up_interruptible_sync_poll_locked(
+=09=09=09=09&pipe->wait, EPOLLIN | EPOLLRDNORM);
+
+=09=09=09spin_unlock_irq(&pipe->wait.lock);
+=09=09=09kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
=20
 =09=09=09/* Insert it into the buffer array */
+=09=09=09buf =3D &pipe->bufs[head & mask];
 =09=09=09buf->page =3D page;
 =09=09=09buf->ops =3D &anon_pipe_buf_ops;
 =09=09=09buf->offset =3D 0;
-=09=09=09buf->len =3D copied;
+=09=09=09buf->len =3D 0;
 =09=09=09buf->flags =3D 0;
 =09=09=09if (is_packetized(filp)) {
 =09=09=09=09buf->ops =3D &packet_pipe_buf_ops;
 =09=09=09=09buf->flags =3D PIPE_BUF_FLAG_PACKET;
 =09=09=09}
-
-=09=09=09head++;
-=09=09=09pipe->head =3D head;
 =09=09=09pipe->tmp_page =3D NULL;
=20
+=09=09=09copied =3D copy_page_from_iter(page, 0, PAGE_SIZE, from);
+=09=09=09if (unlikely(copied < PAGE_SIZE && iov_iter_count(from))) {
+=09=09=09=09if (!ret)
+=09=09=09=09=09ret =3D -EFAULT;
+=09=09=09=09break;
+=09=09=09}
+=09=09=09ret +=3D copied;
+=09=09=09buf->offset =3D 0;
+=09=09=09buf->len =3D copied;
+
 =09=09=09if (!iov_iter_count(from))
 =09=09=09=09break;
 =09=09}
=20
-=09=09if (!pipe_full(head, tail, max_usage))
+=09=09if (!pipe_full(head, pipe->tail, max_usage))
 =09=09=09continue;
=20
 =09=09/* Wait for buffer space to become available. */
