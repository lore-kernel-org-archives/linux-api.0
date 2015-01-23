From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Fri, 23 Jan 2015 21:19:46 +0800
Message-ID: <20150123131946.GA26302@kroah.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <20150123062820.GB7949@Darwish.PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150123062820.GB7949@Darwish.PC>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, daniel@zonque.or, dh.herrmann@gmail.com, tixxdz@opendz.org, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Mack <daniel@zonque.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 23, 2015 at 08:28:20AM +0200, Ahmed S. Darwish wrote:
> On Fri, Jan 16, 2015 at 11:16:05AM -0800, Greg Kroah-Hartman wrote:
> > From: Daniel Mack <daniel@zonque.org>
> > 
> > kdbus is a system for low-latency, low-overhead, easy to use
> > interprocess communication (IPC).
> > 
> > The interface to all functions in this driver is implemented via ioctls
> > on files exposed through a filesystem called 'kdbusfs'. The default
> > mount point of kdbusfs is /sys/fs/kdbus.
> 
> Pardon my ignorance, but we've always been told that adding
> new ioctl()s to the kernel is a very big no-no.  But given
> the seniority of the folks stewarding this kdbus effort,
> there must be a good rationale ;-)
> 
> So, can the rationale behind introducing new ioctl()s be
> further explained? It would be even better if it's included
> in the documentation patch itself.

The main reason to use an ioctl is that you want to atomically set
and/or get something "complex" through the user/kernel boundary.  For
simple device attributes, sysfs works great, for configuring devices,
configfs works great, but for data streams / structures / etc. an ioctl
is the correct thing to use.

Examples of new ioctls being added to the kernel are all over the
place, look at all of the special-purpose ioctls the filesystems keep
creating (they aren't adding new syscalls), look at the monstrosity that
is the DRM layer, look at other complex things like openvswitch, or
"simpler" device-specific interfaces like the MEI one, or even more
complex ones like the MMC interface.  These are all valid uses of ioctls
as they are device/filesystem specific ways to interact with the kernel.

The thing is, almost no one pays attention to these new ioctls as they
are domain-specific interfaces, with open userspace programs talking to
them, and they work well.  ioctl is a powerful and useful interface, and
if we were to suddenly require no new ioctls, and require everything to
be a syscall, we would do nothing except make apis more complex (hint,
you now have to do extra validation on your file descriptor passed to
you to determine if it really is what you can properly operate your
ioctl on), and cause no real benefit at all.

Yes, people abuse ioctls at times, but really, they are needed.

And remember, I was one of the people who long ago thought we should not
be adding more ioctls, but I have seen the folly of my ways, and chalk
it up to youthful ignorance :)

Hope this helps explain things better,

greg k-h
