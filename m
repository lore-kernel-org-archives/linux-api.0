From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v2 1/5] add metadata_incore ioctl in vfs
Date: Tue, 4 Jan 2011 10:40:31 +0100
Message-ID: <201101041040.31482.arnd@arndb.de>
References: <1294119632.1949.366.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294119632.1949.366.camel@sli10-conroe>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 04 January 2011 06:40:32 Shaohua Li wrote:

> +static int ioctl_metadata_incore(struct file *filp, void __user *argp)
> +{
> +       struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +       struct metadata_incore_args args;
> +       struct metadata_incore_ent ent;
> +       loff_t offset, last_offset = 0;
> +       ssize_t size, last_size = 0;
> +       __u64 __user vec_addr;

__user only makes sense on pointers. Just make this a "struct
metadata_incore_ent __user *", which will also take care of the
"sparse" warnings you get from the copy_to_user lines below.

>  
> +struct metadata_incore_ent {
> +       __u64 offset;
> +       __u32 size;
> +       __u32 unused;
> +};
> +
> +struct metadata_incore_args {
> +       __u64 offset; /* offset in meta address */
> +       __u64 __user vec_addr; /* vector's address */
> +       __u32 vec_size; /* vector's size */
> +       __u32 unused;
> +};

We usually try hard to avoid ioctls with indirect pointers
in them. The implementation is correct (most people
get this wrong), besides the extraneous __user keyword in
there.

Have you tried passing just a single metadata_incore_ent
at the ioctl and looping in user space? I would guess the
extra overhead of that would be small enough, but that might
need to be measured.

	Arnd
