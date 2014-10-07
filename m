From: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Date: Tue, 7 Oct 2014 23:44:35 +0400
Message-ID: <20141007194434.GA19745@paralelels.com>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <20141007133039.GG7996@ZenIV.linux.org.uk>
 <20141007133339.GH7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141007133339.GH7996-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 07, 2014 at 02:33:39PM +0100, Al Viro wrote:
> On Tue, Oct 07, 2014 at 02:30:40PM +0100, Al Viro wrote:
> > On Tue, Oct 07, 2014 at 04:12:57PM +0400, Andrey Vagin wrote:
> > > Another problem is that rootfs can't be hidden from a container, because
> > > rootfs can't be moved or umounted.
> > 
> > ... which is a bug in mntns_install(), AFAICS.
> 
> Ability to get to exposed rootfs, that is.
> 
> > > Here is an example how to get access to rootfs:
> > > fd = open("/proc/self/ns/mnt", O_RDONLY)
> > > umount2("/", MNT_DETACH);
> > > setns(fd, CLONE_NEWNS)
> > > 
> > > rootfs may contain data, which should not be avaliable in CT-s.
> > 
> > Indeed.
> 
> ... and it looks like the above is what your mangled reproducer in previous
> patch had been made of -
> 	fd = open("/proc/self/ns/mnt", O_RDONLY)
> 	umount2("/", MNT_DETACH);
> 	setns(fd, CLONE_NEWNS)
> 	umount2("/", MNT_DETACH);
> 
> IMO what it shows is setns() bug.  This "switch root/cwd, no matter what"
> is wrong.

How can we move in another namespace without this "switch"? If the task
root and cwd isn't switched, they points to the old tree. In this case
how can we open something from the new tree?

Do you mean that root should not be changed if it points on a detached
mount or on a mount from another mount namespace? This looks reasonable.
