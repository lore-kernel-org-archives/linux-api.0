From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [v5 5/5] Adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface
 support for ext4
Date: Mon, 27 Oct 2014 08:56:26 +1100
Message-ID: <20141026215626.GC4317@dastard>
References: <1414300973-1118-1-git-send-email-lixi@ddn.com>
 <1414300973-1118-6-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414300973-1118-6-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Oct 26, 2014 at 01:22:53PM +0800, Li Xi wrote:
> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
> support for ext4. The interface is kept consistent with
> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.

What you haven't mentioned is that you also changed the fsxattr
interface structure to add functionality and new behaviours that
isn't supported by XFS or existing applications that use the
interface.

There is no need to modify the interface *at all* for ext4 to use
it. Fields that ext4 does not use can be zeroed on getxattr, and
ignored on setxattr - you do not need to add new fields to say what
fields are valid.

> +/*
> + * Extend attribute flags. These should be or-ed together to figure out what
> + * is valid.
> + */
> +#define FSX_XFLAGS	(1 << 0)
> +#define FSX_EXTSIZE	(1 << 1)
> +#define FSX_NEXTENTS	(1 << 2)
> +#define FSX_PROJID	(1 << 3)

They are not interface definition flags - these are internal XFS
flags to tell an internal shared function what the caller was
modifying.  I actually have a series of patches that removes them
because the internal XFS code shouldn't be shared in this way. As
such, they shouldn't be propagated into the user interface for the
ioctls....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
