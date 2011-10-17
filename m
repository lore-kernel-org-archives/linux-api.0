From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 11:38:03 +0200 (CEST)
Message-ID: <alpine.LFD.2.02.1110171119580.3240@ionos>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>  <1318349729-3108-4-git-send-email-kirill@shutemov.name>  <20111014154348.ae6267aa.akpm@linux-foundation.org>  <20111015112006.GA10173@tango.0pointer.de> <1318705910.2664.5.camel@laptop>
 <20111017013921.GA30035@tango.0pointer.de>  <20111017032232.GA4816@srcf.ucam.org> <4E9BBB6D.4050004@linux.intel.com> <1318837019.6594.29.camel@twins>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318837019.6594.29.camel@twins>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 17 Oct 2011, Peter Zijlstra wrote:

> On Sun, 2011-10-16 at 22:21 -0700, Arjan van de Ven wrote:
> > and..it's not like we let the bad guys go free.
> > We actually seriously hurt their behavior while we throttle their timers 
> > here. 
> 
> How are they hurt? The app appears to behave properly (there are no
> repercussions, the app doesn't crash, the developer doesn't get punched
> in the face). This doesn't make the developer improve his app, nor make
> him take greater care for the next app.
> 
> Such behaviour will in fact encourage crap since he seems to be getting
> away with it.

Unfortunately this is a full speed rolling trainwreck already. The
whole app space is made to encourage shitty applications. Android is
designed exactly in that way and it seems that all other desktop folks
have fully adopted that adsurdity.

Back when NOHZ was merged in the kernel, powertop made people fix crap
left and right in not time. Why should we add something which actively
fosters crappy applications today?

Thanks,

	tglx
