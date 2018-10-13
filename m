From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v3 3/3] namei: aggressively check for nd->root escape on
 ".." resolution
Date: Sat, 13 Oct 2018 19:53:26 +1100
Message-ID: <20181013085326.gx6rvgqbbyuntfvv@ryuk>
References: <20181009070230.12884-1-cyphar@cyphar.com>
 <20181009070230.12884-4-cyphar@cyphar.com>
 <CAG48ez3Ae5b20g2UquekfBNaUw1tLt4nWy2pYm-LNRMbDVpHfA@mail.gmail.com>
 <20181009153728.2altaqxclntvyc7b@mikami>
 <20181013082210.GU32577@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jotekdbjlx6mxzav"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181013082210.GU32577@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Aleksa Sarai <asarai@suse.de>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--jotekdbjlx6mxzav
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-10-13, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > > > +static inline int nd_alloc_dpathbuf(struct nameidata *nd)
> > > > +{
> > > > +       if (unlikely(!nd->dpathbuf)) {
> > > > +               if (nd->flags & LOOKUP_RCU) {
> > > > +                       nd->dpathbuf =3D kmalloc(PATH_MAX, GFP_ATOM=
IC);
> > > > +                       if (unlikely(!nd->dpathbuf))
> > > > +                               return -ECHILD;
> > > > +               } else {
> > > > +                       nd->dpathbuf =3D kmalloc(PATH_MAX, GFP_KERN=
EL);
> > > > +                       if (unlikely(!nd->dpathbuf))
> > > > +                               return -ENOMEM;
> > > > +               }
> > > > +       }
> > > > +       return 0;
> > > > +}
> > >=20
> > > Note that a fixed-size path buffer means that if the path is very
> > > long, e.g. because you followed long symlinks on the way down, this
> > > can cause lookup failures.
> >=20
> > This is already an issue with __d_path (even if the buffer was larger)
> > because it will not output a path longer than PATH_MAX. I imagine this
> > is a pretty strong argument for why we should refactor __d_path so that
> > we can *just* use the escape checking to avoid -ENAMETOOLONG.
>=20
> Let me get it straight - the whole point of that buffer is to check
> if __d_path() returns NULL?  So you allocate it so that you would have
> place to copy the path components into... only to have them completely
> ignored?

Yes (and it was definitely the wrong thing to do).

Since writing that mail, I changed it to not have to allocate a buffer
-- though this is done in the fairly ugly way of changing prepend_path()
to be able to take @buffer=3D=3DNULL which then skips all of the
string-related code, and then having a dumb wrapper which calls
prepend_path(root, path, NULL, NULL).

I was planning on sending out the updated patches after LPC.

> How is that different from path_is_under()?

I didn't know about path_is_under() -- I just checked and it appears to
not take &rename_lock? From my understanding, in order to protect
against the rename attack you need to take &rename_lock (or check
against &rename_lock at least and retry if it changed).

I could definitely use path_is_under() if you prefer, though I think
that in this case we'd need to take &rename_lock (right?). Also is there
a speed issue with taking the write-side of a seqlock when we are just
reading -- is this more efficient than doing a retry like in __d_path?

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--jotekdbjlx6mxzav
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlvBsoUACgkQnhiqJn3b
jbTvuQ//W92VBlMABBuvmA8IDLzI+fF7zn7YpmIcdgIncK4WKCSlbFjGlvNdIQ7Z
LEqfOc0q/iA+SixjXTjKA+Apr5XsyvJXb5PquWrY6EU/1SZ13GvYBnjAOwFZk1C2
gzfthzmMqDVJv8jktnFtoPJ8cHh3m54kPbIhtYqOhPXa/RwJv1L5riAR63osVkVo
ISPrWBavi4Al0LfOMuyXmHePGYt2LSGZMH9AJ8YhMYB6uuhrnbar/3nwyV+34cIE
tAxBb4NZldB3Kb/WZwdPTtxPwtAku7Uqjuhfr+aCGekFAJkdDIvBuL8g7puoI1/X
8hoUIPwbWQEgVTsnEe72hruqu36IfxlnONEWq0R9IgMkBW52SxSpCZGMdvffki7g
exWXDD4NmAKPEugcyitthrq6tosoCCB/N6jBAuZUmif+LzgGzfi2iaNWdjDrGV2a
kHZTPCR9TAU0tpOz84jxF9i5pjBqGeTlxAnnQFCzPR1xUS3L0iDQJBcYvIRTaRS1
s7K4Qb6q9HLiUdZIjdVPQwXBqXjVivAjKHUgOyAElsTTW2hgzYKCywehPDqvOf3A
u/XXcUCt3LuPjaGP0IoFFsLPly8GYn9WusZcDbHrAuYSv2oSYPJBLVBPiQg6kwpQ
V4tRtn2lYMSqqLi5vU299jS6J464/h4QQgIyookUgctX8Mzc95w=
=3hfY
-----END PGP SIGNATURE-----

--jotekdbjlx6mxzav--
