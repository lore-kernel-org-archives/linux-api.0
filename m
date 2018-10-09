From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v3 3/3] namei: aggressively check for nd->root escape on
 ".." resolution
Date: Wed, 10 Oct 2018 02:37:28 +1100
Message-ID: <20181009153728.2altaqxclntvyc7b@mikami>
References: <20181009070230.12884-1-cyphar@cyphar.com>
 <20181009070230.12884-4-cyphar@cyphar.com>
 <CAG48ez3Ae5b20g2UquekfBNaUw1tLt4nWy2pYm-LNRMbDVpHfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mr4rhp3oxd4353fx"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez3Ae5b20g2UquekfBNaUw1tLt4nWy2pYm-LNRMbDVpHfA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--mr4rhp3oxd4353fx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-10-09, 'Jann Horn' via dev <jannh@google.com> wrote:
> On Tue, Oct 9, 2018 at 9:03 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > This patch allows for AT_BENEATH and AT_THIS_ROOT to safely permit ".."
> > resolution (in the case of AT_BENEATH the resolution will still fail if
> > ".." resolution would resolve a path outside of the root -- while
> > AT_THIS_ROOT will chroot(2)-style scope it). "proclink" jumps are still
> > disallowed entirely because now they could result in inconsistent
> > behaviour if resolution encounters a subsequent "..".
> >
> > The need for this patch is explained by observing there is a fairly
> > easy-to-exploit race condition with chroot(2) (and thus by extension
> > AT_THIS_ROOT and AT_BENEATH) where a rename(2) of a path can be used to
> > "skip over" nd->root and thus escape to the filesystem above nd->root.
> >
> >   thread1 [attacker]:
> >     for (;;)
> >       renameat2(AT_FDCWD, "/a/b/c", AT_FDCWD, "/a/d", RENAME_EXCHANGE);
> >   thread2 [victim]:
> >     for (;;)
> >       openat(dirb, "b/c/../../etc/shadow", O_THISROOT);
> >
> > With fairly significant regularity, thread2 will resolve to
> > "/etc/shadow" rather than "/a/b/etc/shadow". There is also a similar
> > (though somewhat more privileged) attack using MS_MOVE.
> >
> > With this patch, such cases will be detected *during* ".." resolution
> > (which is the weak point of chroot(2) -- since walking *into* a
> > subdirectory tautologically cannot result in you walking *outside*
> > nd->root -- except through a bind-mount or "proclink"). By detecting
> > this at ".." resolution (rather than checking only at the end of the
> > entire resolution) we can both correct escapes by jumping back to the
> > root (in the case of AT_THIS_ROOT), as well as avoid revealing to
> > attackers the structure of the filesystem outside of the root (through
> > timing attacks for instance).
> >
> > In order to avoid a quadratic lookup with each ".." entry, we only
> > activate the slow path if a write through &rename_lock or &mount_lock
> > have occurred during path resolution (&rename_lock and &mount_lock are
> > re-taken to further optimise the lookup). Since the primary attack being
> > protected against is MS_MOVE or rename(2), not doing additional checks
> > unless a mount or rename have occurred avoids making the common case
> > slow.
> >
> > The use of __d_path here might seem suspect, but on further inspection
> > of the most important race (a path was *inside* the root but is now
> > *outside*), there appears to be no attack potential. If __d_path occurs
> > before the rename, then the path will be resolved but since the path was
> > originally inside the root there is no escape. Subsequent ".." jumps are
> > guaranteed to check __d_path reachable (by construction, &rename_lock or
> > &mount_lock must have been taken after __d_path returned),
>=20
> "after"? Don't you mean "before"? Otherwise I don't understand what
> you're saying here.

I meant that the attacker doing the rename must've taken &rename_lock
or &mount_lock after __d_path returns in the target process (because the
race being examined is that the rename occurs *after* __d_path) and thus
are guaranteed to be detected).

Maybe there's a better way to phrase what I mean...

