From: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] fbcon: use the cursor blink interval provided by
 vt
Date: Tue, 19 May 2015 23:40:12 +0200
Message-ID: <20150519214011.GA27047@ulmo.nvidia.com>
References: <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
 <20150225094946.GA24627@amd>
 <alpine.LNX.2.11.1502252319330.276@localhost>
 <20150226220243.GC9935@amd>
 <alpine.LNX.2.11.1502271905580.4212@localhost>
 <alpine.LNX.2.11.1502271911380.4248@localhost>
 <20150325111949.GA24230@kroah.com>
 <alpine.DEB.2.11.1503261341260.2164@local>
 <alpine.DEB.2.11.1503261354550.2411@local>
 <CAMAWPa-6ZbE5cDkEZq0XpYa2pHcnf3qweSSVHAXhfhUAUCbKcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMAWPa-6ZbE5cDkEZq0XpYa2pHcnf3qweSSVHAXhfhUAUCbKcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Daniel Stone <daniel-rLtY4a/8tF1rovVCs/uTlw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2015 at 02:15:41PM -0700, Kevin Hilman wrote:
> On Thu, Mar 26, 2015 at 6:56 AM, Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org> wrote:
> > vt now provides a cursor blink interval via vc_data. Use this
> > interval instead of the currently hardcoded 200 msecs. Store it in
> > fbcon_ops to avoid locking the console in cursor_timer_handler().
> >
> > Signed-off-by: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
> > Acked-by: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
>=20
> This patch hit next-20150519 in the form of commit 27a4c827c34a
> (fbcon: use the cursor blink interval provided by vt) and has caused
> boot failure on a handful of ARM platforms when booting a MMC root
> filesystem.  This error was spotted by the kernelci.org bot on
> exynos5800-peach-pi[1] and Thierry and Daniel (Cc'd) have seen it on
> some tegra platforms too.
>=20
> Thierry spotted this commit as a potential cause, and both Daniel and
> I have reverted and boot tested on exynos5 and tegra respectively and
> the boot panics disappear.

FWIW, if I apply the below on top of next-20150519 things seem to be
back to normal as well:

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 05b1d1a71ef9..658c34bb9076 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1310,8 +1310,9 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
                return;
=20
        ops->cur_blink_jiffies =3D msecs_to_jiffies(vc->vc_cur_blink_ms);
-       fbcon_del_cursor_timer(info);
-       if (!(vc->vc_cursor_type & 0x10))
+       if (vc->vc_cursor_type & 0x10)
+               fbcon_del_cursor_timer(info);
+       else
                fbcon_add_cursor_timer(info);
=20
        ops->cursor_flash =3D (mode =3D=3D CM_ERASE) ? 0 : 1;

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVW627AAoJEN0jrNd/PrOhy9kQAIZjuDWhk8QSW5fEUMVIsXrZ
oXMaXclkr/3OYX4a1xEUlgjDjppGb+T01qws9HGefRNTvY3D2bODDbGA/sEew723
/JvOUCa89EV/bCFKHWcV+i0XGiYxd5JTVE74/9sWQLrp8QbGB99NEXFYtB9quNMw
u71c+f8wsRapYSNQcErQwfBsWBW3sRkUSl7HRf0MtfVmSHNnaeFOdDCqquiYL0SL
XE3dIZY1MK5j6wgl/Za9AskTipeKoNWN4UX6pGX1QVNUJCN+3Dt1kpoh4ud6tvn9
AlVvtovy76fdaPbVV0DhF+pdLtgVmZcCCU/lTQMjWdxL1ydLBM/OXLtuTdHgepHq
NOw+DhoU1ezi9MLAzzL2dvolEkMJL6O5RemzjgV6NUZPi2aB7wc7rHP5yWX2k/Yd
jkYM0xHAOm8ra8s7H3WEJLudBK1Klo1x9NHiyZRwMQemxzC/LgRIt5uG5HhhsUCE
bEafdIV08sMrixpfvF5vgVxXIhpWAUOJy7UIFw4sD1ExhyzNuFbOERrotP55uYBY
miZZgQjBhy1HkLT1FC30SRej4v8HqEGTE71cwh6rJsGyIdWKVDqlONtAjpxtFY+5
pBVV1h0roKk7JNYX0JnKmtXSxZZxRB1ru6EHpiY/o87WO8DcG2yEALdVs1/mOkNp
TCE/0wfX2dJBA83LTzaM
=NClv
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
