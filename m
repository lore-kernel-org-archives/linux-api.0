From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Fri, 12 Aug 2016 13:30:15 +0800
Message-ID: <20160812053008.GA18611@tardis.cn.ibm.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-8-git-send-email-mathieu.desnoyers@efficios.com>
 <CO1PR15MB09822FC140F84DCEEF2004CDDD0B0@CO1PR15MB0982.namprd15.prod.outlook.com>
 <1590181502.79032.1469329777708.JavaMail.zimbra@efficios.com>
 <CO1PR15MB09825505EBF36E0C56AA037ADD0C0@CO1PR15MB0982.namprd15.prod.outlook.com>
 <374861479.8581.1470957990793.JavaMail.zimbra@efficios.com>
 <20160812012854.GC1740@tardis.cn.ibm.com>
 <365498072.8664.1470971438957.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2B/JsCI69OhZNC5r"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <365498072.8664.1470971438957.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 12, 2016 at 03:10:38AM +0000, Mathieu Desnoyers wrote:
> ----- On Aug 11, 2016, at 9:28 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>=20
> > On Thu, Aug 11, 2016 at 11:26:30PM +0000, Mathieu Desnoyers wrote:
> >> ----- On Jul 24, 2016, at 2:01 PM, Dave Watson davejwatson-b10kYP2dOMg@public.gmane.org wrot=
e:
> >>=20
> >> >>> +static inline __attribute__((always_inline))
> >> >>> +bool rseq_finish(struct rseq_lock *rlock,
> >> >>> + intptr_t *p, intptr_t to_write,
> >> >>> + struct rseq_state start_value)
> >> >=20
> >> >>> This ABI looks like it will work fine for our use case. I don't th=
ink it
> >> >>> has been mentioned yet, but we may still need multiple asm blocks
> >> >>> for differing numbers of writes. For example, an array-based freel=
ist push:
> >> >=20
> >> >>> void push(void *obj) {
> >> >>> if (index < maxlen) {
> >> >>> freelist[index++] =3D obj;
> >> >>> }
> >> >>> }
> >> >=20
> >> >>> would be more efficiently implemented with a two-write rseq_finish:
> >> >=20
> >> >>> rseq_finish2(&freelist[index], obj, // first write
> >> >>> &index, index + 1, // second write
> >> >>> ...);
> >> >=20
> >> >> Would pairing one rseq_start with two rseq_finish do the trick
> >> >> there ?
> >> >=20
> >> > Yes, two rseq_finish works, as long as the extra rseq management ove=
rhead
> >> > is not substantial.
> >>=20
> >> I've added a commit implementing rseq_finish2() in my rseq volatile
> >> dev branch. You can fetch it at:
> >>=20
> >> https://github.com/compudj/linux-percpu-dev/tree/rseq-fallback
> >>=20
> >> I also have a separate test and benchmark tree in addition to the
> >> kernel selftests here:
> >>=20
> >> https://github.com/compudj/rseq-test
> >>=20
> >> I named the first write a "speculative" write, and the second write
> >> the "final" write.
> >>=20
> >=20
> > Maybe I miss something subtle, but if the first write is only a
> > "speculative" write, why can't we put it in the rseq critical section
> > rather than asm block? Like this:
> >=20
> >	do_rseq(..., result, targetptr, newval
> >		{
> >			newval =3D index;
> >			targetptr =3D &index;
> >			if (newval < maxlen)
> >				freelist[newval++] =3D obj;
> >			else
> >				result =3D false;
> >		}
> >=20
> > No extra rseq_finish() is needed here, but maybe a little more
> > "speculative" writes?
>=20
> This won't work unfortunately. The speculative stores need to be
> between the rseq_event_counter comparison instruction in the rseq_finish
> asm sequence and the final store. The ip fixup is really needed for
> correctness of speculative stores. The sequence number scheme only works
> for loads.
>=20
> Putting it in the C code between rseq_start and rseq_finish would lead
> to races such as:
>=20
> thread A                                thread B
> rseq_start
> <preempted>
>                                         <sched in>
>                                         rseq_start
>                                         freelist[offset + 1] =3D obj
>                                         rseq_finish
>                                            offset++
>                                         <preempted>
> <sched in>
> freelist[newval + 1] =3D obj  <--- corrupts the list content.
>=20

Ah, right!

We couldn't do any "global"(real global or percpu) update in the rseq
critical section(code between rseq_start and rseq_finish), because
without an ip fixup, we cannot abort the critical section immediately,
we have to compare the event_counter in rseq_finish, but that's too late
for speculates stores.

> <snip>
>=20
> > Besides, do we allow userspace programs do read-only access to the
> > memory objects modified by do_rseq(). If so, we have a problem when
> > there are two writes in a do_rseq()(either in the rseq critical section
> > or in the asm block), because in current implemetation, these two writes
> > are unordered, which makes the readers outside a do_rseq() could observe
> > the ordering of writes differently.
> >=20
> > For rseq_finish2(), a simple solution would be making the "final" write
> > a RELEASE.
>=20
> Indeed, we would need a release semantic for the final store here if this
> is the common use. Or we could duplicate the "flavors" of rseq_finish2 and
> add a rseq_finish2_release. We should find a way to eliminate code duplic=
ation

I'm in favor of a separate rseq_finish2_release().

> there. I suspect we'll end up doing macros.
>=20

Me too. Lemme have a try ;-)

Regards,
Boqun

> Thanks,
>=20
> Mathieu
>=20
> >=20
> > Regards,
> > Boqun
> >=20
> >> Thanks,
> >>=20
> >> Mathieu
> >>=20
> >> --
> >> Mathieu Desnoyers
> >> EfficiOS Inc.
> > > http://www.efficios.com
>=20
> --=20
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

--2B/JsCI69OhZNC5r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXrV7kAAoJEEl56MO1B/q4E9sH/3a1ZkvYVSNOirbQHw06mKf7
crEepQNzhxfgzSDY8vWi4m6SLlTUmpUhlTmpi6hFPqN63J202AX+bJqi0VaqZ1ba
sohH0F/AUVzJw/Sp9AuJbFradyFUwkNVNMPcpPeh9E0S0t4GEHrEpR7oswmwiUmT
CqHgtrBuXKR8gQr3LZytyLpEA/aFnYbmnnOTfCn4xORKh0AL1r9yBZQ6ewXeNh2q
ZWuvyPTelrVKueXxjO4l4DfcF7Wvhvb4O7Ta0GAkX6/bfSTFe//X4T/KWNjcbuzY
qHeaDk/trwaoPc5EBfbBzYh1DBhewEjwUjtywky+5LluUsVteh+jaCedJ1Uj8bY=
=j+lU
-----END PGP SIGNATURE-----

--2B/JsCI69OhZNC5r--
