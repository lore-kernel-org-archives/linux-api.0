From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v15 0/9] open: introduce openat2(2) syscall
Date: Wed, 13 Nov 2019 11:46:34 +1100
Message-ID: <20191113004634.tz7geloshltkafwj@yavin.dot.cyphar.com>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191111132404.y523iqicbn6fivx5@yavin.dot.cyphar.com>
 <201911121457.7D02692@keescook>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7ndczamgwxls6q65"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201911121457.7D02692@keescook>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-Id: linux-api@vger.kernel.org


--7ndczamgwxls6q65
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-12, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Nov 12, 2019 at 12:24:04AM +1100, Aleksa Sarai wrote:
> > On 2019-11-05, Aleksa Sarai <cyphar@cyphar.com> wrote:
> > > This patchset is being developed here:
> > >   <https://github.com/cyphar/linux/tree/openat2/master>
> > >=20
> > > Patch changelog:
> > >  v15:
> > >   * Fix code style for LOOKUP_IN_ROOT handling in path_init(). [Linus=
 Torvalds]
> > >   * Split out patches for each individual LOOKUP flag.
> > >   * Reword commit messages to give more background information about =
the
> > >     series, as well as mention the semantics of each flag in more det=
ail.
> > > [...]
> >=20
> > Ping -- this patch hasn't been touched for a week. Thanks.
>=20
> If I've been following correctly, everyone is happy with this series.
> (i.e. Linus's comment appear to have been addressed.)
>=20
> Perhaps the next question is should this go via a pull request by you to
> Linus directly during the v5.5 merge window, via akpm, via akpm, via
> Christian, or some other path? Besides Linus, it's not been clear who
> should "claim" this series. :)

Given the namei changes, I wanted to avoid stepping on Al's toes. Though
he did review the series a few versions ago, the discussion didn't focus
on the openat2(2) semantics (which have also changed since then). I'm
not sure whether to interpret the silence to mean he's satisfied with
things as they are, or if he hasn't had more time to look at the series.

As for which tree it should be routed to, I don't mind -- Christian is
the most straight-forward choice (but if Al wants to route it, that's
fine with me too).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--7ndczamgwxls6q65
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXctSZgAKCRCdlLljIbnQ
Ej+PAP0UBMczq8p/OLMeyIryF0EfQ+noWktKHkfgvrRf7bKN7AEAiW1OItA5gtV4
HiJnADyDHQw1h7livSSrD2X7HKS2BAA=
=yOzJ
-----END PGP SIGNATURE-----

--7ndczamgwxls6q65--
