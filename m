From: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, v6 3/3] cgroups: introduce timer slack controller
Date: Mon, 14 Feb 2011 16:00:55 -0800
Message-ID: <20110215000055.GR16432@count0.beaverton.ibm.com>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name>
 <1297688787-3592-4-git-send-email-kirill@shutemov.name>
 <20110214135926.GO16432@count0.beaverton.ibm.com>
 <20110214225940.GB6230@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110214225940.GB6230-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 15, 2011 at 12:59:40AM +0200, Kirill A. Shutemov wrote:
> On Mon, Feb 14, 2011 at 05:59:26AM -0800, Matt Helsley wrote:
> > On Mon, Feb 14, 2011 at 03:06:27PM +0200, Kirill A. Shutsemov wrote:
> > > From: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

<snip>

> > > +	list_for_each_entry(cur, &cgroup->children, sibling) {
> > > +		child = cgroup_to_tslack_cgroup(cur);
> > > +		if (type == TIMER_SLACK_MIN && val > child->min_slack_ns)
> > > +			return -EBUSY;
> > > +		if (type == TIMER_SLACK_MAX && val < child->max_slack_ns)
> > > +			return -EBUSY;
> > > +	}
> > 
> > This doesn't look right. Child cgroups should not constrain their
> > parents. Instead you should allow the change and propagate the
> > constraint to the children.
> 
> See discussion with Thomas.

<OK, shifting this topic to that thread>
<snip>

> > > +static struct cftype files[] = {
> > > +	{
> > > +		.name = "set_slack_ns",
> > > +		.write_u64 = tslack_write_set_slack_ns,
> > > +	},
> > > +	{
> > > +		.name = "min_slack_ns",
> > > +		.private = TIMER_SLACK_MIN,
> > > +		.read_u64 = tslack_read_range,
> > > +		.write_u64 = tslack_write_range,
> > > +	},
> > > +	{
> > > +		.name = "max_slack_ns",
> > > +		.private = TIMER_SLACK_MAX,
> > > +		.read_u64 = tslack_read_range,
> > > +		.write_u64 = tslack_write_range,
> > > +	},
> > 
> > I didn't get a reply on how a max_slack_ns is useful. It seems
> > prudent to add as little interface as possible and only when
> > we clearly see the utility of it.
> 
> For example, you can create two groups (excluding root cgroup):
> 
> default - timer slack range 50000-50000
> relaxed - timer slack range 500000-unlimited.
> 
> Now you can drag tasks between these group without need to reset value on
> relaxed -> default transition.

Perhaps you misunderstood my point.

Yes, I can see that a maximum allows you to do counter-productive/pointless
little tricks like "setting" the timer slack when you move the task. I
just don't get the point of it. Why is setting a maximum timer slack useful?
If anything it seems like it would be quite counterproductive or pointless
*at best* because limiting the amount of timer slack would not improve
the wakeup situation -- it could easily make it worse. Are there
*any* negative consequences to allowing timer slacks as large as
userspace requests -- perhaps even up to ULLONG_MAX? If there are none then
why should we bother providing userspace a knob to set and enforce such a
limit?

Cheers,
	-Matt Helsley
