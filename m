From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 07/11] pipe: Conditionalise wakeup in pipe_read() [ver
 #3]
Date: Fri, 01 Nov 2019 17:35:05 +0000
Message-ID: <157262970587.13142.9476858866693533437.stgit@warthog.procyon.org.uk>
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

Only do a wakeup in pipe_read() if we made space in a completely full
buffer.  The producer shouldn't be waiting on pipe->wait otherwise.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index ea134f69a292..c16950e36ded 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -328,11 +328,13 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 =09=09=09=09spin_lock_irq(&pipe->wait.lock);
 =09=09=09=09tail++;
 =09=09=09=09pipe->tail =3D tail;
-=09=09=09=09do_wakeup =3D 0;
-=09=09=09=09wake_up_interruptible_sync_poll_locked(
-=09=09=09=09=09&pipe->wait, EPOLLOUT | EPOLLWRNORM);
+=09=09=09=09do_wakeup =3D 1;
+=09=09=09=09if (head - (tail - 1) =3D=3D pipe->max_usage)
+=09=09=09=09=09wake_up_interruptible_sync_poll_locked(
+=09=09=09=09=09=09&pipe->wait, EPOLLOUT | EPOLLWRNORM);
 =09=09=09=09spin_unlock_irq(&pipe->wait.lock);
-=09=09=09=09kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+=09=09=09=09if (head - (tail - 1) =3D=3D pipe->max_usage)
+=09=09=09=09=09kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 =09=09=09}
 =09=09=09total_len -=3D chars;
 =09=09=09if (!total_len)
@@ -361,11 +363,6 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 =09=09=09=09ret =3D -ERESTARTSYS;
 =09=09=09break;
 =09=09}
-=09=09if (do_wakeup) {
-=09=09=09wake_up_interruptible_sync_poll(&pipe->wait, EPOLLOUT | EPOLLWRNO=
RM);
- =09=09=09kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
-=09=09=09do_wakeup =3D 0;
-=09=09}
 =09=09pipe_wait(pipe);
 =09}
 =09__pipe_unlock(pipe);
