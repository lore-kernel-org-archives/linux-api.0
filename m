From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v2 1/3] namei: implement O_BENEATH-style AT_* flags
Date: Wed, 10 Oct 2018 18:28:43 +1100
Message-ID: <20181010072843.xnmqf7mktf25o4w7@ryuk>
References: <20181009065300.11053-1-cyphar@cyphar.com>
 <20181009065300.11053-3-cyphar@cyphar.com>
 <CALCETrUZAYw-g+75WAijS+fmRA_DrTahpv156WrxgYuX3KX2xw@mail.gmail.com>
 <20181010070747.byi2itbi4j42gynq@ryuk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jufqatfmvbsiyd6n"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181010070747.byi2itbi4j42gynq@ryuk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--jufqatfmvbsiyd6n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-10-10, Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2018-10-09, Andy Lutomirski <luto@kernel.org> wrote:
> > On Mon, Oct 8, 2018 at 11:53 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > > * AT_NO_PROCLINK: Disallows ->get_link "symlink" jumping. This is a v=
ery
> > >   specific restriction, and it exists because /proc/$pid/fd/...
> > >   "symlinks" allow for access outside nd->root and pose risk to
> > >   container runtimes that don't want to be tricked into accessing a h=
ost
> > >   path (but do want to allow no-funny-business symlink resolution).
> >=20
> > Can you elaborate on the use case?
> >=20
> [...]
>   I think that AT_BENEATH allowing only proclinks that result in you
>   being under the root is something we might want in the future, but I
>   think there are some cases where you want to be _very_ sure you don't
>   follow a proclink (now or in the future).
> [...]

Sorry, just to clarify this point a bit more.

At the moment, "proclinks" are entirely disabled with AT_BENEATH. This
is a (hopefully) temporary measure until it's decided _how_ they should
be allowed. Personally I think we should allow them if they follow the
same requirement as ".." escapes (that __d_path can resolve them).

But then the question arises -- what if we're looking at a never-mounted
pseudo-filesystem dentry (see the ->d_dname code in d_path)? If we don't
allow it then we'd probably disallow quite a few cases where you'd want
to allow access (nsfs proclinks come immediately to mind).

*But* if we allow it then there's no real way to tell if the container
process has tricked us into opening something we shouldn't (like an open
file descriptor to a memfd or pipe related to some host service). Maybe
we should still allow them in that case because the likelihood of such a
case is very small (and allowing them would let you open nsfs links with
AT_BENEATH), but I'm not sure.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--jufqatfmvbsiyd6n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlu9qioACgkQnhiqJn3b
jbSyDg/+LMMmGHTZOMgeGJsknecuEDVenV+aT22LckbtNEtwJea3hgbPHxoM46B0
FIoFw6I17Yx9+nqGKwp4BmyVfB2DPm4NE+UXvHufY2IoSioF7QY28+JOOL1VM+tB
1iGCh1QtOfML0Zech1eGlfjPf1GBTAEnVe8LJEL2EiKJYR4V2Jh3P4xuJyHg3I5N
eAa+tvc2pXaGVud52rTOW6p2jo5ugu75YdqvjJsP1wnvOBZTKT+EWeLfbUYhrWV+
U8wNbJvkCJ+C192p8lpb1XsTskzvAdo+OnUt9+wR6bi8MrGQtgAOwP5ENDmYjWdW
5+QwtSyBHofvvYOvOp6vMkIeaHB/SSVU+vzK5WgEnGKMFDz2jPNExSS1vGWzRWcg
KBVigjCftiR0TSBljohBURLav8IQpj6TVHcLRbhijYZ5ff93lvFtedzZ4rgpSo2T
NjnT2Ndx9cdAkeQdNN0nKxWt/4Q0qYOyTCf7LgNWtUlMcA8tSe1PefkhJekbnMqx
uzIO5xeQcu5aQ9fGtsSaDH1vjAdIUx932WhZXP65v8KE6hMSf4SxdMhwnCROyxTy
iJGMNZZGH83IxoUAWea3SIUTh7KaoPLiVGa7Z3htKIOcHEXL8XqQU0ux853ORzkw
URqPzwdLExqFsnKylYN5edCiiB954VfYomiy2KTKp74BFdcc6ts=
=SxBd
-----END PGP SIGNATURE-----

--jufqatfmvbsiyd6n--
