From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe as
 bind mounts (take 2)
Date: Thu, 28 May 2015 17:35:03 -0700
Message-ID: <CALCETrXO21Y7PR=pKqaqJb1YZArNyjAv7Z-J44O53FcfLM_0Tw@mail.gmail.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org> <87siaxuvik.fsf@x220.int.ebiederm.org>
 <87wq004im1.fsf@x220.int.ebiederm.org> <CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
 <20150528140839.GD28842@ubuntumail> <87lhg8pwvz.fsf@x220.int.ebiederm.org>
 <CALCETrXXax28s9kMTQ-zDx0MttQWG4rg2y-oz3bSGiumSL=3sg@mail.gmail.com>
 <CAOP=4wid+N_80iyPpiVMN96_fuHZZRGtYQ6AOPn-HFBj2H6Vgg@mail.gmail.com> <87fv6gikfn.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87fv6gikfn.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kenton Varda <kenton@sandstorm.io>, Serge Hallyn <serge.hallyn@ubuntu.com>, Seth Forshee <seth.forshee@canonical.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Richard Weinberger <richard@nod.at>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

[resend due to HTML. Sorry.]


On May 28, 2015 12:19 PM, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>
> Kenton Varda <kenton@sandstorm.io> writes:
>
> > On Thu, May 28, 2015 at 10:33 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> >> On Thu, May 28, 2015 at 8:03 AM, Eric W. Biederman
> >> <ebiederm@xmission.com> wrote:
> >>> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> >>>
> >>>> Quoting Andy Lutomirski (luto@amacapital.net):
> >>>>> On Fri, May 22, 2015 at 10:39 AM, Eric W. Biederman
> >>>>> <ebiederm@xmission.com> wrote:
> >>>>> > I had hoped to get some Tested-By's on that patch series.
> >>>>>
> >>>>> Sorry, I've been totally swamped.
> >>>>>
> >>>>> I suspect that Sandstorm is okay, but I haven't had a chance to test
> >>>>> it for real.  Sandstorm makes only limited use of proc and sysfs in
> >>>>> containers, but I'll see if I can test it for real this weekend.
> >>>>
> >>>> Testing this with unprivileged containers, I get
> >>>>
> >>>> lxc-start: conf.c: lxc_mount_auto_mounts: 808 Operation not permitted
> >>>> - error mounting sysfs on
> >>>> /usr/lib/x86_64-linux-gnu/lxc/sys/devices/virtual/net flags 0
> >>>
> >>> Grr..  I was afraid this would break something. :(
> >>>
> >>> Looking at my system I see that sysfs is currently mounted
> >>> "nosuid,nodev,noexec"
> >>>
> >>> Looking at the lxc-start code I don't see it as including any of those
> >>> mount options.  In practice for sysfs I think those options are
> >>> meaningless (as there should be no devices and nothing executable in
> >>> sysfs) but I can understand the past concerns with chmod on virtual
> >>> filesystems that would incline people to use them, so I think the
> >>> failure is reporting a legitimate security issue in the lxc userspace
> >>> code where the the unprivileged code is currently attempting to give
> >>> greater access to sysfs than was given by the original mount of sysfs.
> >>>
> >>> As nosuid,nodev,noexec should not impair the operation of sysfs
> >>> operation it looks like you can always specify those options and just
> >>> make this concern go away.
> >>
> >> Linus is pretty strict about not breaking the ABI, and this definitely
> >> counts as breaking the ABI.  There's an exception for security issues,
> >> but is there really a security issue here?  That is, do we lose
> >> anything important if we just drop the offending part of the patch
> >> set?  As you've said, there shouldn't be sensitive device nodes,
> >> executables, or setuid files in proc or sysfs in the first place.
>
> We do need to enforce retaining the existing mount flags one way or
> another.  Where this really matters is with MS_RDONLY.  We don't want
> any old user to be able to mount /proc read-write when root mounted it
> read-only.  There is a very real attack vector there.  That attack
> almost works in docker container today and is avoided simply because
> docker mounts over a few files on proc.

You could drop the nosuid, noexec, and nodev changes and keep just the
ro part.  The ro part is probably not an ABI break in the sense of
something that actually breaks real programs.

>
> Which leads to the second side of the reason for these changes.   I am
> fixing a very small but long standing ABI break.   That is in some small
> ways I broke some sandboxes and when I realized they were broken I could
> not imagine think how to fix the code until now.
>
> It is the goal that user namespaces don't introduce anything for people
> to worry about security wise more than simply the ability to execute
> more kernel code.  So at least when the kernel implementation is correct
> developers of existing applications simply do not need care.  Sadly we are
> not quite there yet.
>
> > Speaking as a user of the mount() interfaces, I really think it would
> > be less confusing overall if mount() simply ignored the requested
> > flags when the caller doesn't have a choice. That is, in cases where
> > mount() currently fails with EPERM when not given, say, MS_NOSUID, it
> > should instead just pretend the caller actually set MS_NOSUID and go
> > ahead with a nosuid mount. Or put another way, the absence of
> > MS_NOSUID should not be interpreted as "remove the nosuid bit" but
> > rather "don't set the nosuid bit if not required".
>
> I am conflicted.  Implicits are nice but confusing.  If we can do
> something reliable and robust and maintainable here that is truly worth
> the cost I am all for it.
>
> If I mount proc read-write I likely want to be able to write to proc
> files, and I will be much happier if the mount fails than if a bazillion
> syscalls later something else fails when it tries to write to proc.

I agree.  I don't like the implicit thing.
