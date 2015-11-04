From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 01/13] mm: support madvise(MADV_FREE)
Date: Wed, 4 Nov 2015 16:16:01 -0500
Message-ID: <563A7591.7080607@gmail.com>
References: <1446600367-7976-1-git-send-email-minchan@kernel.org>
 <1446600367-7976-2-git-send-email-minchan@kernel.org>
 <20151104200006.GA46783@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CuneNnFdlk8k24ClMQJxchbWeXnOJPeC3"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151104200006.GA46783-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bmaurer-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CuneNnFdlk8k24ClMQJxchbWeXnOJPeC3
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

> Compared to MADV_DONTNEED, MADV_FREE's lazy memory free is a huge win t=
o reduce
> page fault. But there is one issue remaining, the TLB flush. Both MADV_=
DONTNEED
> and MADV_FREE do TLB flush. TLB flush overhead is quite big in contempo=
rary
> multi-thread applications. In our production workload, we observed 80% =
CPU
> spending on TLB flush triggered by jemalloc madvise(MADV_DONTNEED) some=
times.
> We haven't tested MADV_FREE yet, but the result should be similar. It's=
 hard to
> avoid the TLB flush issue with MADV_FREE, because it helps avoid data
> corruption.
>=20
> The new proposal tries to fix the TLB issue. We introduce two madvise v=
erbs:
>=20
> MARK_FREE. Userspace notifies kernel the memory range can be discarded.=
 Kernel
> just records the range in current stage. Should memory pressure happen,=
 page
> reclaim can free the memory directly regardless the pte state.
>=20
> MARK_NOFREE. Userspace notifies kernel the memory range will be reused =
soon.
> Kernel deletes the record and prevents page reclaim discards the memory=
=2E If the
> memory isn't reclaimed, userspace will access the old memory, otherwise=
 do
> normal page fault handling.
>=20
> The point is to let userspace notify kernel if memory can be discarded,=
 instead
> of depending on pte dirty bit used by MADV_FREE. With these, no TLB flu=
sh is
> required till page reclaim actually frees the memory (page reclaim need=
 do the
> TLB flush for MADV_FREE too). It still preserves the lazy memory free m=
erit of
> MADV_FREE.
>=20
> Compared to MADV_FREE, reusing memory with the new proposal isn't trans=
parent,
> eg must call MARK_NOFREE. But it's easy to utilize the new API in jemal=
loc.
>=20
> We don't have code to backup this yet, sorry. We'd like to discuss it i=
f it
> makes sense.

That's comparable to Android's pinning / unpinning API for ashmem and I
think it makes sense if it's faster. It's different than the MADV_FREE
API though, because the new allocations that are handed out won't have
the usual lazy commit which MADV_FREE provides. Pages in an allocation
that's handed out can still be dropped until they are actually written
to. It's considered active by jemalloc either way, but only a subset of
the active pages are actually committed. There's probably a use case for
both of these systems.


--CuneNnFdlk8k24ClMQJxchbWeXnOJPeC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWOnWRAAoJEPnnEuWa9fIqdeEP/iVWpgU10VwM9SIZZenn5154
aolJpC1qXALGsnrIcMkJXpmlq1Fky4Ew/lhua+Ca1NidemR76TnEZEfZuAghQ3hf
37p7aQDhm9j7WmAcMfxm0iJCcCepKMtp504eRAgUSBoXXdK3Y5VgbPVMZSzNsNBI
Ct9/2RjevChz8ILIz5JFw3C9a4WKOxOBDQELCdU+/ObZ7Ll/xocbBkUEaLu4NlGX
7dAe3EigCMzx2rqoAXuKgbBpVEu4PmBoUu2ORvfQKUZRmsHZ1i9t/Mm8aTU2ynQW
SEw1FjArwGE35RozI3WvKgyGJ9L0GVYw9w8L2ol2ZOzASLBffVaLJd9ODqnhF0Vj
/0gHIJQVWg4Jkn4uJLBjIW7x6Xugr99SlD8/RCwbiU5DLPCWi+IEKCaj0iELad1v
7Ljh+lUpm62kixw0VgucfXWXf0QR9TieI2xXJUnbLLwdYzEsPCmwNhw6EMpKY7ui
LW2+XuZrk9dczLYL2opzc7ln473lV5VJWFuYWHl4bqhjcfJOyNUVWPZtgnqxvvsl
B6ppmCAgFJqD5gUlZuLnNGNDX7Ne7eRFxjJEYbn9bKPXGtHumi/aNQ/ZAkyf93KV
O0LpTD84RabknhROgjKE9IU6BSwtKOGWNH9p4eSJDijX5KaQqqSE18ET6/e/xIVE
bxjp/MAvfZvEN30aJSjA
=PR5d
-----END PGP SIGNATURE-----

--CuneNnFdlk8k24ClMQJxchbWeXnOJPeC3--
