From: Andres Freund <andres-XfW7kCwqgJAb1SvskN2V4Q@public.gmane.org>
Subject: Re: [PATCH v3 0/3] vfs: have syncfs() return error when there are
 writeback errors
Date: Mon, 10 Feb 2020 17:31:17 -0800
Message-ID: <20200211013117.23z3ftgeorx6a3qk@alap3.anarazel.de>
References: <20200207170423.377931-1-jlayton@kernel.org>
 <20200207205243.GP20628@dread.disaster.area>
 <20200207212012.7jrivg2bvuvvful5@alap3.anarazel.de>
 <20200210214657.GA10776@dread.disaster.area>
 <20200211000405.5fohxgpt554gmnhu@alap3.anarazel.de>
 <20200211004830.GB10737@dread.disaster.area>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200211004830.GB10737-pA1nmv6sEBkOM8BvhN4Z8vybgvtCy99p@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

I shortly after this found a thread where Linus was explicitly asking
for potential userspace users of the feature, so I also responded there:
https://lore.kernel.org/linux-fsdevel/20200211005626.7yqjf5rbs3vbwagd-npzPixP2Kky4qIFNZ/xzbbNAH6kLmebB@public.gmane.org/

On 2020-02-11 11:48:30 +1100, Dave Chinner wrote:
> On Mon, Feb 10, 2020 at 04:04:05PM -0800, Andres Freund wrote:
> > On 2020-02-11 08:46:57 +1100, Dave Chinner wrote:
> > As far as I can tell the superblock based stuff does *not* actually
> > report any errors yet (contrast to READONLY, EDQUOT). Is the plan here
> > to include writeback errors as well? Or just filesystem metadata/journal
> > IO?
> 
> Right, that part hasn't been implemented yet, though it's repeatedly
> mentioned as intended to be supported functionality. It will depend
> on the filesystem to what it is going to report

There really ought to be some clear guidelines what is expected to be
reported though. Otherwise we'll just end up with a hodgepodge of
different semantics, which'd be, ummm, not good.


> but I would expect that it will initially be focussed on reporting
> user data errors (e.g. writeback errors, block device gone bad data
> loss reports, etc). It may not be possible to do anything sane with
> metadata/journal IO errors as they typically cause the filesystem to
> shutdown.

I was mostly referencing the metadata/journal errors because it's what a
number of filesystems seem to treat as errors (cf errors=remount-ro
etc), and I just wanted to be sure that more than just those get
reported up...

I think the patch already had support for getting a separate type of
notification for SBs remounted ro, shouldn't be too hard to change that
so it'd report error shutdowns / remount-ro as a different
category. Without


> Of course, a filesystem shutdown is likely to result in a thundering
> herd of userspace IO error notifications (think hundreds of GB of
> dirty page cache getting EIO errors). Hence individual filesystems
> will have to put some thought into how critical filesystem error
> notifications are handled.

Probably would make sense to stop reporting them individually once the
whole FS is shutdown/remounted due to errors, and a notification about
that fact has been sent.


> That said, we likely want userspace notification of metadata IO
> errors for our own purposes. e.g. so we can trigger the online
> filesystem repair code to start trying to fix whatever went wrong. I
> doubt there's much userspace can do with things like "bad freespace
> btree block" notifications, whilst the filesystem's online repair
> tool can trigger a free space scan and rebuild/repair it without
> userspace applications even being aware that we just detected and
> corrected a critical metadata corruption....

Neat.


> > I don't think that block layer notifications would be sufficient for an
> > individual userspace application's data integrity purposes? For one,
> > it'd need to map devices to relevant filesystems afaictl. And there's
> > also errors above the block layer.
> 
> Block device errors separate notifications to the superblock
> notifications. If you want the notification of raw block device
> errors, then that's what you listen for. If you want the filesystem
> to actually tell you what file and offset that EIO was generated
> for, then you'd get that through the superblock notifier, not the
> block device notifier...

Not something we urgently need, but it might come in handy at a later
point.

Thanks,

Andres
