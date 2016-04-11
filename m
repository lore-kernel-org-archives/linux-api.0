From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: Re: [PATCH v2] firmware: qemu_fw_cfg.c: hold ACPI
 global lock during device access
Date: Mon, 11 Apr 2016 09:13:00 -0400
Message-ID: <20160411131300.GW2060@HEDWIG.INI.CMU.EDU>
References: <20160308183050.GJ2049@HEDWIG.INI.CMU.EDU>
	<20160316185440-mutt-send-email-mst@redhat.com>
	<20160317133340.GJ12454@HEDWIG.INI.CMU.EDU>
	<20160405114156-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20160405114156-mutt-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: "Qemu-devel" <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: mark.rutland@arm.com, peter.maydell@linaro.org, matt@codeblueprint.co.uk, stefanha@gmail.com, qemu-devel@nongnu.org, eric@anholt.net, kraxel@redhat.com, linux-api@vger.kernel.org, agross@codeaurora.org, pawel.moll@arm.com, zajec5@gmail.com, rmk+kernel@arm.linux.org.uk, lersek@redhat.com, devicetree@vger.kernel.org, ehabkost@redhat.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, leif.lindholm@linaro.org, robh+dt@kernel.org, pbonzini@redhat.com, rth@twiddle.net, ard.biesheuvel@linaro.org, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, luto@amacapital.net, hanjun.guo@linaro.org, sudeep.holla@arm.com, imammedo@redhat.com, revol@free.fr
List-Id: linux-api@vger.kernel.org

On Tue, Apr 05, 2016 at 11:54:19AM +0300, Michael S. Tsirkin wrote:
> On Thu, Mar 17, 2016 at 09:33:40AM -0400, Gabriel L. Somlo wrote:
> > On Wed, Mar 16, 2016 at 06:57:01PM +0200, Michael S. Tsirkin wrote:
> > > On Tue, Mar 08, 2016 at 01:30:50PM -0500, Gabriel Somlo wrote:
> > > > Allowing for the future possibility of implementing AML-based
> > > > (i.e., firmware-triggered) access to the QEMU fw_cfg device,
> > > > acquire the global ACPI lock when accessing the device on behalf
> > > > of the guest-side sysfs driver, to prevent any potential race
> > > > conditions.
> > > > 
> > > > Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> > > > Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
> > > 
> > > So this patch makes sense of course.
> > > 
> > > 
> > > Given the recent discussion on QEMU mailing list,
> > > I think there is an additional patch that we need:
> > > filter the files exposed to userspace by "opt/" prefix.
> > > 
> > > This will ensure that we can change all other fw cfg files
> > > at will without breaking guest scripts.
> > > 
> > > Gabriel, could you code this up? Or do you see a
> > > pressing need to expose internal QEMU registers to
> > > userspace?
> > 
> > I'd be happy to update the docs to (better) emphasisze that:
> 
> Well my experience shows people do not read the docs.
> And really, good interfaces should be self-documenting.
> 
> >         1 the only way to guarantee any particular item shows up in
> >           guest-side fw_cfg sysfs is manually putting it there via the
> >           host-side command line
> > 
> >                 - and BTW, unless you prefixed it with "opt/..." you
> >                   are off the reservation, and it might collide with
> >                   qemu->firmware communications.
> > 
> >         2 anything one didn't place there themselves via the qemu
> >           command line is informational only, might change or go away
> >           at any time, and developing expectations about it based on
> >           past observation is done at the observer's own risk.
> > 
> > While I don't *personally* care about items outside of "opt/", I'm a bit
> > uncomfortable actively *hiding* them from userspace -- I could easily
> > imagine the ability to see (read-only) fw_cfg content from userspace
> > being a handy debugging/troubleshooting tool. It's back to separating
> > between mechanism and policy: hiding things from userspace would IMHO
> > fall into the policy enforcement side of things, and I'm still unclear
> > about the failure scenario we'd be trying to prevent, and its likelihood.
> > 
> > Thanks,
> > --Gabriel
> 
> Mostly, we can change internal qemu/firmware interfaces
> as long as we verify that firmware that ships with QEMU
> does not rely on them.
> 
> I'm fine with exposing stuff for debugging purposes
> but I would like a cleaner separation between the two,
> and self-documenting interfaces.
> How about:
> 	- place everything that is under "opt/" in e.g. "supported"
> 	  directory, or at root
> 	- place everything that is not under "opt/" in e.g. "unsupported"
> 	  directory
> 
> Abstracting hardware is what OS is all about, this is not policy.

