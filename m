From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 27 Jul 2016 23:03:52 +0800
Message-ID: <20160727150352.GA32142@tardis.cn.ibm.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469135662-31512-2-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Benjamin Herrenschmidt <benh@kern>
List-Id: linux-api@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mathieu,

On Thu, Jul 21, 2016 at 05:14:16PM -0400, Mathieu Desnoyers wrote:
> Expose a new system call allowing each thread to register one userspace
> memory area to be used as an ABI between kernel and user-space for two
> purposes: user-space restartable sequences and quick access to read the
> current CPU number value from user-space.
>=20
> * Restartable sequences (per-cpu atomics)
>=20
> The restartable critical sections (percpu atomics) work has been started
> by Paul Turner and Andrew Hunter. It lets the kernel handle restart of
> critical sections. [1] [2] The re-implementation proposed here brings a
> few simplifications to the ABI which facilitates porting to other

Agreed ;-)

> architectures and speeds up the user-space fast path. A locking-based
> fall-back, purely implemented in user-space, is proposed here to deal
> with debugger single-stepping. This fallback interacts with rseq_start()
> and rseq_finish(), which force retries in response to concurrent
> lock-based activity.
>=20

So I have enabled this on powerpc, thanks to your nice work to make
things easy for porting ;-)

A patchset will follow in-reply-to this email, which includes patches
enabling this on powerpc and a patch that improves the portability of
the selftests, which I think it's not necessary to be a standalone
patch, so it's OK to be merged into your patch #7.

I did some tests on 64bit little/big endian pSeries(guest) kernel with
selftest cases(64bit LE selftest on 64bit LE kernel, 64/32bit BE
selftest on 64bit BE kernel), things seemingly went well ;-)

Here are some benchmark results I got on a little endian guest with 64
VCPUs:

Benchmarking various approaches for reading the current CPU number:

Power8 PSeries Guest(64 VCPUs, the host has 16 cores, 128 hardware
threads):
						=09
- Baseline (empty loop):                                   1.56 ns
- Read CPU from rseq cpu_id:                               1.56 ns
- Read CPU from rseq cpu_id (lazy register):               2.08 ns
- glibc 2.23-0ubuntu3 getcpu:                              7.72 ns
- getcpu system call:                                     91.80 ns


Benchmarking various approaches for counter increment:

Power8 PSeries KVM Guest(64 VCPUs, the host has 16 cores, 128 hardware
threads):

                                 Counter increment speed (ns/increment)
                              1 thread   2 threads   4 threads   8 threads =
  16 threads   32 threads
global increment (baseline)     6.5          N/A         N/A         N/A   =
      N/A           N/A
percpu rseq increment           6.9          6.9         7.2         7.3   =
     15.4          35.5
percpu rseq spinlock           19.0         18.9        19.4        19.4   =
     35.5          71.8
global atomic increment        25.8        111.0       261.0       905.2   =
   2319.5        4170.5 (__sync_add_and_fetch_4)
global atomic CAS              26.2        119.0       341.6      1183.0   =
   3951.3        9312.5 (__sync_val_compare_and_swap_4)
global pthread mutex           40.0        238.1       644.0      2052.2   =
   4272.5        8612.2


I surely need to run more tests for my patches in different
environments, and will try to adjust the patchset according to whatever
change you make(e.g. rseq_finish2) in the future.

(Add PPC maintainers in Cc)

Regards,
Boqun

