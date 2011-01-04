From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v2 3/5]add metadata_readahead ioctl in vfs
Date: Tue, 4 Jan 2011 10:51:13 +0100
Message-ID: <201101041051.13979.arnd@arndb.de>
References: <1294119637.1949.368.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294119637.1949.368.camel@sli10-conroe>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 04 January 2011 06:40:37 Shaohua Li wrote:
>  /*
>   * When you add any new common ioctls to the switches above and below
>   * please update compat_sys_ioctl() too.
> @@ -664,6 +682,9 @@ int do_vfs_ioctl(struct file *filp, unsi
>         case FIMETADATA_INCORE:
>                 return ioctl_metadata_incore(filp, argp);
>  
> +       case FIMETADATA_READAHEAD:
> +               return ioctl_metadata_readahead(filp, argp);
> +
>         default:
>                 if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
>                         error = file_ioctl(filp, cmd, arg);

Did you notice the comment above the function? ;-)

You should really add the new ioctls to compat_sys_ioctl, not
to the COMPATIBLE_IOCTL() list, in order to make the behavior
consistent between 32 and 64 bit user space. The main difference
is that all ioctl commands that are hardcoded in the functions
get called before trying to call the file system specific
.ioctl method.

> +struct metadata_readahead_args {
> +       __u64 offset;
> +       __u64 size;
> +};
> +
>  #define NR_FILE  8192  /* this can well be larger on a larger system */
>  
>  #define MAY_EXEC 1
> @@ -338,6 +343,7 @@ struct metadata_incore_args {
>  #define FITHAW         _IOWR('X', 120, int)    /* Thaw */
>  #define FITRIM         _IOWR('X', 121, struct fstrim_range)    /* Trim */
>  #define FIMETADATA_INCORE _IOWR('X', 122, struct metadata_incore_args)
> +#define FIMETADATA_READAHEAD _IOR('X', 123, struct metadata_readahead_args)

This should be _IOW, not _IOR.

Otherwise looks good.

	Arnd
