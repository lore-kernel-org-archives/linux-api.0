From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 2/2] fbcon: expose cursor blink interval via sysfs
Date: Thu, 26 Feb 2015 23:02:43 +0100
Message-ID: <20150226220243.GC9935@amd>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
 <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
 <20150225094946.GA24627@amd>
 <alpine.LNX.2.11.1502252319330.276@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1502252319330.276@localhost>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 2015-02-25 23:32:00, Scot Doyle wrote:
> On Wed, 25 Feb 2015, Pavel Machek wrote:
> > On Mon 2015-01-26 20:41:53, Scot Doyle wrote:
> > > The fbcon cursor, when set to blink, is hardcoded to toggle display state
> > > five times per second. Expose this setting via
> > > /sys/class/graphics/fbcon/cursor_blink_ms
> > > 
> > > Values written to the interface set the approximate time interval in
> > > milliseconds between cursor toggles, from 1 to 32767. Since the interval
> > > is stored internally as a number of jiffies, the millisecond value read
> > > from the interface may not exactly match the entered value.
> > > 
> > > An outstanding blink timer is reset after a new value is entered.
> > > 
> > > If the cursor blink is disabled, either via the 'cursor_blink' boolean
> > > setting or some other mechanism, the 'cursor_blink_ms' setting may still
> > > be modified. The new value will be used if the blink is reactivated.
> > > 
> > > Signed-off-by: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
> > 
> > Normally, this would be set by ansi escape sequences, no? We can hide
> > cursor using them, set its appearance.. makes sense to change timing
> > value there, too....
> > 									Pavel
> 
> Hi Pavel, what about something like this? For example,
> "echo -e '\033[16;500]' would set the blink interval to 500 milliseconds.
> 
> The duration is stored twice to avoid locking the console in
> cursor_timer_handler().

Yes, I'd say this matches the existing code better.

Acked-by: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>

> +		case 16: /* set cursor blink duration in msec */
> +			if (vc->vc_npar >= 1 && vc->vc_par[1] > 0 &&
> +					vc->vc_par[1] <= USHRT_MAX)
> +				vc->vc_cur_blink_ms = vc->vc_par[1];
> +			else

Actually, vc_cur_blink_ms less then about 50 probably does not make
sense (and may overload the system). Should that be checked?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
