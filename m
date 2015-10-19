From: Yves-Alexis Perez <corsac-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Mon, 19 Oct 2015 14:36:20 +0200
Message-ID: <1445258180.4099.18.camel@debian.org>
References: <5622700C.9090107@miglix.eu>
	 <20151017215501.GA22900@mail.hallyn.com> <5623FD82.4030902@miglix.eu>
	 <20151019014112.GA1683@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-gOR4fNwQbzesgmfVswB5"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151019014112.GA1683-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--=-gOR4fNwQbzesgmfVswB5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On dim., 2015-10-18 at 20:41 -0500, Serge E. Hallyn wrote:
> We shouldn't need a long-term solution.=C2=A0 Your concern is bugs.=C2=A0=
 After
> some time surely we'll feel that we have achieved a stable solution?

But this is actually the whole point: we need a long term solution, because
they will always be bug, whether in user namespaces or in others parts expo=
sed
by user namespaces. It's fine to fix them when we find them, but that still
means they're exploitable even before we know about them. We still find bug=
s
in code written years ago, it's quite certain there are bugs in current cod=
e.

User namespaces are a way to expose more interfaces to unprivileged users,
interfaces which weren't designed to be exposed like that. In a way that's =
the
opposite of seccomp. That doesn't make it bad, obviously, but that still me=
ans
having a way to control it finely could be helpful.

Regards,
--=20

Yves-Alexis

--=-gOR4fNwQbzesgmfVswB5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWJOPEAAoJEG3bU/KmdcClp28IAJziqz7PCmIj1SFP2JqYe+vS
twNOuCbLHY1/TglrscbGbgroanDpJ7Mi6LEZIVWrrtqw5DnV7YF+nqa4EP+r8s0t
knTo6RXxQ/jj7pF+2vtNtjNdZhE5cu8PMsVGe236N/tTKzOQu+bBD9T7avKowW3f
WCBQsA1iIsFIvwmUoOMkBDXrSGqJICfDrInp4xx5rBtSqxKRSt0M78xfrOEV36Ug
isudYr4s1zndOUSzaAiI7O4bY8mG9tVAcBm+uZSwVkLSzTasfHQAaSvdoaK7in/A
bV91+6TPsie9cfbcPdp+pqYlj5Ybqp++1tiL/OMVGMLAPik5oL8sC8cBCeMqQCI=
=wNaw
-----END PGP SIGNATURE-----

--=-gOR4fNwQbzesgmfVswB5--
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
