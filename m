From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH v8 1/4] firmware: introduce sysfs driver for QEMU's
 fw_cfg device
Date: Sun, 21 Feb 2016 12:20:10 -0500
Message-ID: <20160221172010.GA4711@GLSMBP.INI.CMU.EDU>
References: <1453990994-17801-1-git-send-email-somlo@cmu.edu>
 <1453990994-17801-2-git-send-email-somlo@cmu.edu>
 <20160221100557-mutt-send-email-mst@redhat.com>
 <20160221130614.GA4511@GLSMBP.INI.CMU.EDU>
 <20160221150904-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160221150904-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ehabkost-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, revol-GANU6spQydw@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Feb 21, 2016 at 03:10:30PM +0200, Michael S. Tsirkin wrote:
> On Sun, Feb 21, 2016 at 08:06:17AM -0500, Gabriel L. Somlo wrote:
> > 
> > > 
> > > > +#if !(defined(FW_CFG_CTRL_OFF) && defined(FW_CTRL_DATA_OFF))
> > > > +# if (defined(CONFIG_ARM) || defined(CONFIG_ARM64))
> > > > +#  define FW_CFG_CTRL_OFF 0x08
> > > > +#  define FW_CFG_DATA_OFF 0x00
> > > > +# elif (defined(CONFIG_PPC_PMAC) || defined(CONFIG_SPARC32)) /* ppc/mac,sun4m */
> > > > +#  define FW_CFG_CTRL_OFF 0x00
> > > > +#  define FW_CFG_DATA_OFF 0x02
> > > > +# elif (defined(CONFIG_X86) || defined(CONFIG_SPARC64)) /* x86, sun4u */
> > > > +#  define FW_CFG_CTRL_OFF 0x00
> > > > +#  define FW_CFG_DATA_OFF 0x01
> > > > +# else
> > > > +#  warning "QEMU FW_CFG may not be available on this architecture!"
> > > > +#  define FW_CFG_CTRL_OFF 0x00
> > > > +#  define FW_CFG_DATA_OFF 0x01
> > > 
> > > Better not try hacks like this, they are hard
> > > to support down the road. Please only list what is tested and
> > > actually exposed by QEMU.
> > 
> > I was looking for a standard way to advertise register offsets within
> > the ioport or mmio region assigned to fw_cfg, but right now the answer
> > is "there isn't one", and "register offsets are an arch specific
> > detail". As such, the only reasonable way I saw was to copy the same
> > values used in the QEMU source.
> > 
> > See also:
> > https://lists.gnu.org/archive/html/qemu-devel/2015-11/msg05037.html
> >  
> > Thanks much,
> > --Gabriel
> 
> My point is you don't know what will qemu do on these
> other arches which do not at the moment have fw cfg.
> So don't try to guess!

Oh, you mean for the "else". I originally wanted to be able to compile
this on any architecture and wanted some dummy defaults I could
override on the command line. But now we're already restricting this
to known architectures only, so I'll send a patch turning the warning
into an error, and removing the #defines for the "else" branch above.

Sorry I misunderstood you the first time around :)

Thanks,
--Gabriel
