From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
Date: Wed, 08 Oct 2014 12:23:52 -0700
Message-ID: <87vbnue56f.fsf@x220.int.ebiederm.org>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
	<87mw97wqvx.fsf@x220.int.ebiederm.org>
	<20141008110829.GC24908@paralelels.com>
	<CALCETrX4XrgbQNZZa7=1009KqhJ2gT+VBUkC15+59K9yEiTSbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrX4XrgbQNZZa7=1009KqhJ2gT+VBUkC15+59K9yEiTSbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Wed, 8 Oct 2014 08:35:22 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Wed, Oct 8, 2014 at 4:08 AM, Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>> On Tue, Oct 07, 2014 at 01:45:22PM -0700, Eric W. Biederman wrote:
>>> Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:
>>>
>>> > From: Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> >
>>> > Currently when we create a new container with a separate root,
>>> > we need to clone the current mount namespace with all mounts and then
>>> > clean up it by using pivot_root(). A big part of mountpoints are cloned
>>> > only to be umounted.
>>>
>>> Is the motivation performance?  Because if that is the motivation we
>>> need numbers.
>>
>> The major motivation to create a clean mount namespace which contains
>> only required mounts.
>>
>> Now you want to convince us that there is nothing wrong if we use
>> userns, because all inherited mounts are locked. My point is that all
>> useless mounts should be umounted.  If the current root isn't on rootfs,
>> pivot_root() allows us to umount all useless points. But pivot_root()
>> doesn't work, if the current root is on rootfs. How can we umount
>> useless points in this case?

One of your justifications for a new system call was so you could do
less.  Doing less to get to where you want to go is only justified when
your doing less to get better performance.

It sounds like your actual concern is about sandboxing and security
audits.  That is a very legitimate concern.  That isn't however the core
concern of containers, so it was not clear that is what you meant.

>> Maybe we want to say that rootfs should not be used if we are going to
>> create containers...

Today it is an assumption of the vfs that rootfs is mounted.  With
rootfs mounted and pivot_root at the base of the mount stack you can
make as minimal of a set of mounts as the vfs allows.

Removing rootfs from the vfs requires an audit of everything that
manipulates mounts.  It is not remotely a local excercise.

One of the things that needs to be considered is that if you really want
to audit mounts is the code that needs manipulates them needs to be
audited every bit as much as the mounts themselves.

> Could we have an extra rootfs-like fs that is always completely empty,
> doesn't allow any writes, and can sit at the bottom of container
> namespace hierarchies?  If so, and if we add a new syscall that's like
> pivot_root (or unshare) but prunes the hierarchy, then we could switch
> to that rootfs then.

Or equally have something that guarantees that rootfs is empty and
read-only at the time the normal root filesystem is mounted.  That is
certainly a much more localized change if we want to go there.

I am half tempted to suggest that mount --move /some/path / be updated
to make the old / just go away (perhaps to be replaced with a read-only
empty rootfs).  That gets us into figuring out if we break userspace
which is a big challenge.

Eric
