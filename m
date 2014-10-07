From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
Date: Tue, 07 Oct 2014 14:50:47 -0700
Message-ID: <87zjd7pn0o.fsf@x220.int.ebiederm.org>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
	<20141007133039.GG7996@ZenIV.linux.org.uk>
	<20141007133339.GH7996@ZenIV.linux.org.uk>
	<87r3yjy64e.fsf@x220.int.ebiederm.org>
	<CALCETrXgssZfi3BirQ=K7-vrPyEh5AzFX2pF+yj76Ngi0sf7Yw@mail.gmail.com>
	<87siizshav.fsf@x220.int.ebiederm.org>
	<CALCETrWfZwbGCxnUAg0PnM=tN8MGRQkHrJVC42bVF7sdJKXLmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWfZwbGCxnUAg0PnM=tN8MGRQkHrJVC42bVF7sdJKXLmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Tue, 7 Oct 2014 14:38:06 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Tue, Oct 7, 2014 at 2:26 PM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>>
>>> Why should MNT_LOCKED on submounts be enforced?
>>>
>>> Is it because, if you retain a reference to the detached tree, then
>>> you can see under the submounts?
>>
>> Yes. MNT_DETACH is a recursive operation that detaches all of the mount
>> and all of it's submounts.  Which means you can see under the submounts
>> if you have a reference to a detached mount.
>>
>>> If so, let's fix *that*.  Because
>>> otherwise the whole model of pivot_root + detach will break.
>>
>> I am not certain what you are referring to.  pivot_root doesn't
>> manipulate the mount tree so you can see under anything.
>>
>> What I believe is the appropriate fix is to fail umount2(...,MNT_DETACH)
>> if there are any referenced mount points being detached that have a
>> locked submount.
>
> Most of the container-using things do, roughly:
>
> Unshare userns and mountns
> Mount some new stuff
> pivot_root to the new stuff
> MNT_DETACH the old.
>
> That last step will almost always fail if you make this change.

I don't think so.

I expect I could add full busy detection of normal umounts and those
applications would not fail.

What I am proposing is a more targeted version of busy detection that
looks at each mount in the set that detach will unmount.  For each mount
if it is busy with non-submount references and it has at least one
locked submount fail the detach with -EBUSY.

Do you really think we have userspace references to the one or more of the
mounts under old?

Eric
