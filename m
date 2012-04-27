From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 1/6] xstat: Add a pair of system calls to make extended
 file stats available
Date: Fri, 27 Apr 2012 10:51:21 +1000
Message-ID: <20120427005121.GD9541@dastard>
References: <5D4BF4AB-47E9-4E25-B2A3-F895C98BDAA3@dilger.ca>
 <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
 <20120419140612.17272.57774.stgit@warthog.procyon.org.uk>
 <18195.1335447156@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <18195.1335447156-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 26, 2012 at 02:32:36PM +0100, David Howells wrote:
> Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:
> > st_blksize may be variable for a distributed filesystem,

It can be variable for local filesystems, too. XFS will vary the
block size based on the configuration of the inode. e.g. if there is
an extent allocation size hint on the inode, or it's on the realtime
device, and so on. There is no guarantee that from file to file that
it is constant.

> I wonder if there's a way to make this explicit - or is it something that if
> the bit isn't set, you can't use the value in st_blksize.
> I wonder if this
> value always has to be non-zero to make sure existing stat() doesn't explode.

More likely it probably needs to be non-zero to prevent applications
doing division by block size from exploding... ;)

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
