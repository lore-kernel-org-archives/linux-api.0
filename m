From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [RFC v3 1/4] fs: Add generic file system event notifications
Date: Tue, 16 Jun 2015 17:21:47 +0100
Message-ID: <20150616162147.GA17109@ZenIV.linux.org.uk>
References: <1434460173-18427-1-git-send-email-b.michalska@samsung.com>
 <1434460173-18427-2-git-send-email-b.michalska@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434460173-18427-2-git-send-email-b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kmpark-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jun 16, 2015 at 03:09:30PM +0200, Beata Michalska wrote:
> Introduce configurable generic interface for file
> system-wide event notifications, to provide file
> systems with a common way of reporting any potential
> issues as they emerge.
> 
> The notifications are to be issued through generic
> netlink interface by newly introduced multicast group.
> 
> Threshold notifications have been included, allowing
> triggering an event whenever the amount of free space drops
> below a certain level - or levels to be more precise as two
> of them are being supported: the lower and the upper range.
> The notifications work both ways: once the threshold level
> has been reached, an event shall be generated whenever
> the number of available blocks goes up again re-activating
> the threshold.
> 
> The interface has been exposed through a vfs. Once mounted,
> it serves as an entry point for the set-up where one can
> register for particular file system events.

Hmm...

1) what happens if two processes write to that file at the same time,
trying to create an entry for the same fs?  WARN_ON() and fail for one
of them if they race?

2) what happens if fs is mounted more than once (e.g. in different
namespaces, or bound at different mountpoints, or just plain mounted
several times in different places) and we add an event for each?
More specifically, what should happen when one of those gets unmounted?

3) what's the meaning of ->active?  Is that "fs_drop_trace_entry() hadn't
been called yet" flag?  Unless I'm misreading it, we can very well get
explicit removal race with umount, resulting in cleanup_mnt() returning
from fs_event_mount_dropped() before the first process (i.e. write
asking to remove that entry) gets around to its deactivate_super(),
ending up with umount(2) on a filesystem that isn't mounted anywhere
else reporting success to userland before the actual fs shutdown, which
is not a nice thing to do...

4) test in fs_event_mount_dropped() looks very odd - by that point we
are absolutely guaranteed to have ->mnt_ns == NULL.  What's that supposed
to do?


Al, trying to figure out the lifetime rules in all of that...
