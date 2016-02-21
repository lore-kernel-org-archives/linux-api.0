From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v8 1/4] firmware: introduce sysfs driver
 for QEMU's fw_cfg device
Date: Sun, 21 Feb 2016 15:10:30 +0200
Message-ID: <20160221150904-mutt-send-email-mst@redhat.com>
References: <1453990994-17801-1-git-send-email-somlo@cmu.edu>
	<1453990994-17801-2-git-send-email-somlo@cmu.edu>
	<20160221100557-mutt-send-email-mst@redhat.com>
	<20160221130614.GA4511@GLSMBP.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20160221130614.GA4511@GLSMBP.INI.CMU.EDU>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Cc: mark.rutland@arm.com, peter.maydell@linaro.org, matt@codeblueprint.co.uk, stefanha@gmail.com, qemu-devel@nongnu.org, eric@anholt.net, kraxel@redhat.com, linux-api@vger.kernel.org, agross@codeaurora.org, pawel.moll@arm.com, zajec5@gmail.com, rmk+kernel@arm.linux.org.uk, lersek@redhat.com, devicetree@vger.kernel.org, ehabkost@redhat.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, leif.lindholm@linaro.org, robh+dt@kernel.org, pbonzini@redhat.com, rth@twiddle.net, ard.biesheuvel@linaro.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, luto@amacapital.net, hanjun.guo@linaro.org, sudeep.holla@arm.com, imammedo@redhat.com, revol@free.fr
List-Id: linux-api@vger.kernel.org

On Sun, Feb 21, 2016 at 08:06:17AM -0500, Gabriel L. Somlo wrote:
> 
> > 
> > > +#if !(defined(FW_CFG_CTRL_OFF) && defined(FW_CTRL_DATA_OFF))
> > > +# if (defined(CONFIG_ARM) || defined(CONFIG_ARM64))
> > > +#  define FW_CFG_CTRL_OFF 0x08
> > > +#  define FW_CFG_DATA_OFF 0x00
> > > +# elif (defined(CONFIG_PPC_PMAC) || defined(CONFIG_SPARC32)) /* ppc/mac,sun4m */
> > > +#  define FW_CFG_CTRL_OFF 0x00
> > > +#  define FW_CFG_DATA_OFF 0x02
> > > +# elif (defined(CONFIG_X86) || defined(CONFIG_SPARC64)) /* x86, sun4u */
> > > +#  define FW_CFG_CTRL_OFF 0x00
> > > +#  define FW_CFG_DATA_OFF 0x01
> > > +# else
> > > +#  warning "QEMU FW_CFG may not be available on this architecture!"
> > > +#  define FW_CFG_CTRL_OFF 0x00
> > > +#  define FW_CFG_DATA_OFF 0x01
> > 
> > Better not try hacks like this, they are hard
> > to support down the road. Please only list what is tested and
> > actually exposed by QEMU.
> 
> I was looking for a standard way to advertise register offsets within
> the ioport or mmio region assigned to fw_cfg, but right now the answer
> is "there isn't one", and "register offsets are an arch specific
> detail". As such, the only reasonable way I saw was to copy the same
> values used in the QEMU source.
> 
> See also:
> https://lists.gnu.org/archive/html/qemu-devel/2015-11/msg05037.html
>  
> Thanks much,
> --Gabriel

My point is you don't know what will qemu do on these
other arches which do not at the moment have fw cfg.
So don't try to guess!

-- 
MST
