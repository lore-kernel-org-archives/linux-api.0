From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] mmap.2: clarify MAP_LOCKED semantic
Date: Wed, 13 May 2015 10:48:30 -0400
Message-ID: <20150513144830.GF1227@akamai.com>
References: <1431527892-2996-1-git-send-email-miso@dhcp22.suse.cz>
 <1431527892-2996-2-git-send-email-miso@dhcp22.suse.cz>
 <20150513144506.GD1227@akamai.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dWYAkE0V1FpFQHQ3"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150513144506.GD1227-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <miso-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--dWYAkE0V1FpFQHQ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 13 May 2015, Eric B Munson wrote:

> On Wed, 13 May 2015, Michal Hocko wrote:
>=20
> > From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> >=20
> > MAP_LOCKED had a subtly different semantic from mmap(2)+mlock(2) since
> > it has been introduced.
> > mlock(2) fails if the memory range cannot get populated to guarantee
> > that no future major faults will happen on the range. mmap(MAP_LOCKED) =
on
> > the other hand silently succeeds even if the range was populated only
> > partially.
> >=20
> > Fixing this subtle difference in the kernel is rather awkward because
> > the memory population happens after mm locks have been dropped and so
> > the cleanup before returning failure (munlock) could operate on somethi=
ng
> > else than the originally mapped area.
> >=20
> > E.g. speculative userspace page fault handler catching SEGV and doing
> > mmap(fault_addr, MAP_FIXED|MAP_LOCKED) might discard portion of a racing
> > mmap and lead to lost data. Although it is not clear whether such a
> > usage would be valid, mmap page doesn't explicitly describe requirements
> > for threaded applications so we cannot exclude this possibility.
> >=20
> > This patch makes the semantic of MAP_LOCKED explicit and suggest using
> > mmap + mlock as the only way to guarantee no later major page faults.
> >=20
> > Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>=20
> Does the problem still happend when MAP_POPULATE | MAP_LOCKED is used
> (AFAICT MAP_POPULATE will cause the mmap to fail if all the pages cannot
> be made present).
>=20
> Either way this is a good catch.
>=20
> Acked-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
>=20
Sorry for the noise, this should have been a

Reviewed-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>


--dWYAkE0V1FpFQHQ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVU2Q+AAoJELbVsDOpoOa9pw0QAJNQUeH65rfob8aNYHt8BEJX
5PJjFCHF0JkM8RR6CQUyFmZST5c/+G1oHY0DpoT5sWYFFoAFx0WziiIs1y3QC5tW
gQoZXTY/jvlm9z8F6pcZKEnMgMTNtkvhjcP4/4uYXfB6dCcBbv3NmuWqpGjCal2W
IiHZUwroFS14kIfcEr5WHfpuQAeSt4kEy2C8E/T92e3WZ9Gqks8x1T8OyVTQitxw
7N58hqndfG5tBTgHOIwsIfuxyvYvCnTg+gRWyoWsBaSbMOTDj/v9EWZCe7HDX78u
eVJWNrpqx53TdNzx2stk4pwwGtkFOlv9Twq82ezgm/ByYKfBpUPMJk1XyxOsUkwn
KOjmDMFIVaMCviCLBvqJL1B4gKK5zz10HkhndDj2LRr2LDQOcwhqNaBlvFOPnboZ
lqou163GbbiJxC7hm1uySQJW+slYvy0d2g+rYoZ9WFKWfBIyrQKb3O/VR4hyojkB
oqLcZpY9cFVP1nft7cjJEvKWYNIXrkrpOZ+VkkMcFSqeiGj0GQNCnCHIPQn+jwvP
lZpcYtvfqGqkmMM2fXZFFFQ5ZSeYiGL2bWocbQXn3+wdq1YqYvbsw7VtHLtSO7XB
c70vrUpnmfdvjS3mg5TsxapxyE07T0SQqMCjY07sfAodZbKy6IUQORza8ut+TV3S
csaAt+4Olc28v/8N79tC
=KLpL
-----END PGP SIGNATURE-----

--dWYAkE0V1FpFQHQ3--
