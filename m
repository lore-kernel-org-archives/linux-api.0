From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Date: Tue, 7 Oct 2014 21:32:57 +0000
Message-ID: <20141007213257.GJ28519@ubuntumail>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <20141007133039.GG7996@ZenIV.linux.org.uk>
 <20141007133339.GH7996@ZenIV.linux.org.uk>
 <87r3yjy64e.fsf@x220.int.ebiederm.org>
 <20141007204627.GI28519@ubuntumail>
 <87wq8bvbzg.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87wq8bvbzg.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
> 
> > Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> >> Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org> writes:
> >> 
> >> 2> On Tue, Oct 07, 2014 at 02:30:40PM +0100, Al Viro wrote:
> >> >> On Tue, Oct 07, 2014 at 04:12:57PM +0400, Andrey Vagin wrote:
> >> >> > Another problem is that rootfs can't be hidden from a container, because
> >> >> > rootfs can't be moved or umounted.
> >> >> 
> >> >> ... which is a bug in mntns_install(), AFAICS.
> >> >
> >> > Ability to get to exposed rootfs, that is.
> >> 
> >> The container side of this argument is pretty bogus.  It only applies
> >> if user namespaces are not used for the container.
> >
> > User namespaces are still far too restricted for many container use
> > cases.  We can't say "we have user namespaces so now privileged
> > containers can be ignored".  Yes you never should have handed the
> > keys to a privileged container to an untrusted person, but we do
> > still try to protect the host from accidental damage due to a
> > privileged container.
> 
> What I meant is that it isn't about containers.   It is about something
> root can do.  So this is not a "container" problem.

Oh, ok.  

Sorry, I'm getting the two thread confused anyway.  I'm going to bow out
here until I can pay proper attention.

> >> So it is only root (and not root in a container) who can get to the
> >> exposed rootfs.
> >> 
> >> I have a vague memory someone actually had a real use in miminal systems
> >> for being able to get back to the rootfs and being able to use rootfs as
> >> the rootfs.  There was even a patch at that time that Andrew Morton was
> >> carrying for a time to allow unmounting root and get at rootfs, and to
> >> prevent the oops on rootfs unmount in some way.
> >> 
> >> So not only do I not think it is a bug to get back too rootfs, I think
> >> it is a feature that some people have expressed at least half-way sane
> >> uses for.
> >
> > They can still do that if they want, using chroot :)
> 
> It would take fchdir or fchroot and a directory file descriptor open on
> rootfs.  Frequently there is no appropriate directory file descriptor.

?  you can always escape if you're simply chrooted.  waterbuffalo :)
