From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 1/6] xstat: Add a pair of system calls to make extended
 file stats available
Date: Thu, 26 Apr 2012 10:23:29 -0400
Message-ID: <20120426142329.GA7176@fieldses.org>
References: <20120424212911.GA26073@fieldses.org>
 <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
 <20120419140612.17272.57774.stgit@warthog.procyon.org.uk>
 <18533.1335447617@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <18533.1335447617-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 26, 2012 at 02:40:17PM +0100, David Howells wrote:
> J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
> 
> > > (11) Include granularity fields in the time data to indicate the
> > >      granularity of each of the times (NFSv4 time_delta) [Steve French].
> > 
> > It looks like you're including this with *each* time?  But surely
> > there's no filesystem with different granularity (say) for ctime than
> > for mtime.
> 
> I put it in each time struct to use up the hole there.  I could, I suppose,
> split tv_sec from tv_nsec to get rid of the holes and then put the granularity
> separately.  That means that someone who wanted both the tv_sec and tv_nsec
> would have to fish them out separately, but that's probably okay.
> 
> I could even make the granularity bigger then, to allow for the possibility of
> having a granularity >4s, but I don't know of anywhere that requires a gran >2.
> 
> > Also, nfsd will want only one time_delta, not one for each time.
> 
> time_delta?  Is that the same as granularity?

Right, sorry, that's just the NFS word for the same thing.

So my whine here is just that most callers only want to know one number
and we're giving them three.  Whatever, they can just pick one.  It
feels a little ugly, but feel free to ignore my nitpicking....

(Though as Steve French asked: could we add this to statfs (or something
similar) instead?)

> 
> > Note also we need to document carefully what this means: I think it
> > should be the granularity that the filesystem is capable of
> > representing, but people are sometimes surprised to find out that the
> > actual time source is usually more coarse-grained than that.
> 
> Yeah, but the latter is something you may not be able to determine, and may
> indeed change over time (say someone updates the server kernel to one with a
> more fine-grained software clock).  Also, for a network fs, it may depend on
> the client that happened to set that time last.

Yep, agreed, the granularity should be what the filesystem can store, we
should just make sure that statement makes it into any eventual man
pages or other documentation, since it does seem to surprise people.

--b.
