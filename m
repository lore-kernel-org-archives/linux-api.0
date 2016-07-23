From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
 between namespaces
Date: Sat, 23 Jul 2016 14:58:02 -0700
Message-ID: <20160723215802.GO24913@odin.tremily.us>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
 <20160723211414.GA25371@odin.tremily.us>
 <1469309936.2332.35.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U8dGPtp+DHsXOYeW"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469309936.2332.35.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--U8dGPtp+DHsXOYeW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 23, 2016 at 02:38:56PM -0700, James Bottomley wrote:
> On Sat, 2016-07-23 at 14:14 -0700, W. Trevor King wrote:
> > namespaces(7) and clone(2) both have:
> >=20
> >   When a network namespace is freed (i.e., when the last process
> >   in the namespace terminates), its physical network devices are
> >   moved back to the initial network namespace (not to the parent
> >   of the process).
> >=20
> > So the initial network namespace (the head of net_namespace_list?)
> > is special [1].  To understand how physical network devices will
> > be handled, it seems like we want to treat network devices as a
> > depth-1 tree, with all non-initial net namespaces as children of
> > the initial net namespace.  Can we extend this series'
> > NS_GET_PARENT to return:
> >=20
> > * EPERM for an unprivileged caller (like this series currently does
> >   for PID namespaces),
> > * ENOENT when called on net_namespace_list, and
> > * net_namespace_list when called on any other net namespace.
>=20
> What's the practical application of this?  independent net
> namespaces are managed by the ip netns command.  It pins them by a
> bind mount in a flat fashion; if we make them hierarchical the tool
> would probably need updating to reflect this, so we're going to need
> a reason to give the network people.  Just having the interfaces not
> go back to root when you do an ip netns delete doesn't seem very
> compelling.

I'm not suggesting we add support for deeper nesting, I'm suggesting
we use NS_GET_PARENT to allow sufficiently privileged users to
determine if a given net namespace is the initial net namespace.  You
could do this already with something like:

1. Create a new net namespace.
2. Add a physical network device to that namespace.
3. Delete that namespace.
4. See if the physical network device shows up in your
   initial-net-namespace candidate.
5. Delete the physical network device (hopefully it ended up somewhere
   you can find it ;).

But using an NS_GET_PARENT call seems much safer and easier.

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--U8dGPtp+DHsXOYeW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXk+hoAAoJEBBpoQVgXJg1grAP/izpsEtkfca7T007ee59EPOv
QSYj4kT/TCA+c+swwLa35ymkHeRZugbdAuwxGH2eOaAtkUbUdlM1S0WryaMop6Hu
aDSk3urFbbZ9eImHytaSjNjoiw40FzZp7CMfy4sT0qlfXFcV8riox4/aTkbdiXWp
jComoA6tuSHBcrmJTM7Wz7GUtO0TwQjo8JFs+ZnOXScdsSGRBNjAD1cO9G8ajd+M
VynsTIfDLxg1QjylyrBXNWro8fMPzuFcqpO8B7cbfTmjR9sEls351VaatPexbNCQ
kIlVbWoK+Lp92ShfCOekDjQrC96G3sbmYSh5bmdtqxGmL2hJ81NeMtQ6dKgq3gUc
WoWNvgPXi6v9ICYtLkw5zBCIxqKt5zIhDUR1Yv8WRHmMIX4Opdkx9EJS5yKyvw92
aEbMdCJp++34/GbulyQY1PO8c+fU5WCiGsVUNoPjTyjg5LM7kBQ0LkC3l9FGTtAU
DP5olagjT9VX94GSo2yfp4tFT6UmzuSZjk1Slo8NYDjfQjMVE+u3JzKosv3NW1W8
OA8uUjnaXbhp3VnLO7BokTqj50D/gfdcBDHhEZXAWTNtaOoFpvaYPBdaI/Fzc+Uh
ZZhYAsllmdyRLts6sGPPJGVJE80BoR+pf5WmNpC0VzEYkGfgwAOkPsG3uzqCMct+
HAjGrSBqXjQXD0eorI5f
=sBNL
-----END PGP SIGNATURE-----

--U8dGPtp+DHsXOYeW--
