From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mremap: add MREMAP_NOHOLE flag --resend
Date: Thu, 19 Mar 2015 01:34:48 -0400
Message-ID: <550A5FF8.90504@gmail.com>
References: <deaa4139de6e6422a0cec1e3282553aed3495e94.1426626497.git.shli@fb.com> <20150318153100.5658b741277f3717b52e42d9@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2ucVuBgLn6NdbLVigBgjwxBu69u8dihma"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150318153100.5658b741277f3717b52e42d9-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Aliaksey Kandratsenka <alkondratenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2ucVuBgLn6NdbLVigBgjwxBu69u8dihma
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 18/03/15 06:31 PM, Andrew Morton wrote:
> On Tue, 17 Mar 2015 14:09:39 -0700 Shaohua Li <shli-b10kYP2dOMg@public.gmane.org> wrote:
>=20
>> There was a similar patch posted before, but it doesn't get merged. I'=
d like
>> to try again if there are more discussions.
>> http://marc.info/?l=3Dlinux-mm&m=3D141230769431688&w=3D2
>>
>> mremap can be used to accelerate realloc. The problem is mremap will
>> punch a hole in original VMA, which makes specific memory allocator
>> unable to utilize it. Jemalloc is an example. It manages memory in 4M
>> chunks. mremap a range of the chunk will punch a hole, which other
>> mmap() syscall can fill into. The 4M chunk is then fragmented, jemallo=
c
>> can't handle it.
>=20
> Daniel's changelog had additional details regarding the userspace
> allocators' behaviour.  It would be best to incorporate that into your
> changelog.
>
> Daniel also had microbenchmark testing results for glibc and jemalloc. =

> Can you please do this?
>=20
> I'm not seeing any testing results for tcmalloc and I'm not seeing
> confirmation that this patch will be useful for tcmalloc.  Has anyone
> tried it, or sought input from tcmalloc developers?

TCMalloc and jemalloc are currently equally slow in this benchmark, as
neither makes use of mremap. They're ~2-3x slower than glibc. I CC'ed
the currently most active TCMalloc developer so they can give input
into whether this patch would let them use it.

#include <string.h>
#include <stdlib.h>

int main(void) {
  void *ptr =3D NULL;
  size_t old_size =3D 0;
  for (size_t size =3D 4 * 1024 * 1024; size < 1024 * 1024 * 1024; size *=
=3D 2) {
    ptr =3D realloc(ptr, size);
    if (!ptr) return 1;
    memset(ptr, 0xff, size - old_size);
    old_size =3D size;
  }
  free(ptr);
}

If an outer loop is wrapped around this, jemalloc's master branch will
at least be able to do in-place resizing for everything after the 1st
run, but that's much rarer in the real world where there are many users
of the allocator. The lack of mremap still ends up hurting a lot.

FWIW, jemalloc is now the default allocator on Android so there are an
increasing number of Linux machines unable to leverage mremap. It could
be worked around by attempting to use an mmap hint to get the memory
back, but that can fail as it's a race with the other threads and that
leads increases fragmentation over the long term.

It's especially problematic if a large range of virtual memory is
reserved and divided up between per-CPU arenas for concurrency, but
only garbage collectors tend to do stuff like this at the moment. This
can still be dealt with by checking internal uses of mmap and returning
any memory from the reserved range to the right place, but it shouldn't
have to be that ugly.


--2ucVuBgLn6NdbLVigBgjwxBu69u8dihma
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVCl/4AAoJEPnnEuWa9fIqLu0P/07zNGlp+Y382TApAl4IohXu
rH6/q1kLbdBVSFv3wRG/JN0Zh6pb3Mwk/5YVhxEwq59gTtjY47IX987OV8EaXASj
fszO3FiISkiOwsCpr0SPyfs2zQ+IJ3ePRH2ZN10gpfjyWQctFt8KRn9rQfe3eF82
zq7YONnBMPAnF/ub2ets79LLCcfx6LbXrdKT7w5//77d6M3GqqcePZpB7JLZIzGK
IQip8SzKO3qr9D1C0FU0AqwQshFkQgXNiiQsBfdhZEBvGrC4KdnDduOJTy0rKyuO
ZVUX4aXEkiehHfvE8W9VM8V1rtlb+WYW7mhbUZzc2qQD32yiL3YUeE2FbvJkp4hw
K+keYB55z85jrgQN3DZ0TvC5oCiorxdmY50zjmET9b9C9apy8OUshzCgjdfedX8Z
Jtza1hlClVaGzzlk+dXJuFkA7cjqdbYEytq8uvykmuGvxpYsPKwXsz+S7f//ptzW
hl2KX9Owk3W44xrbILpqGauZeRg8YDp7iTvW3bWgJ+cEFl7EscOUgFHlvdon9IUa
QM7T1T2v/Dk0QnCrfiiiOqr/3hdnJq9rEHCUAKSuzQJGyeVxHBMr0r76H0MZSHKs
//VuW2Xv6rNBH20OpjQ7qADyngg9oCJ3M+ufmlZXyF7d4UqRbtTG5KsCWqfCxGLl
U+T/kv6Y31lMP70pGIy+
=0Q5H
-----END PGP SIGNATURE-----

--2ucVuBgLn6NdbLVigBgjwxBu69u8dihma--
