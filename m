From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 06/10] pipe: Advance tail pointer inside of wait
 spinlock in pipe_read() [ver #2]
Date: Wed, 23 Oct 2019 21:18:02 +0100
Message-ID: <157186188205.3995.4257625973468561091.stgit@warthog.procyon.org.uk>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Advance the pipe ring tail pointer inside of wait spinlock in pipe_read()
so that the pipe can be written into with kernel notifications from
contexts where pipe->mutex cannot be taken.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 12e47cae9425..1274305772fb 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -324,9 +324,14 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
=20
 =09=09=09if (!buf->len) {
 =09=09=09=09pipe_buf_release(pipe, buf);
+=09=09=09=09spin_lock_irq(&pipe->wait.lock);
 =09=09=09=09tail++;
 =09=09=09=09pipe_commit_read(pipe, tail);
-=09=09=09=09do_wakeup =3D 1;
+=09=09=09=09do_wakeup =3D 0;
+=09=09=09=09wake_up_interruptible_sync_poll_locked(
+=09=09=09=09=09&pipe->wait, EPOLLOUT | EPOLLWRNORM);
+=09=09=09=09spin_unlock_irq(&pipe->wait.lock);
+=09=09=09=09kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 =09=09=09}
 =09=09=09total_len -=3D chars;
 =09=09=09if (!total_len)
@@ -358,6 +363,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 =09=09if (do_wakeup) {
 =09=09=09wake_up_interruptible_sync_poll(&pipe->wait, EPOLLOUT | EPOLLWRNO=
RM);
  =09=09=09kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+=09=09=09do_wakeup =3D 0;
 =09=09}
 =09=09pipe_wait(pipe);
 =09}
