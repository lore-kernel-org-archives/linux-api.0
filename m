From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: Request to add linux-kselftest to linux-next
Date: Tue, 9 Sep 2014 09:14:57 +1000
Message-ID: <20140909091457.2eb4e643@canb.auug.org.au>
References: <540DC2BD.7030506@osg.samsung.com>
	<20140909085841.2ec2871e@canb.auug.org.au>
	<540E36BD.4060607@osg.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/cgDm0HrJTDmffZh6KUy9_I4"; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <540E36BD.4060607-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

--Sig_/cgDm0HrJTDmffZh6KUy9_I4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Shuah,

On Mon, 08 Sep 2014 17:07:41 -0600 Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wro=
te:
>
> On 09/08/2014 04:58 PM, Stephen Rothwell wrote:
> > Hi Shuah,
> >=20
> > On Mon, 08 Sep 2014 08:52:45 -0600 Shuah Khan=20
> > <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
> >>=20
> >> Could you please add linux-kselftest tree to linux-next. I plan=20
> >> to maintain two branches:
> >>=20
> >> linux-kselftest for Kselftest Framework
> >>=20
> >> fixes - Contains changes intended for merging before the next=20
> >> major release, including fixes for regressions introduced during
> >>  merge window. next  - Contains changes intended for merging=20
> >> during the next merge window between a major release and -rc1.
> >=20
> > Umm, a git URL would be helpful :-)
> >=20
>=20
> Sorry: here it is:
>=20
> https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git/

Not a git URL :-(

I assume hat you mean is
git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git .
I will use that.

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Sig_/cgDm0HrJTDmffZh6KUy9_I4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDjh3AAoJEMDTa8Ir7ZwVplsP/2N4Jxegp6ck6uUBSaSkZg9r
zGRjU3AybEaY3ZimtQxuS4wV+NX2J+xI7R49e/Pjk1PQ0heWGxdYkDfTxga2Ra9z
UUGvFJl33lAH17bLytC52oAeWKVjYR5yykt8DIEeAbktHibJZ8+KsUbWP7RntddU
D5R/wEFluP0tuAFs0Jub2hojaAurSeFSlhVUn06lfXS1VE9YZFSAe6eyO3ZHsqr4
/xneC5F3H2SYZLRbGjc++kKBsZB2jBrAYCJ68wl3Tn2nYRATSVuH2BaN1+yGrNZ9
g66i9yFWw0v7EYd6NVjfAxZ7Rm0SqqRUFQpbQgN0VL9/eRYIBF9CP/3uQhzd7PkJ
3N3eDtEIosITf55ssdwJotO3vTD+1FExs4N4Bk9q+o70ZZ04EvcII85JmUMs534+
eoYiFlAjiOCaVEvTs8rf6DGo0+JDxikGd7HlzukF79tzWllbjUjarJT1v26N2b8R
wMEN2Njmv5ea2J81XqETul+Hn0CG9OtdeWghFrsmOUYISrR1XaMnOWncIggBR+6V
PsCOapZhq+j8H0kFMimOfgjrP2dF4N0+sSuwdbkQpPfglB+5YYne5PqIfzllfMQo
L6W2yfteJHuOPiiHcJ2uPOLKzHtMz8QM/ROsCPtKRrmF5KdFDpUWfxMZla06veKU
Ji6XuRJDBVb4JLoQr9Kv
=/fOQ
-----END PGP SIGNATURE-----

--Sig_/cgDm0HrJTDmffZh6KUy9_I4--
