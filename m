From: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Date: Wed, 8 Oct 2014 15:08:30 +0400
Message-ID: <20141008110829.GC24908@paralelels.com>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <87mw97wqvx.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mw97wqvx.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 07, 2014 at 01:45:22PM -0700, Eric W. Biederman wrote:
> Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:
> 
> > From: Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> > Currently when we create a new container with a separate root,
> > we need to clone the current mount namespace with all mounts and then
> > clean up it by using pivot_root(). A big part of mountpoints are cloned
> > only to be umounted.
> 
> Is the motivation performance?  Because if that is the motivation we
> need numbers.

The major motivation to create a clean mount namespace which contains
only required mounts.

Now you want to convince us that there is nothing wrong if we use
userns, because all inherited mounts are locked. My point is that all
useless mounts should be umounted.  If the current root isn't on rootfs,
pivot_root() allows us to umount all useless points. But pivot_root()
doesn't work, if the current root is on rootfs. How can we umount
useless points in this case?

Maybe we want to say that rootfs should not be used if we are going to
create containers...

Thanks,
Andrew
