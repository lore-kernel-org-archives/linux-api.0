From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 11/11] pipe: Increase the writer-wakeup threshold to
 reduce context-switch count [ver #3]
Date: Fri, 01 Nov 2019 17:35:41 +0000
Message-ID: <157262974145.13142.5910403713310791673.stgit@warthog.procyon.org.uk>
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

Increase the threshold at which the reader sends a wake event to the
writers in the queue such that the queue must be half empty before the wake
is issued rather than the wake being issued when just a single slot
available.

This reduces the number of context switches in the tests significantly,
without altering the amount of work achieved.  With my pipe-bench program,
there's a 20% reduction versus an unpatched kernel.

Suggested-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/pipe.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index aba2455caabe..9cd5cbef9552 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -324,16 +324,18 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 =09=09=09}
=20
 =09=09=09if (!buf->len) {
+=09=09=09=09bool wake;
 =09=09=09=09pipe_buf_release(pipe, buf);
 =09=09=09=09spin_lock_irq(&pipe->wait.lock);
 =09=09=09=09tail++;
 =09=09=09=09pipe->tail =3D tail;
 =09=09=09=09do_wakeup =3D 1;
-=09=09=09=09if (head - (tail - 1) =3D=3D pipe->max_usage)
+=09=09=09=09wake =3D head - (tail - 1) =3D=3D pipe->max_usage / 2;
+=09=09=09=09if (wake)
 =09=09=09=09=09wake_up_interruptible_sync_poll_locked(
 =09=09=09=09=09=09&pipe->wait, EPOLLOUT | EPOLLWRNORM);
 =09=09=09=09spin_unlock_irq(&pipe->wait.lock);
-=09=09=09=09if (head - (tail - 1) =3D=3D pipe->max_usage)
+=09=09=09=09if (wake)
 =09=09=09=09=09kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 =09=09=09}
 =09=09=09total_len -=3D chars;
