From: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, v7] cgroups: introduce timer slack controller
Date: Wed, 2 Mar 2011 23:46:09 -0800
Message-ID: <20110303074609.GL14893@count0.beaverton.ibm.com>
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name>
 <1299084001-3916-2-git-send-email-kirill@shutemov.name>
 <alpine.LFD.2.00.1103021912090.2701@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103021912090.2701-bi+AKbBUZKagILUCTcTcHdKyNwTtLsGr@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: "Kirill A. Shutsemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 02, 2011 at 07:40:01PM +0100, Thomas Gleixner wrote:
> On Wed, 2 Mar 2011, Kirill A. Shutsemov wrote:

<snip>

> > +		if (val > child->min_slack_ns)
> > +			tslack_write_min(cur, cft, val);
> > +	}
> 
> So, we can increase the value and propagate it through the groups
> children, but decreasing it requires to go through all child groups
> seperately. 

One goal is to restrict shrinking timer slacks so that they
cannot be less than the parent cgroup's.

> 
> When I'm trying to optimize something during runtime and chose a too
> high value I need to go through hoops and loops to make it smaller
> again.
> 
> Asymetric behaviour sucks always.

Well, in this case I think the asymmetry is less sucky because I don't
see any point in imposing the same restrictions on raising the timer
slack *except* this symmetry argument. But I haven't played much with
timer slacks so I don't know: Is there any case where raising the timer
slack would be harmful?

Would making the values additive solve the symmetry problem? In other words,
the "minimum" you see in a cgroups min_slack_ns file is the minimum in
addition to the minimum timer slack of its parent. Then, so long as negative
values are disallowed, you can't possibly write values that violate this
restriction. We could re-evaluate the resulting minimum timer slack internally
during writes to the file so functions using timer slack won't have to walk
the cgroup parents to calculate it but it couldn't result in EPERM...

Cheers,
	-Matt Helsley
