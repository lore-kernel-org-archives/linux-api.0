From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mremap: add MREMAP_NOHOLE flag --resend
Date: Wed, 25 Mar 2015 21:21:10 -0400
Message-ID: <55135F06.4000906@gmail.com>
References: <deaa4139de6e6422a0cec1e3282553aed3495e94.1426626497.git.shli@fb.com> <20150318153100.5658b741277f3717b52e42d9@linux-foundation.org> <550A5FF8.90504@gmail.com> <CADpJO7zBLhjecbiQeTubnTReiicVLr0-K43KbB4uCL5w_dyqJg@mail.gmail.com> <20150323051731.GA2616341@devbig257.prn2.facebook.com> <CADpJO7zk8J3q7Bw9NibV9CzLarO+YkfeshyFTTq=XeS5qziBiA@mail.gmail.com> <55117724.6030102@gmail.com> <20150326005009.GA7658@blaptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gWdQ5wWODA4o1bSuSbrBd7JDhcQbGfSI0"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150326005009.GA7658@blaptop>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aliaksey Kandratsenka <alkondratenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gWdQ5wWODA4o1bSuSbrBd7JDhcQbGfSI0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

> I didn't follow this thread. However, as you mentioned MADV_FREE will
> make many page fault, I jump into here.
> One of the benefit with MADV_FREE in current implementation is to
> avoid page fault as well as no zeroing.
> Why did you see many page fault?

I think I just misunderstood why it was still so much slower than not
using purging at all.

>> I get ~20k requests/s with jemalloc on the ebizzy benchmark with this
>> dual core ivy bridge laptop. It jumps to ~60k requests/s with MADV_FRE=
E
>> IIRC, but disabling purging via MALLOC_CONF=3Dlg_dirty_mult:-1 leads t=
o
>> 3.5 *million* requests/s. It has a similar impact with TCMalloc.
>=20
> When I tested MADV_FREE with ebizzy, I saw similar result two or three
> times fater than MADV_DONTNEED. But It's no free cost. It incurs MADV_F=
REE
> cost itself*(ie, enumerating all of page table in the range and clear
> dirty bit and tlb flush). Of course, it has mmap_sem with read-side loc=
k.
> If you see great improve when you disable purging, I guess mainly it's
> caused by no lock of mmap_sem so some threads can allocate while other
> threads can do page fault. The reason I think so is I saw similar resul=
t
> when I implemented vrange syscall which hold mmap_sem read-side lock
> during very short time(ie, marking the volatile into vma, ie O(1) while=

> MADV_FREE holds a lock during enumerating all of pages in the range, ie=
 O(N))

It stops doing mmap after getting warmed up since it never unmaps so I
don't think mmap_sem is a contention issue. It could just be caused by
the cost of the system call itself and TLB flush. I found perf to be
fairly useless in identifying where the time was being spent.

It might be much more important to purge very large ranges in one go
with MADV_FREE. It's a different direction than the current compromises
forced by MADV_DONTNEED.


--gWdQ5wWODA4o1bSuSbrBd7JDhcQbGfSI0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVE18GAAoJEPnnEuWa9fIqC68QAJEVXESm4ZtUrtyXhW+NTxy/
L49+LLO03Eg6epvhCd85NJ60PJtUxDu6bLOnCctF8Jm/0xq0DN04GcNkKh/hMT4w
nzZDmD/fz6BgWCS29dCA07QBMs8VuuC6BiW3JakS5xuP9yt6lezFk1IEbByB01PR
jiGBjqM0S7dnJJDpeVvuha9kS7YBorWM6xc1iyo11pdK71GgCCEcqRXm+rggcuBx
2DGqQItYx4uO4LKysLIumMwJ/Gqwsg1GVuL3Ufg8chFBw7E8xPtGEA8c/wcQTbwG
0jzKCdz0OU2VTb31NIaJl9d4OQBbUjjStYCA1qktjobmaf6KYJ6dNEA1QevmVX7p
2wZ5duZNI9MZt9ZrDoLtAlxdzFFoweXsQIFMHXOzNXcTuPj3UQYK6M35AT1kppYA
RPdWl/OFYzcJiioJEs9wVteKYuOsVFxRtRDqUD9a9H3X6opJ7kQhQyuyw8/af7v/
uf9S6WlDXxZCqsefHCpbvjnExKBHL7NMh7PeQnduPIdsJyJXhzofu1HzxQCrhdmw
aJZL6jVXZIuIUEsdk3QixdSFNwtQ+TDeIBplZR5ep+S3UxOqR8vka8CiFmeKEonX
G5Bi0LQVBZ5BQaI722yOpywR/aXqmeZUbcULqi7HEr1i2ZNPWDjHk+dwuiBGQQbR
j6ySNFdhv2QS0C5sDME6
=7xwN
-----END PGP SIGNATURE-----

--gWdQ5wWODA4o1bSuSbrBd7JDhcQbGfSI0--
