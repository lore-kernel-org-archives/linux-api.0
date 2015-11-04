From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/8] mm: move lazily freed pages to inactive list
Date: Wed, 4 Nov 2015 16:48:17 -0500
Message-ID: <563A7D21.6040505@gmail.com>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
 <1446188504-28023-6-git-send-email-minchan@kernel.org>
 <20151104205504.GA9927@cmpxchg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SIniK9POceDHqW8AWkRjx172aJX0cGs4j"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151104205504.GA9927-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Wang, Yalin" <Yalin.Wang-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SIniK9POceDHqW8AWkRjx172aJX0cGs4j
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

> Even if we're wrong about the aging of those MADV_FREE pages, their
> contents are invalidated; they can be discarded freely, and restoring
> them is a mere GFP_ZERO allocation. All other anonymous pages have to
> be written to disk, and potentially be read back.
>=20
> [ Arguably, MADV_FREE pages should even be reclaimed before inactive
>   page cache. It's the same cost to discard both types of pages, but
>   restoring page cache involves IO. ]

Keep in mind that this is memory the kernel wouldn't be getting back at
all if the allocator wasn't going out of the way to purge it, and they
aren't going to go out of their way to purge it if it means the kernel
is going to steal the pages when there isn't actually memory pressure.

An allocator would be using MADV_DONTNEED if it didn't expect that the
pages were going to be used against shortly. MADV_FREE indicates that it
has time to inform the kernel that they're unused but they could still
be very hot.

> It probably makes sense to stop thinking about them as anonymous pages
> entirely at this point when it comes to aging. They're really not. The
> LRU lists are split to differentiate access patterns and cost of page
> stealing (and restoring). From that angle, MADV_FREE pages really have
> nothing in common with in-use anonymous pages, and so they shouldn't
> be on the same LRU list.
>=20
> That would also fix the very unfortunate and unexpected consequence of
> tying the lazy free optimization to the availability of swap space.
>=20
> I would prefer to see this addressed before the code goes upstream.

I don't think it would be ideal for these potentially very hot pages to
be dropped before very cold pages were swapped out. It's the kind of
tuning that needs to be informed by lots of real world experience and
lots of testing. It wouldn't impact the API.

Whether MADV_FREE is useful as an API vs. something like a pair of
system calls for pinning and unpinning memory is what should be worried
about right now. The internal implementation just needs to be correct
and useful right now, not perfect. Simpler is probably better than it
being more well tuned for an initial implementation too.


--SIniK9POceDHqW8AWkRjx172aJX0cGs4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWOn0hAAoJEPnnEuWa9fIqwqQP/0Mbf4HS1hsGCrhHLcpn9U0o
VA+N8QVO/x4Rb05Qkpm7Nr8ZqJsnda0wqjM7Ei75MXx4Mc6n4xsQnrpCKwtyr+q9
taJZYvpKJjvkaHKt0s9HGTX2dns5+Hdxwmqn0tYqHMPQYXQse55RTgBqtfzZ65N5
CzNzyampw5bSu50e+702un5Ew2ZLeDIop1whzGc2kSWafCTuxv2t1F3JZoWZD7dk
T7A873bxft7aUUQFt+GA4kd7PgsNrN4zdfIB5IucHsFda6Hei8wLe519caPbG9CF
627AAMStLhztFxN9FbW+PozGeh3dP99lgy2RTdWtoVmcNjLQ3qK/8N0L28lF1QXU
iVFChkpW7o8gtnIVdACQSpZD8KtSfYMlUQas4Xg5mXj/tOS45l65FFfZ1mRPXqYg
PEF0AoHcTSH9DXRVB+AOkCFLHIhYlZvYuQeQ1/Tx6G29n8Op29YZUf+eWxVYf0sx
0kyADd3PMSDd8l1l/vugf6AUiRqW52cFjnBzSweVkGZITGqs2+Jf1t1NfI/W0NOw
/sRTwRT00y58lEEy8qZO7/piUzYIoobWpmlowCw2fiGycbOx2VvvUryeSxw0BZxW
XrhbombAt5F/Imz8mI+IoNnQR9BU6GyNdT9vnKc0nBAEjD/raKt606sqXI+nWM8W
qF2Wf2dpy39NE5D3c3To
=hwJg
-----END PGP SIGNATURE-----

--SIniK9POceDHqW8AWkRjx172aJX0cGs4j--
