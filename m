From: Dave Chinner <david@fromorbit.com>
Subject: Re: [v6 4/4] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Wed, 12 Nov 2014 08:58:23 +1100
Message-ID: <20141111215823.GX23575@dastard>
References: <1415468619-31851-1-git-send-email-lixi@ddn.com>
 <1415468619-31851-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415468619-31851-5-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Sun, Nov 09, 2014 at 01:43:39AM +0800, Li Xi wrote:
> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
> support for ext4. The interface is kept consistent with
> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.

I missed somethignthe first time around, and it's to do with
fsx_flags field and what ext4 is putting in it....

> @@ -617,7 +713,45 @@ resizefs_out:
>  	}
>  	case EXT4_IOC_PRECACHE_EXTENTS:
>  		return ext4_ext_precache(inode);
> +	case EXT4_IOC_FSGETXATTR:
> +	{
> +		struct fsxattr fa;
> +
> +		memset(&fa, 0, sizeof(struct fsxattr));
> +
> +		ext4_get_inode_flags(ei);
> +		fa.fsx_xflags = ei->i_flags & EXT4_FL_USER_VISIBLE;

You're putting ext4 inode flags in this field. That's not right -
the flags that are defined for this field are the XFS_XFLAGS_*
fields, and you need to translate between the ext4 flags and the
existing falg definitions. Any falg definitions that don't already
exist that ext4 needs to support need to be added to the XFS_XFLAGS
definitions.

i.e. this is not a field that has flags defined by ext4 - the
flags must be the same across all filesystems that implement it, and
that means ext4 must use the existing definitions where they already
exist.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
