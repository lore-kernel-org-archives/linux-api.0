From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info available
Date: Fri, 18 Nov 2016 10:29:04 +0000
Message-ID: <27040.1479464944@warthog.procyon.org.uk>
References: <20161117234047.GE28177@dastard> <147938969703.13574.10295364502230379833.stgit@warthog.procyon.org.uk> <147938970382.13574.11581172952175034619.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161117234047.GE28177@dastard>
Content-ID: <27039.1479464944.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:

> > (13) FS_IOC_GETFLAGS value.  These could be translated to BSD's st_flags.
> >      Note that the Linux IOC flags are a mess and filesystems such as Ext4
> >      define flags that aren't in linux/fs.h, so translation in the kernel
> >      may be a necessity (or, possibly, we provide the filesystem type too).
> 
> And we now also have FS_IOC_FSGETXATTR that extends the flags
> and information userspace can get from filesystems.

Btw, can you point me at the manpage that defines the fsxattr struct and its
flags?

Also, ioctl_list(2) should probably include FS_IOC_FS[GS]ETXATTR.

David
