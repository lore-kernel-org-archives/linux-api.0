From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: Introspecting userns relationships to other namespaces?
Date: Fri, 8 Jul 2016 00:18:53 -0700
Message-ID: <20160708071853.GN4916@odin.tremily.us>
References: <CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
 <20160707133631.GA2994@mail.hallyn.com>
 <1467903712.2347.16.camel@HansenPartnership.com>
 <CAKgNAkg+OiBngdFsdVR0gsSnVhMppuH2DxMBLCNAx8in5C0-zQ@mail.gmail.com>
 <1467919055.2322.36.camel@HansenPartnership.com>
 <20160708021617.GB10512@outlook.office365.com>
 <20160708030055.GC10512@outlook.office365.com>
 <1467948407.2322.88.camel@HansenPartnership.com>
 <20160708052650.GM4916@odin.tremily.us>
 <20160708065453.GB14391@outlook.office365.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CSGWCrCVWDYEEUXI"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160708065453.GB14391-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org


--CSGWCrCVWDYEEUXI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07, 2016 at 11:54:54PM -0700, Andrew Vagin wrote:
> On Thu, Jul 07, 2016 at 10:26:50PM -0700, W. Trevor King wrote:
> > On Thu, Jul 07, 2016 at 08:26:47PM -0700, James Bottomley wrote:
> > > On Thu, 2016-07-07 at 20:00 -0700, Andrew Vagin wrote:
> > > > On Thu, Jul 07, 2016 at 07:16:18PM -0700, Andrew Vagin wrote:
> > > > > I think we can show all required information in fdinfo. We open
> > > > > a namespaces file (/proc/pid/ns/N) and then read
> > > > > /proc/pid/fdinfo/X for it.
> > > >=20
> > > > Here is a proof-of-concept patch.
> > > > =E2=80=A6
> > > > In [2]: fd =3D os.open("/proc/self/ns/pid", os.O_RDONLY)
> > > >=20
> > > > In [3]: print open("/proc/self/fdinfo/%d" % fd).read()
> > > > pos:	0
> > > > flags:	0100000
> > > > mnt_id:	2
> > > > userns: 4026531837
> > > >=20
> > > > In [4]: print "/proc/self/ns/user -> %s" %
> > > > os.readlink("/proc/self/ns/user")
> > > > /proc/self/ns/user -> user:[4026531837]
> > >=20
> > > can't you just do
> > >=20
> > > readlink /proc/self/ns/user | sed 's/.*\[\(.*\)\]/\1/'
> > =E2=80=A6
> > If you only put one level in fdinfo, you're stuck if one of the
> > namespaces involved has neither bind mounts nor a PID to give you
> > handle on it [1].  And if you want to put that whole ancestor tree in
> > fdinfo, you have to come up with some way to handle the two-parent
> > branching.
>=20
> I think it's a bad idea to draw a tree in fdinfo. Why do we want to know
> this hierarchy? Probably we will want to access these namespaces (setns),
> in this case we need to have a way to open them.
>=20
> Maybe we need to extend functionality of the nsfs filesystem
> (somethink like /proc/PID for namespaces)?

A similar idea came up during the PID-translation brainstorming [1],
but I'm not sure if anything ever came of that.  Once you're dealing
with a separate pseudo-filesystem, it seems easier to decouple it from
proc and just make a mountable namespace-hierarchy filesystem (like we
have mountable cgroup hierarchy filesystems).  That also gets you an
opt-in playground while the details of the nsfs filesystem view are
worked out.  Are you imagining something like:

  $ tree .
  .
  =E2=94=9C=E2=94=80=E2=94=80 mnt{inum}
  =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 user -> ../user{inum}
  =E2=94=9C=E2=94=80=E2=94=80 pid{inum}
  =E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 pid{inum}
  =E2=94=82=C2=A0=C2=A0 =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 u=
ser -> ../../user{inum}/user{inum}
  =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 user -> ../user{inum}
  =E2=94=94=E2=94=80=E2=94=80 user{inum}
      =E2=94=94=E2=94=80=E2=94=80 user{inum}

Cheers,
Trevor

[1]: http://thread.gmane.org/gmane.linux.kernel.containers/28105/focus=3D28=
164
     Subject: RE: [RFC]Pid conversion between pid namespace
     Date: Fri, 25 Jul 2014 10:01:45 +0000
     Message-ID: <5871495633F38949900D2BF2DC04883E56C7A2-ZEd+hNNJ6a5ZYpXjqAkB5h1MG4Scf5jO@public.gmane.org=
8.fujitsu.local>

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--CSGWCrCVWDYEEUXI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXf1PZAAoJEBBpoQVgXJg1M9QQAJU1E9CCFgOk+C1FrNclvRXf
8dCxoFjl4KNe92UxxoElnLTkmsg3x6tiWui9y+8GRUaD6SzjieOVDUzLuqCPbejI
W+7ePc6jC5flPqtpu3Hy3PeggcuIbgCO9Vq7/tzY1wZMO1wBup/NH4qAb69d18Dt
MAvObxsNe0AhqPw79ccXKywcoleaK9Q1G5AgmMiqOfXgbgQ8Qc4KgEsqr2YsDNfC
mMIhIKlAblydoAKpoyZNMLPnP2EMe5OnPCPobcnu/JRzSayY4pEUm+a016ENz8Np
UIyZ7iFMqYSp0sHZHgOZcOlItBJjkb7h3ZEJ7NdCfG+bBvuPeULDfmxM78aYsTIB
NI//bYgHzQNdsWmKnUnD59Mbf8c3wcYafLmBopGl2agzFFKTiFYLUPCeYbOTG/Ab
bhetzn9klvS6K4HNozEJ1gY9Lvj05BL1bofzlEnwVYh00KMdNsrwkzh2DUmL8H2x
rG2+Wk1o4Kegd9/yD9yea0Pmr2eAmIaGwQXNF/C8Sanq/ClbZTleMoAynS084+Wo
C3OIMuhD7neJ0LgPPggOyabFhUlBhvA9ElhfbXGSlCH5jfG2OpUQJIL5EW/Lm07r
wuYpbFDZhmaB5ghpz8CNDmpnf4j8kIcgsaDieG6DOH/79IY0U1PqyO4NJCfNhET+
mw/cODQCNVblLTPXK04q
=yY0b
-----END PGP SIGNATURE-----

--CSGWCrCVWDYEEUXI--
