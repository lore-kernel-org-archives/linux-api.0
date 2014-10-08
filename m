From: Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Date: Wed, 08 Oct 2014 16:23:09 -0500
Message-ID: <5435AB3D.3040407@landley.net>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>	<87mw97wqvx.fsf@x220.int.ebiederm.org>	<20141008110829.GC24908@paralelels.com>	<CALCETrX4XrgbQNZZa7=1009KqhJ2gT+VBUkC15+59K9yEiTSbQ@mail.gmail.com> <87vbnue56f.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87vbnue56f.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/08/14 14:23, Eric W. Biederman wrote:
>> Could we have an extra rootfs-like fs that is always completely empty,
>> doesn't allow any writes, and can sit at the bottom of container
>> namespace hierarchies?  If so, and if we add a new syscall that's like
>> pivot_root (or unshare) but prunes the hierarchy, then we could switch
>> to that rootfs then.
> 
> Or equally have something that guarantees that rootfs is empty and
> read-only at the time the normal root filesystem is mounted.  That is
> certainly a much more localized change if we want to go there.

What do you mean "normal" root filesystem? It is entirely possible (and
in fact common in the embedded world) to run from rootfs. I pushed my
old inittmpfs patches (at the request of cray) last year because being
able to take down the system with "cat /dev/zero > /blah" (as rootfs
allows and tmpfs doesn't) is a bad thing.

Rootfs is about as special as PID 1 is. We don't filter out PID 1 from
"ps" to avoid confusing people, but for some reason whoever did
/proc/$PID/mountinfo decided that rootfs shouldn't show up because magic
magic specialness.

We show /run, which is a tmpfs instance. If I mount two different
filesystems on top of each other on /mnt, it shows both. (Overmounts
were not invented by rootfs.) But no, mountinfo filters out rootfs
because magic magic specialness.

It makes me sad that this kind of special-case thinking is allowed in
the kernel.

> I am half tempted to suggest that mount --move /some/path / be updated
> to make the old / just go away (perhaps to be replaced with a read-only
> empty rootfs).  That gets us into figuring out if we break userspace
> which is a big challenge.

My concern was that chroot() moving a magic "/" pointer that you can
trivially escape from with x=open("."); chroot("sub"); fdchdir(".");
chdir("../../../../../../../../.."); is having extra code in the kernel
to do it _wrong_.

We have per-process namespaces now. We can actually adjust the mount
tree (inserting a new bind mount if the directory we're changing to is
not already a mount point). If a per-process namespace needs to be
anchored by a tmpfs, fine. But requiring that to be teh SAME instance
globally for the entire system is not what containers is _about_. It's
not true for PID 1 and it shouldn't be true for rootfs.

By all means, if a filesystem is no longer accessable in a namespace,
decrement its reference count. (Keeping in mind that a bind mount should
count as a reference, and rootfs should always have a nonzero reference
count.) But "/" is not special in this regard. If you want to make all
overmounts vanish (which seems like a really bad idea and breaks 40
years of unix semantics), argue for that. Please stop treating rootfs
like it isn't potentialy usable as a full-fledged filesystem.

(Pet peeve of mine.)

> Eric

Rob
