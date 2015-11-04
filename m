From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/8] mm: move lazily freed pages to inactive list
Date: Wed, 4 Nov 2015 18:49:54 -0500
Message-ID: <563A99A2.6010708@gmail.com>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
 <1446188504-28023-6-git-send-email-minchan@kernel.org>
 <20151104205504.GA9927@cmpxchg.org> <563A7D21.6040505@gmail.com>
 <20151104225527.GA25941@cmpxchg.org> <563A9681.3070102@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="k0kDwtgODIEgNHu0OeacGeSBTwiQV7a4u"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <563A9681.3070102-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Wang, Yalin" <Yalin.Wang-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k0kDwtgODIEgNHu0OeacGeSBTwiQV7a4u
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

> From a user perspective, it doesn't depend on swap. It's just slower
> without swap because it does what MADV_DONTNEED does. The current
> implementation can be dropped in where MADV_DONTNEED was previously use=
d.

It just wouldn't replace existing layers of purging logic until that
edge case is fixed and it gains better THP integration.

It's already a very useful API with significant performance wins over
MADV_DONTNEED, so it will be useful. The only risk involved in landing
it is that a better feature might come along. Worst case scenario being
that the kernel ends up with a synonym for MADV_DONTNEED (but I think
there will still be a use case for this even if a pinning/unpinning API
existed, as this is more precise).


--k0kDwtgODIEgNHu0OeacGeSBTwiQV7a4u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWOpmiAAoJEPnnEuWa9fIqDPQP/R9XV3XxkHqRG4OYJrAtg1WB
FOHhev+ws5lP+6P/4Da6BS9OFPC8Ok7P2tCf/9b3p2nEMmN8vVmuKdTToZpUfTzK
n5//uXoUey5+S1OlDD7Vs9StkqdBG3mhz7eISzRn0TTv8MMeXkvk4n90fzjrIQF1
iEnUvOTrB1SU8U+DvTGuHwkfHN5WWFBJjnIFRqzADHBVQoXS9MRC0QZM5SaKF5Ms
j72DJVwpUQUWVeMhtuTtyehyCOp1mYTLoMlII8z1E/sFxZ9Bry/WG4iCIWNPfDxb
sQVqBWk2v80LF7Fo3bA+YuM6D+ZqSFULec+WUpq6s0ZESiFAcb3kJlriwocGuHdF
A16h+ZKQIXIdsUD5KbnxfsK0OiSH7/PE+GCpe8OhCOw5yH5VVePLcxBJ0MCXAJIW
mOIuYNlgadl2Pgh2YiXT1l9A8moICZzAWwUnjjvWdPow2JtHEDsAV2UdT1jOuYCb
EQsiiMxy2FNagHqAu5cWnSrgDatQPW5CY4lqngD9RY8hX+/RxYZ2Yxmg7R1/Tg6P
rsVFjrWMkw4KqdSIBberOEKYfiRcpU/OZ6/mPmRf2gokDQA7DjCr1tQOq85d1K7O
nrFN0nhI95EnK1rX8sYpYy39D/6ZfIU9UjLiLKNo4qq2z4V4juMNYH92hjra92Qn
WBbxJnB1JR6DjLNm0eiW
=mmlT
-----END PGP SIGNATURE-----

--k0kDwtgODIEgNHu0OeacGeSBTwiQV7a4u--
