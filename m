From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 09/10] pipe: Remove redundant wakeup from pipe_write()
 [ver #2]
Date: Wed, 23 Oct 2019 21:18:28 +0100
Message-ID: <157186190801.3995.3420819228734631242.stgit@warthog.procyon.org.uk>
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

Remove a redundant wakeup from pipe_write().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 1bfad2212b95..3df93990dd9d 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -516,11 +516,6 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
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
