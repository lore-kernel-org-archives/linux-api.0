From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Date: Wed, 8 Oct 2014 23:38:54 +0000
Message-ID: <20141008233854.GG31366@ubuntumail>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <87mw97wqvx.fsf@x220.int.ebiederm.org>
 <20141008110829.GC24908@paralelels.com>
 <CALCETrX4XrgbQNZZa7=1009KqhJ2gT+VBUkC15+59K9yEiTSbQ@mail.gmail.com>
 <87vbnue56f.fsf@x220.int.ebiederm.org>
 <CALCETrVSxYr=Oa29qHNL-GoifS26U8TfpreGY+KN7g926YgHUw@mail.gmail.com>
 <5435AE41.20105@landley.net>
 <CALCETrXapWTiFw2CC1m43fs9yuHuesXxXtmHh-5F3J_bUYeRxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXapWTiFw2CC1m43fs9yuHuesXxXtmHh-5F3J_bUYeRxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Andy Lutomirski (luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org):
> On Wed, Oct 8, 2014 at 2:36 PM, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org> wrote:
> > On 10/08/14 14:31, Andy Lutomirski wrote:
> >> On Wed, Oct 8, 2014 at 12:23 PM, Eric W. Biederman
> >> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> >>> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
> >>>>> Maybe we want to say that rootfs should not be used if we are going to
> >>>>> create containers...
> >>>
> >>> Today it is an assumption of the vfs that rootfs is mounted.  With
> >>> rootfs mounted and pivot_root at the base of the mount stack you can
> >>> make as minimal of a set of mounts as the vfs allows.
> >>>
> >>> Removing rootfs from the vfs requires an audit of everything that
> >>> manipulates mounts.  It is not remotely a local excercise.
> >>
> >> Would it be a less invasive audit to allow different mount namespaces
> >> to have different rootfses?
> >
> > I.E. The same way different namespaces have different init tasks?
> >
> > The abstraction containers has implemented here should be logically
> > consistent.
> >
> >>>> Could we have an extra rootfs-like fs that is always completely empty,
> >>>> doesn't allow any writes, and can sit at the bottom of container
> >>>> namespace hierarchies?  If so, and if we add a new syscall that's like
> >>>> pivot_root (or unshare) but prunes the hierarchy, then we could switch
> >>>> to that rootfs then.
> >>>
> >>> Or equally have something that guarantees that rootfs is empty and
> >>> read-only at the time the normal root filesystem is mounted.  That is
> >>> certainly a much more localized change if we want to go there.
> >>>
> >>> I am half tempted to suggest that mount --move /some/path / be updated
> >>> to make the old / just go away (perhaps to be replaced with a read-only
> >>> empty rootfs).  That gets us into figuring out if we break userspace
> >>> which is a big challenge.
> >>
> >> Hence my argument for a new syscall or entirely new operation.
> >
> > I'm still waiting for somebody to explain to my why chroot() shouldn't
> > be changed to do this instead of adding a new syscall. (At least when
> > mount namespace support is enabled.)
> 
> Because chroot has no effect on the namespace at all.  If you fork and
> the child chroots, the parent isn't chrooted.  And, more importantly
> for my example, is a process has it's cwd as /foo, and then it forks
> and the child chroots, then parent's ".." isn't changed as a result of
> the chroot.
> 
> >
> >> mount(2) and friends are way too multiplexed right now.  I just found
> >> yet another security bug due to the insanely complicated semantics of
> >> the vfs syscalls.  (Yes, a different one from the one yesterday.)
> >
> > As the guy who rewrote busybox mount 3 times, and who just implemented a
> > brand new one (toybox) from scratch:
> >
> > It's a bit fiddly, yes.
> >
> >> A new operation kills several birds with one stone.  It could look like:
> >>
> >> int mntns_change_root(int dfd, const char *path, int flags);
> >>
> >> return -EPERM if chrooted.
> >
> > Really?
> 
> Now that CVE-2014-7970 is public: what the heck is pivot_root supposed
> to do if the caller is chrooted?  The current behavior is obviously
> incorrect (it leaks memory), but it's not entirely clear to me what
> should happen.  I think it should either be disallowed or should have
> well-defined semantics.
> 
> For simplicity, if a new syscall for this is added, then I think that
> the caller-is-chrooted case should be disallowed.  If someone needs it
> and can articulate what the semantics should be, then I have no
> problem with allowing it going forward.

It's not that I'd have a need for that, but rather if for some
reason I started out chrooted due to some bogus initramfs, I'd
prefer to not have to feel like a criminial and escape the chroot
first.
