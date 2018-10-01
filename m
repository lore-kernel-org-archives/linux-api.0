From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH 2/3] namei: implement AT_THIS_ROOT chroot-like path
 resolution
Date: Mon, 1 Oct 2018 19:46:40 +1000
Message-ID: <20181001090809.6t7ydq7gk2bwbout@ryuk>
References: <20180929103453.12025-1-cyphar@cyphar.com>
 <20180929131534.24472-1-cyphar@cyphar.com>
 <CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com>
 <F0E08B90-F10B-4897-913D-CA18E99A987D@amacapital.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3rw33qkti4zr7rb4"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F0E08B90-F10B-4897-913D-CA18E99A987D@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, jlayton@kernel.org, Bruce Fields <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, shuah@kernel.org, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, christian@brauner.io, Tycho Andersen <tycho@tycho.ws>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-kselftest@vger.kernel.org, dev@opencontainers.org, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--3rw33qkti4zr7rb4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-09-29, Andy Lutomirski <luto@amacapital.net> wrote:
> >> On Sat, Sep 29, 2018 at 4:29 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> >> The primary motivation for the need for this flag is container runtimes
> >> which have to interact with malicious root filesystems in the host
> >> namespaces. One of the first requirements for a container runtime to be
> >> secure against a malicious rootfs is that they correctly scope symlinks
> >> (that is, they should be scoped as though they are chroot(2)ed into the
> >> container's rootfs) and ".."-style paths. The already-existing AT_XDEV
> >> and AT_NO_PROCLINKS help defend against other potential attacks in a
> >> malicious rootfs scenario.
> >=20
> > So, I really like the concept for patch 1 of this series (but haven't
> > read the code yet); but I dislike this patch because of its footgun
> > potential.
> >=20
>=20
> The code could do it differently: do the path walk and then, before
> accepting the result, walk back up and make sure the result is under
> the starting point.
>=20
> This is *not* a full solution, though, since a walk above the root gas
> side effects on timing, various caches, and possibly network traffic,
> so it=E2=80=99s open to Spectre-like attacks in which a malicious contain=
er
> could use a runtime-initiated AT_THIS_ROOT to infer the existence of
> directories outside the container.

I think that one way to solve this problem might be to have more strict
checks on nd->root in follow_dotdot(). The problem here (as far as I can
tell) is that ".." could end up skipping past the root because of a
rename, however walking *down* into a path shouldn't be a problem (even
absolute symlinks shouldn't be a problem because they will nd_jump_root
and will land back in the root).

However, I'm not entirely sure what happens to nd->root if it gets
renamed -- can you still safely do checks against it (we'd need to do
some sort of is_descendant() check on the current path before we handle
".." in follow_dotdot).

That way, we wouldn't shouldn't have the spectre-like attack problem
(since the attack would be halted at the ".." stage -- before the path
walk can proceed into host paths). Would this be sufficient or is there
a more serious issue I'm missing?

> But what=E2=80=99s the container usecase?  Any sane container is based on
> pivot_root or similar, so the runtime can just do the walk in the
> container context. IOW I=E2=80=99m a bit confused as to the exact intende=
d use
> of the whole series. Can you elaborate?

I went into this in my response to Jann.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--3rw33qkti4zr7rb4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlux7QAACgkQnhiqJn3b
jbSivg/9FPpKpSI/3NIGc0Xsz57u4GP6sltPO39Uc26c9Mj829m60Mj1g5Ht+lnx
nUpjcHp/TGM6gbjDVXrH6k3NZur63m31FLOBMB7AIz3HlPK3Nk269md4ej4OFI94
ouW4mMtEmFaLjVQbrf/ozT5pepVqLprWCzsGj5mOCb7uZ/yqOSG6qBKNAYYJUzQ2
yBsHKTIYGkaQ0tPOzPzO+d3EyRSIh2GZTkcXPkzreEdtlpm44A545siHNQoFihOT
EcDExHHRcYNPusLJvErSTm82TamFHZetq6UdUmUGbt3PJaswZmVWVkwyOplu24ly
79MjLzFg6+afW/jvKKmKYjBlsL00Uf5HbsAaUZuiIJox3eLilCEGQUO87CK9o9q3
dSsfFpRm1uWQPn7P+6TXvEpiHKQVW8zIghLoL1uFr60R/RRXHRrKnWZSnhZNpe7P
q9BoosKfzOW6zXCOnuQksvqxC8+I1BueJasO88UJmYJb7nK+RrEYegZJ5+u0jY1L
qTyjltatxnBgfimoeIxOe6DcHOwSAyNZ14YImXuDGDFVaXTs/hoxraLDUV9Yzup9
/ym3ys+YZQWLGi5Zyfk8DS/RuZX4AfCLFVtm1fFBHHBIE2kpa9xNmFhDhQgd2VbV
mfqYV7yKyqKWCpFwLFEIsXCl7BY2cntpPe3VajLGKG/EXdPYlSE=
=Pymu
-----END PGP SIGNATURE-----

--3rw33qkti4zr7rb4--
