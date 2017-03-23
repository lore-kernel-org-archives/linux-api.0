From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Thu, 23 Mar 2017 23:07:12 +0100
Message-ID: <20170323220712.GH4554@comp-core-i7-2640m-0182e6>
References: <20170312021257.GP29622@ZenIV.linux.org.uk>
 <20170320125855.GG4554@comp-core-i7-2640m-0182e6>
 <CAEiveUcj6d7mJKRHJs73T7Z1-qRgqE+xsMc1NDivFKeJhjMeJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEiveUcj6d7mJKRHJs73T7Z1-qRgqE+xsMc1NDivFKeJhjMeJQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Vasiliy Kulikov <segoon@openwall.com>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Dmitry V. Levin" <ldv@altlinux.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 23, 2017 at 05:06:28PM +0100, Djalal Harouni wrote:
> Hi Alexey,
> 
> On Mon, Mar 20, 2017 at 1:58 PM, Alexey Gladkov
> <gladkov.alexey@gmail.com> wrote:
> >
> >
> > Al Viro, this patch looks better ?
> >
> > == Overview ==
> >
> > Some of the container virtualization systems are mounted /proc inside
> > the container. This is done in most cases to operate with information
> > about the processes. Knowing that /proc filesystem is not fully
> > virtualized they are mounted on top of dangerous places empty files or
> > directories (for exmaple /proc/sys, /proc/kcore, /sys/firmware, etc.).
> >
> > The structure of this filesystem is dynamic and any module can create a
> > new object which will not necessarily be virtualized. There are
> > proprietary modules that aren't in the mainline whose work we can not
> > verify.
> >
> > This opens up a potential threat to the system. The developers of the
> > virtualization system can't predict all dangerous places in /proc by
> > definition.
> >
> > A more effective solution would be to mount into the container only what
> > is necessary and ignore the rest.
> >
> > Right now there is the opportunity to pass in the container any port of
> > the /proc filesystem using mount --bind expect the pids.
> >
> > This patch allows to mount only the part of /proc related to pids without
> > rest objects. Since this is an option for /proc, flags applied to /proc
> > have an effect on this subset of filesystem.
> 
> I just sent a patch that also has to deal with proc hidepid here:
> https://lkml.org/lkml/2017/3/23/505

I completely agree with you that it looks wrong when options of one
mountpoint affect the others mountpoints.

> I'm not sure if that's the right approach, it is still buggy, however
> seems that your patch also stores the mount option inside the
> pid_namespace which may get propagated to all mounts inside same pidns
> ?

I don't store 'pidonly' option in my current patch. I mean in:
https://lkml.org/lkml/2017/3/20/363

I parse options twice at first mount of procfs. It happens before
the mounting /proc in userspace.

I know it's bad, but I couldn't find place to store this option.

> I didn't have enough time but maybe if they are related we can work it
> out together ?

I don't have enough experience in kenrel hacking, but I would happily do
my best :)

I also tring to mention it in every patch, as my changes almost completely
useless without the ability to use the overlayfs.

Now if you remove the restriction:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/proc/inode.c#n497

and mount procfs as lowerdir in overlayfs then you get NULL pointer
dereference at:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/namei.c#n891

I got it when I tried to do `ls -la /overlay/proc/self/`.

-- 
Rgrds, legion
