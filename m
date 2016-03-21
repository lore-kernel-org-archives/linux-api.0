From: Michael Adam <obnox-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Date: Mon, 21 Mar 2016 19:20:57 +0100
Message-ID: <20160321182057.GF1044@samba.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
 <20160311140134.GA14808@infradead.org>
 <CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
 <20160315071103.GC19747@infradead.org>
 <20160315154514.GB39038@jra3>
 <20160315201700.GA22945@sernet.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NklN7DEeGtkPCoo3"
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160315201700.GA22945-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2016-03-15 at 21:17 +0100, Volker Lendecke wrote:
> On Tue, Mar 15, 2016 at 08:45:14AM -0700, Jeremy Allison wrote:
> > On Tue, Mar 15, 2016 at 12:11:03AM -0700, Christoph Hellwig wrote:
> > > People have long learned that we only have 'alloc' permissions.  Any
> > > model that mixes allow and deny ACE is a mistake.
> >=20
> > People can also learn and change though :-). One of the
> > biggest complaints people deploying Samba on Linux have is the
> > incompatible ACL models.
>=20
> Just to confirm: I see this a lot in the field. NFSv4 ACLs, while not a
> perfect match for NTFS ACLs are a lot closer much more usable to people
> who want to serve Windows clients.
>=20
> Also in the pure linux world there is a lot that you can not express
> with just rwx, sgid, sticky bits and friends. If you want the additional
> functionality of the richacl bits, I would call it a big mistake to
> omit negative aces, if just for the reason not to create yet another
> ACLs flavor.
>=20
> > Whilst I have sympathy with your intense dislike of the
> > Windows ACL model, this comes down to the core of "who
> > do we serve ?"
>=20
> The world has enough confusion around ACL semanics, please do not add
> more to it by creating your own model of the day.

Exacty: Like it or not, Windows ACLs are a fact. And the
approximation by the NFSv4 ACLs is getting closer and closer
with each iteration... ;-) So it is not only that Windows world
looking into this.

As Volker and Jeremy have pointed out, the lack of ACL semantics
is one of things the users of Samba complain about most bitterly.
While Samba can work around it when it is acting exclusively on
the files, this is not an option when NFS or other protocols are
to access the data concurrently. In that case we need more
precision down in the file system. So because they make use of
*existing* formats and semantics, I think Andreas' richacls are
just the way to go, as alien as they may seem from the pure linux
filesystem point of view at first.

Cheers - Michael

--NklN7DEeGtkPCoo3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: comment

iEYEARECAAYFAlbwO4kACgkQyU9JOBhPkDSbLgCgg014joqbBszyQNQOfv6cNSVX
GSIAoJHvKMybjmmMy0l/xqCBjTDuVjzS
=vumV
-----END PGP SIGNATURE-----

--NklN7DEeGtkPCoo3--
