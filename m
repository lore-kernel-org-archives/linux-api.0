From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 01/13] mm: support madvise(MADV_FREE)
Date: Wed, 4 Nov 2015 00:53:42 -0500
Message-ID: <56399D66.5010606@gmail.com>
References: <1446600367-7976-1-git-send-email-minchan@kernel.org>
 <1446600367-7976-2-git-send-email-minchan@kernel.org>
 <CALCETrUuNs=26UQtkU88cKPomx_Bik9mbgUUF9q7Nmh1pQJ4qg@mail.gmail.com>
 <56399CA5.8090101@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cUQ8j9QwPBRa7ColOaP5oLioCC5dAas0V"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56399CA5.8090101-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cUQ8j9QwPBRa7ColOaP5oLioCC5dAas0V
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> In the common case it will be passed many pages by the allocator. There=

> will still be a layer of purging logic on top of MADV_FREE but it can b=
e
> much thinner than the current workarounds for MADV_DONTNEED. So the
> allocator would still be coalescing dirty ranges and only purging when
> the ratio of dirty:clean pages rises above some threshold. It would be
> able to weight the largest ranges for purging first rather than logic
> based on stuff like aging as is used for MADV_DONTNEED.

I would expect that jemalloc would just start putting the dirty ranges
into the usual pair of red-black trees (with coalescing) and then doing
purging starting from the largest spans to get back down below whatever
dirty:clean ratio it's trying to keep. Right now, it has all lots of
other logic to deal with this since each MADV_DONTNEED call results in
lots of zeroing and then page faults.


--cUQ8j9QwPBRa7ColOaP5oLioCC5dAas0V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWOZ1mAAoJEPnnEuWa9fIqqlAQAJLjzAeM7JTdDiC4x1MD5iT9
HLoKkhjx3h7vYNjJ7DX67+AHchAsEVGqi7mmEi2WNKa0Ia9nihJnOJ5yN5QLVFNk
nncn0tRocYeBjiyGnXENsNf3BmleemmQ+A9y/1j2INWB2hFTtv8H4HXglwiFNT1w
BHO10/mUgeHUgkLjR3Ev30Pz2/6EdNHDdccQafdBdYn4DMU3i2WRHk9LeqcpkY1B
oWnPl+AL29FkwbFbHRwBWGdg905NckpG23Res4+NgCsDh2dn+qZJEeDyh0mppZQU
HgIwmyC1YOx+5Gtxqj4VYtdmyfVDboo2ho0IEcmUL0Q/8xixnVUn15oVqt7ea87Q
TFD5ynLQs4Rsi2HTwVLGkZOlPWZZOsmcDYVsBsxK5ft1sLkzDqIO5fD3zNop7XyV
A3x1LHzGNe24fV2sJXUf1kaPO2cj/rpJVKkmAu4Dnx7+L3hI7Exk2TNWLyi5dJni
0rAVECfCDWx52I9+txdQ4tujTLBfpOXns1FEIAw2bi+K7XCGhs+wilj71us42Pg2
rTOnl6hB8R6nOPHuLUmEiTPzlhH5hdMA9ulYLLlyThVXTD4fVHIO3KqNB1I6H2Lz
YnXdSCv+3h4oItr/DK5Hc2Xcj8KRCKP7aXl10Jv2xTFcFs6aOlyxV28Ma8ipZen5
x0wElmKMJVChjJm3JSUd
=sB2E
-----END PGP SIGNATURE-----

--cUQ8j9QwPBRa7ColOaP5oLioCC5dAas0V--
