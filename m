From: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, v6 3/3] cgroups: introduce timer slack controller
Date: Mon, 14 Feb 2011 15:39:36 -0800
Message-ID: <20110214233936.GQ16432@count0.beaverton.ibm.com>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name>
 <1297688787-3592-4-git-send-email-kirill@shutemov.name>
 <alpine.LFD.2.00.1102141432440.26192@localhost6.localdomain6>
 <20110214151914.GA4210@shutemov.name>
 <alpine.LFD.2.00.1102141753240.26192@localhost6.localdomain6>
 <20110214223939.GA6230@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110214223939.GA6230-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 15, 2011 at 12:39:39AM +0200, Kirill A. Shutemov wrote:
> On Mon, Feb 14, 2011 at 06:01:06PM +0100, Thomas Gleixner wrote:
> > B1;2401;0cOn Mon, 14 Feb 2011, Kirill A. Shutemov wrote:
> > 
> > > On Mon, Feb 14, 2011 at 03:00:03PM +0100, Thomas Gleixner wrote:
> > > > On Mon, 14 Feb 2011, Kirill A. Shutsemov wrote:
> > > > > From: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

<snip>

> > > > > +	list_for_each_entry(cur, &cgroup->children, sibling) {
> > > > > +		child = cgroup_to_tslack_cgroup(cur);
> > > > > +		if (type == TIMER_SLACK_MIN && val > child->min_slack_ns)
> > > > > +			return -EBUSY;
> > > > 
> > > >   I thought the whole point is to propagate values through the group.
> > > 
> > > I think silent change here is wrong. cpuset returns -EBUSY in similar
> > > case.
> > 
> > And how is cpuset relevant for this ? Not at all. This is about

I agree with Thomas here -- cpusets aren't relevant.

> > timer_slack and we better have a well defined scheme for all of this
> > and not some cobbled together thing with tons of exceptions and corner
> > cases. Of course undocumented as far the code goes.
> 
> I don't like silent cascade changes. Userspace can implement it if

It need not be totally silent. memcg has a "use_hierarchy" flag file.
Alternately, you could punt for now and disable hierarchy somewhat like
blkio does.

> needed. -EBUSY is appropriate.

Hmm, I haven't thought about that method of cascading enough. The important
question to consider is how will the parent cgroup be constrained if the
owner/group of the children is different and thus disallows userspace from
implementing this cascade. I suppose it's consistent with the owner/group
ids but it hardly seems consistent with the "spirit" of using cgroups to
enable things like containers.

Cheers,
	-Matt Helsley
