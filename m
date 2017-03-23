From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Thu, 23 Mar 2017 17:06:28 +0100
Message-ID: <CAEiveUcj6d7mJKRHJs73T7Z1-qRgqE+xsMc1NDivFKeJhjMeJQ@mail.gmail.com>
References: <20170312021257.GP29622@ZenIV.linux.org.uk> <20170320125855.GG4554@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170320125855.GG4554@comp-core-i7-2640m-0182e6>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Alexey,

On Mon, Mar 20, 2017 at 1:58 PM, Alexey Gladkov
<gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>
> Al Viro, this patch looks better ?
>
> == Overview ==
>
> Some of the container virtualization systems are mounted /proc inside
> the container. This is done in most cases to operate with information
> about the processes. Knowing that /proc filesystem is not fully
> virtualized they are mounted on top of dangerous places empty files or
> directories (for exmaple /proc/sys, /proc/kcore, /sys/firmware, etc.).
>
> The structure of this filesystem is dynamic and any module can create a
> new object which will not necessarily be virtualized. There are
> proprietary modules that aren't in the mainline whose work we can not
> verify.
>
> This opens up a potential threat to the system. The developers of the
> virtualization system can't predict all dangerous places in /proc by
> definition.
>
> A more effective solution would be to mount into the container only what
> is necessary and ignore the rest.
>
> Right now there is the opportunity to pass in the container any port of
> the /proc filesystem using mount --bind expect the pids.
>
> This patch allows to mount only the part of /proc related to pids without
> rest objects. Since this is an option for /proc, flags applied to /proc
> have an effect on this subset of filesystem.

I just sent a patch that also has to deal with proc hidepid here:
https://lkml.org/lkml/2017/3/23/505

I'm not sure if that's the right approach, it is still buggy, however
seems that your patch also stores the mount option inside the
pid_namespace which may get propagated to all mounts inside same pidns
?

I didn't have enough time but maybe if they are related we can work it
out together ?

Thank you!


-- 
tixxdz
