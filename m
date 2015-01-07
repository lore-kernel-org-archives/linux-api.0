From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 7 Jan 2015 20:30:59 +0100
Message-ID: <20150107193059.GA1857@mail.hallyn.com>
References: <1417744550-6461-9-git-send-email-adityakali@google.com>
 <548E17CE.8010704@nod.at>
 <CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com>
 <54AB15BD.8020007@nod.at>
 <87lhlgpyxk.fsf@x220.int.ebiederm.org>
 <CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
 <54AB2992.6060707@nod.at>
 <CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
 <54ACFC38.5070007@nod.at>
 <87fvbmir9q.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87fvbmir9q.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org> writes:
> 
> > Am 07.01.2015 um 00:20 schrieb Aditya Kali:
> >> I understand your point. But it will add some complexity to the code.
> >> 
> >> Before trying to make it work for non-unified hierarchy cases, I would
> >> like to get a clearer idea.
> >> What do you expect to be mounted when you run:
> >>   container:/ # mount -t cgroup none /sys/fs/cgroup/
> >> from inside the container?
> >> 
> >> Note that cgroup-namespace wont be able to change the way cgroups are
> >> mounted .. i.e., if say cpu and cpuacct subsystems are mounted
> >> together at a single mount-point, then we cannot mount them any other
> >> way (inside a container or outside). This restriction exists today and
> >> cgroup-namespaces won't change that.
> >
> > I wondered why cgroup namespaces won't change that and looked at your patches
> > in more detail.
> > What you propose as cgroup namespace is much more a cgroup chroot() than
> > a namespace.
> > As you pass relative paths into the namespace you depend on the mount structure
> > of the host side.
> > Hence, the abstraction between namespaces happens on the mount paths of the initial
> > cgroupfs. But we really want a new cgroupfs instance within a container and not just
> > a cut out of the initial cgroupfs mount.
> >
> > I fear you approach is over simplified and won't work for all cases. It may work
> > for your specific use case at Google but we really want something generic.
> > Eric, what do you think?
> 
> I think I probably need to go back upthread and read the patches.
> 
> I think it is a reasonable practical requirement that a widely used long
> term supported distribution like RHEL 7 needs to be able to run in a linux
> container bizarre init system and all.  And that we the abstractions
> should be that that we should be able to migrate such a beast.

Userspace should be able to deal with however cgroups are mounted for
it.  The only case I've heard of where it really made a meaningful
difference was google's advanced grid usage.  In fact, the whole
justification of the unified cgroup stuff was that it was claimed (and
argued against by google) that that sufficed for any users.

Now yes, until now userspace could cache its info on how cgroups were
mounted and assume that wouldn't change (because the kernel wouldn't
let it), and migration will break that.  But if the cgroup roadmap
is to obsolete anything but unified hierarchy, then this was going
to happen regardless of what the cgroupns patchset did.

I agree with Aditya.  So long as the proclaimed direction of cgroups is
to only support unified cgroup hierarchy, there's no point in having
cgroupns do anything more than the chrooting.

> There are a couple of issues in play and I think we need actual testing
> rather than reports that something shouldn't work before we reject a set
> of patches.    Aditya in one of his replies to me has reported a
> configuration that he expects will work.  So I think that configuration
> needs to be tested.
> 
> cgroups is a weird beast and the problems tend not to lie where a person
> would first expect.
> 
> I suspect no one strongly cares if the cgroup hierarchy is unified or
> not.

Well, google does.  There are cases that were either much more complicated
or impossible to represent with unified hierarchy.  But complicating cgroupns
to support something which Tejun has said is explicitly not going to be
supported in the future would be ill-advised.

>   By unified hierarchy I mean that  every mount of cgroupfs has the
> same directories with the same processes in each directory.

No, my reading of Documentation/cgroups/unified-hierarchy.txt is that
unified hierarchy means that all (sane) controllers are co-mounted into
one hierarchy.

> I do think people will care which controllers will show up in differ
> mounts of cgroupfs, and I think that is relevant to process migration.
> 
> 
> 
> 
> I am going to segway into scope of what is achievable with a cgroup namespace.
> 
> - If there are files in cgroupfs that are not safe to delegate we can
>   not support those files in a container. 
> 
>   Last I looked there were such files and systemd used them.
> 
> - Which controllers share hierarchies of processes to track resources is
>   a core cgroup issue and not a cgroup namespace issue.
> 
>   If we find problems with using a unified hierarchy support we need to
>   go fix cgroups in general not cgroupfs.
> 
> Eric
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
