From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 00:13:28 +0800
Message-ID: <20160809161328.GA1740@tardis.cn.ibm.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
 <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com>
 <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com>
 <20160803122717.GL6862@twins.programming.kicks-ass.net>
 <CALCETrWw0M9YLWTR7_ruxY8cW9_5XRONdw1QN+_pBp0Y63L8pA@mail.gmail.com>
 <20160804042710.GA13232@tardis.cn.ibm.com>
 <CALCETrW7t89BWXW5JbWyLVciKS1HJMXe7feopM31wkqL4AtoFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW7t89BWXW5JbWyLVciKS1HJMXe7feopM31wkqL4AtoFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2016 at 10:03:32PM -0700, Andy Lutomirski wrote:
> On Wed, Aug 3, 2016 at 9:27 PM, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Wed, Aug 03, 2016 at 09:37:57AM -0700, Andy Lutomirski wrote:
> >> On Wed, Aug 3, 2016 at 5:27 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =
wrote:
> >> > On Tue, Jul 26, 2016 at 03:02:19AM +0000, Mathieu Desnoyers wrote:
> >> >> We really care about preemption here. Every migration implies a
> >> >> preemption from a user-space perspective. If we would only care
> >> >> about keeping the CPU id up-to-date, hooking into migration would be
> >> >> enough. But since we want atomicity guarantees for restartable
> >> >> sequences, we need to hook into preemption.
> >> >
> >> >> It allows user-space to perform update operations on per-cpu data w=
ithout
> >> >> requiring heavy-weight atomic operations.
> >> >
> >> > Well, a CMPXCHG without LOCK prefix isn't all that expensive on x86.
> >> >
> >> > It is however on PPC and possibly other architectures, so in name of
> >> > simplicity supporting only the one variant makes sense.
> >> >
> >>
> >> I wouldn't want to depend on CMPXCHG.  But imagine we had primitives
> >> that were narrower than the full abort-on-preemption primitive.
> >> Specifically, suppose we had abort if (actual cpu !=3D expected_cpu ||
> >> *aptr !=3D aval).  We could do things like:
> >>
> >> expected_cpu =3D cpu;
> >> aval =3D NULL;  // disarm for now
> >> begin();
> >> aval =3D event_count[cpu] + 1;
> >> event_count[cpu] =3D aval;
> >> event_count[cpu]++;
> >
> > This line is redundant, right? Because it will guarantee a failure even
> > in no-contention cases.
> >
> >>
> >> ... compute something ...
> >>
> >> // arm the rest of it
> >> aptr =3D &event_count[cpu];
> >> if (*aptr !=3D aval)
> >>   goto fail;
> >>
> >> *thing_im_writing =3D value_i_computed;
> >> end();
> >>
> >> The idea here is that we don't rely on the scheduler to increment the
> >> event count at all, which means that we get to determine the scope of
> >> what kinds of access conflicts we care about ourselves.
> >>
> >
> > If we increase the event count in userspace, how could we prevent two
> > userspace threads from racing on the event_count[cpu] field? For
> > example:
> >
> >         CPU 0
> >         =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >         {event_count[0] is initially 0}
> >
> >         [Thread 1]
> >         begin();
> >         aval =3D event_count[cpu] + 1; // 1
> >
> >         (preempted)
> >         [Thread 2]
> >         begin();
> >         aval =3D event_count[cpu] + 1; // 1, too
> >         event_count[cpu] =3D aval; // event_count[0] is 1
> >
>=20
> You're right :(  This would work with an xadd instruction, but that's
> very slow and doesn't exist on most architectures.  It could also work
> if we did:
>=20
> aval =3D some_tls_value++;
>=20
> where some_tls_value is set up such that no two threads could ever end
> up with the same values (using high bits as thread ids, perhaps), but
> that's messy.  Maybe my idea is no good.

This is a little more complex, plus I failed to find a way to do an
atomic "if (*aptr =3D=3D aval) *b =3D c" in userspace ;-(

However, I'm thinking maybe we can use some tricks to avoid unnecessary
aborts-on-preemption.

First of all, I notice we haven't make any constraint on what kind of
memory objects could be "protected" by rseq critical sections yet. And I
think this is something we should decide before adding this feature into
kernel.

We can do some optimization if we have some constraints. For example, if
the memory objects inside the rseq critical sections could only be
modified by userspace programs, we therefore don't need to abort
immediately when userspace task -> kernel task context switch.

Further more, if the memory objects inside the rseq critical sections
could only be modified by userspace programs that have registered their
rseq structures, we don't need to abort immediately between the context
switches between two rseq-unregistered tasks or one rseq-registered
task and one rseq-unregistered task.

Instead, we do tricks as follow:

defining a percpu pointer in kernel:

DEFINE_PER_CPU(struct task_struct *, rseq_owner);

and a cpu field in struct task_struct:

	struct task_struct {
	...
	#ifdef CONFIG_RSEQ                                                        =
     =20
		struct rseq __user *rseq;                                              =
=20
		uint32_t rseq_event_counter;                                           =
=20
		int rseq_cpu;
	#endif =20
	...
	};

(task_struct::rseq_cpu should be initialized as -1.)

each time at sched out(in rseq_sched_out()), we do something like:

	if (prev->rseq) {
		raw_cpu_write(rseq_owner, prev);
		prev->rseq_cpu =3D smp_processor_id();
	}

each time sched in(in rseq_handle_notify_resume()), we do something
like:

	if (current->rseq &&
	    (this_cpu_read(rseq_owner) !=3D current ||=20
	     current->rseq_cpu !=3D smp_processor_id()))
		__rseq_handle_notify_resume(regs);

(Also need to modify rseq_signal_deliver() to call
__rseq_handle_notify_resume() directly).


I think this could save some unnecessary aborts-on-preemption, however,
TBH, I'm too sleepy to verify every corner case. Will recheck this
tomorrow.

Regards,
Boqun

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXqgElAAoJEEl56MO1B/q43zUH/RjUtHNM4xa1GKNUoc/ZuGz8
miZ4SOzAKAlkB4AEkuTpRZhM0lKRvIc5VxtCW96FmWw1qmtpDA7ImWCB1yd0VkxJ
6Si2/aLNhqMd/YAZHUE90sYeNtWSsMCSP4hO76A9+Ldp+zgrO7I8rZOgXx72za0p
9EV0AyIlnILgpR6sfFoOV5FIIAVLFjxCGDGLjBqb2DfTp8cS9Lu+TrXG6hNqYzKh
sObG67x6XwMmNM4FyLMDINebuUVqZaAggj+ySD2pbkPGnWLfSAKfQpWmHqnW9Uu3
L/Z2Pfh4VAuYC11ek/XMHj0NJY6ZcRr40JpkwuIUFgJhVHB0VsSlusk2B/utJDk=
=SslK
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
