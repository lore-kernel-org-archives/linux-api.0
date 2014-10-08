From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Date: Wed, 8 Oct 2014 15:01:34 -0700
Message-ID: <CALCETrXapWTiFw2CC1m43fs9yuHuesXxXtmHh-5F3J_bUYeRxg@mail.gmail.com>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <87mw97wqvx.fsf@x220.int.ebiederm.org> <20141008110829.GC24908@paralelels.com>
 <CALCETrX4XrgbQNZZa7=1009KqhJ2gT+VBUkC15+59K9yEiTSbQ@mail.gmail.com>
 <87vbnue56f.fsf@x220.int.ebiederm.org> <CALCETrVSxYr=Oa29qHNL-GoifS26U8TfpreGY+KN7g926YgHUw@mail.gmail.com>
 <5435AE41.20105@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5435AE41.20105@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Vagin <avagin@parallels.com>, Andrey Vagin <avagin@openvz.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Serge Hallyn <serge.hallyn@canonical.com>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 8, 2014 at 2:36 PM, Rob Landley <rob@landley.net> wrote:
> On 10/08/14 14:31, Andy Lutomirski wrote:
>> On Wed, Oct 8, 2014 at 12:23 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>> Maybe we want to say that rootfs should not be used if we are going to
>>>>> create containers...
>>>
>>> Today it is an assumption of the vfs that rootfs is mounted.  With
>>> rootfs mounted and pivot_root at the base of the mount stack you can
>>> make as minimal of a set of mounts as the vfs allows.
>>>
>>> Removing rootfs from the vfs requires an audit of everything that
>>> manipulates mounts.  It is not remotely a local excercise.
>>
>> Would it be a less invasive audit to allow different mount namespaces
>> to have different rootfses?
>
> I.E. The same way different namespaces have different init tasks?
>
> The abstraction containers has implemented here should be logically
> consistent.
>
>>>> Could we have an extra rootfs-like fs that is always completely empty,
>>>> doesn't allow any writes, and can sit at the bottom of container
>>>> namespace hierarchies?  If so, and if we add a new syscall that's like
>>>> pivot_root (or unshare) but prunes the hierarchy, then we could switch
>>>> to that rootfs then.
>>>
>>> Or equally have something that guarantees that rootfs is empty and
>>> read-only at the time the normal root filesystem is mounted.  That is
>>> certainly a much more localized change if we want to go there.
>>>
>>> I am half tempted to suggest that mount --move /some/path / be updated
>>> to make the old / just go away (perhaps to be replaced with a read-only
>>> empty rootfs).  That gets us into figuring out if we break userspace
>>> which is a big challenge.
>>
>> Hence my argument for a new syscall or entirely new operation.
>
> I'm still waiting for somebody to explain to my why chroot() shouldn't
> be changed to do this instead of adding a new syscall. (At least when
> mount namespace support is enabled.)

Because chroot has no effect on the namespace at all.  If you fork and
the child chroots, the parent isn't chrooted.  And, more importantly
for my example, is a process has it's cwd as /foo, and then it forks
and the child chroots, then parent's ".." isn't changed as a result of
the chroot.

>
>> mount(2) and friends are way too multiplexed right now.  I just found
>> yet another security bug due to the insanely complicated semantics of
>> the vfs syscalls.  (Yes, a different one from the one yesterday.)
>
> As the guy who rewrote busybox mount 3 times, and who just implemented a
> brand new one (toybox) from scratch:
>
> It's a bit fiddly, yes.
>
>> A new operation kills several birds with one stone.  It could look like:
>>
>> int mntns_change_root(int dfd, const char *path, int flags);
>>
>> return -EPERM if chrooted.
>
> Really?

Now that CVE-2014-7970 is public: what the heck is pivot_root supposed
to do if the caller is chrooted?  The current behavior is obviously
incorrect (it leaks memory), but it's not entirely clear to me what
should happen.  I think it should either be disallowed or should have
well-defined semantics.

For simplicity, if a new syscall for this is added, then I think that
the caller-is-chrooted case should be disallowed.  If someone needs it
and can articulate what the semantics should be, then I have no
problem with allowing it going forward.

>
>>  Returns -EINVAL if path (relative to dfd) isn't a mountmount.
>
> Requiring that chroot() only be called on mountpoints would break
> existing semantics, which gets us back to new systemcall instead of
> changing behavior of existing one.

But we're talking about a pivot_root replacement.  You can always
create a bindmount.  Alternatively, the syscall could create a fresh
bind-mount and reattach all children to it if needed.

>
> If I recall, the first line of pushback against merging the openvz code
> as is was "buckets of new syscalls". Pushback against adding a new
> system call is understandable. Why can't we fix chroot() now that we
> have the tools to do so?

Because chroot already does something else.  In particularly, the new
"root"'s parents are *still there*, which is why it's so easy to
escape from a chroot.  Sensible container systems (and initramfs
code!) wants to clean up all the mounts that should be unreachable.

>
>>  Otherwise it disconnects path from the existing
>> hierarchy, attaches a permanently-empty read-only rootfs under it,
>> makes it the root of the mntns, and does the root refs fixup.  The old
>> hierarchy gets thrown out.
>
> We have a chroot() syscall. We don't use it for containers because it
> doesn't do what we want. Does it currently do what _anybody_ wants?

Irrelevant.  It's POSIX and we'll break all kinds of things if we change it.

>
>> Systemd could use this, too.
>
> While that's a strong argument against it, I'm willing to overlook it.

:)

Feel free to read that as "an initramfs /init that prepares to hand
off to /sbin/init could use this."  busybox's switch_root could do
this, too, and even my virtme tool would indirectly benefit slightly.
(virtme uses an init system that is a few tens of lines of
busybox-compatible shell script that runs in a highly controlled
environment.)

--Andy