I'm not sure I agree with this last point:

Arguably, fw_cfg could be viewed as a glorified out-of-band USB stick
with special files prepared by QEMU for the guest VM.

The sysfs driver is a mechanism to list/access these files, and is
IMHO the only thing one can reasonably construe as "kernel interface".

What you're suggesting boils down to adding a translation layer between
what QEMU names the files when preparing this magic USB stick, and what
we tell users the names are (by adding additional folders named e.g.
"supported" and "unsupported").

That to me looks like injecting policy ("look *here*, NOT there!") by
doing this, instead of sticking with mechanism only ("here's what qemu
wrote to fw_cfg, look at it if you want, or don't...").

While I understand your concerns, I'm not sure we should have to go
through this level of convolution to protect people from their own
mistakes (such as assuming certain content on the magic USB stick will
always be there, and writing some sort of script which would break if
said content mysteriously disappears, then reasonably complain about
either the sysfs kernel driver or qemu itself). Presence or absence of
some file on a magic USB stick does NOT (again, IMHO) an interface make...

I was thinking of maybe adding a module parameter, let's call it
"show-all", off by default, and which would cause the "by-name" folder
to only be populated by things starting with "opt" when off, and
all fw-cfg files when enabled. But I'm not sure I like having to do it
in the first place (particularly hardcoding the string "opt" anywhere
in the driver :) ) so let me think about this a bit more (additional
pro/con thoughs and opinions welcome!)...

Thanks,
--Gabriel

> 
> > > > ---
> > > > 
> > > > Changes since v1:
> > > > 	- no more "#ifdef CONFIG_ACPI"; instead we proceed if
> > > > 	  acpi_acquire_global_lock() returns either OK or NOT_CONFIGURED,
> > > > 	  and only throw a warning/error message otherwise.
> > > > 
> > > > 	- didn't get any *negative* feedback from the QEMU crowd, so
> > > > 	  this is now a bona-fide "please apply this", rather than just
> > > > 	  an RFC :)
> > > > 
> > > > 	- tested on ACPI-enabled x86_64, and acpi_less ARM (32 and 64 bit)
> > > > 	  QEMU VMs (I don't have handy access to an ACPI-enabled ARM VM)
> > > > 
> > > > Thanks much,
> > > >   --Gabriel
> > > > 
> > > >  drivers/firmware/qemu_fw_cfg.c | 16 ++++++++++++++++
> > > >  1 file changed, 16 insertions(+)
> > > > 
> > > > diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
> > > > index 7bba76c..a44dc32 100644
> > > > --- a/drivers/firmware/qemu_fw_cfg.c
> > > > +++ b/drivers/firmware/qemu_fw_cfg.c
> > > > @@ -77,12 +77,28 @@ static inline u16 fw_cfg_sel_endianness(u16 key)
> > > >  static inline void fw_cfg_read_blob(u16 key,
> > > >  				    void *buf, loff_t pos, size_t count)
> > > >  {
> > > > +	u32 glk;
> > > > +	acpi_status status;
> > > > +
> > > > +	/* If we have ACPI, ensure mutual exclusion against any potential
> > > > +	 * device access by the firmware, e.g. via AML methods:
> > > > +	 */
> > > > +	status = acpi_acquire_global_lock(ACPI_WAIT_FOREVER, &glk);
> > > > +	if (ACPI_FAILURE(status) && status != AE_NOT_CONFIGURED) {
> > > > +		/* Should never get here */
> > > > +		WARN(1, "fw_cfg_read_blob: Failed to lock ACPI!\n");
> > > > +		memset(buf, 0, count);
> > > > +		return;
> > > > +	}
> > > > +
> > > >  	mutex_lock(&fw_cfg_dev_lock);
> > > >  	iowrite16(fw_cfg_sel_endianness(key), fw_cfg_reg_ctrl);
> > > >  	while (pos-- > 0)
> > > >  		ioread8(fw_cfg_reg_data);
> > > >  	ioread8_rep(fw_cfg_reg_data, buf, count);
> > > >  	mutex_unlock(&fw_cfg_dev_lock);
> > > > +
> > > > +	acpi_release_global_lock(glk);
> > > >  }
> > > >  
> > > >  /* clean up fw_cfg device i/o */
> > > > -- 
> > > > 2.4.3
