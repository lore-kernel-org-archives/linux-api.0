From: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH v2 2/3] fbcon: use the cursor blink interval provided by
 vt
Date: Fri, 22 May 2015 12:00:03 +0200
Message-ID: <20150522100002.GB16507@ulmo>
References: <alpine.DEB.2.11.1503261354550.2411@local>
 <CAMAWPa-6ZbE5cDkEZq0XpYa2pHcnf3qweSSVHAXhfhUAUCbKcA@mail.gmail.com>
 <20150519214011.GA27047@ulmo.nvidia.com>
 <CAMAWPa88E2pfViKLXjxWHuT4ZkVhzYt_BsXGePzc-70ZrEmJFA@mail.gmail.com>
 <20150519215228.GA27163@ulmo.nvidia.com>
 <20150519234112.GA25218@kroah.com>
 <20150520123615.GA24016@ulmo.nvidia.com>
 <20150521042638.GB22632@kroah.com>
 <20150521080049.GA25079@ulmo>
 <20150522020031.GA3516@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150522020031.GA3516@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kevin Hilman <khilman@kernel.org>, Scot Doyle <lkml14@scotdoyle.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Jiri Slaby <jslaby@suse.cz>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Pavel Machek <pavel@ucw.cz>, Geert Uytterhoeven <geert@linux-m68k.org>, lkml <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, Tyler Baker <tyler.baker@linaro.org>, Olof Johansson <olof@lixom.net>, Daniel Stone <daniel@fooishbar.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2015 at 07:00:31PM -0700, Greg Kroah-Hartman wrote:
> On Thu, May 21, 2015 at 10:00:50AM +0200, Thierry Reding wrote:
> > On Wed, May 20, 2015 at 09:26:38PM -0700, Greg Kroah-Hartman wrote:
> > > On Wed, May 20, 2015 at 02:36:17PM +0200, Thierry Reding wrote:
> > > > On Tue, May 19, 2015 at 04:41:12PM -0700, Greg Kroah-Hartman wrote:
> > > > > On Tue, May 19, 2015 at 11:52:29PM +0200, Thierry Reding wrote:
> > > > > > On Tue, May 19, 2015 at 02:45:19PM -0700, Kevin Hilman wrote:
> > > > > > > On Tue, May 19, 2015 at 2:40 PM, Thierry Reding
> > > > > > > <thierry.reding@gmail.com> wrote:
> > > > > > > > On Tue, May 19, 2015 at 02:15:41PM -0700, Kevin Hilman wrot=
e:
> > > > > > > >> On Thu, Mar 26, 2015 at 6:56 AM, Scot Doyle <lkml14@scotdo=
yle.com> wrote:
> > > > > > > >> > vt now provides a cursor blink interval via vc_data. Use=
 this
