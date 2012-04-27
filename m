From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Fri, 27 Apr 2012 11:06:10 +1000
Message-ID: <20120427010610.GE9541@dastard>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120419140558.17272.74360.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 19, 2012 at 03:05:58PM +0100, David Howells wrote:
> 
> Implement a pair of new system calls to provide extended and further extensible
> stat functions.
> 
> The second of the associated patches is the main patch that provides these new
> system calls:
> 
> 	ssize_t ret = xstat(int dfd,
> 			    const char *filename,
> 			    unsigned atflag,
> 			    unsigned mask,
> 			    struct xstat *buffer);
> 
> 	ssize_t ret = fxstat(int fd,
> 			     unsigned atflag,
> 			     unsigned mask,
> 			     struct xstat *buffer);
> 
> which are more fully documented in the first patch's description.
> 
> These new stat functions provide a number of useful features, in summary:
> 
>  (1) More information: creation time, inode generation number, data version
>      number, flags/attributes.  A subset of these is available through a number
>      of filesystems (such as CIFS, NFS, AFS, Ext4 and BTRFS).

If we are adding per-inode flags, then what do we do with filesystem
specific flags? e.g. XFS has quite a number of per-inode flags that
don't align with any other filesystem (e.g. filestream allocator,
real time file, behaviour inheritence flags, etc), but may be useful
to retrieve in such a call. We currently have an ioctl to get that
information from each inode. Have you thought about how to handle
such flags?

Along the same lines, filesytsems can have different allocation
constraints to IO the filesystem block size - ext4 with it's
bigalloc hack, XFS with it's per-inode extent size hints and the
realtime device, etc. Then there's optimal IO characteristics
(e.g. geometery hints like stripe unit/stripe width for the
allocation policy of that given file) that applications could use
if they were present rather than having to expose them through
ioctls that nobody even knows about...

Perhaps also exposing the project ID for quota purposes, like we do
UID and GID. That way we wouldn't need a filesystem specific ioctl
to read it....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
