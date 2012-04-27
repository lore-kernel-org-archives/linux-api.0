From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 1/6] xstat: Add a pair of system calls to make extended file stats available
Date: Thu, 26 Apr 2012 21:11:21 -0600
Message-ID: <066E4E15-FE60-4D1C-9616-4679EE700CF6@dilger.ca>
References: <5D4BF4AB-47E9-4E25-B2A3-F895C98BDAA3@dilger.ca> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <20120419140612.17272.57774.stgit@warthog.procyon.org.uk> <18195.1335447156@redhat.com> <20120427005121.GD9541@dastard>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120427005121.GD9541@dastard>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 2012-04-26, at 6:51 PM, Dave Chinner wrote:
> On Thu, Apr 26, 2012 at 02:32:36PM +0100, David Howells wrote:
>> I wonder if there's a way to make this explicit - or is it something that if the bit isn't set, you can't use the value in st_blksize.
>> I wonder if this value always has to be non-zero to make sure existing
>> stat() doesn't explode.
> 
> More likely it probably needs to be non-zero to prevent applications
> doing division by block size from exploding... ;)

Right, and any application which knows it needs the blocksize should
also be requesting it when using the statxat() (or whatever) syscall.

Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
