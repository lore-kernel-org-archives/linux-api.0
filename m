From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mremap: add MREMAP_NOHOLE flag --resend
Date: Wed, 25 Mar 2015 23:36:55 -0400
Message-ID: <55137ED7.6000300@gmail.com>
References: <deaa4139de6e6422a0cec1e3282553aed3495e94.1426626497.git.shli@fb.com> <20150318153100.5658b741277f3717b52e42d9@linux-foundation.org> <550A5FF8.90504@gmail.com> <CADpJO7zBLhjecbiQeTubnTReiicVLr0-K43KbB4uCL5w_dyqJg@mail.gmail.com> <550E6D9D.1060507@gmail.com> <5512E0C0.6060406@suse.cz> <55131F70.7020503@gmail.com> <alpine.DEB.2.10.1503251710400.31453@chino.kir.corp.google.com> <551351CA.3090803@gmail.com> <alpine.DEB.2.10.1503251914260.16714@chino.kir.corp.google.com> <55137C06.9020608@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fkRdFvaECUfOwRNlDWWPUfxapEi6OUESe"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55137C06.9020608-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Aliaksey Kandratsenka <alkondratenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fkRdFvaECUfOwRNlDWWPUfxapEi6OUESe
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

jemalloc doesn't really use free lists or sbrk for user allocations much
at all: thread caches are arrays of pointers (easier to flush and no
need to deref stale memory), red-black trees manage chunks and runs
within chunks, and runs use bitmaps. It can use sbrk as an alternate
source of chunks, but it defaults to using mmap and there's no real
advantage to switching it.

THP currently seems to be designed around the assumption that all
userspace allocators are variants of dlmalloc...


--fkRdFvaECUfOwRNlDWWPUfxapEi6OUESe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVE37XAAoJEPnnEuWa9fIqWGsQAIcv47DkrYMIHMjcI76ZgTlJ
xIPQp54tN6/irfJmlZVR3YYxpfL/PkjRmnsmTuiXgD/ngrl3xLi2j0yGObiYIeoh
iZU4V/YOt6a5Qe6cmonsIvCCvUL3glqp94F8k+JoSBr8GTvykzkqKXvstzJXZkvT
xBOYmFfO7GvQlJDpwX6P3bj/Yq3ldIkiq/UiGo8w8DTcsUdqlNYjU9JZlhQwiukF
J5cysbA3YuuxS6ZFrQdyAI1p30PIIKMTIXjluVWNsybREPtsapvEaWiotEdE/DFU
fACW0m6EWL1yq0uDi1BWXESrufEiIB3jXYB4TFTmynuRf1LToXZm1sqyk+7OUz5+
Pjg1L+hEv08nLVcDduJlSJzRcp2uV4wLKAWd369aWafmQrTsAViREemKLzaV7XJV
4ec6+z+8oA293uKA585jMElR/SHelku3yAiPoCiw1hxFZHKBIHvDdGFQaXaxgdsr
YZ9ViCiUSkNAyNGF15SY9LkVWqzF0rl1viX2jxSvBn0JUY4UK4AIplq75MmH28Y6
XbZpNslIIDUKTJRI9VluA9Yw/Rp5OJKjmsCq/Rzr4skQGVRNsz6UrLeENTgbJLAy
Q7aQ7X/aGqHbwCbhPH6DNBDOwv7TWTvfZl6gyDpa/klAmluaPntBu1x5u716zLVF
rEpOzWMmvkW2Ha5slZIw
=SD8J
-----END PGP SIGNATURE-----

--fkRdFvaECUfOwRNlDWWPUfxapEi6OUESe--
