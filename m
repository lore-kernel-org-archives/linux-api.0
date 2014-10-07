From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
Date: Tue, 07 Oct 2014 13:30:57 -0700
Message-ID: <87r3yjy64e.fsf@x220.int.ebiederm.org>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
	<20141007133039.GG7996@ZenIV.linux.org.uk>
	<20141007133339.GH7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141007133339.GH7996-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org> (Al Viro's message of
	"Tue, 7 Oct 2014 14:33:39 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org> writes:

2> On Tue, Oct 07, 2014 at 02:30:40PM +0100, Al Viro wrote:
>> On Tue, Oct 07, 2014 at 04:12:57PM +0400, Andrey Vagin wrote:
>> > Another problem is that rootfs can't be hidden from a container, because
>> > rootfs can't be moved or umounted.
>> 
>> ... which is a bug in mntns_install(), AFAICS.
>
> Ability to get to exposed rootfs, that is.

The container side of this argument is pretty bogus.  It only applies
if user namespaces are not used for the container.

So it is only root (and not root in a container) who can get to the
exposed rootfs.

I have a vague memory someone actually had a real use in miminal systems
for being able to get back to the rootfs and being able to use rootfs as
the rootfs.  There was even a patch at that time that Andrew Morton was
carrying for a time to allow unmounting root and get at rootfs, and to
prevent the oops on rootfs unmount in some way.

So not only do I not think it is a bug to get back too rootfs, I think
it is a feature that some people have expressed at least half-way sane
uses for.

>> > Here is an example how to get access to rootfs:
>> > fd = open("/proc/self/ns/mnt", O_RDONLY)
>> > umount2("/", MNT_DETACH);
>> > setns(fd, CLONE_NEWNS)
>> > 
>> > rootfs may contain data, which should not be avaliable in CT-s.
>> 
>> Indeed.
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

IMO the bug is allowing us to unmount things that should never be unmounted.

In a mount namespace created with just user namespace permissions we
can't get at rootfs because MNT_LOCKED is set on the root directory
and thus it can not be mounted.

Further if anyone has permission to call chroot and chdir on any mount
in a mount namespace (that isn't currently covered) they can get at all
of them that are not currently covered.  A mount namespace where no one
can get at any uncovered filesystem seems to be the definition of
useless and ridiculous.


Now there is a bug in that MNT_DETACH today does not currently enforce
MNT_LOCKED on submounts of the mount point that is detached. I am
currently looking at how to construct the appropriate permission check
to prevent that.  Unfortunately I can not disallow MNT_DETACH with
submounts all together as that breaks too many legitimate uses.

That failure to enforce MNT_LOCKED is my mistake. I had a naive notion
that submounts would remain mounted after a mount detach and I misread
the code when I did the original work.  My mistake. 

Eric
