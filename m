From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 09:28:49 +0200
Message-ID: <1318836529.6594.20.camel@twins>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
	 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
	 <20111014154348.ae6267aa.akpm@linux-foundation.org>
	 <20111015112006.GA10173@tango.0pointer.de> <1318705910.2664.5.camel@laptop>
	 <20111017013921.GA30035@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111017013921.GA30035-kS5D54t9nk0aINubkmmoJbNAH6kLmebB@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2011-10-17 at 03:39 +0200, Lennart Poettering wrote:

> Well, maybe that works in fantasy land. In real life however there's
> stuff like closed source crap, and all kinds of other things you cannot
> fix. In a world where everybody wants "apps" (i.e. 3rd party code
> running with limited privileges) your chance to fix every bit of code is
> gone.

I don't care for closed source crap, and I'm the proof your stmt is
false since I don't want no fucking apps. That's the same kind of
'everybody' that makes GNOME the utter head-up-arse crap it is.

> Despite that: even if all software was open source, and even if we had
> the manpower to fix every single project: do you honestly believe it is
> such a good idea to build the idle state tracking into each program so
> that it can change the timer slack from the inside, if this could be
> done in a much much simpler way from the outside?

That would be doing it wrong. You want your runtime enforcing this
stuff. Simply let X kill whomever issues a drawing request for a
nonvisible surface.

Also, no apps shouldn't change their timer slack, if you think that you
really just don't get it, go away! They shouldn't be using those timers
to begin with. Increasing the slack is a bandaid trying to sort of
compensate for wrong timer usage.

There's absolutely no point in firefox trying to animate a GIF in a
non-visible tab (all are non-visible when the screen if off). Yet it
does. Go and fix that.

As to the proprietary plugins, let firefox spawn one per tab and simply
SIGSTOP the thing when the tab becomes invisible or so, dunno.

> So yeah, because there'll always be closed source userspace, and because
> I believe hacking userspace software should be easy and accessible to
> everybody, and because we also should make it difficult to fuck up
> runtime behaviour of the machine (such as power usage) I believe
> enforcing logic the way we can do it with timerslack cgroups is a good
> thing, not a bad thing.

I'm of the absolute opposite camp, make the runtime unforgiving of
fuckups, like we are for memory protection violations. Apps that crash a
lot aren't popular like you can see in various app markets.

So improve the runtime to detect power unfriendly behaviour and simply
kill.

> > Also, the downside of your approach is that you treat all applications
> > the same, what if there is a genuine need for reasonable timer response
> > and your 'policy' wrecks things?
> 
> Well, if some thread needs reasonable timer response, then they probably
> should be enabling RT anyway and IIRC the patch excludes RT threads when
> it mucks with the timer slack. But I guess Kirill can comment on this
> much better than I could.

That's nonsense, you shouldn't need RT privs in order to get a timer to
fire more than once every few seconds just because the screen if off.
