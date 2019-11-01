From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 09/11] pipe: Remove redundant wakeup from pipe_write()
 [ver #3]
Date: Fri, 01 Nov 2019 17:35:24 +0000
Message-ID: <157262972442.13142.11480420475866936493.stgit@warthog.procyon.org.uk>
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

Remove a redundant wakeup from pipe_write().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index ce77ac0d8901..d7b8d3f22987 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -517,11 +517,6 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 =09=09=09=09ret =3D -ERESTARTSYS;
 =09=09=09break;
 =09=09}
-=09=09if (do_wakeup) {
-=09=09=09wake_up_interruptible_sync_poll(&pipe->wait, EPOLLIN | EPOLLRDNOR=
M);
-=09=09=09kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-=09=09=09do_wakeup =3D 0;
-=09=09}
 =09=09pipe->waiting_writers++;
 =09=09pipe_wait(pipe);
 =09=09pipe->waiting_writers--;
