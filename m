From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: Why not make kdbus use CUSE?
Date: Tue, 2 Dec 2014 09:12:49 -0800
Message-ID: <20141202171249.GA8326@kroah.com>
References: <20141129063416.GE32286@woodpecker.gentoo.org>
 <20141129175947.GB32510@kroah.com>
 <547D50B9.9040909@gentoo.org>
 <20141202054850.GA17043@kroah.com>
 <547D7159.2040900@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <547D7159.2040900-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Yao <ryao-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 02, 2014 at 02:59:21AM -0500, Richard Yao wrote:
> On 12/02/2014 12:48 AM, Greg Kroah-Hartman wrote:
> > On Tue, Dec 02, 2014 at 12:40:09AM -0500, Richard Yao wrote:
> >>>> They regard a userland compatibility shim in the systemd repostory to provide
> >>>> backward compatibility for applications. Unfortunately, this is insufficient to
> >>>> ensure compatibility because dependency trees have multiple levels. If cross
> >>>> platform package A depends on cross platform library B, which depends on dbus,
> >>>> and cross platform library B decides to switch to kdbus, then it ceases to be
> >>>> cross platform and cross platform package A is now dependent on Linux kernels
> >>>> with kdbus. Not only does that affect other POSIX systems, but it also affects
> >>>> LTS versions of Linux.
> >>>
> >>> What does LTS versions have anything to do here?  And what specific
> >>> dependancies are you worried about?
> >>
> >> Lets say that you have a Linux 3.10 system and you want some package
> >> that indirectly depends on the new API due to library dependencies. You
> >> will have a problem. You could probably install an older version of the
> >> library, but if the older version has a CVE, most end users will end up
> >> between a rock and a hard place. This situation should merit some
> >> consideration because you are taking something that lived previously in
> >> userland, modifying it so that anything depending on the modifications
> >> is no longer backward compatible and then tying it to new kernels.
> > 
> > Then you need to get a better distro, as any "well run" long-term
> > enterprise distro handles stuff like this for you.  Otherwise you need
> > to update systems properly.  There's nothing that I can do here to help
> > with that, nor do I ever want to, sorry.
> 
> Another option is to include KVM-style kernel compatibility code to
> allow the module to be built against older kernels. If you target
> 2.6.32.y, 3.2.y, 3.4.y and 3.10.y, the risk of people on older Linux
> systems being left behind would be minimized.

If you want to do that for an out-of-tree patch/module, feel free to do
so, but this has nothing to do with the in-kernel kdbusfs code, sorry.

> >> 1. Debugging kernel code is a pain while debugging user code is
> >> relatively easy.
> > 
> > You have full access to a debugger, what more do you need?  :)
> 
> I would prefer not to start bringing userland daemons into the kernel
> unless there is no other choice. That way, a wider range of people can
> tackle bugs and the code could be applied to a larger number of systems.

What exactly do you mean here?  There are thousands of people who know
how to properly debug Linux kernel code, this isn't an issue at all.

> > And why would you need to debug the kernel kdbus code?  Is something not
> > working properly in it?  Otherwise just use wireshark to read the kdbus
> > data stream and all should be fine.
> 
> Putting daemons in the kernel means that we further complicate already
> complex relationships with regard to things like memory utilization and
> CPU time. It is easier to deal with this in userland where we could
> better utilize cgroups.

What does cgroups have to do with dbus userspace libraries here?  In
fact, I don't think you looked at the code, as we properly tie into
namespaces and all the stuff you can only do in the kernel, you aren't
reading my introductory email at all that explains all of this.

> >> 2. Security vulnerabilities in kernel code give complete access to
> >> everything while security vulnerabilities in userspace code can be
> >> limited in scope by SELinux.
> > 
> > Kernel code is hard, security matters, yes I know this, we all have been
> > doing this for a very long time.  Of course bugs happen, but if you look
> > closely, your "attack surface" is now smaller using kdbus than it was
> > using old-style dbus.
> 
> Lets say that I have a system running LXC containers, someone does full
> disclosure of proof of concept code for an arbitrary code execution zero
> day and then someone else tries the exploit in a LXC container on
> mysystem. With old-style dbus, only the container is affected and if
> selinux is used, then it is possible to restrict daemon to things in the
> container using dbus.

And how exactly does this relate to the kdbusfs code?  Please, stop
making random statements that have nothing to do with the code being
proposed.

> I heard quite clearly at LinuxCon Europe that there are no expected
> benefits from using the shim with kdbus such that we have the equivalent
> of the original dbus daemon in the kernel, but there were plenty of
> benefits from the protocol. If that is the case, it seems that being in
> the kernel is not a necessity, but the new protocol is. FUSE might be
> somewhat slower than an in-kernel filesystem, but it allows us to
> enforce least privilege like we can do now with the current dbus daemon.
> We cannot do that with kdbus/kdbusfs. If the reduction in context switch
> overhead actually mattered, I would understand the desire to put this
> into the kernel, but I have heard quite consistently that the context
> switch overhead is not a significant motivation for pushing this code
> into the kernel.

You heard wrong, the context switch removal is a big thing, and a major
issue for a lot of users.  But that's not the only reason this is being
proposed, again, go read and respond to the 00 patch introduction
please, or even better yet, read the code and documentation and respond
to issues you find there.

Again, FUSE makes no sense here, sorry.

> >> 3. Integration with things like LXC should be easier from userspace,
> >> where each container can have its own daemon.
> > 
> > How does the current implementation not work properly for this?  The
> > filesystem implementation makes this easier than ever, while sticking
> > with the character device made this quite difficult in different ways.
> 
> As you pointed out, my information was out of date. Making this into a
> filesystem is an excellent idea that handles container integration quite
> nicely.

I'm glad you agree with the current implementation, thanks for your
approval.

greg k-h