> Here are benchmarks of counter increment in various scenarios compared
> to restartable sequences:
>=20
> ARMv7 Processor rev 4 (v7l)
> Machine model: Cubietruck
>=20
>                       Counter increment speed (ns/increment)
>                              1 thread    2 threads
> global increment (baseline)      6           N/A
> percpu rseq increment           50            52
> percpu rseq spinlock            94            94
> global atomic increment         48            74 (__sync_add_and_fetch_4)
> global atomic CAS               50           172 (__sync_val_compare_and_=
swap_4)
> global pthread mutex           148           862
>=20
> ARMv7 Processor rev 10 (v7l)
> Machine model: Wandboard
>=20
>                       Counter increment speed (ns/increment)
>                              1 thread    4 threads
> global increment (baseline)      7           N/A
> percpu rseq increment           50            50
> percpu rseq spinlock            82            84
> global atomic increment         44           262 (__sync_add_and_fetch_4)
> global atomic CAS               46           316 (__sync_val_compare_and_=
swap_4)
> global pthread mutex           146          1400
>=20
> x86-64 Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz:
>=20
>                       Counter increment speed (ns/increment)
>                               1 thread           8 threads
> global increment (baseline)      3.0                N/A
> percpu rseq increment            3.6                3.8
> percpu rseq spinlock             5.6                6.2
> global LOCK; inc                 8.0              166.4
> global LOCK; cmpxchg            13.4              435.2
> global pthread mutex            25.2             1363.6
>=20
> * Reading the current CPU number
>=20
> Speeding up reading the current CPU number on which the caller thread is
> running is done by keeping the current CPU number up do date within the
> cpu_id field of the memory area registered by the thread. This is done
> by making scheduler migration set the TIF_NOTIFY_RESUME flag on the
> current thread. Upon return to user-space, a notify-resume handler
> updates the current CPU value within the registered user-space memory
> area. User-space can then read the current CPU number directly from
> memory.
>=20
> Keeping the current cpu id in a memory area shared between kernel and
> user-space is an improvement over current mechanisms available to read
> the current CPU number, which has the following benefits over
> alternative approaches:
>=20
> - 35x speedup on ARM vs system call through glibc
> - 20x speedup on x86 compared to calling glibc, which calls vdso
>   executing a "lsl" instruction,
> - 14x speedup on x86 compared to inlined "lsl" instruction,
> - Unlike vdso approaches, this cpu_id value can be read from an inline
>   assembly, which makes it a useful building block for restartable
>   sequences.
> - The approach of reading the cpu id through memory mapping shared
>   between kernel and user-space is portable (e.g. ARM), which is not the
>   case for the lsl-based x86 vdso.
>=20
> On x86, yet another possible approach would be to use the gs segment
> selector to point to user-space per-cpu data. This approach performs
> similarly to the cpu id cache, but it has two disadvantages: it is
> not portable, and it is incompatible with existing applications already
> using the gs segment selector for other purposes.
>=20
> Benchmarking various approaches for reading the current CPU number:
>=20
> ARMv7 Processor rev 4 (v7l)
> Machine model: Cubietruck
> - Baseline (empty loop):                                    8.4 ns
> - Read CPU from rseq cpu_id:                               16.7 ns
> - Read CPU from rseq cpu_id (lazy register):               19.8 ns
> - glibc 2.19-0ubuntu6.6 getcpu:                           301.8 ns
> - getcpu system call:                                     234.9 ns
>=20
> x86-64 Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz:
> - Baseline (empty loop):                                    0.8 ns
> - Read CPU from rseq cpu_id:                                0.8 ns
> - Read CPU from rseq cpu_id (lazy register):                0.8 ns
> - Read using gs segment selector:                           0.8 ns
> - "lsl" inline assembly:                                   13.0 ns
> - glibc 2.19-0ubuntu6 getcpu:                              16.6 ns
> - getcpu system call:                                      53.9 ns
>=20
> - Speed
>=20
> Running 10 runs of hackbench -l 100000 seems to indicate, contrary to
> expectations, that enabling CONFIG_RSEQ slightly accelerates the
> scheduler:
>=20
> Configuration: 2 sockets * 8-core Intel(R) Xeon(R) CPU E5-2630 v3 @
> 2.40GHz (directly on hardware, hyperthreading disabled in BIOS, energy
> saving disabled in BIOS, turboboost disabled in BIOS, cpuidle.off=3D1
> kernel parameter), with a Linux v4.6 defconfig+localyesconfig,
> restartable sequences series applied.
>=20

[snip]

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXmM1SAAoJEEl56MO1B/q48hEH/jdZPcrUxynDFXqoKp2lrjF+
WxW++H99rIOQKgTF7etYCUDW9zxBEFRE+PXiGHYa9dalimOQx4XxBMOqDFOGZo2y
ezb2asTEOg3uzSmDAPzz5PczYJHFf6qpIDoL50osfybZ+FvOpoLdecT14MBLAlR5
8BSZNVLCISYKv61tEDic7J9slTiWWpOqVs2nEXezb0BoCSUnsith5kZn4QyOJ+bw
scDjTieXVWkCyCimhKAaKvndWMumbeQgFpY9zvIAmjidoIw08Gk8mP9hNEhhUnKa
zj+NdZkxUlR/y4Y01LHHDcsqFLkijs6TnOzKqleDzqP59U+vBoCamUM28SB/Ziw=
=HElv
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
