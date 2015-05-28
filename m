From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe as bind mounts (take 2)
Date: Thu, 28 May 2015 14:14:20 -0500
Message-ID: <87fv6gikfn.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<87siaxuvik.fsf@x220.int.ebiederm.org>
	<87wq004im1.fsf@x220.int.ebiederm.org>
	<CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
	<20150528140839.GD28842@ubuntumail>
	<87lhg8pwvz.fsf@x220.int.ebiederm.org>
	<CALCETrXXax28s9kMTQ-zDx0MttQWG4rg2y-oz3bSGiumSL=3sg@mail.gmail.com>
	<CAOP=4wid+N_80iyPpiVMN96_fuHZZRGtYQ6AOPn-HFBj2H6Vgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOP=4wid+N_80iyPpiVMN96_fuHZZRGtYQ6AOPn-HFBj2H6Vgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Kenton Varda's message of "Thu, 28 May 2015 11:20:07 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org> writes:

> On Thu, May 28, 2015 at 10:33 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Thu, May 28, 2015 at 8:03 AM, Eric W. Biederman
>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>> Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
>>>
>>>> Quoting Andy Lutomirski (luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org):
>>>>> On Fri, May 22, 2015 at 10:39 AM, Eric W. Biederman
>>>>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>>>> > I had hoped to get some Tested-By's on that patch series.
>>>>>
>>>>> Sorry, I've been totally swamped.
>>>>>
>>>>> I suspect that Sandstorm is okay, but I haven't had a chance to test
>>>>> it for real.  Sandstorm makes only limited use of proc and sysfs in
>>>>> containers, but I'll see if I can test it for real this weekend.
>>>>
>>>> Testing this with unprivileged containers, I get
>>>>
>>>> lxc-start: conf.c: lxc_mount_auto_mounts: 808 Operation not permitted
>>>> - error mounting sysfs on
>>>> /usr/lib/x86_64-linux-gnu/lxc/sys/devices/virtual/net flags 0
>>>
>>> Grr..  I was afraid this would break something. :(
>>>
>>> Looking at my system I see that sysfs is currently mounted
>>> "nosuid,nodev,noexec"
>>>
>>> Looking at the lxc-start code I don't see it as including any of those
>>> mount options.  In practice for sysfs I think those options are
>>> meaningless (as there should be no devices and nothing executable in
>>> sysfs) but I can understand the past concerns with chmod on virtual
>>> filesystems that would incline people to use them, so I think the
>>> failure is reporting a legitimate security issue in the lxc userspace
>>> code where the the unprivileged code is currently attempting to give
>>> greater access to sysfs than was given by the original mount of sysfs.
>>>
>>> As nosuid,nodev,noexec should not impair the operation of sysfs
>>> operation it looks like you can always specify those options and just
>>> make this concern go away.
>>
>> Linus is pretty strict about not breaking the ABI, and this definitely
>> counts as breaking the ABI.  There's an exception for security issues,
>> but is there really a security issue here?  That is, do we lose
>> anything important if we just drop the offending part of the patch
>> set?  As you've said, there shouldn't be sensitive device nodes,
>> executables, or setuid files in proc or sysfs in the first place.

We do need to enforce retaining the existing mount flags one way or
another.  Where this really matters is with MS_RDONLY.  We don't want
any old user to be able to mount /proc read-write when root mounted it
read-only.  There is a very real attack vector there.  That attack
almost works in docker container today and is avoided simply because
docker mounts over a few files on proc.

Which leads to the second side of the reason for these changes.   I am
fixing a very small but long standing ABI break.   That is in some small
ways I broke some sandboxes and when I realized they were broken I could
not imagine think how to fix the code until now.

It is the goal that user namespaces don't introduce anything for people
to worry about security wise more than simply the ability to execute
more kernel code.  So at least when the kernel implementation is correct
developers of existing applications simply do not need care.  Sadly we are
not quite there yet.

> Speaking as a user of the mount() interfaces, I really think it would
> be less confusing overall if mount() simply ignored the requested
> flags when the caller doesn't have a choice. That is, in cases where
> mount() currently fails with EPERM when not given, say, MS_NOSUID, it
> should instead just pretend the caller actually set MS_NOSUID and go
> ahead with a nosuid mount. Or put another way, the absence of
> MS_NOSUID should not be interpreted as "remove the nosuid bit" but
> rather "don't set the nosuid bit if not required".

I am conflicted.  Implicits are nice but confusing.  If we can do
something reliable and robust and maintainable here that is truly worth
the cost I am all for it.

If I mount proc read-write I likely want to be able to write to proc
files, and I will be much happier if the mount fails than if a bazillion
syscalls later something else fails when it tries to write to proc.

> Consider:
>
> - This approach will actually cause lxc to have the correct behavior,
> without any changes to lxc. I suspect that this generalizes: In the
> vast majority of cases, when users have failed to set MS_NOSUID, it's
> not because they are explicitly requesting that the flag be turned
> off, but rather that they didn't know it mattered.
>
> - If a user actually *does* expect not passing MS_NOSUID to remove the
> nosuid bit, and they find instead that the nosuid bit is silently
> kept, I don't think they'll be confused: it's pretty obvious in
> context that this must be for security reasons.
>
> - On the other hand, the current behavior *is* very confusing: mount()
> returns EPERM because of rules the caller probably doesn't know
> anything about. I've spent a fair amount of time frustrated by this
> sort of thing.

My sympathies.  This all started with an oh crap we overlooked corner
case X and it actually matters, and the fixes were quite likely a little
bit hasty.  The only case where this really shows up is remount insode
of a user namespace of filesystems that were mounted outside of the user
namespace is where this all actually matters.  And mounting new
instances of proc and sysfs wind up being weird instances of that
nonsense.

But please someone test sandstorm with this patchset and tell me if it
bites you.  The impetus to find a way to avoid breaking slightly buggy
userspace is higher if it is more than unprivileged lxc that is broken.

Eric
