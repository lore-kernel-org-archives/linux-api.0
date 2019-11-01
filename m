From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 10/11] pipe: Check for ring full inside of the spinlock
 in pipe_write() [ver #3]
Date: Fri, 01 Nov 2019 17:35:32 +0000
Message-ID: <157262973277.13142.11996381016183033698.stgit@warthog.procyon.org.uk>
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

Make pipe_write() check to see if the ring has become full between it
taking the pipe mutex, checking the ring status and then taking the
spinlock.

This can happen if a notification is written into the pipe as that happens
without the pipe mutex.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/pipe.c b/fs/pipe.c
index d7b8d3f22987..aba2455caabe 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -463,6 +463,11 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 =09=09=09spin_lock_irq(&pipe->wait.lock);
=20
 =09=09=09head =3D pipe->head;
+=09=09=09if (pipe_full(head, pipe->tail, max_usage)) {
+=09=09=09=09spin_unlock_irq(&pipe->wait.lock);
+=09=09=09=09continue;
+=09=09=09}
+
 =09=09=09pipe->head =3D head + 1;
=20
 =09=09=09/* Always wake up, even if the copy fails. Otherwise