> > > > > > > >> > interval instead of the currently hardcoded 200 msecs. S=
tore it in
> > > > > > > >> > fbcon_ops to avoid locking the console in cursor_timer_h=
andler().
> > > > > > > >> >
> > > > > > > >> > Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
> > > > > > > >> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > > > > > > >>
> > > > > > > >> This patch hit next-20150519 in the form of commit 27a4c82=
7c34a
> > > > > > > >> (fbcon: use the cursor blink interval provided by vt) and =
has caused
> > > > > > > >> boot failure on a handful of ARM platforms when booting a =
MMC root
> > > > > > > >> filesystem.  This error was spotted by the kernelci.org bo=
t on
> > > > > > > >> exynos5800-peach-pi[1] and Thierry and Daniel (Cc'd) have =
seen it on
> > > > > > > >> some tegra platforms too.
> > > > > > > >>
> > > > > > > >> Thierry spotted this commit as a potential cause, and both=
 Daniel and
> > > > > > > >> I have reverted and boot tested on exynos5 and tegra respe=
ctively and
> > > > > > > >> the boot panics disappear.
> > > > > > > >
> > > > > > > > FWIW, if I apply the below on top of next-20150519 things s=
eem to be
> > > > > > > > back to normal as well:
> > > > > > > >
> > > > > > > > diff --git a/drivers/video/console/fbcon.c b/drivers/video/=
console/fbcon.c
> > > > > > > > index 05b1d1a71ef9..658c34bb9076 100644
> > > > > > > > --- a/drivers/video/console/fbcon.c
> > > > > > > > +++ b/drivers/video/console/fbcon.c
> > > > > > > > @@ -1310,8 +1310,9 @@ static void fbcon_cursor(struct vc_da=
ta *vc, int mode)
> > > > > > > >                 return;
> > > > > > > >
> > > > > > > >         ops->cur_blink_jiffies =3D msecs_to_jiffies(vc->vc_=
cur_blink_ms);
> > > > > > > > -       fbcon_del_cursor_timer(info);
> > > > > > > > -       if (!(vc->vc_cursor_type & 0x10))
> > > > > > > > +       if (vc->vc_cursor_type & 0x10)
> > > > > > > > +               fbcon_del_cursor_timer(info);
> > > > > > > > +       else
> > > > > > > >                 fbcon_add_cursor_timer(info);
> > > > > > > >
> > > > > > > >         ops->cursor_flash =3D (mode =3D=3D CM_ERASE) ? 0 : =
1;
> > > > > > >=20
> > > > > > > Applying this on next-20150519 makes my exynos board happily =
boot again as well.
> > > > > > >=20
> > > > > > > Tested-by: Kevin Hilman <khilman@linaro.org>
> > > > > >=20
> > > > > > Excellent. Greg, Scot, any opinions on whether or not this is t=
he right
> > > > > > thing to do? It restores a bit that looks suspiciously like it =
snuck in
> > > > > > in the original (at least it isn't documented in the commit mes=
sage).
> > > > > >=20
> > > > > > Greg, feel free to squash this in if everybody agrees this is g=
ood to
> > > > > > go. If you prefer a patch on top let me know and I'll come up w=
ith a
> > > > > > proper commit message.
> > > > >=20
> > > > > Please send a real patch and I'll apply it on top, as I can't reb=
ase my
> > > > > public tree.
> > > >=20
> > > > Attached.
> > >=20
> > > Ugh, no, please resend it as a stand-alone patch, I can't easily apply
> > > attachments.
> >=20
> > Really? Your MUA can't dissect multipart messages? Anyway, sent
> > separately for your convenience.
>=20
> "git am" doesn't do that.  I apply patches in huge chunks of mbox files.

What I frequently end up doing is apply patches straight from mutt by
piping the mail or an attached patch to git am. I guess I had expected
that you'd have something similar to simplify applying patches.

> Remember, if I have to hand-edit, or do something special with your
> patch, I will not do it, you need to do it correctly to make
> maintainer's lives easier, not harder, given that maintainers are the
> limited resouce, not developers.

I understand. I'll make a mental note to never send you patches as
attachment again.

Thierry

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXv4iAAoJEN0jrNd/PrOhod8P/2bTc8WC2BXiYPEuYzLvZ2YL
Bi4inwmI7vT5nREf8KqOvuGeL99xifYqvwGZDiC420KBnpkWE722TvMBl3VpdFej
5lsKBXyPQJnJrUCZ3NFkeBD3biPOWo6i8BWFkIKD29L5sdcP31ZTcFHI9mEiEaa8
iuXboWUJ34Oy+B0y5eOIPaTFJtwowqOd/MtvLyNKU1dcowmtJx6MxRTsiMjkAwXE
Llyrq1ALtWveNOIrUbwF27kHcq8BKB1BZvEmPw3pI4aATuCY2UqNMAIECJS8vH7b
hIYExKBmv78yN2Po8IWVgwjSVE1h9HH782OXATILy8OuzqWBFoW6qJsqD4/D4LrW
+oU8LUpjgZysEGamHD84LIG8pAFOZrasyjNEkIRH/LevIKIYXEIgWBye8JOfhcF+
j/fY2yZIQxCN8CC8/sf3acVBWiOVIAAOq3y8AS5zaqzcFlZajE/9E7i99tuuzUN6
rQV8IFrW3u7T5cdCRKXYtfvO+hx+1TtWK0v1zrZz/Bn9D7Ak8eLtq9Fl0EIMIsdd
mWcgfyP0F6bXWirFG2kMcin2JN4XqA5EkdMUGvKcSABnr8JdmdkKQIXBGBpgNm2E
RW8dLOohIqioguWisBt+1BWGebukhAYD8JeGZRWKS9myd3OiD1UhKEHpZkToRjFZ
7X+NIdcb0xRpNSI/bz6p
=eXVq
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
