From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 09/14] pipe: Add notification lossage handling [ver #2]
Date: Thu, 07 Nov 2019 13:36:41 +0000
Message-ID: <157313380189.29677.220998621067398332.stgit@warthog.procyon.org.uk>
References: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
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
index 588355c24ee0..955a4ec1dc50 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -292,6 +292,30 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 =09=09unsigned int tail =3D pipe->tail;
 =09=09unsigned int mask =3D pipe->ring_size - 1;
=20
+#ifdef CONFIG_WATCH_QUEUE
+=09=09if (pipe->note_loss) {
+=09=09=09struct watch_notification n;
+
+=09=09=09if (total_len < 8) {
+=09=09=09=09if (ret =3D=3D 0)
+=09=09=09=09=09ret =3D -ENOBUFS;
+=09=09=09=09break;
+=09=09=09}
+
+=09=09=09n.type =3D WATCH_TYPE_META;
+=09=09=09n.subtype =3D WATCH_META_LOSS_NOTIFICATION;
+=09=09=09n.info =3D watch_sizeof(n);
+=09=09=09if (copy_to_iter(&n, sizeof(n), to) !=3D sizeof(n)) {
+=09=09=09=09if (ret =3D=3D 0)
+=09=09=09=09=09ret =3D -EFAULT;
+=09=09=09=09break;
+=09=09=09}
+=09=09=09ret +=3D sizeof(n);
+=09=09=09total_len -=3D sizeof(n);
+=09=09=09pipe->note_loss =3D false;
+=09=09}
+#endif
+
 =09=09if (!pipe_empty(head, tail)) {
 =09=09=09struct pipe_buffer *buf =3D &pipe->bufs[tail & mask];
 =09=09=09size_t chars =3D buf->len;
@@ -334,6 +358,10 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 =09=09=09=09bool wake;
 =09=09=09=09pipe_buf_release(pipe, buf);
 =09=09=09=09spin_lock_irq(&pipe->wait.lock);
+#ifdef CONFIG_WATCH_QUEUE
+=09=09=09=09if (buf->flags & PIPE_BUF_FLAG_LOSS)
+=09=09=09=09=09pipe->note_loss =3D true;
+#endif
 =09=09=09=09tail++;
 =09=09=09=09pipe->tail =3D tail;
 =09=09=09=09do_wakeup =3D 1;
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index a19d60a06869..5be6fdf5134d 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -9,6 +9,9 @@
 #define PIPE_BUF_FLAG_GIFT=090x04=09/* page is a gift */
 #define PIPE_BUF_FLAG_PACKET=090x08=09/* read() as a packet */
 #define PIPE_BUF_FLAG_WHOLE=090x10=09/* read() must return entire buffer o=
r error */
+#ifdef CONFIG_WATCH_QUEUE
+#define PIPE_BUF_FLAG_LOSS=090x20=09/* Message loss happened after this bu=
ffer */
+#endif
=20
 /**
  *=09struct pipe_buffer - a linux kernel pipe buffer
@@ -33,6 +36,7 @@ struct pipe_buffer {
  *=09@wait: reader/writer wait point in case of empty/full pipe
  *=09@head: The point of buffer production
  *=09@tail: The point of buffer consumption
+ *=09@note_loss: The next read() should insert a data-lost message
  *=09@max_usage: The maximum number of slots that may be used in the ring
  *=09@ring_size: total number of buffers (should be a power of 2)
  *=09@nr_accounted: The amount this pipe accounts for in user->pipe_bufs
@@ -56,6 +60,9 @@ struct pipe_inode_info {
 =09unsigned int tail;
 =09unsigned int max_usage;
 =09unsigned int ring_size;
+#ifdef CONFIG_WATCH_QUEUE
+=09bool note_loss;
+#endif
 =09unsigned int nr_accounted;
 =09unsigned int readers;
 =09unsigned int writers;
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index b1d30296e29b..b34ad1b170a4 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -132,6 +132,8 @@ static bool post_one_notification(struct watch_queue *w=
queue,
 =09return done;
=20
 lost:
+=09buf =3D &pipe->bufs[(head - 1) & mask];
+=09buf->flags |=3D PIPE_BUF_FLAG_LOSS;
 =09goto out;
 }
=20
diff --git a/samples/watch_queue/watch_test.c b/samples/watch_queue/watch_t=
est.c
index f6fb6e813551..58e826109ecc 100644
--- a/samples/watch_queue/watch_test.c
+++ b/samples/watch_queue/watch_test.c
@@ -120,6 +120,9 @@ static void consumer(int fd)
 =09=09=09=09=09       (n.n.info & WATCH_INFO_ID) >>
 =09=09=09=09=09       WATCH_INFO_ID__SHIFT);
 =09=09=09=09=09break;
+=09=09=09=09case WATCH_META_LOSS_NOTIFICATION:
+=09=09=09=09=09printf("-- LOSS --\n");
+=09=09=09=09=09break;
 =09=09=09=09default:
 =09=09=09=09=09printf("other meta record\n");
 =09=09=09=09=09break;
