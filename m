From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH RESEND v5 0/5] namei: vfs flags to restrict path
 resolution
Date: Fri, 26 Apr 2019 05:45:25 +1000
Message-ID: <20190425194525.5d66uzfqfxmorx2n@yavin>
References: <20190320143717.2523-1-cyphar@cyphar.com>
 <CALCETrV-Q4qZXGeavBPQbF6-VVz7hqvjRkbhFeYmbGiQgu5Omg@mail.gmail.com>
 <20190325130429.dbrgjxnvq3w5cpb3@yavin>
 <CAGXu5jKPrarixQkWWXOBCu6kRRpQd0aaJsPJbvsAyh0Wvc620A@mail.gmail.com>
 <20190424153806.64qkkmkudzodxnz2@yavin>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mgp24gaplbeperzh"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190424153806.64qkkmkudzodxnz2@yavin>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, David Drysdale <drysdale@google.com>, Tycho Andersen <tycho@tycho.ws>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-fo>
List-Id: linux-api@vger.kernel.org


--mgp24gaplbeperzh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-04-25, Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2019-04-23, Kees Cook <keescook@chromium.org> wrote:
> > This series provides solutions to so many different race and confusion
> > issues, I'd really like to see it land. What's the next step here? Is
> > this planned to go directly to Linus for v5.2, or is it going to live
> > in -mm for a while? I'd really like to see this moving forward.
>=20
> Given some of the security requirements of this interface, I think
> getting it to live in -mm wouldn't be a bad idea so folks can shake the
> bugs out before it's depended on by container runtimes.

Scratch my mention of -mm, it should be in Al's tree since it touches
quite a few of the namei seqlocks. My point was that it should live in
someone's tree for a little bit before it goes into a release.

I will put together a PoC of a resolveat(2) variation of this series and
re-send it out with both versions.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--mgp24gaplbeperzh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlzCDlUACgkQSnvnv3De
m5+dTBAAkJaalB1ZAlNLaIBqNJeW7q7mu/h9lSLPEiXvdvYaaX7vsxdRP+qw733+
70e5zLtSp63rWZ+C1qC+X29jPP6sqxoYIbSrufbpBGXFl0DqWh2bdibbyJ0OfMgl
uWQRnlzgKF9OsdXWHUOe6vyaL5OrBYM27mgCZ0DRzOrULUbTcYn2C3iYFI6sIwwq
9i58pEVwTosNB48fvvmP97ANjZrdpIfovNCELQJL//uQTGTRIYc31lRn5bxJw31R
kZAO9hv2khQZnBQmiB/AntAnYzAjOeaT1I2EgbO4eDXmb1VOzBlO7VzlkPDy34Wj
EiyVktScI1Fr/ckbyQ2f0HJVXwYIE6Qh7kodot8ZY3BcYQUpptW6BTffvU7qqra8
LUScCOdgyOf4A3iTJM3/HdnWkTCOnbbwMHQf97sQlJN3+SnBelrz++bQ8d4Pnlci
IXDQkTvaJPzmehd8iBEfqdoSb5H0ipxmIr1OZgdvBskQ1X3zRMhemSKfGU2umC7p
Dt5qTpiuwmMdqN/mzb6rd/OQCiww3vHaPWn0cY9ppPQyaqn5M7vVd38B0sJ2RfRm
n7ojrJ6Hrl3Tl30N0LXlS8EXTEF2gOFznn/beWig+SIoF1WRBX+YdD+N03h940C2
/D7ioE/0fOukT/9ZM4Aco28Y4b2GLI36jlmEFGSDRzzwuEtb4UU=
=niPy
-----END PGP SIGNATURE-----

--mgp24gaplbeperzh--
