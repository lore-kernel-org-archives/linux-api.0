From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v2 1/5] add metadata_incore ioctl in vfs
Date: Thu, 6 Jan 2011 08:38:48 +0100
Message-ID: <201101060838.49359.arnd@arndb.de>
References: <1294119632.1949.366.camel@sli10-conroe> <201101051042.37181.arnd@arndb.de> <1294276437.1949.578.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294276437.1949.578.camel@sli10-conroe>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thursday 06 January 2011, Shaohua Li wrote:
> I don't understand. adding a case statement in compat_sys_ioctl, so we will do
> compat_ioctl_check_table(). If I add COMPATIBLE_IOCTL(), then the check
> will success, we will go to the found_handler code path and execute
> do_vfs_ioctl, which is what we want. if not adding COMPATIBLE_IOCTL(),
> the check will fail, and in any case, we will go to the out_fput code
> path, so our ioctl does nothing.

You are correct, I misremembered the code and did not check properly.

> > Two more general comments:
> > 
> > - You probably want to add the ioctls to file_ioctl instead of do_vfs_ioctl,
> >   so you don't add another case statement to the common path.
> > 
> > - I don't know if there are any rules for what should be an ioctl or an
> >   fcntl, we're rather inconsistent about this. If you have found a good
> >   reason for making it an ioctl, just put that into the changelog so we
> >   can refer to it next time.
> it can be applied to a directory too. I thought file_ioctl or fcntl is
> for file.

Right again, good point!

	Arnd
