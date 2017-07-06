From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] afs: Add metadata xattrs
Date: Thu, 6 Jul 2017 12:27:21 -0600
Message-ID: <2863583A-79F1-4998-8AC4-1C4C9D4C060F@dilger.ca>
References: <20170706152304.GA10584@infradead.org>
 <149935261019.29744.8564287571048506851.stgit@warthog.procyon.org.uk>
 <149935262759.29744.6299062653432480230.stgit@warthog.procyon.org.uk>
 <31934.1499357651@warthog.procyon.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_CADB85E2-D85B-4755-85B0-3716B9D2A91E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <31934.1499357651@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_CADB85E2-D85B-4755-85B0-3716B9D2A91E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 6, 2017, at 10:14 AM, David Howells <dhowells@redhat.com> wrote:
>=20
> Christoph Hellwig <hch@infradead.org> wrote:
>=20
>> NAK.  Don't overload xattrs with magic behavior just to avoid the =
need
>> to do proper syscalls or ioctls.
>=20
> How?  This has to work on non-files, files you can't open and =
mountpoints.
> You can't do an ioctl() on a file opened O_PATH:
>=20
> 	if (unlikely(f->f_flags & O_PATH)) {
> 		f->f_mode =3D FMODE_PATH;
> 		f->f_op =3D &empty_fops;
> 		return 0;
> 	}
>=20
> and you can't specify AT_NO_AUTOMOUNT or AT_NO_FOLLOW to openat(), so =
ioctl()
> is of no use here.
>=20
> Do you advocate introducing a pioctl() call?  Linus was dead-set =
against that
> as I recall.
>=20
> I could invent a bunch of AFS-specific syscalls, but I'd rather not do =
that or
> I suppose bring my fsinfo() patches up to scratch - but you didn't =
like those
> either.
>=20
> Note that using xattrs for fs info is not without precedent in Linux - =
cifs,
> for example.

IMHO, xattrs are a fairly reasonable interface for accessing =
filesystem-specific
attributes of a file that do not have generic equivalents on other =
filesystems.
I can't see there being much value to having AFS-specific syscalls, and =
xattrs
also are more easily accessed by generic userspace tools than ioctl() =
calls.

There is also the general negative opinion among kernel developers to =
adding new
ioctls in the first place that means there are few options for how to =
get
non-standard information.

I could imagine that "fid" (file identifier that is larger than 64-bit =
inode) is
common enough that it could be added to statx(). I think at least =
"volume" (maybe
as "label") and "cell" (maybe =3D=3D "server" or "fsname"?) could be =
generic part of
fsinfo if there was some willingness to accept that interface upstream.

Cheers, Andreas






--Apple-Mail=_CADB85E2-D85B-4755-85B0-3716B9D2A91E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZXoEMpIg59Q01vtYRAlJzAKC1wqRaVf5s4De8tbyeSYuD5waXEACfVTjm
WvIlQ37zI62NH1Aek0LRjWE=
=ym1q
-----END PGP SIGNATURE-----

--Apple-Mail=_CADB85E2-D85B-4755-85B0-3716B9D2A91E--
