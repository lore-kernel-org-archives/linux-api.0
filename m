From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: Introspecting userns relationships to other namespaces?
Date: Thu, 7 Jul 2016 22:26:50 -0700
Message-ID: <20160708052650.GM4916@odin.tremily.us>
References: <CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
 <20160706141348.GB20728@mail.hallyn.com>
 <CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
 <20160707133631.GA2994@mail.hallyn.com>
 <1467903712.2347.16.camel@HansenPartnership.com>
 <CAKgNAkg+OiBngdFsdVR0gsSnVhMppuH2DxMBLCNAx8in5C0-zQ@mail.gmail.com>
 <1467919055.2322.36.camel@HansenPartnership.com>
 <20160708021617.GB10512@outlook.office365.com>
 <20160708030055.GC10512@outlook.office365.com>
 <1467948407.2322.88.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qBCOWMU5EZvXye3z"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467948407.2322.88.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org


--qBCOWMU5EZvXye3z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07, 2016 at 08:26:47PM -0700, James Bottomley wrote:
> On Thu, 2016-07-07 at 20:00 -0700, Andrew Vagin wrote:
> > On Thu, Jul 07, 2016 at 07:16:18PM -0700, Andrew Vagin wrote:
> > > I think we can show all required information in fdinfo. We open
> > > a namespaces file (/proc/pid/ns/N) and then read
> > > /proc/pid/fdinfo/X for it.
> >=20
> > Here is a proof-of-concept patch.
> > =E2=80=A6
> > In [2]: fd =3D os.open("/proc/self/ns/pid", os.O_RDONLY)
> >=20
> > In [3]: print open("/proc/self/fdinfo/%d" % fd).read()
> > pos:	0
> > flags:	0100000
> > mnt_id:	2
> > userns: 4026531837
> >=20
> > In [4]: print "/proc/self/ns/user -> %s" %
> > os.readlink("/proc/self/ns/user")
> > /proc/self/ns/user -> user:[4026531837]
>=20
> can't you just do
>=20
> readlink /proc/self/ns/user | sed 's/.*\[\(.*\)\]/\1/'

With Andrew's fdinfo approach you know the user namespace owning
/proc/self/ns/pid is 4026531837.  That happens to be
/proc/self/ns/user in this case, but doesn't have to be in general.

> But what Michael was asking about was the parent user_ns of all the
> other namespaces ... I don't think there's any way we can get that
> out of any information in /proc/self/

If fdinfo only shows immediate parents, you'd need to walk the tree to
get back to the root.  And at each layer of the PID namespace tree
there will be another user-namespace parent branching off).  With a
tree like:

  Namespace         | Parent       | Owning userns
 -------------------+--------------+-------------------
  Root userns       | -            | -
  Root PID ns       | -            | Root userns
  Child userns      | Root usens   | Root userns
  Child PID ns      | Root PID ns  | Root userns
  Grandchild userns | Child userns | Child userns
  Grandchild PID ns | Child PID ns | Grandchild userns

Walking from the granchild PID namespace would give you:

  Grandchild PID ns
  |-- Child PID ns
  |   |-- Root PID ns
  |   `-- Root userns=20
  `-- Granchild userns
      `-- Child userns
          `-- Root userns

If you only put one level in fdinfo, you're stuck if one of the
namespaces involved has neither bind mounts nor a PID to give you
handle on it [1].  And if you want to put that whole ancestor tree in
fdinfo, you have to come up with some way to handle the two-parent
branching.

I'm also not sure how exposing nsfs information [2] would handle
namespaces that had neither a surviving bind mount nor a direct
process.

If all the information is available (possible after a mechanical patch
[3] makes it more accessible), then it seems easier to put it in a
separate /proc or /sys file.  There was a stab at this for PID
namespaces in [4] (the same series that landed NStgid, etc.) with
additional background and alternative approaches in [5].  There were
problems with that patch (and it was trying to do more by also listing
a process's ID in each PID namespace), but the =E2=80=9Clet's put the whole
tree in a new file=E2=80=9D approach seems sound to me.

Cheers,
Trevor

[1]: http://thread.gmane.org/gmane.linux.kernel.containers/30456/focus=3D20=
536
     Subject: Re: Introspecting userns relationships to other namespaces?
     Date: Thu, 7 Jul 2016 13:24:42 -0500
     Message-ID: <20160707182442.GA6402-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
[2]: http://thread.gmane.org/gmane.linux.kernel.containers/30456/focus=3D30=
499
     Subject: Re: [CRIU] Introspecting userns relationships to other namesp=
aces?
     Date: Thu, 07 Jul 2016 20:20:05 -0700
     Message-ID: <1467948005.2322.84.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
[3]: http://thread.gmane.org/gmane.linux.kernel.containers/30456/focus=3D20=
537
     Subject: Re: Introspecting userns relationships to other namespaces?
     Message-ID: <1467903712.2347.16.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
     Date: Thu, 07 Jul 2016 08:01:52 -0700
[4]: http://thread.gmane.org/gmane.linux.kernel.containers/28925/focus=3D28=
928
     Subject: [resend][PATCH v9 1/3] procfs: show hierarchy of pid namespace
     Date: Tue, 23 Dec 2014 18:20:37 +0800
     Message-ID: <1419330039-29207-2-git-send-email-chenhanxiao-BthXqXjhjHUYnX86y03XkA@public.gmane.org=
com>
[5]: http://thread.gmane.org/gmane.linux.kernel.containers/28105
     Subject: [RFC]Pid conversion between pid namespace
     Date: Thu, 3 Jul 2014 12:18:33 +0000
     Message-ID: <5871495633F38949900D2BF2DC04883E55C374-ZEd+hNNJ6a5ZYpXjqAkB5h1MG4Scf5jO@public.gmane.org=
8.fujitsu.local>

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--qBCOWMU5EZvXye3z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXfzmZAAoJEBBpoQVgXJg1qtEQAIf/b/Ry7Nlq2HQ8ByqsRTRL
GWbPPVTZRsWsxdb3dThwJS8YS1BBMkgKHOsvq6BGFRDsyJUOTuVhQowX7S+ABdct
7rdyIQ5YH9/+xYg7LglwmMX8UuqwMXpixKnqkrOVzCI9SZcBWAeohvUvO/XwXmHs
EBQubcNq0yx2u37tY9tc7GGHuhABf7pyx8suJrM/fLCyi5oKkA8uL9bCq2auBhWU
T7rJ4LCWoi45W7WgdqDwIrxqBvQHdK0el7+gr/7HVEUgzoxhE7OIhACGmNsjOCH8
w/1jbkGRoWNbquGPvxRuGpyBPE/3PTQzoiAJcg8WspuCeDY19jRj+xAcl5TzFo+O
XPiIyZ2eZHVBByaEJcT1xw55x6ZHvGl/acdW6H8wasoq9XBlgL5fIkAxs5ksAxyf
imgTquNm1yxolhUHKZXk5Xenoi4SVvGPH58qkQigGkwxs0VUPDgLoABs44GNxuzm
CiWZ8HiFneY3mSsb8gLG3gLLpzgzdIpaqEJRp8JyZAAWIhmQ9e6zfeKZ9K1U9YFW
TLGQ2qLJBUsgWnxr541neizDMjb4CIwzEAJAcyjA0cQuYvga9Ksv5pH2Ox6hpV19
svxxFMEFeJmAxBfTHnEC3ZTr1Wg5sEN4oAi0gXnLljucM+MSx9wQFYf+DLttDQA+
8mnGjDDnhpPif2IL/6H5
=srm/
-----END PGP SIGNATURE-----

--qBCOWMU5EZvXye3z--
