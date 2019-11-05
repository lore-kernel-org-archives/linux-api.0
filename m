From: Oleg Nesterov <oleg@redhat.com>
Subject: handle_exit_race && PF_EXITING
Date: Tue, 5 Nov 2019 16:27:28 +0100
Message-ID: <20191105152728.GA5666@redhat.com>
References: <20191104002909.25783-1-shawn@git.icu>
 <87woceslfs.fsf@oldenburg2.str.redhat.com>
 <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Florian Weimer <fweimer@redhat.com>, Shawn Landden <shawn@git.icu>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On 11/05, Thomas Gleixner wrote:
>
> Out of curiosity, what's the race issue vs. robust list which you are
> trying to solve?

Off-topic, but this reminds me...

=09#include <sched.h>
=09#include <assert.h>
=09#include <unistd.h>
=09#include <syscall.h>

=09#define FUTEX_LOCK_PI=09=096

=09int main(void)
=09{
=09=09struct sched_param sp =3D {};

=09=09sp.sched_priority =3D 2;
=09=09assert(sched_setscheduler(0, SCHED_FIFO, &sp) =3D=3D 0);

=09=09int lock =3D vfork();
=09=09if (!lock) {
=09=09=09sp.sched_priority =3D 1;
=09=09=09assert(sched_setscheduler(0, SCHED_FIFO, &sp) =3D=3D 0);
=09=09=09_exit(0);
=09=09}

=09=09syscall(__NR_futex, &lock, FUTEX_LOCK_PI, 0,0,0);
=09=09return 0;
=09}

this creates the unkillable RT process spinning in futex_lock_pi() on
a single CPU machine (or you can use taskset).

Probably the patch below makes sense anyway, but of course it doesn't
solve the real problem: futex_lock_pi() should not spin in this case.

It seems to me I even sent the fix a long ago, but I can't recall what
exactly it did. Probably the PF_EXITING check in attach_to_pi_owner()
must simply die, I'll try to recall...

Oleg.

--- x/kernel/futex.c
+++ x/kernel/futex.c
@@ -2842,10 +2842,12 @@ static int futex_lock_pi(u32 __user *uaddr, unsigne=
d int flags,
 =09=09=09 *   exit to complete.
 =09=09=09 * - The user space value changed.
 =09=09=09 */
-=09=09=09queue_unlock(hb);
-=09=09=09put_futex_key(&q.key);
-=09=09=09cond_resched();
-=09=09=09goto retry;
+=09=09=09if (!fatal_signal_pending(current)) {
+=09=09=09=09queue_unlock(hb);
+=09=09=09=09put_futex_key(&q.key);
+=09=09=09=09cond_resched();
+=09=09=09=09goto retry;
+=09=09=09}
 =09=09default:
 =09=09=09goto out_unlock_put_key;
 =09=09}
