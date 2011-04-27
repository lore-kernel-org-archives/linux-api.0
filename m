From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Wed, 27 Apr 2011 12:33:08 -0600
Message-ID: <20110427183308.GA16716@parisc-linux.org>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1303928027-5100-1-git-send-email-andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2011 at 08:13:47PM +0200, Andrea Righi wrote:
> @@ -127,6 +128,12 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>  			invalidate_mapping_pages(mapping, start_index,
>  						end_index);
>  		break;
> +	case POSIX_FADV_DONTNEED_FS:
> +		if (capable(CAP_SYS_ADMIN))
> +			drop_pagecache_sb(file->f_dentry->d_sb, NULL);
> +		else
> +			ret = -EPERM;
> +		break;
>  	default:
>  		ret = -EINVAL;
>  	}

Mmm ... what if I open /dev/sdxyz and call fadvise() on it?  I think
you end up flushing /dev's page cache entries, instead of the filesystem
which is on /dev/sdxyz.

If I understand correctly, you want mapping->host->i_sb instead of
file->f_dentry->d_sb.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
