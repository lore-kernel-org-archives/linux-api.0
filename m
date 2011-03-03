From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH, v7] cgroups: introduce timer slack controller
Date: Thu, 3 Mar 2011 09:28:59 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103030918390.2701@localhost6.localdomain6>
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name> <1299084001-3916-2-git-send-email-kirill@shutemov.name> <alpine.LFD.2.00.1103021912090.2701@localhost6.localdomain6> <20110303074609.GL14893@count0.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110303074609.GL14893-52DBMbEzqgQ/wnmkkaCWp/UQ3DHhIser@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "Kirill A. Shutsemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2 Mar 2011, Matt Helsley wrote:

> On Wed, Mar 02, 2011 at 07:40:01PM +0100, Thomas Gleixner wrote:
> > On Wed, 2 Mar 2011, Kirill A. Shutsemov wrote:
> 
> <snip>
> 
> > > +		if (val > child->min_slack_ns)
> > > +			tslack_write_min(cur, cft, val);
> > > +	}
> > 
> > So, we can increase the value and propagate it through the groups
> > children, but decreasing it requires to go through all child groups
> > seperately. 
> 
> One goal is to restrict shrinking timer slacks so that they
> cannot be less than the parent cgroup's.

Right, but that's not what the code is doing.
 
> > 
> > When I'm trying to optimize something during runtime and chose a too
> > high value I need to go through hoops and loops to make it smaller
> > again.
> > 
> > Asymetric behaviour sucks always.
> 
> Well, in this case I think the asymmetry is less sucky because I don't
> see any point in imposing the same restrictions on raising the timer
> slack *except* this symmetry argument. But I haven't played much with
> timer slacks so I don't know: Is there any case where raising the timer
> slack would be harmful?

Well, the slack can delay your timer expiry by slack ns. So chosing a
too large slack value can affect the functionality of an application.

Now imagine you are tuning your system and typo the slack value by an
order of magnitude, which makes your apps unhappy. Then you definitely
want to be able to undo that w/o going through loops and circles.

> Would making the values additive solve the symmetry problem? In other words,
> the "minimum" you see in a cgroups min_slack_ns file is the minimum in
> addition to the minimum timer slack of its parent. Then, so long as negative
> values are disallowed, you can't possibly write values that violate this
> restriction. We could re-evaluate the resulting minimum timer slack internally
> during writes to the file so functions using timer slack won't have to walk
> the cgroup parents to calculate it but it couldn't result in EPERM...

That would work, but that wants some interface to read out the
effective slack value for a group.

Thanks,

	tglx
