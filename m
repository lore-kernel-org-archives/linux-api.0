From: Scot Doyle <lkml14@scotdoyle.com>
Subject: Re: [PATCH v2 2/3] fbcon: use the cursor blink interval provided by
 vt
Date: Wed, 20 May 2015 00:36:24 +0000 (UTC)
Message-ID: <alpine.DEB.2.11.1505200022510.1617@local>
References: <alpine.LNX.2.11.1502252319330.276@localhost> <20150226220243.GC9935@amd> <alpine.LNX.2.11.1502271905580.4212@localhost> <alpine.LNX.2.11.1502271911380.4248@localhost> <20150325111949.GA24230@kroah.com> <alpine.DEB.2.11.1503261341260.2164@local>
 <alpine.DEB.2.11.1503261354550.2411@local> <CAMAWPa-6ZbE5cDkEZq0XpYa2pHcnf3qweSSVHAXhfhUAUCbKcA@mail.gmail.com> <20150519214011.GA27047@ulmo.nvidia.com> <CAMAWPa88E2pfViKLXjxWHuT4ZkVhzYt_BsXGePzc-70ZrEmJFA@mail.gmail.com>
 <20150519215228.GA27163@ulmo.nvidia.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150519215228.GA27163@ulmo.nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Kevin Hilman <khilman@kernel.org>, Scot Doyle <lkml14@scotdoyle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Jiri Slaby <jslaby@suse.cz>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Pavel Machek <pavel@ucw.cz>, Geert Uytterhoeven <geert@linux-m68k.org>, lkml <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, Tyler Baker <tyler.baker@linaro.org>, Olof Johansson <olof@lixom.net>, Daniel Stone <daniel@fooishbar.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

On Tue, 19 May 2015, Thierry Reding wrote:
> On Tue, May 19, 2015 at 02:45:19PM -0700, Kevin Hilman wrote:
> > On Tue, May 19, 2015 at 2:40 PM, Thierry Reding
> > <thierry.reding@gmail.com> wrote:

...

> > >
> > > FWIW, if I apply the below on top of next-20150519 things seem to be
> > > back to normal as well:
> > >
> > > diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> > > index 05b1d1a71ef9..658c34bb9076 100644
> > > --- a/drivers/video/console/fbcon.c
> > > +++ b/drivers/video/console/fbcon.c
> > > @@ -1310,8 +1310,9 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
> > >                 return;
> > >
> > >         ops->cur_blink_jiffies = msecs_to_jiffies(vc->vc_cur_blink_ms);
> > > -       fbcon_del_cursor_timer(info);
> > > -       if (!(vc->vc_cursor_type & 0x10))
> > > +       if (vc->vc_cursor_type & 0x10)
> > > +               fbcon_del_cursor_timer(info);
> > > +       else
> > >                 fbcon_add_cursor_timer(info);
> > >
> > >         ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;
> > 
> > Applying this on next-20150519 makes my exynos board happily boot again as well.
> > 
> > Tested-by: Kevin Hilman <khilman@linaro.org>
> 
> Excellent. Greg, Scot, any opinions on whether or not this is the right
> thing to do? It restores a bit that looks suspiciously like it snuck in
> in the original (at least it isn't documented in the commit message).
> 
> Greg, feel free to squash this in if everybody agrees this is good to
> go. If you prefer a patch on top let me know and I'll come up with a
> proper commit message.
> 
> Thierry

Hi all, sorry for the trouble.

The timer delete was to prevent blink stutter when updating the interval. 
Since the stutter isn't so noticable when changing from the default 200ms, 
and since most people seem to prefer leaving the fbcon code alone if 
possible, I agree with Thierry's approach.

Tested-by: Scot Doyle <lkml14@scotdoyle.com>
