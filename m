From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Thu, 11 Aug 2016 12:54:16 +0800
Message-ID: <20160811045416.GB1740@tardis.cn.ibm.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com>
 <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com>
 <20160803122717.GL6862@twins.programming.kicks-ass.net>
 <CALCETrWw0M9YLWTR7_ruxY8cW9_5XRONdw1QN+_pBp0Y63L8pA@mail.gmail.com>
 <20160804042710.GA13232@tardis.cn.ibm.com>
 <CALCETrW7t89BWXW5JbWyLVciKS1HJMXe7feopM31wkqL4AtoFA@mail.gmail.com>
 <20160809161328.GA1740@tardis.cn.ibm.com>
 <1918884375.7403.1470850424697.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1918884375.7403.1470850424697.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 10, 2016 at 05:33:44PM +0000, Mathieu Desnoyers wrote:
> ----- On Aug 9, 2016, at 12:13 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>=20
> <snip>
>=20
> >=20
> > However, I'm thinking maybe we can use some tricks to avoid unnecessary
> > aborts-on-preemption.
> >=20
> > First of all, I notice we haven't make any constraint on what kind of
> > memory objects could be "protected" by rseq critical sections yet. And I
> > think this is something we should decide before adding this feature into
> > kernel.
> >=20
> > We can do some optimization if we have some constraints. For example, if
> > the memory objects inside the rseq critical sections could only be
> > modified by userspace programs, we therefore don't need to abort
> > immediately when userspace task -> kernel task context switch.
>=20
> The rseq_owner per-cpu variable and rseq_cpu field in task_struct you
> propose below would indeed take care of this scenario.
>=20
> >=20
> > Further more, if the memory objects inside the rseq critical sections
> > could only be modified by userspace programs that have registered their
> > rseq structures, we don't need to abort immediately between the context
> > switches between two rseq-unregistered tasks or one rseq-registered
> > task and one rseq-unregistered task.
> >=20
> > Instead, we do tricks as follow:
> >=20
> > defining a percpu pointer in kernel:
> >=20
> > DEFINE_PER_CPU(struct task_struct *, rseq_owner);
> >=20
> > and a cpu field in struct task_struct:
> >=20
> >	struct task_struct {
> >	...
> >	#ifdef CONFIG_RSEQ
> >		struct rseq __user *rseq;
> >		uint32_t rseq_event_counter;
> >		int rseq_cpu;
> >	#endif
> >	...
> >	};
> >=20
> > (task_struct::rseq_cpu should be initialized as -1.)
> >=20
> > each time at sched out(in rseq_sched_out()), we do something like:
> >=20
> >	if (prev->rseq) {
> >		raw_cpu_write(rseq_owner, prev);
> >		prev->rseq_cpu =3D smp_processor_id();
> >	}
> >=20
> > each time sched in(in rseq_handle_notify_resume()), we do something
> > like:
> >=20
> >	if (current->rseq &&
> >	    (this_cpu_read(rseq_owner) !=3D current ||
> >	     current->rseq_cpu !=3D smp_processor_id()))
> >		__rseq_handle_notify_resume(regs);
> >=20
> > (Also need to modify rseq_signal_deliver() to call
> > __rseq_handle_notify_resume() directly).
> >=20
> >=20
> > I think this could save some unnecessary aborts-on-preemption, however,
> > TBH, I'm too sleepy to verify every corner case. Will recheck this
> > tomorrow.
>=20
> This adds extra fields to the task struct, per-cpu rseq_owner pointers,
> and hooks into sched_in which are not needed otherwise, all this to
> eliminate unneeded abort-on-preemption.
>=20
> If we look at the single-stepping use-case, this means that gdb would
> only be able to single-step applications as long as neither itself, nor
> any of its libraries, use rseq. This seems to be quite fragile. I prefer
> requiring rseq users to implement a fallback to locking which progresses
> in every situation rather than adding complexity and overhead trying
> lessen the odds of triggering the restart.
>=20
> Simply lessening the odds of triggering the restart without a design that
> ensures progress even in restart cases seems to make the lack-of-progress
> problem just harder to debug when it will surface in real life.
>=20

Fair enough.

