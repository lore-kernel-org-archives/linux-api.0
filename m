From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 07/10] pipe: Conditionalise wakeup in pipe_read() [ver #2]
Date: Thu, 31 Oct 2019 16:38:04 +0000
Message-ID: <3165.1572539884@warthog.procyon.org.uk>
References: <fe167a90-1503-7ca2-4150-eeffd5cb1378@yandex-team.ru> <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk> <157186189069.3995.10292601951655075484.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fe167a90-1503-7ca2-4150-eeffd5cb1378@yandex-team.ru>
Content-ID: <3164.1572539884.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Okay, attached is a change that might give you what you want.  I tried my
pipe-bench program (see cover note) with perf.  The output of the program w=
ith
the patch applied was:

-       pipe                  305127298     36262221772       302185181    =
     7887690

The output of perf with the patch applied:

        239,943.92 msec task-clock                #    1.997 CPUs utilized
            17,728      context-switches          #   73.884 M/sec
               124      cpu-migrations            #    0.517 M/sec
             9,330      page-faults               #   38.884 M/sec
   885,107,207,365      cycles                    # 3688822.793 GHz
 1,386,873,499,490      instructions              #    1.57  insn per cycle
   311,037,372,339      branches                  # 1296296921.931 M/sec
        33,467,827      branch-misses             #    0.01% of all branche=
s

And without:

        239,891.87 msec task-clock                #    1.997 CPUs utilized
            22,187      context-switches          #   92.488 M/sec
               133      cpu-migrations            #    0.554 M/sec
             9,334      page-faults               #   38.909 M/sec
   884,906,976,128      cycles                    # 3688787.725 GHz
 1,391,986,932,265      instructions              #    1.57  insn per cycle
   311,394,686,857      branches                  # 1298067400.849 M/sec
        30,242,823      branch-misses             #    0.01% of all branche=
s

So it did make something like a 20% reduction in context switches.

David
---
diff --git a/fs/pipe.c b/fs/pipe.c
index e3d5f7a39123..5167921edd73 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -276,7 +276,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 =09size_t total_len =3D iov_iter_count(to);
 =09struct file *filp =3D iocb->ki_filp;
 =09struct pipe_inode_info *pipe =3D filp->private_data;
-=09int do_wakeup;
+=09int do_wakeup, wake;
 =09ssize_t ret;

 =09/* Null read succeeds. */
@@ -329,11 +329,12 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
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
