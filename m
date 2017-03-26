From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Sun, 26 Mar 2017 09:03:33 +0200
Message-ID: <CAEiveUe15YvZ4hMYSPgm586MkJ20PO515r9krXdjPCUmrG1wSA@mail.gmail.com>
References: <20170312021257.GP29622@ZenIV.linux.org.uk> <20170320125855.GG4554@comp-core-i7-2640m-0182e6>
 <CAEiveUcj6d7mJKRHJs73T7Z1-qRgqE+xsMc1NDivFKeJhjMeJQ@mail.gmail.com> <20170323220712.GH4554@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170323220712.GH4554@comp-core-i7-2640m-0182e6>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

(Cc'ed Kees and Jann for the procfs stacking issue)


On Thu, Mar 23, 2017 at 11:07 PM, Alexey Gladkov
<gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Mar 23, 2017 at 05:06:28PM +0100, Djalal Harouni wrote:
>> Hi Alexey,
>>
>> On Mon, Mar 20, 2017 at 1:58 PM, Alexey Gladkov
>> <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >
>> > Al Viro, this patch looks better ?
>> >
>> > == Overview ==
>> >
>> > Some of the container virtualization systems are mounted /proc inside
>> > the container. This is done in most cases to operate with information
>> > about the processes. Knowing that /proc filesystem is not fully
>> > virtualized they are mounted on top of dangerous places empty files or
>> > directories (for exmaple /proc/sys, /proc/kcore, /sys/firmware, etc.).
>> >
>> > The structure of this filesystem is dynamic and any module can create a
>> > new object which will not necessarily be virtualized. There are
>> > proprietary modules that aren't in the mainline whose work we can not
>> > verify.
>> >
>> > This opens up a potential threat to the system. The developers of the
>> > virtualization system can't predict all dangerous places in /proc by
>> > definition.
>> >
>> > A more effective solution would be to mount into the container only what
>> > is necessary and ignore the rest.
>> >
>> > Right now there is the opportunity to pass in the container any port of
>> > the /proc filesystem using mount --bind expect the pids.
>> >
>> > This patch allows to mount only the part of /proc related to pids without
>> > rest objects. Since this is an option for /proc, flags applied to /proc
>> > have an effect on this subset of filesystem.
>>
>> I just sent a patch that also has to deal with proc hidepid here:
>> https://lkml.org/lkml/2017/3/23/505
>
> I completely agree with you that it looks wrong when options of one
> mountpoint affect the others mountpoints.
>
>> I'm not sure if that's the right approach, it is still buggy, however
>> seems that your patch also stores the mount option inside the
>> pid_namespace which may get propagated to all mounts inside same pidns
>> ?
>
> I don't store 'pidonly' option in my current patch. I mean in:
> https://lkml.org/lkml/2017/3/20/363
>
> I parse options twice at first mount of procfs. It happens before
> the mounting /proc in userspace.
>
> I know it's bad, but I couldn't find place to store this option.

Ok, then maybe that approach of having a procfs struct holder instead
of using pid namespace may help!


>> I didn't have enough time but maybe if they are related we can work it
>> out together ?
>
> I don't have enough experience in kenrel hacking, but I would happily do
> my best :)

OK, let's sync on this then.

> I also tring to mention it in every patch, as my changes almost completely
> useless without the ability to use the overlayfs.
>
> Now if you remove the restriction:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/proc/inode.c#n497

This protection was introduced in e54ad7f1ee263

That's a security fix, ecryptfs seems to schedule some code through
kthreads which always run in the initial namespaces with full
capabilities, bypassing all security checks.

I don't know if overlayfs has something similar, if not then maybe if
it's possible in ecryptfs to check the lower mount and the fs type and
move this procfs there...  Cc'ed Jann in case he may comment.

> and mount procfs as lowerdir in overlayfs then you get NULL pointer
> dereference at:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/namei.c#n891
>
> I got it when I tried to do `ls -la /overlay/proc/self/`.
>
> --
> Rgrds, legion
