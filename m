From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 15:06:26 +0200
Message-ID: <1318856786.4172.22.camel@twins>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
	 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
	 <20111014154348.ae6267aa.akpm@linux-foundation.org>
	 <20111015112006.GA10173@tango.0pointer.de> <1318705910.2664.5.camel@laptop>
	 <20111017013921.GA30035@tango.0pointer.de>
	 <20111017032232.GA4816@srcf.ucam.org> <4E9BBB6D.4050004@linux.intel.com>
	 <1318837019.6594.29.camel@twins> <alpine.LFD.2.02.1110171119580.3240@ionos>
	 <20111017124647.GA12838@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111017124647.GA12838-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2011-10-17 at 13:46 +0100, Matthew Garrett wrote:
> On Mon, Oct 17, 2011 at 11:38:03AM +0200, Thomas Gleixner wrote:
> 
> > Unfortunately this is a full speed rolling trainwreck already. The
> > whole app space is made to encourage shitty applications. Android is
> > designed exactly in that way and it seems that all other desktop folks
> > have fully adopted that adsurdity.
> > 
> > Back when NOHZ was merged in the kernel, powertop made people fix crap
> > left and right in not time. Why should we add something which actively
> > fosters crappy applications today?
> 
> They're orthogonal. Sometimes you want timer-driven behaviour (how else 
> are you going to draw animations?) and that's obviously going to 
> generate wakeups. This is for the idle case, where the user is no longer 
> sitting in front of the machine but you don't want to trigger a full 
> system suspend. We either need every application that ever uses 
> timer-driven behaviour to support setting its own timer slack on some 
> sort of external policy decision, or we need a way to let the kernel 
> force them to.

No!! you want that application to stop drawing stuff that is invisible.
Setting your own timerslack for something you know is pointless is worse
than doing something pointless, its down right stupid.

Please, work with the X folks and make it an error to draw to invisible
surfaces. And yes, I know that composition makes that a non-trivial
problem. But at least the blank screen case should be trivial, and I
suspect there's more tractable cases as well. Mostly the desktop is
still a very static place and a few extra timer ticks for when you're
spinning your desktop cube around isn't going to be a problem.
