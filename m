From: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] fbcon: use the cursor blink interval provided by
 vt
Date: Wed, 20 May 2015 14:36:17 +0200
Message-ID: <20150520123615.GA24016@ulmo.nvidia.com>
References: <alpine.LNX.2.11.1502271905580.4212@localhost>
 <alpine.LNX.2.11.1502271911380.4248@localhost>
 <20150325111949.GA24230@kroah.com>
 <alpine.DEB.2.11.1503261341260.2164@local>
 <alpine.DEB.2.11.1503261354550.2411@local>
 <CAMAWPa-6ZbE5cDkEZq0XpYa2pHcnf3qweSSVHAXhfhUAUCbKcA@mail.gmail.com>
 <20150519214011.GA27047@ulmo.nvidia.com>
 <CAMAWPa88E2pfViKLXjxWHuT4ZkVhzYt_BsXGePzc-70ZrEmJFA@mail.gmail.com>
 <20150519215228.GA27163@ulmo.nvidia.com>
 <20150519234112.GA25218@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150519234112.GA25218-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Daniel Stone <daniel-rLtY4a/8tF1rovVCs/uTlw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2015 at 04:41:12PM -0700, Greg Kroah-Hartman wrote:
> On Tue, May 19, 2015 at 11:52:29PM +0200, Thierry Reding wrote:
> > On Tue, May 19, 2015 at 02:45:19PM -0700, Kevin Hilman wrote:
> > > On Tue, May 19, 2015 at 2:40 PM, Thierry Reding
> > > <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > > On Tue, May 19, 2015 at 02:15:41PM -0700, Kevin Hilman wrote:
> > > >> On Thu, Mar 26, 2015 at 6:56 AM, Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>=
 wrote:
