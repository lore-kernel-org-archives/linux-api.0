From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 08/14] pipe: Allow buffers to be marked
 read-whole-or-error for notifications [ver #2]
Date: Thu, 07 Nov 2019 13:36:33 +0000
Message-ID: <157313379331.29677.5209561321495531328.stgit@warthog.procyon.org.uk>
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

Allow a buffer to be marked such that read() must return the entire buffer
in one go or return ENOBUFS.  Multiple buffers can be amalgamated into a
single read, but a short read will occur if the next "whole" buffer won't
fit.

This is useful for watch queue notifications to make sure we don't split a
notification across multiple reads, especially given that we need to
fabricate an overrun record under some circumstances - and that isn't in
the buffers.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c                        |    8 +++++++-
 include/linux/pipe_fs_i.h        |    1 +
 kernel/watch_queue.c             |    2 +-
 samples/watch_queue/watch_test.c |    2 +-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 099bf4b657dd..588355c24ee0 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -298,8 +298,14 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 =09=09=09size_t written;
 =09=09=09int error;
=20
-=09=09=09if (chars > total_len)
+=09=09=09if (chars > total_len) {
+=09=09=09=09if (buf->flags & PIPE_BUF_FLAG_WHOLE) {
+=09=09=09=09=09if (ret =3D=3D 0)
+=09=09=09=09=09=09ret =3D -ENOBUFS;
+=09=09=09=09=09break;
+=09=09=09=09}
 =09=09=09=09chars =3D total_len;
+=09=09=09}
=20
 =09=09=09error =3D pipe_buf_confirm(pipe, buf);
 =09=09=09if (error) {
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 816bc0d3aecd..a19d60a06869 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -8,6 +8,7 @@
 #define PIPE_BUF_FLAG_ATOMIC=090x02=09/* was atomically mapped */
 #define PIPE_BUF_FLAG_GIFT=090x04=09/* page is a gift */
 #define PIPE_BUF_FLAG_PACKET=090x08=09/* read() as a packet */
+#define PIPE_BUF_FLAG_WHOLE=090x10=09/* read() must return entire buffer o=
r error */
=20
 /**
  *=09struct pipe_buffer - a linux kernel pipe buffer
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index b73fbfe0d467..b1d30296e29b 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -115,7 +115,7 @@ static bool post_one_notification(struct watch_queue *w=
queue,
 =09buf->ops =3D &watch_queue_pipe_buf_ops;
 =09buf->offset =3D offset;
 =09buf->len =3D len;
-=09buf->flags =3D 0;
+=09buf->flags =3D PIPE_BUF_FLAG_WHOLE;
 =09pipe->head =3D head + 1;
=20
 =09if (!test_and_clear_bit(note, wqueue->notes_bitmap)) {
diff --git a/samples/watch_queue/watch_test.c b/samples/watch_queue/watch_t=
est.c
index 8925593bdb9b..f6fb6e813551 100644
--- a/samples/watch_queue/watch_test.c
+++ b/samples/watch_queue/watch_test.c
@@ -63,7 +63,7 @@ static void saw_key_change(struct watch_notification *n, =
size_t len)
  */
 static void consumer(int fd)
 {
-=09unsigned char buffer[4096], *p, *end;
+=09unsigned char buffer[433], *p, *end;
 =09union {
 =09=09struct watch_notification n;
 =09=09unsigned char buf1[128];
