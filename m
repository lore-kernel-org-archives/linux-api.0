From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: Extended file stat: Splitting file- and fs-specific info?
Date: Wed, 09 May 2012 13:55:16 +0200
Message-ID: <4FAA5B24.1020306@itwm.fraunhofer.de>
References: <20120509002420.GL5091@dastard> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <16281.1336508382@redhat.com> <20170.1336555274@redhat.com> <20120509111958.GA11345@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120509111958.GA11345-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/09/2012 01:19 PM, Christoph Hellwig wrote:
> On Wed, May 09, 2012 at 10:21:14AM +0100, David Howells wrote:
>> Dave Chinner<david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>  wrote:
>>
>>> I don't think we want to expose the inode generation numbers. It is
>>> trivial to construct NFS file handles (usually just fsid, inode
>>> number and generation) with that information and hence bypass
>>> security checks to access files.
>>
>> I was asked for it by Bernd Schubert for userspace NFS servers and FUSE -
>> maybe he can say what he wants it for.
>
> It's entirely broken, as a generation number might be part of the file
> handle (and for Linux-like filesystems normally is), but it's entirely
> up to the filesystem to decide how it works.  That's why we added system
> calls to do operations on opaque file handles that the file system
> controls.  Exposing a completely meaningless "generation" is a bad idea.
>

The basic idea of generation numbers is to check if an inode was 
recycled, so only if the tuple of inode-number and generation-number 
matches we still have the same file. Kernel nfs uses that and unfs3 uses 
it via EXT2_IOC_GETVERSION, which has the overhead of an additional 
syscall. Unionfs-fuse usually keeps file open, however, it might run out 
of the maximum allowed files and I plan to add a mode to close and 
re-open files as failback mode. For that the definite knowledge if a 
file/inode is still the very same and the inode was not just recycled is 
crucial.

All of that being said, I think with open_by_handle_at() syscall we 
don't need the inode generation number any more.



Cheers,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
