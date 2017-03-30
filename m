From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Thu, 30 Mar 2017 23:45:23 +0200
Message-ID: <20170330214523.GA13761@comp-core-i7-2640m-0182e6>
References: <20170312021257.GP29622@ZenIV.linux.org.uk>
 <20170320125855.GG4554@comp-core-i7-2640m-0182e6>
 <CAEiveUcj6d7mJKRHJs73T7Z1-qRgqE+xsMc1NDivFKeJhjMeJQ@mail.gmail.com>
 <20170323220712.GH4554@comp-core-i7-2640m-0182e6>
 <CAEiveUe15YvZ4hMYSPgm586MkJ20PO515r9krXdjPCUmrG1wSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAEiveUe15YvZ4hMYSPgm586MkJ20PO515r9krXdjPCUmrG1wSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 26, 2017 at 09:03:33AM +0200, Djalal Harouni wrote:
> (Cc'ed Kees and Jann for the procfs stacking issue)
> 
> > I completely agree with you that it looks wrong when options of one
> > mountpoint affect the others mountpoints.
> >
> >> I'm not sure if that's the right approach, it is still buggy, however
> >> seems that your patch also stores the mount option inside the
> >> pid_namespace which may get propagated to all mounts inside same pidns
> >> ?
> >
> > I don't store 'pidonly' option in my current patch. I mean in:
> > https://lkml.org/lkml/2017/3/20/363
> >
> > I parse options twice at first mount of procfs. It happens before
> > the mounting /proc in userspace.
> >
> > I know it's bad, but I couldn't find place to store this option.
> 
> Ok, then maybe that approach of having a procfs struct holder instead
> of using pid namespace may help!

I deside to stop doing my patch. I talked with a few people and found out
that the overlayfs doesn't feel very well if on the lower level filesystem
appear/disappear files.

In addition with the pidfs isn't so simple. Separate the root will lead to
a doubling of memory consumption and restrictions on the filesystem operations
level can easily be skipped.

It means that even I can do this pidfs (or pid subset in /proc), it
will be pointless.

-- 
Rgrds, legion
