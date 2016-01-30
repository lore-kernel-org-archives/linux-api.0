From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR
 promotion
Date: Fri, 29 Jan 2016 23:41:51 -0500
Message-ID: <20160130044151.GA5925@thunk.org>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <1442146833-13652-4-git-send-email-lixi@ddn.com>
 <20160103230534.GE6682@dastard>
 <CAJhHMCAvTJj=bX=uE1oK+DzG8aGNGvM-BkY83+H4BgzQiNBa+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJhHMCAvTJj=bX=uE1oK+DzG8aGNGvM-BkY83+H4BgzQiNBa+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:OVERLAYFS FILESYSTEM" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 29, 2016 at 07:56:44PM -0500, Pranith Kumar wrote:
>=20
> This commit breaks building latest qemu as follows:

Well, this commit moves where the fsxattr struct is around, but the
header files that gcc is complaining about here:

> In file included from /usr/include/xfs/xfs.h:58:0,
>                  from /home/pranith/qemu/block/raw-posix.c:96:
> /usr/include/xfs/xfs_fs.h:42:8: error: redefinition of =E2=80=98struc=
t fsxattr=E2=80=99
>  struct fsxattr {
>         ^
> In file included from /home/pranith/qemu/block/raw-posix.c:59:0:
> /usr/include/linux/fs.h:155:8: note: originally defined here
>  struct fsxattr {
>         ^
> /home/pranith/qemu/rules.mak:57: recipe for target 'block/raw-posix.o=
' failed

are userspace header files in /usr/include, and so the problem isn't
in the kernel, but how the userspace header files have been set up.

You didn't say what distribution you are using, but I suspect what's
going on is that you are getting /usr/include/xfs/xfs_fs.h from the
xfsprogs package, while the /usr/include/linux/fs.h is getting derived
from the include/uapi/linux/fs.h file from the kernel header files.

So the issue is that these two header files are out of sync.  It's
because of issues like this that I'm not a fan of updating the kernel
header files whenever I install a newer kernel version.

So on my Debain system, I don't update linux-libc-dev when I install a
new upstream kernel built using "make deb-pkg".  I'll still a new
version of the linux-image-*.deb file, and maybe a newer version of
linux-firmware-*.dev, but I don't bother installing the
linux-headers-*.deb file (since I don't compile external kernel
modules), and I don't bother installing linux-libc-dev-*.deb (because
of situations like this, where the userspace include files need ot be
updated in sync, and this should be the distribution's problem to
handle).

Cheers,

						- Ted
