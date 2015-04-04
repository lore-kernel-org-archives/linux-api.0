From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 13/14] twl4030_charger: Increase current carefully while
 watching voltage.
Date: Sat, 4 Apr 2015 09:48:32 +0200
Message-ID: <20150404074832.GB31064@amd>
References: <20150322231635.23789.70149.stgit@notabene.brown>
 <20150322232029.23789.30185.stgit@notabene.brown>
 <20150323212541.GD14779@amd>
 <20150330082637.4bf4832d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150330082637.4bf4832d-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, inux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!

> > > The USB Battery Charging spec (BC1.2) suggests a dedicated
> > > charging port can deliver from 0.5 to 5.0A at between 4.75 and 5.25
> > > volts.
> > > 
> > > To choose the "correct" current voltage setting requires a trial
> > > and error approach: try to draw current and see if the voltage drops
> > > too low.
> > > 
> > > Even with a configured Standard Downstream Port, it may not be possible
> > > to reliably pull 500mA - depending on cable quality and source
> > > quality I have reports of charging failure due to the voltage dropping
> > > too low.
> > > 
> > > To address both these concerns, this patch introduce incremental
> > > current setting.
> > > The current pull from VBUS is increased in steps of 20mA every 100ms
> > > until the target is reached or until the measure voltage drops below
> > > 4.75V.  If the voltage does go too low, the target current is reduced
> > > by 20mA and kept there.
> > 
> > Still nervous. If it is possible to overheat the charger, without
> > tripping internal fuse, then you'll do it.
> 
> If it is possible to overheat the charger without tripping an internal fuse,
> then sure the charger is mis-designed - is it not?
> 
> Can you suggest an algorithm for determining how much current can safely be
> pulled from a charger that would *not* make you nervous?

Not nervous? No.

Less nervous?

Run detection as you do, but then round down to "known reasonable"
max charging currents?

If you detected 1.1A charger, you are probably overloading 1A
charger. So idea would be to round down to 0.5A, 1A, 1.7A.


> > Idle device. Code will find that it can charge using 1A, backs up to
> > 0.9A. User starts hotspot. Now device will draw 1.4A, overloading the
> > charger and not charging at all...?
> 
> The current being measured and controlled is the current flowing in from the
> USB VBUS, not flowing out to the battery.
> So I the code choose 0.9A, that is all that will be drawn.
> 
> This is a possible issue similar to this though.
> If the device is idle and the battery is fully charged, then it won't draw
> much current from USB even if we allow it too.
> So the algorithm might decide it is OK to draw 1.7A because at that time the
> device cannot use more than 200mA, and that doesn't cause the voltage to drop.
> 
> Then later when user enabled wifi-hotspot, the current needed might go up
> above what the charger can provide.
> 
> Maybe I should only increase the limit while the actual current is also
> increasing.  Maybe also revisit the setting when the battery starts charging.

Yes, that sounds better.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
