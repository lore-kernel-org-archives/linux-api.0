From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 1/6] xstat: Add a pair of system calls to make extended
 file stats available
Date: Thu, 26 Apr 2012 10:28:16 -0400
Message-ID: <20120426142816.GB7176@fieldses.org>
References: <CAH2r5muMb8m9-fMc_tcfn3ku_s55q9EEbc-vzvoFjPnsDdq1gA@mail.gmail.com>
 <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
 <20120419140612.17272.57774.stgit@warthog.procyon.org.uk>
 <20120424212911.GA26073@fieldses.org>
 <18765.1335447954@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <18765.1335447954-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 26, 2012 at 02:45:54PM +0100, David Howells wrote:
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > I also would prefer that we simply treat the time granularity as part
> > of the superblock (mounted volume) ie returned on fstat rather than on
> > every stat of the filesystem.   For cifs mounts we could conceivably
> > have different time granularity (1 or 2 second) on mounts to old
> > servers rather than 100 nanoseconds.
> 
> The question is whether you want to have to do a statfs in addition to a stat?
> I suppose you can potentially cache the statfs based on device number.
> 
> That said, there are cases where caching filesystem-level info based on i_dev
> doesn't work.  OpenAFS springs to mind as that only has one superblock and
> thus one set of device numbers, but keeps all the inodes for all the different
> volumes it may have mounted there.
> 
> I don't know whether this would be a problem for CIFS too - say on a windows
> server you fabricate P:, for example, by joining together several filesystems
> (with junctions?).  How does this appear on a Linux client when it steps from
> one filesystem to another within a mounted share?

In the NFS case we do try to preserve filesystem boundaries as well as
we can--the protocol has an fsid field and the client creates a new
mount each time it sees it change.  And the protocol defines time_delta
as a per-filesystem attribute (though, somewhat hilariously, there's
also a per-filesystem "homogeneous" attribute that a server can clear to
indicate the per-filesystem attributes might actually vary within the
filesystem.)

--b.