> > +static inline int nd_alloc_dpathbuf(struct nameidata *nd)
> > +{
> > +       if (unlikely(!nd->dpathbuf)) {
> > +               if (nd->flags & LOOKUP_RCU) {
> > +                       nd->dpathbuf =3D kmalloc(PATH_MAX, GFP_ATOMIC);
> > +                       if (unlikely(!nd->dpathbuf))
> > +                               return -ECHILD;
> > +               } else {
> > +                       nd->dpathbuf =3D kmalloc(PATH_MAX, GFP_KERNEL);
> > +                       if (unlikely(!nd->dpathbuf))
> > +                               return -ENOMEM;
> > +               }
> > +       }
> > +       return 0;
> > +}
>=20
> Note that a fixed-size path buffer means that if the path is very
> long, e.g. because you followed long symlinks on the way down, this
> can cause lookup failures.

This is already an issue with __d_path (even if the buffer was larger)
because it will not output a path longer than PATH_MAX. I imagine this
is a pretty strong argument for why we should refactor __d_path so that
we can *just* use the escape checking to avoid -ENAMETOOLONG.

I can work on this, but I'll wait until after LPC to see what the
discussion there brings up.

> > +                       error =3D nd_alloc_dpathbuf(nd);
> > +                       if (error)
> > +                               return error;
> > +                       pathptr =3D __d_path(&nd->path, &nd->root, nd->=
dpathbuf, PATH_MAX);
> > +                       if (unlikely(!pathptr))
> > +                               /* Breakout -- go back to root! */
> > +                               return nd_jump_root(nd);
>=20
> I find the semantics of this check odd - especially in the
> LOOKUP_BENEATH case, but also in the LOOKUP_CHROOT case. Wouldn't it
> make more sense to just throw an error here? Making /.. go back to the
> root is one thing, but making ".." from anything that has escaped from
> the root go back to the root seems less logical to me.

For AT_BENEATH, nd_jump_root() will always return -EXDEV -- but I'll
take your point for AT_THIS_ROOT below.

> Thread A (a webserver or whatever) looks up
> "example.org/images/foo/../bar.png" under "/var/www" with
> LOOKUP_BENEATH.
> Thread B concurrently moves "/var/www/example.org/images" to
> "/var/backup/example.org/images".
> Now thread A can accidentally resolve its path to "/var/www/bar.png"
> if the race happens the wrong way?

This is a good point. When I changed this from always being -EXDEV in my
other postings, I was thinking about "/.." rather than the case you've
outlined where ".." is in the path but it's not actually meant to go to
the root.

I agree -EXDEV makes much more sense here. I will add this to my tree
(but I'll wait until after LPC before I send out a new series).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--mr4rhp3oxd4353fx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlu8yzUACgkQnhiqJn3b
jbTOFg/6A4Zyz4xnpElf3G/74j+95DNPJAXdrePXZOfjSXVtunzBKX4gbtKTaQZ6
nEK220NmPVDiRtkGPprfcxcStE8icUhsLAdimRoUflFK9Kckk6I3gZjdhpMNdd6+
DzgGxWabet4AmSZPtXpbgd9Nf5Ryzxi5BTateq7HPiMMUxVYmE47Sf7FvthCIHqc
vkcM7Bx06vxQ/Yz82fdV3tFWkeK1XHW5/GLnB5ftZYFHultPemJ9IxCU8pBaRmEJ
VmsG8jOsPi1T5EUMt69lVY/HhmEXXIQRuHEDbq5CWZasQHYs7+YJ/+1zrQAMuNyl
5dGXCnkCEOGoJ3DOfc6uGTNTW8e/ShAdBtIyz4rpOyaR3YDE3PuwO/LUDNa8zdrA
3eFs3iKybl4x2ssTQYq06ZHd53GA5rZIMIVX0Ntz+W0AgSrNJ9sgKcywo5nfG8Ja
M/ZOmBokvg5h+RYK373oNK5Cf578ZZZfrJPPtfPMVZ7UsQ9mp9sp8nDiLJX/JLPi
ct0KCPK4jwPNaMiWhdZZUvYoDwT8i6jFuQCERg54WKSVMOQYkTSW3eP9ubBMSwSF
h9FXVQxZYAwp33DfUmZGQlTPqCrUzTjI3FJioLBhbDOY+qEPV+iod0gX0SylejaD
qUlBUx0G9RFnI7v9Ar0IJ2zYO7TOEaFj2awFSnRAc32MG1Wznfk=
=kcHG
-----END PGP SIGNATURE-----

--mr4rhp3oxd4353fx--
