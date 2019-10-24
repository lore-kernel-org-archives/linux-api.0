From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 11/10] pipe: Add fsync() support [ver #2]
Date: Thu, 24 Oct 2019 17:57:32 +0100
Message-ID: <30394.1571936252@warthog.procyon.org.uk>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
Content-ID: <30392.1571936252.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

pipe: Add fsync() support

The keyrings testsuite needs the ability to wait for all the outstanding
notifications in the queue to have been processed so that it can then go
through them to find out whether the notifications it expected have been
emitted.

Implement fsync() support for pipes to provide this.  The tailmost buffer
at the point of calling is marked and fsync adds itself to the list of
waiters, noting the tail position to be waited for and marking the buffer
as no longer mergeable.  Then when the buffer is consumed, if the flag is
set, any matching waiters are woken up.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 fs/fuse/dev.c             |    1=20
 fs/pipe.c                 |   61 +++++++++++++++++++++++++++++++++++++++++=
+++++
 fs/splice.c               |    3 ++
 include/linux/pipe_fs_i.h |   22 ++++++++++++++++
 lib/iov_iter.c            |    2 -
 5 files changed, 88 insertions(+), 1 deletion(-)


diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5ef57a322cb8..9617a35579cb 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1983,6 +1983,7 @@ static ssize_t fuse_dev_splice_write(struct pipe_inod=
e_info *pipe,
 =09=09if (rem >=3D ibuf->len) {
 =09=09=09*obuf =3D *ibuf;
 =09=09=09ibuf->ops =3D NULL;
+=09=09=09pipe_wake_fsync(pipe, ibuf, tail);
 =09=09=09tail++;
 =09=09=09pipe_commit_read(pipe, tail);
 =09=09} else {
diff --git a/fs/pipe.c b/fs/pipe.c
index 6a982a88f658..8e5fd7314be1 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -30,6 +30,12 @@
=20
 #include "internal.h"
=20
+struct pipe_fsync {
+=09struct list_head=09link;=09=09/* Link in pipe->fsync */
+=09struct completion=09done;
+=09unsigned int=09=09tail;=09=09/* The buffer being waited for */
+};
+
 /*
  * The max size that a non-root user is allowed to grow the pipe. Can
  * be set by root in /proc/sys/fs/pipe-max-size
@@ -269,6 +275,58 @@ static bool pipe_buf_can_merge(struct pipe_buffer *buf=
)
 =09return buf->ops =3D=3D &anon_pipe_buf_ops;
 }
=20
+/*
+ * Wait for all the data currently in the pipe to be consumed.
+ */
+static int pipe_fsync(struct file *file, loff_t a, loff_t b, int datasync)
+{
+=09struct pipe_inode_info *pipe =3D file->private_data;
+=09struct pipe_buffer *buf;
+=09struct pipe_fsync fsync;
+=09unsigned int head, tail, mask;
+
+=09pipe_lock(pipe);
+
+=09head =3D pipe->head;
+=09tail =3D pipe->tail;
+=09mask =3D pipe->ring_size - 1;
+
+=09if (pipe_empty(head, tail)) {
+=09=09pipe_unlock(pipe);
+=09=09return 0;
+=09}
+
+=09init_completion(&fsync.done);
+=09fsync.tail =3D tail;
+=09buf =3D &pipe->bufs[tail & mask];
+=09buf->flags |=3D PIPE_BUF_FLAG_FSYNC;
+=09pipe_buf_mark_unmergeable(buf);
+=09list_add_tail(&fsync.link, &pipe->fsync);
+=09pipe_unlock(pipe);
+
+=09if (wait_for_completion_interruptible(&fsync.done) < 0) {
+=09=09pipe_lock(pipe);
+=09=09list_del(&fsync.link);
+=09=09pipe_unlock(pipe);
+=09=09return -EINTR;
+=09}
+
+=09return 0;
+}
+
+void __pipe_wake_fsync(struct pipe_inode_info *pipe, unsigned int tail)
+{
+=09struct pipe_fsync *fsync, *p;
+
+=09list_for_each_entry_safe(fsync, p, &pipe->fsync, link) {
+=09=09if (fsync->tail =3D=3D tail) {
+=09=09=09list_del_init(&fsync->link);
+=09=09=09complete(&fsync->done);
+=09=09}
+=09}
+}
+EXPORT_SYMBOL(__pipe_wake_fsync);
+
 static ssize_t
 pipe_read(struct kiocb *iocb, struct iov_iter *to)
 {
@@ -325,6 +383,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 =09=09=09if (!buf->len) {
 =09=09=09=09pipe_buf_release(pipe, buf);
 =09=09=09=09spin_lock_irq(&pipe->wait.lock);
+=09=09=09=09pipe_wake_fsync(pipe, buf, tail);
 =09=09=09=09tail++;
 =09=09=09=09pipe_commit_read(pipe, tail);
 =09=09=09=09do_wakeup =3D 1;
@@ -717,6 +776,7 @@ struct pipe_inode_info *alloc_pipe_info(void)
 =09=09pipe->ring_size =3D pipe_bufs;
 =09=09pipe->user =3D user;
 =09=09mutex_init(&pipe->mutex);
+=09=09INIT_LIST_HEAD(&pipe->fsync);
 =09=09return pipe;
 =09}
=20
@@ -1060,6 +1120,7 @@ const struct file_operations pipefifo_fops =3D {
 =09.llseek=09=09=3D no_llseek,
 =09.read_iter=09=3D pipe_read,
 =09.write_iter=09=3D pipe_write,
+=09.fsync=09=09=3D pipe_fsync,
 =09.poll=09=09=3D pipe_poll,
 =09.unlocked_ioctl=09=3D pipe_ioctl,
 =09.release=09=3D pipe_release,
diff --git a/fs/splice.c b/fs/splice.c
index 3f72bc31b6ec..e106367e1be6 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -523,6 +523,7 @@ static int splice_from_pipe_feed(struct pipe_inode_info=
 *pipe, struct splice_des
=20
 =09=09if (!buf->len) {
 =09=09=09pipe_buf_release(pipe, buf);
+=09=09=09pipe_wake_fsync(pipe, buf, tail);
 =09=09=09tail++;
 =09=09=09pipe_commit_read(pipe, tail);
 =09=09=09if (pipe->files)
@@ -771,6 +772,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, st=
ruct file *out,
 =09=09=09=09ret -=3D buf->len;
 =09=09=09=09buf->len =3D 0;
 =09=09=09=09pipe_buf_release(pipe, buf);
+=09=09=09=09pipe_wake_fsync(pipe, buf, tail);
 =09=09=09=09tail++;
 =09=09=09=09pipe_commit_read(pipe, tail);
 =09=09=09=09if (pipe->files)
@@ -1613,6 +1615,7 @@ static int splice_pipe_to_pipe(struct pipe_inode_info=
 *ipipe,
 =09=09=09 */
 =09=09=09*obuf =3D *ibuf;
 =09=09=09ibuf->ops =3D NULL;
+=09=09=09pipe_wake_fsync(ipipe, ibuf, i_tail);
 =09=09=09i_tail++;
 =09=09=09pipe_commit_read(ipipe, i_tail);
 =09=09=09input_wakeup =3D true;
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 90055ff16550..1a3027089558 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -8,6 +8,7 @@
 #define PIPE_BUF_FLAG_ATOMIC=090x02=09/* was atomically mapped */
 #define PIPE_BUF_FLAG_GIFT=090x04=09/* page is a gift */
 #define PIPE_BUF_FLAG_PACKET=090x08=09/* read() as a packet */
+#define PIPE_BUF_FLAG_FSYNC=090x10=09/* fsync() is waiting for this buffer=
 to die */
=20
 /**
  *=09struct pipe_buffer - a linux kernel pipe buffer
@@ -43,6 +44,7 @@ struct pipe_buffer {
  *=09@w_counter: writer counter
  *=09@fasync_readers: reader side fasync
  *=09@fasync_writers: writer side fasync
+ *=09@fsync: Waiting fsyncs
  *=09@bufs: the circular array of pipe buffers
  *=09@user: the user who created this pipe
  **/
@@ -62,6 +64,7 @@ struct pipe_inode_info {
 =09struct page *tmp_page;
 =09struct fasync_struct *fasync_readers;
 =09struct fasync_struct *fasync_writers;
+=09struct list_head fsync;
 =09struct pipe_buffer *bufs;
 =09struct user_struct *user;
 };
@@ -268,6 +271,25 @@ extern const struct pipe_buf_operations nosteal_pipe_b=
uf_ops;
 long pipe_fcntl(struct file *, unsigned int, unsigned long arg);
 struct pipe_inode_info *get_pipe_info(struct file *file);
=20
+void __pipe_wake_fsync(struct pipe_inode_info *pipe, unsigned int tail);
+
+/**
+ * pipe_wake_fsync - Wake up anyone waiting with fsync for this point
+ * @pipe: The pipe that owns the buffer
+ * @buf: The pipe buffer in question
+ * @tail: The index in the ring of the buffer
+ *
+ * Check to see if anyone is waiting for the pipe ring to clear up to and
+ * including this buffer, and, if they are, wake them up.
+ */
+static inline void pipe_wake_fsync(struct pipe_inode_info *pipe,
+=09=09=09=09   struct pipe_buffer *buf,
+=09=09=09=09   unsigned int tail)
+{
+=09if (unlikely(buf->flags & PIPE_BUF_FLAG_FSYNC))
+=09=09__pipe_wake_fsync(pipe, tail);
+}
+
 int create_pipe_files(struct file **, int);
 unsigned int round_pipe_size(unsigned long size);
=20
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index e22f4e283f6d..38d52524cd21 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -404,7 +404,7 @@ static size_t copy_page_to_iter_pipe(struct page *page,=
 size_t offset, size_t by
 =09buf->offset =3D offset;
 =09buf->len =3D bytes;
=20
-=09pipe_commit_read(pipe, i_head);
+=09pipe_commit_write(pipe, i_head);
 =09i->iov_offset =3D offset + bytes;
 =09i->head =3D i_head;
 out:
