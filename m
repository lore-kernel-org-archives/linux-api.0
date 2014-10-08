From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Date: Wed, 8 Oct 2014 12:31:50 -0700
Message-ID: <CALCETrVSxYr=Oa29qHNL-GoifS26U8TfpreGY+KN7g926YgHUw@mail.gmail.com>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <87mw97wqvx.fsf@x220.int.ebiederm.org> <20141008110829.GC24908@paralelels.com>
 <CALCETrX4XrgbQNZZa7=1009KqhJ2gT+VBUkC15+59K9yEiTSbQ@mail.gmail.com> <87vbnue56f.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87vbnue56f.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Vagin <avagin@parallels.com>, Andrey Vagin <avagin@openvz.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Serge Hallyn <serge.hallyn@canonical.com>, Rob Landley <rob@landley.net>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 8, 2014 at 12:23 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> On Wed, Oct 8, 2014 at 4:08 AM, Andrew Vagin <avagin@parallels.com> wrote:
>>> On Tue, Oct 07, 2014 at 01:45:22PM -0700, Eric W. Biederman wrote:
>>>> Andrey Vagin <avagin@openvz.org> writes:
>>>>
>>>> > From: Andrey Vagin <avagin@gmail.com>
>>>> >
>>>> > Currently when we create a new container with a separate root,
>>>> > we need to clone the current mount namespace with all mounts and then
>>>> > clean up it by using pivot_root(). A big part of mountpoints are cloned
>>>> > only to be umounted.
>>>>
>>>> Is the motivation performance?  Because if that is the motivation we
>>>> need numbers.
>>>
>>> The major motivation to create a clean mount namespace which contains
>>> only required mounts.
>>>
>>> Now you want to convince us that there is nothing wrong if we use
>>> userns, because all inherited mounts are locked. My point is that all
>>> useless mounts should be umounted.  If the current root isn't on rootfs,
>>> pivot_root() allows us to umount all useless points. But pivot_root()
>>> doesn't work, if the current root is on rootfs. How can we umount
>>> useless points in this case?
>
> One of your justifications for a new system call was so you could do
> less.  Doing less to get to where you want to go is only justified when
> your doing less to get better performance.
>
> It sounds like your actual concern is about sandboxing and security
> audits.  That is a very legitimate concern.  That isn't however the core
> concern of containers, so it was not clear that is what you meant.
>
>>> Maybe we want to say that rootfs should not be used if we are going to
>>> create containers...
>
> Today it is an assumption of the vfs that rootfs is mounted.  With
> rootfs mounted and pivot_root at the base of the mount stack you can
> make as minimal of a set of mounts as the vfs allows.
>
> Removing rootfs from the vfs requires an audit of everything that
> manipulates mounts.  It is not remotely a local excercise.

Would it be a less invasive audit to allow different mount namespaces
to have different rootfses?

>
> One of the things that needs to be considered is that if you really want
> to audit mounts is the code that needs manipulates them needs to be
> audited every bit as much as the mounts themselves.
>
>> Could we have an extra rootfs-like fs that is always completely empty,
>> doesn't allow any writes, and can sit at the bottom of container
>> namespace hierarchies?  If so, and if we add a new syscall that's like
>> pivot_root (or unshare) but prunes the hierarchy, then we could switch
>> to that rootfs then.
>
> Or equally have something that guarantees that rootfs is empty and
> read-only at the time the normal root filesystem is mounted.  That is
> certainly a much more localized change if we want to go there.
>
> I am half tempted to suggest that mount --move /some/path / be updated
> to make the old / just go away (perhaps to be replaced with a read-only
> empty rootfs).  That gets us into figuring out if we break userspace
> which is a big challenge.

Hence my argument for a new syscall or entirely new operation.
mount(2) and friends are way too multiplexed right now.  I just found
yet another security bug due to the insanely complicated semantics of
the vfs syscalls.  (Yes, a different one from the one yesterday.)

A new operation kills several birds with one stone.  It could look like:

int mntns_change_root(int dfd, const char *path, int flags);

return -EPERM if chrooted.  Returns -EINVAL if path (relative to dfd)
isn't a mountmount.  Otherwise it disconnects path from the existing
hierarchy, attaches a permanently-empty read-only rootfs under it,
makes it the root of the mntns, and does the root refs fixup.  The old
hierarchy gets thrown out.

Benefits:
 - Plausibly slightly faster.  (Especially if we add the trivial
optimization that, if the caller holds the only reference to the
mntns, then changing root refs can avoid the big loop, but maybe
pivot_root could do that, too.)
 - Sidesteps the whole rootfs mess.
 - Much easier to use than pivot_root.
 - No userspace breakage.

Heck, it could be even simpler: it could just unconditionally skip the
fs struct walk.  Just require callers to make sure that everyone else
chroots into the new root.

Systemd could use this, too.  If it wants to keep a reference to the
initramfs, it can use a file descriptor.

--Andy