> > > >> > vt now provides a cursor blink interval via vc_data. Use this
> > > >> > interval instead of the currently hardcoded 200 msecs. Store it =
in
> > > >> > fbcon_ops to avoid locking the console in cursor_timer_handler().
> > > >> >
> > > >> > Signed-off-by: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
> > > >> > Acked-by: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
> > > >>
> > > >> This patch hit next-20150519 in the form of commit 27a4c827c34a
> > > >> (fbcon: use the cursor blink interval provided by vt) and has caus=
ed
> > > >> boot failure on a handful of ARM platforms when booting a MMC root
> > > >> filesystem.  This error was spotted by the kernelci.org bot on
> > > >> exynos5800-peach-pi[1] and Thierry and Daniel (Cc'd) have seen it =
on
> > > >> some tegra platforms too.
> > > >>
> > > >> Thierry spotted this commit as a potential cause, and both Daniel =
and
> > > >> I have reverted and boot tested on exynos5 and tegra respectively =
and
> > > >> the boot panics disappear.
> > > >
> > > > FWIW, if I apply the below on top of next-20150519 things seem to be
> > > > back to normal as well:
> > > >
> > > > diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/=
fbcon.c
> > > > index 05b1d1a71ef9..658c34bb9076 100644
> > > > --- a/drivers/video/console/fbcon.c
> > > > +++ b/drivers/video/console/fbcon.c
> > > > @@ -1310,8 +1310,9 @@ static void fbcon_cursor(struct vc_data *vc, =
int mode)
> > > >                 return;
> > > >
> > > >         ops->cur_blink_jiffies =3D msecs_to_jiffies(vc->vc_cur_blin=
k_ms);
> > > > -       fbcon_del_cursor_timer(info);
> > > > -       if (!(vc->vc_cursor_type & 0x10))
> > > > +       if (vc->vc_cursor_type & 0x10)
> > > > +               fbcon_del_cursor_timer(info);
> > > > +       else
> > > >                 fbcon_add_cursor_timer(info);
> > > >
> > > >         ops->cursor_flash =3D (mode =3D=3D CM_ERASE) ? 0 : 1;
> > >=20
> > > Applying this on next-20150519 makes my exynos board happily boot aga=
in as well.
> > >=20
> > > Tested-by: Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >=20
> > Excellent. Greg, Scot, any opinions on whether or not this is the right
> > thing to do? It restores a bit that looks suspiciously like it snuck in
> > in the original (at least it isn't documented in the commit message).
> >=20
> > Greg, feel free to squash this in if everybody agrees this is good to
> > go. If you prefer a patch on top let me know and I'll come up with a
> > proper commit message.
>=20
> Please send a real patch and I'll apply it on top, as I can't rebase my
> public tree.

Attached.

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="0001-fbcon-Avoid-deleting-a-timer-in-IRQ-context.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 4f2f70dbbe9de54c0da9b03a1f384e1464755eab Mon Sep 17 00:00:00 2001
=46rom: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Date: Wed, 20 May 2015 13:41:52 +0200
Subject: [PATCH] fbcon: Avoid deleting a timer in IRQ context

Commit 27a4c827c34a ("fbcon: use the cursor blink interval provided by
vt") unconditionally removes the cursor blink timer. Unfortunately that
wreaks havoc under some circumstances. An easily reproducible way is to
use both the framebuffer console and a debug serial port as the console
output for kernel messages (e.g. "console=3DttyS0 console=3Dtty1" on the
kernel command-line. Upon boot this triggers a warning from within the
del_timer_sync() function because it is called from IRQ context:

	[    5.070096] ------------[ cut here ]------------
	[    5.070110] WARNING: CPU: 0 PID: 0 at ../kernel/time/timer.c:1098 del_t=
imer_sync+0x4c/0x54()
	[    5.070115] Modules linked in:
	[    5.070120] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.1.0-rc4-next-20=
150519 #1
	[    5.070123] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
	[    5.070142] [] (unwind_backtrace) from [] (show_stack+0x10/0x14)
	[    5.070156] [] (show_stack) from [] (dump_stack+0x70/0xbc)
	[    5.070164] [] (dump_stack) from [] (warn_slowpath_common+0x74/0xb0)
	[    5.070169] [] (warn_slowpath_common) from [] (warn_slowpath_null+0x1c/=
0x24)
	[    5.070174] [] (warn_slowpath_null) from [] (del_timer_sync+0x4c/0x54)
	[    5.070183] [] (del_timer_sync) from [] (fbcon_del_cursor_timer+0x2c/0x=
40)
	[    5.070190] [] (fbcon_del_cursor_timer) from [] (fbcon_cursor+0x9c/0x18=
0)
	[    5.070198] [] (fbcon_cursor) from [] (hide_cursor+0x30/0x98)
	[    5.070204] [] (hide_cursor) from [] (vt_console_print+0x2a8/0x340)
	[    5.070212] [] (vt_console_print) from [] (call_console_drivers.constpr=
op.23+0xc8/0xec)
	[    5.070218] [] (call_console_drivers.constprop.23) from [] (console_unl=
ock+0x498/0x4f0)
	[    5.070223] [] (console_unlock) from [] (vprintk_emit+0x1f0/0x508)
	[    5.070228] [] (vprintk_emit) from [] (vprintk_default+0x24/0x2c)
	[    5.070234] [] (vprintk_default) from [] (printk+0x70/0x88)

After which the system starts spewing all kinds of weird and seemingly
unrelated error messages.

This commit fixes this by restoring the condition under which the call
to fbcon_del_cursor_timer() happens.

Reported-by: Daniel Stone <daniel-rLtY4a/8tF1rovVCs/uTlw@public.gmane.org>
Reported-by: Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Tested-by: Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Tested-by: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Signed-off-by: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
---
 drivers/video/console/fbcon.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 05b1d1a71ef9..658c34bb9076 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1310,8 +1310,9 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
 		return;
=20
 	ops->cur_blink_jiffies =3D msecs_to_jiffies(vc->vc_cur_blink_ms);
-	fbcon_del_cursor_timer(info);
-	if (!(vc->vc_cursor_type & 0x10))
+	if (vc->vc_cursor_type & 0x10)
+		fbcon_del_cursor_timer(info);
+	else
 		fbcon_add_cursor_timer(info);
=20
 	ops->cursor_flash =3D (mode =3D=3D CM_ERASE) ? 0 : 1;
--=20
2.4.1


--BXVAT5kNtrzKuDFl--

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXH+/AAoJEN0jrNd/PrOhImYQAKskUmz3kouw4V2aVVoSE+kE
AgdEUMFByB+yWHfeVjBNavJIWIzrIR7IAZM4GYby8ihzCZFIRI7aJU8okU+bPGz2
kH3DjB17PCaIDCc+U1e2jAuGbGyQ50uyilyomYLzidyG9MrVIFstXqo+zlf4IsFM
p+7Reg7f3sSFqk1xrddau0a2OIwR3PRRXRJnqNw9jxcqkWVp+bWsUUeltcXaVEV+
D9BdHBCmV7rjV0YmZHPbJql1gBis3nNTt7gcJs/gYU2Utt9wXIfwHFM6EM0L2y22
EIfNE9RF9VIxUG5R+KBkgBdtgtHYWZT1Kt2Y2xsvIWcu/sCvvC3iMhjFSJ8S/k5e
9qgHT01N+3b9HB9JyL2JgW3/mQJ3gLBqAx9/fkhFFRQHw+xjCmHtyqa5q/S8GxvD
Lep2pqAkHz2wtivsup63J6/fd45CjOoWp3DC+mJ9cvPkANWuQH8FEyK1yk06/Xbt
ihsIZ81vUDfDNNCj/HTZcnyUxUOp6yWllvbUoz5Fxz0ExUuG/VM78ONcbjf/07Cj
H64rA3Jtrrx3t53LaLAkW5aAeAy6FpNyyjgkl+ReONkANyoYpqZ80Dqe8Wh/Gz3f
TdaiQ92/oG5D8FQBzr00Buc2OMAzZfE0laoI179T1DJiBZck/hiIpBVYOtugoAAB
Zhdcp8iWFfrskRHR8+k4
=R53W
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
