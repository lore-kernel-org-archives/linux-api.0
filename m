From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info
 available
Date: Sat, 19 Nov 2016 08:27:25 +1100
Message-ID: <20161118212725.GA31101@dastard>
References: <20161117234047.GE28177@dastard>
 <147938969703.13574.10295364502230379833.stgit@warthog.procyon.org.uk>
 <147938970382.13574.11581172952175034619.stgit@warthog.procyon.org.uk>
 <27040.1479464944@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <27040.1479464944@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 18, 2016 at 10:29:04AM +0000, David Howells wrote:
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > > (13) FS_IOC_GETFLAGS value.  These could be translated to BSD's st_flags.
> > >      Note that the Linux IOC flags are a mess and filesystems such as Ext4
> > >      define flags that aren't in linux/fs.h, so translation in the kernel
> > >      may be a necessity (or, possibly, we provide the filesystem type too).
> > 
> > And we now also have FS_IOC_FSGETXATTR that extends the flags
> > and information userspace can get from filesystems.
> 
> Btw, can you point me at the manpage that defines the fsxattr struct and its
> flags?

man xfsctl is the original source. However, ....

> Also, ioctl_list(2) should probably include FS_IOC_FS[GS]ETXATTR.

... I thought patches had been sent to Michael to document them at
the VFS ioctl level. maybe I confused it with something else.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
