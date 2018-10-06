From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path
 resolution
Date: Sat, 6 Oct 2018 12:10:02 +1000
Message-ID: <20181006021002.6vzsdwd3klddbmji@ryuk>
References: <20180929103453.12025-1-cyphar@cyphar.com>
 <20180929131534.24472-1-cyphar@cyphar.com>
 <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
 <20181004162611.vdlujbdguvagalpt@ryuk>
 <CAG48ez2u--Wac7d9n3idC92Pd-M40QzYtR6FKR8PAYr=VQHUBQ@mail.gmail.com>
 <20181005150728.mgqnpkbukpeu3bsm@ryuk>
 <CAG48ez3FG0axt92F=+vDe1Q=kj-YngmCgFqDET7E2xCE1mOgeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y5cyimyl4h3ru7zm"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez3FG0axt92F=+vDe1Q=kj-YngmCgFqDET7E2xCE1mOgeg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, "cyphar@cyphar.com Linux API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--y5cyimyl4h3ru7zm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-10-05, Jann Horn <jannh@google.com> wrote:
> > What if we took rename_lock (call it nd->r_seq) at the start of the
> > resolution, and then only tried the __d_path-style check
> >
> >   if (read_seqretry(&rename_lock, nd->r_seq) ||
> >       read_seqretry(&mount_lock, nd->m_seq))
> >           /* do the __d_path lookup. */
> >
> > That way you would only hit the slow path if there were concurrent
> > renames or mounts *and* you are doing a path resolution with
> > AT_THIS_ROOT or AT_BENEATH. I've attached a modified patch that does
> > this (and after some testing it also appears to work).
>=20
> Yeah, I think that might do the job.

*phew* I was all out of other ideas. :P

> > ---
> >  fs/namei.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 46 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 6f995e6de6b1..12c9be175cb4 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -493,7 +493,7 @@ struct nameidata {
> >         struct path     root;
> >         struct inode    *inode; /* path.dentry.d_inode */
> >         unsigned int    flags;
> > -       unsigned        seq, m_seq;
> > +       unsigned        seq, m_seq, r_seq;
> >         int             last_type;
> >         unsigned        depth;
> >         int             total_link_count;
> > @@ -1375,6 +1375,27 @@ static int follow_dotdot_rcu(struct nameidata *n=
d)
> >                                 return -EXDEV;
> >                         break;
> >                 }
> > +               if (unlikely((nd->flags & (LOOKUP_BENEATH | LOOKUP_CHRO=
OT)) &&
> > +                            (read_seqretry(&rename_lock, nd->r_seq) ||
> > +                             read_seqretry(&mount_lock, nd->m_seq)))) {
> > +                       char *pathbuf, *pathptr;
> > +
> > +                       nd->r_seq =3D read_seqbegin(&rename_lock);
> > +                       /* Cannot take m_seq here. */
> > +
> > +                       pathbuf =3D kmalloc(PATH_MAX, GFP_ATOMIC);
> > +                       if (!pathbuf)
> > +                               return -ECHILD;
> > +                       pathptr =3D __d_path(&nd->path, &nd->root, path=
buf, PATH_MAX);
> > +                       kfree(pathbuf);
>=20
> You're doing this check before actually looking up the parent, right?
> So as long as I don't trigger the "path_equal(&nd->path, &nd->root)"
> check that you do for O_BENEATH, escaping up by one level is possible,
> right? You should probably move this check so that it happens after
> following "..".

Yup, you're right. I'll do that.

> (Also: I assume that you're going to get rid of that memory allocation
> in a future version.)

Sure. Would you prefer adding some scratch space in nameidata, or that I
change __d_path so it accepts NULL as the buffer (and thus it doesn't
actually do any string operations)?

> >                 if (nd->path.dentry !=3D nd->path.mnt->mnt_root) {
> >                         int ret =3D path_parent_directory(&nd->path);
> >                         if (ret)
> > @@ -2269,6 +2311,9 @@ static const char *path_init(struct nameidata *nd=
, unsigned flags)
> >         nd->last_type =3D LAST_ROOT; /* if there are only slashes... */
> >         nd->flags =3D flags | LOOKUP_JUMPED | LOOKUP_PARENT;
> >         nd->depth =3D 0;
> > +       nd->m_seq =3D read_seqbegin(&mount_lock);
> > +       nd->r_seq =3D read_seqbegin(&rename_lock);
>=20
> This means that now, attempting to perform a lookup while something is
> holding the rename_lock will spin on the lock. I don't know whether
> that's a problem in practice though. Does anyone on this thread know
> whether this is problematic?

I could make it so that we only take &rename_lock
  if (nd->flags & (FOLLOW_BENEATH | FOLLOW_CHROOT)),
since it's not used outside of that path.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--y5cyimyl4h3ru7zm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlu4GXcACgkQnhiqJn3b
jbSetw/9H1Y6MiSjGRuK0/R1aLFbEbq0BkUgy+kdt3R+qt0BJjUU9JrmzbbUWnjC
eQH8by6CDPNBIY5R8G/SlbcUiEoyRevo/saa14ZS5ny2vJjuxd9n82Ey9oHpZb0Y
hSD4+dx6S4iQADq0+HbsVO/5x+9jxVr2Nmk92GkTdGd1kTeob8NmNW8rbFqteGM8
6HJ9DxCaOC0Tlk0aY70OzavIk5rylvi4conyxoYWqE+gZIXUCRNzFBBqbxSAgUMq
NKFkDwEK+MuCgMoGstrKvCnaGijbuTGBGjY1lKmY506wsnPO1k2hnQPDS904jOoB
P4MjsobwBIU2Kx4lPIeDbL70E+f1AwXpmBQw2rFotf4mq79SoASM40wb/TP7HBhx
cn9gjPO1oykB9NkJ/yhFySN3rZszXHfhNRAY2BwQeBlA5Mo1fmJCAN0E8813GCt8
f5KLN6vYYxsnUjiY4R1yLHe4TsY+F93b0xqLkghdgpHg+78ytOvgpDR+13TShE3j
eIcwyeG0ZCJr84Xgloeny/tc13IhtW0nnH5HgTaNXqFHpavtaRAROBXttV7ADTL2
XSmRgIihrrN8ULpFTuwEvE7qBLwh3V9AyYhMY4XrVlanEygmdVJkn0R/CQ7lbwiV
EW56EqlbKmen/1fN7jYU9obldALUIX+b5Iq8AktXKyOOVBeekXk=
=EMae
-----END PGP SIGNATURE-----

--y5cyimyl4h3ru7zm--
