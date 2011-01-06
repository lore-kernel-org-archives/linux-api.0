From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/5] add metadata_incore ioctl in vfs
Date: Thu, 06 Jan 2011 09:13:57 +0800
Message-ID: <1294276437.1949.578.camel@sli10-conroe>
References: <1294119632.1949.366.camel@sli10-conroe>
	 <201101041040.31482.arnd@arndb.de> <1294193836.1949.384.camel@sli10-conroe>
	 <201101051042.37181.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201101051042.37181.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2011-01-05 at 17:42 +0800, Arnd Bergmann wrote:
> On Wednesday 05 January 2011 03:17:16 Shaohua Li wrote:
> > On Tue, 2011-01-04 at 17:40 +0800, Arnd Bergmann wrote:
> > 
> > > Have you tried passing just a single metadata_incore_ent
> > > at the ioctl and looping in user space? I would guess the
> > > extra overhead of that would be small enough, but that might
> > > need to be measured.
> > metadata usually isn't continuous, so this means we have a lot of
> > metadata_incore_ent entries. And this is called at boot time and I want
> > to make the overhead as low as possible to not impact boot. Unless there
> > are certain reasons we can't use indirect pointers, I'd like to make
> > kernel return a vector of entries.
> 
> It's not a strict rule, but the indirect data passing is rather
> ugly and I'd only do that if the difference can be /measured/.
> 
> If the purpose is to speed up boot time by preloading metadata,
> the FIMETADATA_INCORE operations should of course not take a
> significant amount of time compared to the actual preloading,
> but as long as it's less than one percent of the time you need
> for the preload, I would just use the simpler interface.
ok, just have a measurement, the overhead is acceptable. I'll change the
code to just accept one entry.

> > @@ -882,6 +882,7 @@ COMPATIBLE_IOCTL(FIGETBSZ)
> >  /* 'X' - originally XFS but some now in the VFS */
> >  COMPATIBLE_IOCTL(FIFREEZE)
> >  COMPATIBLE_IOCTL(FITHAW)
> > +COMPATIBLE_IOCTL(FIMETADATA_INCORE)
> >  COMPATIBLE_IOCTL(KDGETKEYCODE)
> >  COMPATIBLE_IOCTL(KDSETKEYCODE)
> >  COMPATIBLE_IOCTL(KDGKBTYPE)
> 
> This change can go away as well.
I don't understand. adding a case statement in compat_sys_ioctl, so we will do
compat_ioctl_check_table(). If I add COMPATIBLE_IOCTL(), then the check
will success, we will go to the found_handler code path and execute
do_vfs_ioctl, which is what we want. if not adding COMPATIBLE_IOCTL(),
the check will fail, and in any case, we will go to the out_fput code
path, so our ioctl does nothing.

> Two more general comments:
> 
> - You probably want to add the ioctls to file_ioctl instead of do_vfs_ioctl,
>   so you don't add another case statement to the common path.
> 
> - I don't know if there are any rules for what should be an ioctl or an
>   fcntl, we're rather inconsistent about this. If you have found a good
>   reason for making it an ioctl, just put that into the changelog so we
>   can refer to it next time.
it can be applied to a directory too. I thought file_ioctl or fcntl is
for file.

Thanks,
Shaohua
