From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe as bind mounts (take 2)
Date: Thu, 28 May 2015 23:36:08 -0500
Message-ID: <87fv6g80g7.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<87siaxuvik.fsf@x220.int.ebiederm.org>
	<87wq004im1.fsf@x220.int.ebiederm.org>
	<CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
	<20150528140839.GD28842@ubuntumail>
	<87lhg8pwvz.fsf@x220.int.ebiederm.org>
	<CALCETrXXax28s9kMTQ-zDx0MttQWG4rg2y-oz3bSGiumSL=3sg@mail.gmail.com>
	<CAOP=4wid+N_80iyPpiVMN96_fuHZZRGtYQ6AOPn-HFBj2H6Vgg@mail.gmail.com>
	<87fv6gikfn.fsf@x220.int.ebiederm.org>
	<CALCETrXO21Y7PR=pKqaqJb1YZArNyjAv7Z-J44O53FcfLM_0Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXO21Y7PR=pKqaqJb1YZArNyjAv7Z-J44O53FcfLM_0Tw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Thu, 28 May 2015 17:35:03 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
> On May 28, 2015 12:19 PM, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org> writes:
>>
>> We do need to enforce retaining the existing mount flags one way or
>> another.  Where this really matters is with MS_RDONLY.  We don't want
>> any old user to be able to mount /proc read-write when root mounted it
>> read-only.  There is a very real attack vector there.  That attack
>> almost works in docker container today and is avoided simply because
>> docker mounts over a few files on proc.
>
> You could drop the nosuid, noexec, and nodev changes and keep just the
> ro part.  The ro part is probably not an ABI break in the sense of
> something that actually breaks real programs.

As a change simply removing the code from the existing patches that
worries about nosuid, noexec, and the nodev flags is certainly doable.
It is the best proposal I have heard so far.

I remain unconvinced about ignoring those flags:
- There are clearly people who think it matters (or else proc and sysfs
  would not have those flags specified).

- There have been times when it actually has mattered.
  Aka when files like /proc/self/env could be chmodded and used for
  privilege escalation.

- The code in lxc and libvirt-lxc so far has been clearly buggy.
  * lxc only has problems with sysfs (in some configurations).
  * libvirt-lxc only has problems on a bind mount remount of
    proc after remounting proc properly.

So I am leaning towards enforcing all of the mount flags including
nosuid, noexec, and nodev.  Then when the next subtle bug in proc or
sysfs with respect to chmod shows up I will be able to sleep soundly at
night because the mount flags of those filesystems allow a mitigation,
and I did not sabatage the mitigation.

Plus contemplating code that just enforces a couple of mount flags but
not all of the feels wrong.

I don't think it is actually a maintainable position to just enforce a
couple of those flags.  If nothing else I would expect someone to look
at the code and to generate a bug fix to start enforcing the rest of the
flags.  Or perhaps it is in a few years time and something gets
refactored and the enforcing starts happening by virtue of using a new
common function that no-one realizes will be a problem.

Additionally if we don't enforce nosuid, noexec, and nodev people are
going to ask questions, that will be hard to explain.  When what is
truly desirable is to say that sysfs and proc are a little odd but they
don't allow anything that a bind mount won't.

I can be persuaded otherwise but right now I do think the kernel code
needs to enforce nosuid, noexec, and nodev as it is a security issue (if
only a defence in depth one), and a maintenance issue as I do not
believe in the long term it is a maintanable or an explicable position.

>> > Speaking as a user of the mount() interfaces, I really think it would
>> > be less confusing overall if mount() simply ignored the requested
>> > flags when the caller doesn't have a choice. That is, in cases where
>> > mount() currently fails with EPERM when not given, say, MS_NOSUID, it
>> > should instead just pretend the caller actually set MS_NOSUID and go
>> > ahead with a nosuid mount. Or put another way, the absence of
>> > MS_NOSUID should not be interpreted as "remove the nosuid bit" but
>> > rather "don't set the nosuid bit if not required".
>>
>> I am conflicted.  Implicits are nice but confusing.  If we can do
>> something reliable and robust and maintainable here that is truly worth
>> the cost I am all for it.
>>
>> If I mount proc read-write I likely want to be able to write to proc
>> files, and I will be much happier if the mount fails than if a bazillion
>> syscalls later something else fails when it tries to write to proc.
>
> I agree.  I don't like the implicit thing.

My memory returns of our last round of looking at this and for whatever
it's warts the existing mount API for remounting filesystems needs to
have the flags have exactly the same meaning as at mount time.  There
are existing userspace applications that depend on that behavior.

Implicits for only the locked mount flags is a little different but
still ick.

Eric
