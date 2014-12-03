From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: Why not make kdbus use CUSE?
Date: Wed, 3 Dec 2014 13:15:04 -0800
Message-ID: <20141203211504.GB15713@kroah.com>
References: <20141129063416.GE32286@woodpecker.gentoo.org>
 <20141129175947.GB32510@kroah.com>
 <547D50B9.9040909@gentoo.org>
 <20141202054850.GA17043@kroah.com>
 <547D7159.2040900@gentoo.org>
 <547DAEF3.1090106@gentoo.org>
 <20141202172612.GA8958@kroah.com>
 <547ED659.2040106@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <547ED659.2040106-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Yao <ryao-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 03, 2014 at 04:22:33AM -0500, Richard Yao wrote:
> On 12/02/2014 12:26 PM, Greg Kroah-Hartman wrote:
> > On Tue, Dec 02, 2014 at 07:22:11AM -0500, Richard Yao wrote:
> >> Assuming that this dance succeeds, the FUSE process could then make a
> >> readonly file in itself, open it read only, unlink it, put the data into
> >> the file and send the file descriptor via UNIX domain socket while
> >> refusing further writes. If it has its own user/group, the file should
> >> be safe from prying eyes.
> >>
> >> This is not as good as a memfd and also suffers from the race that
> >> O_TMPFILE was meant to close, but it should be able to function as a
> >> decent fallback.
> > 
> > We can't knowingly create and advocate for broken code, sorry.
> >
> >> This would preserve portability across not only
> >> different versions of Linux, but also other POSIX systems.
> > 
> > I honestly do not care about any other system than Linux, so I don't see
> > why this would ever be an issue.
> 
> If you tie your userland to the most recent kernel and then want to
> bisect an old bug, you will have a problem.

Like you do today with any kernel feature that any userspace code relies
on, there's nothing new here that we haven't delt with for the past 20
years.

> You could try to find another userland that supports the older
> kernels, but it would be *much* easier if you could just use your
> current userland with it because then the bare minimum must change.
> Writing portable software is the way to do that.

I don't think I understand what you mean by "portable", please define it
better.

> >> Keeping the code in userspace would allow us to apply SELinux policies
> >> to it, which is something that we would lose if it were go to into the
> >> kernel.
> > 
> > On the contrary, the kdbusfs implementation gives you better security
> > model support than before, it ties directly into the LSM hooks, see the
> > add-on patches from some other developers that bring full support of LSM
> > to the codebase.
> 
> If a bug in kdbusfs that allows arbitrary code execution is exploited in
> the wild, would kdbus be more secure than a userland version?

s/kdbusfs/fuse/ if you want to make the same argument.  Sure, any kernel
feature comes with additional code and the normal worries about security
issues.  Being afraid of ever adding new features or code just because
_maybe_ there could be a problem there is a sure way to kill an entire
project.  A non-changing operating system is a dead operating system.

> > - performance: fewer process context switches, fewer copies, fewer
> >   syscalls, larger memory chunks via memfd.  This is really important
> >   for a whole class of userspace programs that are ported from other
> >   operating systems that are run on tiny ARM systems that rely on
> >   hundreds of thousands of messages passed at boot time, and at
> >   "critical" times in their user interaction loops.
> 
> What are some examples of these programs?

Lots of programs that previously ran on QNX have been ported to Linux
for a huge range of products (automotive has a bunch of these if you are
curious to look at them.)

> Are any of them examples of good software design?

"good software design" is in the eye of the beholder.

> > - security: the peers which communicate do not have to trust each other,
> >   as the only trustworthy compoenent in the game is the kernel which
> >   adds metadata and ensures that all data passed as payload is either
> >   copied or sealed, so that the receiver can parse the data without
> >   having to protect against changing memory while parsing buffers.
> 
> What keeps userspace from passing around memfds?

Nothing, userspace programs are already doing that, but memfds are not
the be-all-end-all, and actually are much slower for a large majority of
"normal" message sizes.

> > - more metadata can be attached to messages than in userspace
> 
> How much metadata can be attached in either case? is there some inherit
> aspect of the existing syscall API that prevents userspace from
> attaching more? Why do we want to attach more?

See the documentation for what can be attached, and yes, userspace can
not get access to lots of these things in a way that can not be
"spoofed", making the metadata pointless.

> > - being in the kernle closes a lot of races which can't be fixed with
> >   the current userspace solutions.  For example, with kdbus, there is a
> >   way a client can disconnect from a bus, but do so only if no further
> >   messages present in its queue, which is crucial for implementing
> >   race-free "exit-on-idle" services
> 
> Is the current dbus daemon not supporting this this only thing
> preventing us from doing it in userspace?

It's one of many things, as this list shows.

> > Of course, some of the bits above could be implemented in userspace
> > alone, for example with more sophisticated memory management APIs, but
> > this is usually done by losing out on the other details.  For example,
> > for many of the memory management APIs, it's hard to not require the
> > communicating peers to fully trust each other.  And we _really_ don't
> > want peers to have to trust each other.
> 
> Does being in the kernel solve this in a way that using memfds in
> userspace does not?

See above for why you can't use a memfd for "everything", you will slow
things down from what you have today if you were to attempt it.

> > Another benefit of having this in the kernel, rather than as a userspace
> > daemon, is that you can now easily use the bus from the initrd, or up to
> > the very end when the system shuts down.  On current userspace D-Bus,
> > this is not really possible, as this requires passing the bus instance
> > around between initrd and the "real" system.  Such a transition of all
> > fds also requires keeping full state of what has already been read from
> > the connection fds.  kdbus makes this much simpler, as we can change the
> > ownership of the bus, just by passing one fd over from one part to the
> > other.
> 
> Why do we want to start D-Bus inside the initramfs?

To allow the existing applications in the initramfs from having to
roll-their-own form of IPC like they have had to do so today.  Also it
allows a much easier way to transition out of the initramfs than we have
today.

thanks,

greg k-h
