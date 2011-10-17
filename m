From: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 04:22:32 +0100
Message-ID: <20111017032232.GA4816@srcf.ucam.org>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
 <20111014154348.ae6267aa.akpm@linux-foundation.org>
 <20111015112006.GA10173@tango.0pointer.de>
 <1318705910.2664.5.camel@laptop>
 <20111017013921.GA30035@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111017013921.GA30035-kS5D54t9nk0aINubkmmoJbNAH6kLmebB@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 17, 2011 at 03:39:21AM +0200, Lennart Poettering wrote:
> On Sat, 15.10.11 21:11, Peter Zijlstra (peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org) wrote:
> > I would argue this is an excellent reason not to merge this. This really
> > is in the camp of lets paper over shitty userspace instead of fix it.
> > 
> > Such a scheme takes away the immediate need to fix crap and therefore
> > crap will not get fixed. Why not focus on creating tools (I think
> > powertop really already does everything you need) and track down WTF
> > apps are firing so many timers when the screen if off.
> 
> Well, maybe that works in fantasy land. In real life however there's
> stuff like closed source crap, and all kinds of other things you cannot
> fix. In a world where everybody wants "apps" (i.e. 3rd party code
> running with limited privileges) your chance to fix every bit of code is
> gone.

I agree. We can't assume perfect software, and I don't think *requiring* 
the duplication of this functionality in every single session 
application is sensible. We want to be able to shut down timer based 
code when the session is idle. We could do this by exposing the slack in 
/proc. We could do this by modifying every piece of code to listen for 
session idle events and (independently) enact session-wide policy. Or we 
could just accept that it's a problem that maps onto what people are 
already using cgroups for and implement it in the same way.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