I did my own research of the mechanism I proposed. The patch is attached
at the end of the email. Unfortunately, there is no noticeable
performance gain for the current benchmark. One possible reason may be:
The rseq critical sections in current benchmark are quite small, which
makes retrying is not that expensive.

=46rom another angle, this may imply that in current senarios,
abort-on-preemption doesn't hurt the performance much. But these are
only my two cents.

> Thanks,
>=20
> Mathieu
>=20

---
 include/linux/sched.h | 18 +++++++++++++++---
 kernel/rseq.c         |  2 ++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5875fdd6edc8..c23e5dee9c60 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1922,6 +1922,7 @@ struct task_struct {
 #ifdef CONFIG_RSEQ
 	struct rseq __user *rseq;
 	u32 rseq_event_counter;
+	int rseq_cpu;
 #endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
@@ -3393,6 +3394,8 @@ void cpufreq_remove_update_util_hook(int cpu);
 #endif /* CONFIG_CPU_FREQ */
=20
 #ifdef CONFIG_RSEQ
+DECLARE_PER_CPU(struct task_struct *, rseq_owner);
+
 static inline void rseq_set_notify_resume(struct task_struct *t)
 {
 	if (t->rseq)
@@ -3401,7 +3404,9 @@ static inline void rseq_set_notify_resume(struct task=
_struct *t)
 void __rseq_handle_notify_resume(struct pt_regs *regs);
 static inline void rseq_handle_notify_resume(struct pt_regs *regs)
 {
-	if (current->rseq)
+	if (current->rseq &&
+	    (current !=3D raw_cpu_read(rseq_owner) ||
+	     current->rseq_cpu !=3D smp_processor_id()))
 		__rseq_handle_notify_resume(regs);
 }
 /*
@@ -3415,9 +3420,11 @@ static inline void rseq_fork(struct task_struct *t, =
unsigned long clone_flags)
 	if (clone_flags & CLONE_THREAD) {
 		t->rseq =3D NULL;
 		t->rseq_event_counter =3D 0;
+		t->rseq_cpu =3D -1;
 	} else {
 		t->rseq =3D current->rseq;
 		t->rseq_event_counter =3D current->rseq_event_counter;
+		t->rseq_cpu =3D -1;
 		rseq_set_notify_resume(t);
 	}
 }
@@ -3428,11 +3435,16 @@ static inline void rseq_execve(struct task_struct *=
t)
 }
 static inline void rseq_sched_out(struct task_struct *t)
 {
-	rseq_set_notify_resume(t);
+	if (t->rseq) {
+		raw_cpu_write(rseq_owner, t);
+		t->rseq_cpu =3D smp_processor_id();
+		rseq_set_notify_resume(t);
+	}
 }
 static inline void rseq_signal_deliver(struct pt_regs *regs)
 {
-	rseq_handle_notify_resume(regs);
+	if (current->rseq)
+		__rseq_handle_notify_resume(regs);
 }
 #else
 static inline void rseq_set_notify_resume(struct task_struct *t)
diff --git a/kernel/rseq.c b/kernel/rseq.c
index 7e4d1d0e9520..0390a57ef0e5 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -100,6 +100,8 @@
  *   F2. Return false.
  */
=20
+DEFINE_PER_CPU(struct task_struct *, rseq_owner);
+
 /*
  * The rseq_event_counter allow user-space to detect preemption and
  * signal delivery. It increments at least once before returning to
--=20
2.9.0

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXrAT0AAoJEEl56MO1B/q4O08H/jJSPgM3/JbvtO9R0oEngCbQ
Ix5EE/nrmqWKhCVg26BLesVNDY8MvJZBt2YY2mfIbs7GtNnDjbnBhSAWYTRVTYWI
gjprEGW11UxdCz/JM3YYI00Pvnh/QW8sOBVmQTLTyjyn6FYAh4jBsm4UfyqjBgxO
uii/8wjYWvPbEQbutjnb/ZxFCwykUBExBxEOs0nHBPW/Sj+AN+Yf7S8ScsIF33Wi
lTWmMUsIhX22wuHvNWgFIdUrF752HbmHPQMH7B6+iSbBYbdOXDvu+Lc+Wq7vAcr6
vpi5dIUzxjDJF5N78u0AmcJ51Pmt5pdXp+yFh/Vs7QM+nGgcNS+ppRzwV4y3HCc=
=xZ+5
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
