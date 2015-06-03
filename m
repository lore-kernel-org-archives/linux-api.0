From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe as bind mounts (take 2)
Date: Wed, 03 Jun 2015 16:13:21 -0500
Message-ID: <87k2vkebri.fsf@x220.int.ebiederm.org>
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
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVEA0Ug+3aj5rjupqZub-1tPLw+szzbs4kTyEyVvNs7qg@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 29 May 2015 10:49:59 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kenton Varda <kenton@sandstorm.io>, Serge Hallyn <serge.hallyn@ubuntu.com>, Seth Forshee <seth.forshee@canonical.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Richard Weinberger <richard@nod.at>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> One option would be to break the nosuid, nodev, and noexec parts into
> their own patch and then avoid tagging that patch for -stable if at
> all possible.  It would be nice to avoid another -stable ABI break if
> at all possible.

So I don't think we actually have anything that could be called an ABI
break in the whole mess, but it is definitely a behavioral change that
is a regression for lxc and libvirt-lxc that prevents them from starting.

nodev does not actually matter because of the implicit silliness that
is being added right now.

We do want those programs fixed and after those programs are fixed we
can safely begin failing mount when those attributes are being cleared
in a fresh mount.

So it looks to me like the best thing to do is to print a warning
whenever lxc or libvirt-lxc gets it wrong, which should ensure the
authors are sufficiently pestered that in a kernel release or 3 we can
begin enforcing those attributes.  Especially as the discussion on the
fix for those applications has already begun.

And if folks would double check the patch I am going to post in a moment
to ensure that lxc and libvirt-lxc continue to start I would appreciate it.

Eric



