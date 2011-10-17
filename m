From: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 03:39:21 +0200
Message-ID: <20111017013921.GA30035@tango.0pointer.de>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
 <20111014154348.ae6267aa.akpm@linux-foundation.org>
 <20111015112006.GA10173@tango.0pointer.de>
 <1318705910.2664.5.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1318705910.2664.5.camel@laptop>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, 15.10.11 21:11, Peter Zijlstra (peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org) wrote:

> > consider you have one or more desktop user sessions logged in, each one
> > in a timer slack cgroup. Now, userspace already tracks when sessions
> > become idle (i.e. currently desktop userspace then starts a screensaver,
> > or turns off the screen, or similar), and we'd like to increase the timer slack
> > for the session cgroups individually as the individual session becomes
> > idle, and decrease it again if the session stops being idle.
> 
> > What matters for us here is that the timer slack cgroup controller
> > provides us with a very nice way to change the timerslack for the whole
> > set of session processes in one go and from the outside. i.e. the idle
> > logic in userspace would be trivially easy to implement, since we
> > already track per-session idle states and with the timerlsack cgroup
> > controller we'd have to touch only a single kernel file to make our
> > changes.
> 
> I would argue this is an excellent reason not to merge this. This really
> is in the camp of lets paper over shitty userspace instead of fix it.
> 
> Such a scheme takes away the immediate need to fix crap and therefore
> crap will not get fixed. Why not focus on creating tools (I think
> powertop really already does everything you need) and track down WTF
> apps are firing so many timers when the screen if off.

Well, maybe that works in fantasy land. In real life however there's
stuff like closed source crap, and all kinds of other things you cannot
fix. In a world where everybody wants "apps" (i.e. 3rd party code
running with limited privileges) your chance to fix every bit of code is
gone.

Despite that: even if all software was open source, and even if we had
the manpower to fix every single project: do you honestly believe it is
such a good idea to build the idle state tracking into each program so
that it can change the timer slack from the inside, if this could be
done in a much much simpler way from the outside?

So yeah, because there'll always be closed source userspace, and because
I believe hacking userspace software should be easy and accessible to
everybody, and because we also should make it difficult to fuck up
runtime behaviour of the machine (such as power usage) I believe
enforcing logic the way we can do it with timerslack cgroups is a good
thing, not a bad thing.

> Also, the downside of your approach is that you treat all applications
> the same, what if there is a genuine need for reasonable timer response
> and your 'policy' wrecks things?

Well, if some thread needs reasonable timer response, then they probably
should be enabling RT anyway and IIRC the patch excludes RT threads when
it mucks with the timer slack. But I guess Kirill can comment on this
much better than I could.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
