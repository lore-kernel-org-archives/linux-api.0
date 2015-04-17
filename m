From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC 1/4] fs: Add generic file system event notifications
Date: Fri, 17 Apr 2015 18:22:47 +0200
Message-ID: <20150417162247.GB27500@quack.suse.cz>
References: <1429082147-4151-1-git-send-email-b.michalska@samsung.com>
 <1429082147-4151-2-git-send-email-b.michalska@samsung.com>
 <20150417113110.GD3116@quack.suse.cz>
 <553104E5.2040704@samsung.com>
 <55310957.3070101@gmail.com>
 <55311DE2.9000901@redhat.com>
 <20150417154351.GA26736@quack.suse.cz>
 <55312FEA.3030905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55312FEA.3030905-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Spray <john.spray-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kmpark-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Linux Filesystem Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri 17-04-15 17:08:10, John Spray wrote:
> 
> On 17/04/2015 16:43, Jan Kara wrote:
> >On Fri 17-04-15 15:51:14, John Spray wrote:
> >>On 17/04/2015 14:23, Austin S Hemmelgarn wrote:
> >>
> >>>For some filesystems, it may make sense to differentiate between a
> >>>generic warning and an error.  For BTRFS and ZFS for example, if
> >>>there is a csum error on a block, this will get automatically
> >>>corrected in many configurations, and won't require anything like
> >>>fsck to be run, but monitoring applications will still probably
> >>>want to be notified.
> >>Another key differentiation IMHO is between transient errors (like
> >>server is unavailable in a distributed filesystem) that will block
> >>the filesystem but might clear on their own, vs. permanent errors
> >>like unreadable drives that definitely will not clear until the
> >>administrator takes some action.  It's usually a reasonable
> >>approximation to call transient issues warnings, and permanent
> >>issues errors.
> >   So you can have events like FS_UNAVAILABLE and FS_AVAILABLE but what use
> >would this have? I wouldn't like the interface to be dumping ground for
> >random crap - we have dmesg for that :).
> In that case I'm confused -- why would ENOSPC be an appropriate use
> of this interface if the mount being entirely blocked would be
> inappropriate?  Isn't being unable to service any I/O a more
> fundamental and severe thing than being up and healthy but full?
> 
> Were you intending the interface to be exclusively for data
> integrity issues like checksum failures, rather than more general
> events about a mount that userspace would probably like to know
> about?
  Well, I'm not saying we cannot have those events for fs availability /
inavailability. I'm just saying I'd like to see some use for that first.
I don't want events to be added just because it's possible...

For ENOSPC we have thin provisioned storage and the userspace deamon
shuffling real storage underneath. So there I know the usecase.

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
