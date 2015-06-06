From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CFT][PATCH 11/10] mnt: Avoid unnecessary regressions in fs_fully_visible
Date: Sat, 06 Jun 2015 14:14:36 -0500
Message-ID: <87a8wcy7hf.fsf@x220.int.ebiederm.org>
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
	<87fv6g80g7.fsf@x220.int.ebiederm.org>
	<CALCETrVEA0Ug+3aj5rjupqZub-1tPLw+szzbs4kTyEyVvNs7qg@mail.gmail.com>
	<87k2vkebri.fsf@x220.int.ebiederm.org>
	<87eglseboh.fsf_-_@x220.int.ebiederm.org>
	<CALCETrWwtFaiaYGLoq4EPkrgcq9nEA2GseVfP3iBkbYZ8NfGPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWwtFaiaYGLoq4EPkrgcq9nEA2GseVfP3iBkbYZ8NfGPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Thu, 4 Jun 2015 17:46:35 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Wed, Jun 3, 2015 at 2:15 PM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> Not allowing programs to clear nosuid, nodev, and noexec on new mounts
>> of sysfs or proc will cause lxc and libvirt-lxc to fail to start (a
>> regression).  There are no device nodes or executables on sysfs or
>> proc today which means clearing these flags is harmless today.
>>
>> Instead of failing the fresh mounts of sysfs and proc emit a warning
>> when these flags are improprely cleared.  We only reach this point
>> because lxc and libvirt-lxc clear flags they mount flags had not
>> intended to.
>>
>> In a couple of kernel releases when lxc and libvirt-lxc have been
>> fixed we can start failing fresh mounts proc and sysfs that clear
>> nosuid, nodev and noexec.  Userspace clearly means to enforce those
>> attributes and historically they have avoided bugs.
>
> At the very least, I think this should be folded in so that the ABI
> doesn't break in the middle of the series.

Nothing in any of these patches has ever broken the ABI.  The bits have
always been interpreted with the same meaning.

I have been going back and forth on exactly the best way to handle this
because I don't like breaking working executables even for valid
reasons.

I think I have finally reach my personal peace on this issue.

Not requiring the presence of nosuid and noexec on a fresh mount of proc
and sysfs if the original mount has nosuid or noexec is a security issue
as what proc and sysfs implement in the future can not be known.

The one possible way to remedy this is to implicity add nosuid and
noexec as appropriate unfortunately that would break the ABI as it
changes the interpretation of the bits in the userspace interface, and
the day proc or sysfs changes and we honest to truly want to enable suid
exectuables on proc or sysfs we would not be able to. :( So implicitly
adding attributes is out.

As the current implementation of proc and sysfs are known I agree
it does not make sense to backport the enforcement of nosuid and
noexec.   So I have split the patch.  See my for-testing branch
and shortly my for-next branch.

It only takes two or three line patches in the affected userspace
executables, and a 5 minute test.  So a warning printk does not actually
make sense.

If the authors of lxc and libvirt-lxc have not taken the time to fix
their code by the time this code lands in a stable release (in 2 months
or so) no amount of other warnings are going to be enough.

Eric
