From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Fri, 23 Jan 2015 21:29:47 +0800
Message-ID: <20150123132947.GA28278@kroah.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <20150123062820.GB7949@Darwish.PC>
 <20150123131946.GA26302@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150123131946.GA26302-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ahmed S. Darwish" <darwish.07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-cYrQPVfZooxQFI55V6+gNQ@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 23, 2015 at 09:19:46PM +0800, Greg Kroah-Hartman wrote:
> On Fri, Jan 23, 2015 at 08:28:20AM +0200, Ahmed S. Darwish wrote:
> > On Fri, Jan 16, 2015 at 11:16:05AM -0800, Greg Kroah-Hartman wrote:
> > > From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
> > > 
> > > kdbus is a system for low-latency, low-overhead, easy to use
> > > interprocess communication (IPC).
> > > 
> > > The interface to all functions in this driver is implemented via ioctls
> > > on files exposed through a filesystem called 'kdbusfs'. The default
> > > mount point of kdbusfs is /sys/fs/kdbus.
> > 
> > Pardon my ignorance, but we've always been told that adding
> > new ioctl()s to the kernel is a very big no-no.  But given
> > the seniority of the folks stewarding this kdbus effort,
> > there must be a good rationale ;-)
> > 
> > So, can the rationale behind introducing new ioctl()s be
> > further explained? It would be even better if it's included
> > in the documentation patch itself.
> 
> The main reason to use an ioctl is that you want to atomically set
> and/or get something "complex" through the user/kernel boundary.  For
> simple device attributes, sysfs works great, for configuring devices,
> configfs works great, but for data streams / structures / etc. an ioctl
> is the correct thing to use.
> 
> Examples of new ioctls being added to the kernel are all over the
> place, look at all of the special-purpose ioctls the filesystems keep
> creating (they aren't adding new syscalls), look at the monstrosity that
> is the DRM layer, look at other complex things like openvswitch, or
> "simpler" device-specific interfaces like the MEI one, or even more
> complex ones like the MMC interface.

Oops, I meant, MIC, not MMC, sorry about that.
