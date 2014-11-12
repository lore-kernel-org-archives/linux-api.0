From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init cgroupns
Date: Wed, 12 Nov 2014 09:48:18 -0800
Message-ID: <CAGr1F2Ho1kGVbVHxX1wY2PMhiAYgp6Tdnshj1pkV9pAeQLO=Qw@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-8-git-send-email-adityakali@google.com> <87y4rvrakn.fsf@x220.int.ebiederm.org>
 <CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA@mail.gmail.com>
 <20141104134633.GA14014@htj.dyndns.org> <CALCETrUggQCJyxsTWRNrjt3GM=R0VMU6RjMkU1aw3YUNMx1xEw@mail.gmail.com>
 <20141104155052.GA7027@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141104155052.GA7027-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

I agree with what Andy and Serge has to say. The ability to mount
cgroupfs inside userns also seems consistent with other kernel
interfaces like sysfs, procfs, etc.

Though it would be great if we can atleast merge the rest of the
patches first while we address the mounting part.

Thanks for your feedback.

On Tue, Nov 4, 2014 at 7:50 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
>
> Quoting Andy Lutomirski (luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org):
> > On Tue, Nov 4, 2014 at 5:46 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > Hello, Aditya.
> > >
> > > On Mon, Nov 03, 2014 at 02:43:47PM -0800, Aditya Kali wrote:
> > >> I agree that this is effectively bind-mounting, but doing this in kernel
> > >> makes it really convenient for the userspace. The process that sets up the
> > >> container doesn't need to care whether it should bind-mount cgroupfs inside
> > >> the container or not. The tasks inside the container can mount cgroupfs on
> > >> as-needed basis. The root container manager can simply unshare cgroupns and
> > >> forget about the internal setup. I think this is useful just for the reason
> > >> that it makes life much simpler for userspace.
> > >
> > > If it's okay to require userland to just do bind mounting, I'd be far
> > > happier with that.  cgroup mount code is already overcomplicated
> > > because of the dynamic matching of supers to mounts when it could just
> > > have told userland to use bind mounting.  Doesn't the host side have
> > > to set up some of the filesystem layouts anyway?  Does it really
> > > matter that we require the host to set up cgroup hierarchy too?
> > >
> >
> > Sort of, but only sort of.
> >
> > You can create a container by unsharing namespaces, mounting
> > everything, and then calling pivot_root.  But this is unpleasant
> > because of the strange way that pid namespaces work -- you generally
> > have to fork first, so this gets tedious.  And it doesn't integrate
> > well with things like fstab or other container-side configuration
> > mechanisms.
> >
> > It's nicer if you can unshare namespaces, mount the bare minimum,
> > pivot_root, and let the contained software do as much setup as
> > possible.
>
> Also, the bind-mount requires the container manager to know where
> the guest distro will want the cgroups mounted.
>
> -serge
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers




-- 
Aditya
