From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 01/13] mm: support madvise(MADV_FREE)
Date: Wed, 4 Nov 2015 16:29:00 -0500
Message-ID: <563A789C.5040409@gmail.com>
References: <1446600367-7976-1-git-send-email-minchan@kernel.org>
 <1446600367-7976-2-git-send-email-minchan@kernel.org>
 <20151104200006.GA46783@kernel.org> <563A7591.7080607@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uKBOvN247j2AhpxbKS9KA7xPxPb947xqX"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <563A7591.7080607-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bmaurer-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uKBOvN247j2AhpxbKS9KA7xPxPb947xqX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

> That's comparable to Android's pinning / unpinning API for ashmem and I=

> think it makes sense if it's faster. It's different than the MADV_FREE
> API though, because the new allocations that are handed out won't have
> the usual lazy commit which MADV_FREE provides. Pages in an allocation
> that's handed out can still be dropped until they are actually written
> to. It's considered active by jemalloc either way, but only a subset of=

> the active pages are actually committed. There's probably a use case fo=
r
> both of these systems.

Also, consider that MADV_FREE would allow jemalloc to be extremely
aggressive with purging when it actually has to do it. It can start with
the largest span of memory and it can mark more than strictly necessary
to drop below the ratio as there's no cost to using the memory again
(not even a system call).

Since the main cost is using the system call at all, there's going to be
pressure to mark the largest possible spans in one go. It will mean
concentration on memory compaction will improve performance. I think
that's the right direction for the kernel to be guiding userspace. It
will play better with THP than the allocator trying to be very precise
with purging based on aging.


--uKBOvN247j2AhpxbKS9KA7xPxPb947xqX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWOnicAAoJEPnnEuWa9fIqPygP/34m87CX/U7dqygXAt2utvmi
sqX36PHbkm9mScLW7iin77VBJz+o/oVHqaEHryN14t+bVrDm/n7o4jaJKCDpJxm6
W9OoeF65SRXI95GoyDnvgZ5TvMuBwf9AGK36mahPMjlWkIka1KbUyd5Dy7GaFOKL
kSc6ETZK2SnHeOD0bTUk33I78pIJWJxk040CzDYfDwNuVs7fwD9rW2TbSfV8Inkm
9FN7GUKY8IHznLr/BV9wDlVd9CDvH/vaPdhc2f5SKtICnEiv6ZUUhCDmx2oHwlUC
NGPXIBVLn1iOeeGAbUb3oFz/1Tua92eDpYr/xwoPk75X+Wzi3GvUFKZ7HWH4EcP0
FC3FNwp/Ig1IC4BjoY8/kAiQS3PX+iTB5TGCdZmIpP2Y/W32lnoj7cdve/EHaJh/
4PFOmKxqSBgxG/DMTM+W4skov/c5LUcDt4BBLC14nEYqc9yN73HaFuprcwKHqbSN
p0TuvXK90r22XgH/jJ2EjeGjEG2Vyjj1UYdl1OWVBYXHO8aWqVzR+GQ8IFzBNk/i
Ip2571ITaUXsKFo6DJTquKJq1r6jvmH8TjI/hqZUq0Cogog+R2KMVobJUwGa/MoV
TDyrpWrdtqux/B7yjBqQcO2m3WwFyXIqMPZ2q9bS0bo8uyNQ2z7vxPfhQP+62Tng
O2ZV6Slyha4JAr2Ueubi
=Mp2Q
-----END PGP SIGNATURE-----

--uKBOvN247j2AhpxbKS9KA7xPxPb947xqX--
