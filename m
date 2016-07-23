From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
	between namespaces
Date: Sat, 23 Jul 2016 14:38:56 -0700
Message-ID: <1469309936.2332.35.camel@HansenPartnership.com>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
	<20160723211414.GA25371@odin.tremily.us>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7253629007204505012=="
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160723211414.GA25371-q4NCUed9G3sTnwFZoN752g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W.
	Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--===============7253629007204505012==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-kSwB3cCseu6dSnXvVDJD"


--=-kSwB3cCseu6dSnXvVDJD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2016-07-23 at 14:14 -0700, W. Trevor King wrote:
> On Thu, Jul 14, 2016 at 11:20:14AM -0700, Andrey Vagin wrote:
> > Pid and user namepaces are hierarchical. There is no way to=20
> > discover parent-child relationships too.
>=20
> It bothers me that network namespaces are not hierarchical too ;).

Well, there's a reason for that: mapping namespaces need to be be
hierarchical because the mapping may be remapped; The initial point for
creating a new namespace is the mapped endpoint of the old one.  Label
based namespaces don't really have any need to be.

> namespaces(7) and clone(2) both have:
>=20
>   When a network namespace is freed (i.e., when the last process in
>   the namespace terminates), its physical network devices are moved
>   back to the initial network namespace (not to the parent of the
>   process).
>=20
> So the initial network namespace (the head of net_namespace_list?) is
> special [1].  To understand how physical network devices will be
> handled, it seems like we want to treat network devices as a depth-1
> tree, with all non-initial net namespaces as children of the initial
> net namespace.  Can we extend this series' NS_GET_PARENT to return:
>=20
> * EPERM for an unprivileged caller (like this series currently does
>   for PID namespaces),
> * ENOENT when called on net_namespace_list, and
> * net_namespace_list when called on any other net namespace.

What's the practical application of this?  independent net namespaces
are managed by the ip netns command.  It pins them by a bind mount in a
flat fashion; if we make them hierarchical the tool would probably need
updating to reflect this, so we're going to need a reason to give the
network people.  Just having the interfaces not go back to root when
you do an ip netns delete doesn't seem very compelling.

James


--=-kSwB3cCseu6dSnXvVDJD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXk+PwAAoJEAVr7HOZEZN4o3cP/1XxGOqjI04Txn9qRd5D6pok
ikA46TsvbvM1NcprgpknqmgqjSSgh7wddusm7QGucCZIm5AXr150Udf63T86CNrG
QIwquCuolqJggSW0PPSF60hq2fv57IVxcR4kMzvu/X+/c9xbZ6yTlxf1gbW4hWc/
5FgXblQidVUhVUmy6diWNfUeAh5eOYSirY1IoUCp3ZmDVhQSkRfX6YTRRXaL5Kt4
Z6giWQ2Ng6yoilundZQNBIZONHNYyhTVhGsUcdyd7cb62Sgfo8dDbU1AukAipjGQ
hGk5s0FpnFD/LaHgAgwvL6AkPMW5ndpLvfa3svdxHO7IKhDa0Eb1WcZM2MtJGNDf
eoGWSPVMhC8Lg4myN9LuBzmxQEWeYnTzLVZujr/GYW1NKRPUqdcbzSrRICqrfc53
nO1hdgdN/ZgoDyIf4mPLL4n7Ouy9YNfHZo9cqKmdRUiLhlBYADFkMJXpZbjsKMGO
XoifD0Cygp9SYN2clxI0uneNYoBfYiasAprfb/FmRf2Kj025dENzsVFzWFwpIQOd
b+2Z0h/1DAPvREbS6M3wwa/uUrdy2TDZgkr9CtJkkGDXzRz5Ej+QtscdlYk+/okm
us2vXe++OcBaSAo3hzWKDJ/qfXu9eV4/rlFcnwpPu7JG/JOATGuo2/5hfJtkFTVE
yjEiRkQP+PK3E69nJ40n
=xCXj
-----END PGP SIGNATURE-----

--=-kSwB3cCseu6dSnXvVDJD--


--===============7253629007204505012==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--===============7253629007204505012==--
