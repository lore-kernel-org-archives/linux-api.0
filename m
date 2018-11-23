From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v4 2/4] namei: O_BENEATH-style path resolution flags
Date: Sat, 24 Nov 2018 03:52:12 +1100
Message-ID: <20181123165212.xldikl55iwcy4hyq@mikami>
References: <20181112142654.341-1-cyphar@cyphar.com>
 <20181112142654.341-3-cyphar@cyphar.com>
 <1ce83cdf6e3168350b69f98f08aaa202bbaa682d.camel@bitron.ch>
 <CALCETrURCXjNMBR6DjujVc6HHHS=CbET81kHS+odur+Bm-z7Tg@mail.gmail.com>
 <20181123164819.skruu23wjwzf47f5@mikami>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="obp4tcxxutn7x4sr"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181123164819.skruu23wjwzf47f5@mikami>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: j@bitron.ch, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, David Drysdale <drysdale@google.com>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--obp4tcxxutn7x4sr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-11-24, Aleksa Sarai <asarai@suse.de> wrote:
> > >> On Tue, 2018-11-13 at 01:26 +1100, Aleksa Sarai wrote:
> > >> * O_BENEATH: Disallow "escapes" from the starting point of the
> > >>  filesystem tree during resolution (you must stay "beneath" the
> > >>  starting point at all times). Currently this is done by disallowing
> > >>  ".." and absolute paths (either in the given path or found during
> > >>  symlink resolution) entirely, as well as all "magic link" jumping.
> > >
> > > With open_tree(2) and OPEN_TREE_CLONE, will O_BENEATH still be
> > > necessary?
> >=20
> > This discussion reminds me of something I=E2=80=99m uncomfortable with =
in the
> > current patches: currently, most of the O_ flags determine some
> > property of the returned opened file.  The new O_ flags you're adding
> > don't -- instead, they affect the lookup of the file.  So O_BENEATH
> > doesn't return a descriptor that can only be used to loop up files
> > beneath it -- it just controls whether open(2) succeeds or fails.  It
> > might be nice for the naming of the flags to reflect this.
>=20
> I agree that there is something quite weird about having path resolution
> flags in an *open* syscall. The main reason why it's linked to open is
> because that's the only way to get O_PATH descriptors (which is what you
> would use for most of the extended operations we need -- as well as
> reading+writing to files which is what most users would do with this).
>=20
> And I think O_PATH is another example of an open flag that is just odd
> in how it changes the semantics of using open(2).
>=20
> One of the ideas I pitched in an earlier mail was a hypothetical
> resolveat(2) -- which would just be a new way of getting an O_PATH
> descriptor. This way, we wouldn't be using up more O_* flag bits with
> this feature and we'd be able to play with more radical semantic changes
> in the future. I can outline these here if you like, but it's a bit of a
> long discussion and I'd prefer not to derail things too much if
> resolveat(2) is definitely out of the question.

Sorry, one thing I forgot to mention about returning descriptors that
can only look up files beneath it -- while I think this would be very
useful, I'd be worried about jumping into chroot(2) territory where now
you are giving userspace the opportunity to try to create nested
"beneathfds" and so on. I do think it would be quite useful and
interesting though, but I'm not entirely sure how doable it would be
with the current namei infrastructure.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--obp4tcxxutn7x4sr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlv4MDwACgkQnhiqJn3b
jbSFOQ//WF57zWBKmv5f+pJ0wqIOd40G7NvVc33oOtGKuGI6+n1j6PGgtyfCThod
Ug6s3QlOab3tNyV7Eemuu2+v+8B/Z47RPqvvgOdO82XktAHLJoBiYNXH3+vYwQ0Z
RObH75dbfI/KPTJhdzLUlKktXMdC3sEfJF63xOWmINoYdc92UQgHgRuyDK2I33Fd
w2I7wCb0/y6hkCBamhLg/16OfBQvvPfjg7Arf2q9E3bOB7aDrvCcq2IZ360Otp6c
04HrCH2FU9eX74LgzpJ8C8QGksT6q8l0lHijBjLLirnXgVpCNGFb6qpitH3nakjK
6VBihD/PBYvGB+vVwL9ntgcrOg2WKBolZ8kj21bSMs6W2esKtqWafUaPUYTLzXW0
OpVGNeHugkOIfZGtZPFMoGNiN//JWQ8o7GS48S7XbSktHn7zmlgI8Rk2d+9d3kiE
ucSelf8ywABVB9Jia+ZNMdj7sls0TcxguI7NZYtx4vos3KLfua96JANnGxMc45b8
2HE79MUK6pM4wez3/n6Uj71RS/r9zM8/QmfLnXdAJiT7HTSwLvK79YuPIevneApn
O3JKW7iCFM4N/y6OMWnp37kUl/LMDB7ImAcVtvzXAsqqTYLo/259lm4f02HMGrQc
M3QFeLlT00fSJvzrBXGbQpxHlLYkwChGJP/uZVzc8DtmKNr3aT8=
=PiR+
-----END PGP SIGNATURE-----

--obp4tcxxutn7x4sr--
