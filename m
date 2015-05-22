From: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] fbcon: use the cursor blink interval provided by
 vt
Date: Fri, 22 May 2015 16:44:09 +0200
Message-ID: <20150522144407.GC19922@ulmo.nvidia.com>
References: <alpine.DEB.2.11.1503261354550.2411@local>
 <20150522020031.GA3516@kroah.com>
 <20150522100002.GB16507@ulmo>
 <3661627.JqpS87pBks@wuerfel>
 <20150522114957.GF16507@ulmo>
 <20150522143205.GA6508@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150522143205.GA6508-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Daniel Stone <daniel-rLtY4a/8tF1rovVCs/uTlw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 22, 2015 at 07:32:05AM -0700, Greg Kroah-Hartman wrote:
> On Fri, May 22, 2015 at 01:49:58PM +0200, Thierry Reding wrote:
> > On Fri, May 22, 2015 at 12:33:42PM +0200, Arnd Bergmann wrote:
> > > On Friday 22 May 2015 12:00:03 Thierry Reding wrote:
> > > >=20
> > > > > Remember, if I have to hand-edit, or do something special with yo=
ur
> > > > > patch, I will not do it, you need to do it correctly to make
> > > > > maintainer's lives easier, not harder, given that maintainers are=
 the
> > > > > limited resouce, not developers.
> > > >=20
> > > > I understand. I'll make a mental note to never send you patches as
> > > > attachment again.
> > > >=20
> > >=20
> > > Better make that a general rule. My workflow is different from Greg's
> > > but also doesn't cope well with attachments. A lot of people in turn
> > > have problems quoting from an attachment when replying to the patch,
> > > which happens to work for me.
> >=20
> > Okay. Any hints on how to simplify sending out such patches with the
> > same list of recipients? I find it very annoying to have to manually
> > copy each recipient into the git send-email command-line, but I don't
> > know of a better way to do it. Replying to an email from the MUA will
> > at least do that automatically.
>=20
> Reply from the MUA and then just put the patch in the email body.  If
> you have a good MUA it should be trivial to do[1]
>=20
> thanks,
>=20
> greg k-h
>=20
> 1) mutt drops you to your editor, and then you can just read in the
>    patch file directly to that buffer.

Indeed, that should work. As I understand it, I wouldn't even have to
further edit the email (except strip the reply) because git am prefers
headers in the patch to headers in the message (it certainly does that
for From:, so I suspect it would do it for Date: and Subject: as well).
Or if that doesn't work, Arnd's suggestion to use a scissors line is a
good alternative as well.

Thanks guys for the suggestions,
Thierry

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVX0C3AAoJEN0jrNd/PrOhQ7oQAKArrF2b4QBsmIiS3d5sd+p2
YIL4IdzKGa1AiYzyrkFj4j2xZ6dpdrJkWz23kwrBLoneYcFG9WqMlh/cGHhwBBX9
zNUtfxKZNuvmJamkLq54UsNGdm7lXD+462dA4E8aLedaA36FgzPprWR+6WHsVKl4
brs6uMGGFMQAhgxP8YO1qHu6mrsXLe4l+6JRHY+nmRG8dah0WUQm0n6rGfHB3dSw
8UOq0mowjEDHuugSlsTkkAL9jqXLGXFIFAAtZA+Jbew51k07MYIGHV3jlhKlZRP2
bRg2hfxaZMuurN6kbuD8MlDHH3t1ayN6UADkJLt6uykI+WqKCI5VjQsjNdWt8df1
/CuFAk6/a1pv+Rxn7xhnh5oaen33Yt08dEEfvDN0tI5Nbq6fXWRQnVGH0NIjsfa+
bJPwWA4/hzYH4jQZmnsdH0Z6GnoiOdmfI8G0MwGOpYDAnsW3NiiLNXYFxlwWazz8
gayda7BtfhB2wrtdprI18cfltwW59BIPruW5PaY95tTBJbVEtzu4nVForN4nb/y3
5WIHqhwz/o9DC5UUCbQ1D/mA93HyOSMvUxislahzItG5V/bPL/qkjPSSqGadcDEq
7jHodQaQ7kHW0YYeFdbnd4QeGaXjU+EstIDSuWa1Qed8r+diNQUfN5XHsNf2nW6i
WJaSAw9MdGgJjMYLkUKW
=dqlF
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
