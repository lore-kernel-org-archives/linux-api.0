From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH v6 0/4] SysFS driver for QEMU fw_cfg device
Date: Sat, 19 Dec 2015 10:10:07 -0500
Message-ID: <20151219151006.GA11545@GLSMBP.INI.CMU.EDU>
References: <1449242946-12062-1-git-send-email-somlo@cmu.edu>
 <20151217160923.GI19448@HEDWIG.INI.CMU.EDU>
 <20151219091228.GA6024@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151219091228.GA6024@amd>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, revol-GANU6spQydw@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Pavel,

On Sat, Dec 19, 2015 at 10:12:28AM +0100, Pavel Machek wrote:
> On Thu 2015-12-17 11:09:23, Gabriel L. Somlo wrote:
> > ping ?
> > 
> > Also, for the corresponding patch set on the QEMU end of things,
> > ping on http://thread.gmane.org/gmane.comp.emulators.qemu/376321
> 
> I guess missing information is why such access is a good
> idea. Debugging?

Debugging did come up in earlier threads as well. However, personally,
I am interested in a mechanism for the host to pass information to the
guest in a way that's both

	- asynchronous: i.e., host doesn't need to wait for guest to
	  be ready to accept data (e.g. by first starting an agent)

	- out-of-band: don't commandeer guest elements normally visible
	  and available to guest *users* (e.g. kernel command line,
	  mount a floppy/cdrom image, etc).

QEMU now allows arbitrary fw_cfg blobs to be added via the command
line, so it would be nice to make it easy to access them from the
guest OS -- and what's nicer and easier than:

	cat /sys/firmware/qemu-fw-cfg/.../some-blob-name/raw

Thanks,
--Gabriel

> > On Fri, Dec 04, 2015 at 10:29:02AM -0500, Gabriel L. Somlo wrote:
> > > Allow access to QEMU firmware blobs, passed into the guest VM via
> > > the fw_cfg device, through SysFS entries. Blob meta-data (e.g. name,
> > > size, and fw_cfg key), as well as the raw binary blob data may be
> > > accessed.
> > > 
> > > The SysFS access location is /sys/firmware/qemu_fw_cfg/... and was
> > > selected based on overall similarity to the type of information
> > > exposed under /sys/firmware/dmi/entries/...
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
