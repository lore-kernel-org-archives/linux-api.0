From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 00/11] pipe: Notification queue preparation [ver #3]
Date: Fri, 01 Nov 2019 22:05:26 +0000
Message-ID: <13964.1572645926@warthog.procyon.org.uk>
References: <CAHk-=wjqx4j2vqg-tAwthNP1gcAcj1x4B7sq6Npbi8QJTUMd-A@mail.gmail.com> <157262963995.13142.5568934007158044624.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wjqx4j2vqg-tAwthNP1gcAcj1x4B7sq6Npbi8QJTUMd-A@mail.gmail.com>
Content-ID: <13963.1572645926.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Side note: we have a couple of cases where I don't think we should use
> the "sync" version at all.
>=20
> Both pipe_read() and pipe_write() have that
>=20
>         if (do_wakeup) {
>                 wake_up_interruptible_sync_poll(&pipe->wait, ...
>=20
> code at the end, outside the loop. But those two wake-ups aren't
> actually synchronous.

Changing those to non-sync:

BENCHMARK       BEST            TOTAL BYTES     AVG BYTES       STDDEV
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
pipe                  305816126     36255936983       302132808         888=
0788
splice                282402106     27102249370       225852078       21003=
3443
vmsplice              440022611     48896995196       407474959        5990=
6438

Changing the others in pipe_read() and pipe_write() too:

pipe                  305609682     36285967942       302383066         741=
5744
splice                282475690     27891475073       232428958       20168=
7522
vmsplice              451458280     51949421503       432911845        3492=
5242

The cumulative patch is attached below.  I'm not sure how well this should
make a difference with my benchmark programs since each thread can run on i=
ts
own CPU.

David
---
diff --git a/fs/pipe.c b/fs/pipe.c
index 9cd5cbef9552..c5e3765465f0 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -332,7 +332,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 =09=09=09=09do_wakeup =3D 1;
 =09=09=09=09wake =3D head - (tail - 1) =3D=3D pipe->max_usage / 2;
 =09=09=09=09if (wake)
-=09=09=09=09=09wake_up_interruptible_sync_poll_locked(
+=09=09=09=09=09wake_up_locked_poll(
 =09=09=09=09=09=09&pipe->wait, EPOLLOUT | EPOLLWRNORM);
 =09=09=09=09spin_unlock_irq(&pipe->wait.lock);
 =09=09=09=09if (wake)
@@ -371,7 +371,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
=20
 =09/* Signal writers asynchronously that there is more room. */
 =09if (do_wakeup) {
-=09=09wake_up_interruptible_sync_poll(&pipe->wait, EPOLLOUT | EPOLLWRNORM)=
;
+=09=09wake_up_interruptible_poll(&pipe->wait, EPOLLOUT | EPOLLWRNORM);
 =09=09kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 =09}
 =09if (ret > 0)
@@ -477,7 +477,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 =09=09=09 * syscall merging.
 =09=09=09 * FIXME! Is this really true?
 =09=09=09 */
-=09=09=09wake_up_interruptible_sync_poll_locked(
+=09=09=09wake_up_locked_poll(
 =09=09=09=09&pipe->wait, EPOLLIN | EPOLLRDNORM);
=20
 =09=09=09spin_unlock_irq(&pipe->wait.lock);
@@ -531,7 +531,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 out:
 =09__pipe_unlock(pipe);
 =09if (do_wakeup) {
-=09=09wake_up_interruptible_sync_poll(&pipe->wait, EPOLLIN | EPOLLRDNORM);
+=09=09wake_up_interruptible_poll(&pipe->wait, EPOLLIN | EPOLLRDNORM);
 =09=09kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 =09}
 =09if (ret > 0 && sb_start_write_trylock(file_inode(filp)->i_sb)) {
