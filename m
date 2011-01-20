From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/5]add new ioctls to do metadata readahead in btrfs
Date: Thu, 20 Jan 2011 10:58:55 +0800
Message-ID: <1295492335.1949.905.camel@sli10-conroe>
References: <1295399715.1949.863.camel@sli10-conroe>
	 <20110119123451.75bb3c76.akpm@linux-foundation.org>
	 <1295490858.1949.894.camel@sli10-conroe>
	 <20110119184636.fed233a7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110119184636.fed233a7.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2011-01-20 at 10:46 +0800, Andrew Morton wrote:
> On Thu, 20 Jan 2011 10:34:18 +0800 Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > > >   Under a harddisk based netbook with Meego, the metadata readahead
> > > > reduced about 3.5s boot time in average from total 16s.
> > > 
> > > That's a respectable speedup.  And it *needs* to be a good speedup,
> > > given how hacky all of this is!
> > > 
> > > But then..  reducing bootup time on a laptop/desktop/server by 3.5s
> > > isn't exactly a world-shattering benefit, is it?  Is it worth all the
> > > hacky code?
> > a laptop/desktop/server need read more data from hard disks, this will
> > give more bootup time saving I think, though not tested yet.
> 
> Well, the whole point of the patch is to improve boot times, so the
> more boot-time testing you can do, the better that is!
each distribution uses its own readahead (data readahead) daemon, it's
time-cost to change the daemon, but I'll check if I get some data in a
desktop.

> > > It would be much more valuable if those 3.5 seconds were available to
> > > devices which really really care about bootup times, but very few of
> > > those devices use rotating disks nowadays, I expect?
> > Currently most popular netbooks are using rotating disks actually. And
> > this will benefit laptop/desktop too.
> 
> But my point is that three seconds boot-time improvement for a system
> which has an uptime of days or months isn't terribly exciting.
> 
> What *would* be terribly exciting is a three-second improvement for
> cameras, cellphones, etc.  But they don't use spinning disks.
> 
> Can we expect *any* benefit for flash-type storage devices?  If so, how
> much?
There should be no benefit for high end SSD, because they have high
throughput even for random IO. For low end flash-type storage devices,
this should have a little benefit, but won't expect much. I can't test a
camera or cellphone, I can test a USB disk in a desktop if you like.

Thanks,
Shaohua
