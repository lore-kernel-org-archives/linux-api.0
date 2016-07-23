From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
	between namespaces
Date: Sat, 23 Jul 2016 15:34:48 -0700
Message-ID: <20160723223448.GP24913@odin.tremily.us>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
	<20160723211414.GA25371@odin.tremily.us>
	<1469309936.2332.35.camel@HansenPartnership.com>
	<20160723215802.GO24913@odin.tremily.us>
	<87mvl8nhlv.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2586409739552667305=="
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87mvl8nhlv.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--===============2586409739552667305==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7W3oHc+rRRQmdpwZ"
Content-Disposition: inline


--7W3oHc+rRRQmdpwZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 23, 2016 at 04:56:44PM -0500, Eric W. Biederman wrote:
> "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org> writes:
> > On Sat, Jul 23, 2016 at 02:38:56PM -0700, James Bottomley wrote:
> >> On Sat, 2016-07-23 at 14:14 -0700, W. Trevor King wrote:
> >> > namespaces(7) and clone(2) both have:
> >> >=20
> >> >   When a network namespace is freed (i.e., when the last
> >> >   process in the namespace terminates), its physical network
> >> >   devices are moved back to the initial network namespace (not
> >> >   to the parent of the process).
> >> >=20
> >> > So the initial network namespace (the head of
> >> > net_namespace_list?)  is special [1].  To understand how
> >> > physical network devices will be handled, it seems like we want
> >> > to treat network devices as a depth-1 tree, with all
> >> > non-initial net namespaces as children of the initial net
> >> > namespace.  Can we extend this series' NS_GET_PARENT to return:
> >> >=20
> >> > * EPERM for an unprivileged caller (like this series currently
> >> >   does for PID namespaces),
> >> > * ENOENT when called on net_namespace_list, and
> >> > * net_namespace_list when called on any other net namespace.
> >>=20
> >> What's the practical application of this?  independent net
> >> namespaces are managed by the ip netns command.  It pins them by
> >> a bind mount in a flat fashion; if we make them hierarchical the
> >> tool would probably need updating to reflect this, so we're going
> >> to need a reason to give the network people.  Just having the
> >> interfaces not go back to root when you do an ip netns delete
> >> doesn't seem very compelling.
> >
> > I'm not suggesting we add support for deeper nesting, I'm suggesting
> > we use NS_GET_PARENT to allow sufficiently privileged users to
> > determine if a given net namespace is the initial net namespace.  You
> > could do this already with something like:
> >
> > 1. Create a new net namespace.
> > 2. Add a physical network device to that namespace.
> > 3. Delete that namespace.
> > 4. See if the physical network device shows up in your
> >    initial-net-namespace candidate.
> > 5. Delete the physical network device (hopefully it ended up
> >    somewhere you can find it ;).
> >
> > But using an NS_GET_PARENT call seems much safer and easier.
>=20
> Have you had the problem in practice where you can't tell which
> network namespace is the initial network namespace.  This all seems
> like a theoretical problem rather than a real one.

I haven't had any practical problems here, I'm just trying to wrap my
head around namespace-relationship discovery.  The special physical
network device handling seems a lot like init re-parenting (with no
PR_SET_CHILD_SUBREAPER analog in a 1-deep namespace tree), so calling
the initial network namespace a parent (and all the other namespaces
its direct children) seems natural enough.  If that doesn't sound
convincing, I'm happy to punt this idea until someone runs into a
practical problem ;).

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--7W3oHc+rRRQmdpwZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXk/EFAAoJEBBpoQVgXJg1ZKoP/1xsnpjb4J/35qXhDhm8bPrX
mOsuqEi+PIOSigmWmFnUziF0D/XUzSJTio/Ewe4w18XMVa5actpRvXjX/klrkBx9
tdnDS6rEBe2rgGNIdIn2b7u8IZnfJD+kYYKMLCKsKZIILuwgbebN8Jp+r3QpbWTp
7cpe8uHbojqmXGZn9bCXB3GGbVJjIt/bfqqmkrjN+nek/0cRyjsIKD0YxKdy9UEs
/QKzjdZdLOxkyYSN3X60MTF2oLe9cnnd6B8jKxAuklGgfy7J6ugx9TQRb1QqC2Jx
feEfxVZoYqZHY4hNxNS8WvTzaYCUMX+B52ZXSu7XUd2+Rd9u9c/YNzHlCcSTnQTR
s29oTXIilqzs0s4jbonVaPnv5wo3zBg+CulRFzoQdbnb/tA28tO1GjI3NWyfXUmF
vzK3Fd+csqfiXre9JX/5u/opOzH5kDfv3bJb3FgWWWsfuBT4JrNqPdbnqZ5tlT3C
u4obfQSJLrlJVh++zIGTeT0DIvcQGMTtzbXfMukBmJ2Hsiy7aDWxB9tG7mqANfPn
v43oOwhOnz+fRODM04mF2PgAez6Gt4SfUnx2JjUMWXOxTbj/UVoW9Xt94UWKMknR
+fofmYWuiPCbn3sEzWvrPbLkg7AJV8qL/GJQCJNm2bbxY+jwC3ZPQcZyt+K2su8o
fLF6gi7jKTm8ZYf6VoXe
=E33G
-----END PGP SIGNATURE-----

--7W3oHc+rRRQmdpwZ--

--===============2586409739552667305==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--===============2586409739552667305==--
