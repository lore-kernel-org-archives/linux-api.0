From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] mmap2: clarify MAP_POPULATE
Date: Wed, 13 May 2015 10:47:15 -0400
Message-ID: <20150513144715.GE1227@akamai.com>
References: <1431527892-2996-1-git-send-email-miso@dhcp22.suse.cz>
 <1431527892-2996-3-git-send-email-miso@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a+b56+3nqLzpiR9O"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431527892-2996-3-git-send-email-miso-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <miso-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--a+b56+3nqLzpiR9O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 13 May 2015, Michal Hocko wrote:

> From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>=20
> David Rientjes has noticed that MAP_POPULATE wording might promise much
> more than the kernel actually provides and intend to provide. The
> primary usage of the flag is to pre-fault the range. There is no
> guarantee that no major faults will happen later on. The pages might
> have been reclaimed by the time the process tries to access them.
>=20
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Reviewed-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>

--a+b56+3nqLzpiR9O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVU2PzAAoJELbVsDOpoOa9MfUQAJTJ/HrT0MkSGYeicZsd/fPv
Rr/bJn9eQ+kYCXs5UqSpseRznLOt297Yt0aA45cbk2CGXe/s1FMxlr+OqZJaq5b+
kJXcJ0vorN/29AFSyqHUHs+3Dfkmcop6k1PomDItwVx8p9tVi7dSdE8laYufx1fJ
smsw/jm+vecBLuriss1RmtnYkGwOdbwB9HDzte30x6DAOKRC6y/gZeBlLTJ+cdUB
FyH8kLtOkm8O9x1bR6TbBswo1tVn1LmCQHyNxZH9i41FuZVciTkpu6SrGpfn4j0Z
jtQoNXVukruRQjZyIrBdiuxZWV/HFSTS3G0DUORpm/uupLG4VcBf904VH7jEgAkU
3h/ky8TMvXN3IOxy9GENsJ6GKhIjXSJuYQp6iUQfcHLTKNnkOfSJJnpy75wvmJCu
kIGHunZXd6ocCA2vBPqiOHx46scOy9E58Vurdtz5SnwVVV6crznvIQ7jzewpVkFs
0EIU0xf0FOb9iGYmvRetb2Ut6rwS4/i/VkGbHbl7nLaGBcJtX1zP/f26X2NrnCAy
iauzQ/ullPiji0JufVB+G2v+RBR7fRpnYB/CUF5p+ubzKHpSjjC4jWhjOW8jQc+W
coZUJiXBQE6LfeqOSh+MPIVFoyBmEN8HnQ9vQxpvlopfJ1D+jVjOBnFIvzdwre7R
jVUo3LatpKU4Z796F6xS
=yYNO
-----END PGP SIGNATURE-----

--a+b56+3nqLzpiR9O--
