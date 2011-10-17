From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 16:45:30 +0200
Message-ID: <1318862730.4172.41.camel@twins>
References: <20111014154348.ae6267aa.akpm@linux-foundation.org>
	  <20111015112006.GA10173@tango.0pointer.de>
	 <1318705910.2664.5.camel@laptop>
	  <20111017013921.GA30035@tango.0pointer.de>
	  <20111017032232.GA4816@srcf.ucam.org> <4E9BBB6D.4050004@linux.intel.com>
	  <1318837019.6594.29.camel@twins>
	 <alpine.LFD.2.02.1110171119580.3240@ionos>
	  <20111017124647.GA12838@srcf.ucam.org> <1318856786.4172.22.camel@twins>
	  <20111017141147.GA14581@srcf.ucam.org> <1318861707.4172.32.camel@twins>
	 <4E9C3D39.9020109@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E9C3D39.9020109-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-o55+BOBDEFg@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2011-10-17 at 07:35 -0700, Arjan van de Ven wrote:
> On 10/17/2011 7:28 AM, Peter Zijlstra wrote:
> > Or even when I minimize firefox. That said, ff will probably crash as 
> > soon as I open a second tab because the retarded thing will very 
> > likely continue animating everything on the invisible tab anyway. You 
> > could start by making the X lib of the day, is that XCB these days?, 
> > issue an error print (you get plenty of those anyway) and progress to 
> > full on crashing later. This gives developers a migration window and 
> > incentive to fix up their apps.
> 
> so back in the time that worked on a project that used Qt as their 
> toolkit (geez is it that long ago already ;-) )... we fixed Qt to stop 
> doing this.
> The right level for this sort of thing is the toolkit level (which by 
> and large also does the animations), not Xlib.
> The toolkit level also will then need to provide the right notifications 
> to the app for things the toolkit does not do
> (eg "we're at least partially visible" versus "now none of our pixels 
> are on the screen").
> 
> It ended up being a thing for the toolkit and a minor tweak in the 
> compositor... and it worked quite ok, the app guys actually
> asked for the API (because they knew I would beat them up for getting it 
> wrong)...
> 
> doing things on the xlib level (or even X level) means you take away the 
> chance for the App(tm) to do things the right way;
> make it easy for the app, not hard.

I'm not immediately seeing how enforcing these semantics through X makes
it harder for the app, or would in fact get in the way of the toolkit
providing similar features.

But they key point to my argument is that at whatever level you're going
to do this, it needs to be unforgivingly enforced. Otherwise its useless
because people either don't know or don't care.

Esp. when you then go do crap like proposed and fudge the timers so that
the impact of doing it wrong is dampened.
