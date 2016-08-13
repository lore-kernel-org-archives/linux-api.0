From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Sat, 13 Aug 2016 09:28:42 +0800
Message-ID: <20160813012834.GC18611@tardis.cn.ibm.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1590181502.79032.1469329777708.JavaMail.zimbra@efficios.com>
 <CO1PR15MB09825505EBF36E0C56AA037ADD0C0@CO1PR15MB0982.namprd15.prod.outlook.com>
 <374861479.8581.1470957990793.JavaMail.zimbra@efficios.com>
 <20160812012854.GC1740@tardis.cn.ibm.com>
 <365498072.8664.1470971438957.JavaMail.zimbra@efficios.com>
 <20160812053008.GA18611@tardis.cn.ibm.com>
 <20160812163542.GB18611@tardis.cn.ibm.com>
 <434180831.9286.1471025505641.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NklN7DEeGtkPCoo3"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <434180831.9286.1471025505641.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 12, 2016 at 06:11:45PM +0000, Mathieu Desnoyers wrote:
> ----- On Aug 12, 2016, at 12:35 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>=20
> > On Fri, Aug 12, 2016 at 01:30:15PM +0800, Boqun Feng wrote:
> > [snip]
> >> > > Besides, do we allow userspace programs do read-only access to the
> >> > > memory objects modified by do_rseq(). If so, we have a problem when
> >> > > there are two writes in a do_rseq()(either in the rseq critical se=
ction
> >> > > or in the asm block), because in current implemetation, these two =
writes
> >> > > are unordered, which makes the readers outside a do_rseq() could o=
bserve
> >> > > the ordering of writes differently.
> >> > >=20
> >> > > For rseq_finish2(), a simple solution would be making the "final" =
write
> >> > > a RELEASE.
> >> >=20
> >> > Indeed, we would need a release semantic for the final store here if=
 this
> >> > is the common use. Or we could duplicate the "flavors" of rseq_finis=
h2 and
> >> > add a rseq_finish2_release. We should find a way to eliminate code d=
uplication
> >>=20
> >> I'm in favor of a separate rseq_finish2_release().
> >>=20
> >> > there. I suspect we'll end up doing macros.
> >> >=20
> >>=20
> >> Me too. Lemme have a try ;-)
> >>=20
> >=20
> > How about this? Although a little messy, I separated the asm block into
> > several parts and implemented each part in a arch-diagnose way.
>=20
> I find it rather hard to follow the per-arch assembly with this approach.
> It might prove to be troublesome if we want to do arch-specific optimizat=
ions
> in the future.
>=20

It might be, but I was just trying to kill as much duplicate code as
possible, because the more duplicate we have, the more maintain effort
we need.

For example, PPC32 and PPC64 may have the same asm code to check the
event counter, but different code to do the final store.  Having the
same RSEQ_CHECK_COUNTER() for PPC32 and PPC64 actually makes it easy if
we come up a way to optimize the counter check code on PPC.

And if some arch wants to have some very specifical optimizations,
it could always write the whole asm block again rather than use the
helpers macros.

> I've come up with the following macro approach instead, feedback welcome!
>=20
>=20
> commit 4d27431d6aefaee617540ef04518962b0e4d14f4
> Author: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> Date:   Thu Aug 11 19:11:27 2016 -0400
>=20
>     rseq_finish2, rseq_finish2_release (WIP)
>=20
[...]
> +#elif defined(__ARMEL__)
> +
> +#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
> +		_failure, extra_store, extra_input) \
> +	__asm__ __volatile__ goto ( \
> +		".pushsection __rseq_table, \"aw\"\n\t" \
> +		".balign 32\n\t" \
> +		".word 1f, 0x0, 2f, 0x0, %l[failure], 0x0, 0x0, 0x0\n\t" \
> +		".popsection\n\t" \
> +		"1:\n\t" \
> +		RSEQ_INJECT_ASM(1) \
> +		"adr r0, 3f\n\t" \
> +		"str r0, [%[rseq_cs]]\n\t" \
> +		RSEQ_INJECT_ASM(2) \
> +		"ldr r0, %[current_event_counter]\n\t" \
> +		"mov r1, #0\n\t" \
> +		"cmp %[start_event_counter], r0\n\t" \
> +		"bne %l[failure]\n\t" \
> +		RSEQ_INJECT_ASM(3) \
> +		extra_store \
> +		"str %[to_write_final], [%[target_final]]\n\t" \
> +		"2:\n\t" \
> +		RSEQ_INJECT_ASM(5) \
> +		"str r1, [%[rseq_cs]]\n\t" \

I find this is a little weird here, that is having an extra register for
zeroing the rseq_cs. Could we

		"mov r0, #0\n\t"
		"str r0, [%[rseq_cs]]\n\t"

here? Which not only saves a register, but also an instruction "mov r1,
#0" in the fast path. Am I missing something subtle?

> +		"b 4f\n\t" \
> +		".balign 32\n\t" \
> +		"3:\n\t" \
> +		".word 1b, 0x0, 2b, 0x0, l[failure], 0x0, 0x0, 0x0\n\t" \
> +		"4:\n\t" \
> +		: /* no outputs */ \
> +		: [start_event_counter]"r"((_start_value).event_counter), \
> +		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter),=
 \
> +		  [to_write_final]"r"(_to_write_final), \
> +		  [target_final]"r"(_target_final), \
> +		  [rseq_cs]"r"(&(_start_value).rseqp->rseq_cs) \
> +		  extra_input \
> +		  RSEQ_INJECT_INPUT \
> +		: "r0", "r1", "memory", "cc" \
> +		  RSEQ_INJECT_CLOBBER \
> +		: _failure \
>  	);

[...]

> +
> +#define RSEQ_FINISH2_RELEASE_SPECULATIVE_STORE_ASM() \
> +		RSEQ_FINISH2_SPECULATIVE_STORE_ASM() \
> +		"dmb\n\t"
> +

Having a RELEASE barrier here may be OK for all current archs we
support, but there are archs which rather than have a lightweight
RELEASE barrier but use a special instruction for RELEASE operations,
for example, AArch64. Do we need to take that into consideration and
define a RSEQ_FINISH_ASM_RELEASE() rather than a
RSEQ_FINISH2_SPECULATIVE_STORE_INPUT_ASM()?

[...]

Regards
Boqun

--NklN7DEeGtkPCoo3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXrnfHAAoJEEl56MO1B/q4iQEH/Re9k0oz0jXxrp4NSMZNCNC0
Q5NdA+K6/c1mfBwzHcU/rBmbdN3yJKmgEFiCEkv8w4vGW4ma9GBhBtQXHOwOTbAa
0aUQKLNkK4t+xL+sBwqOLoeOBiGgJBUd2jOnq5gD4GyvmNoJWnZEU6rYydfmozy2
o73u9loF4e9Yk2Wx9LjED4ia8LTDBX+TsRSW5e+MP6po9gewdxEH/6IJJlRRw9Q6
zKYhvHNmhWMJr7k16424IizM8PN5M9sWkJhJ9VPs1pt1IxBmP2ahbsLeC2QfSX5X
l2+zmX9WL10HfFjdsRfr0oAbTNIg4NtjUUkgyMa94Nd0F6ldxwVoUmgsOFxC2q4=
=Dl+4
-----END PGP SIGNATURE-----

--NklN7DEeGtkPCoo3--
