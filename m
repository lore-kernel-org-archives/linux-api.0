From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v8 0/4] SysFS driver for QEMU fw_cfg device
Date: Tue, 9 Feb 2016 17:38:28 -0800
Message-ID: <20160210013828.GA32439@kroah.com>
References: <1453990994-17801-1-git-send-email-somlo@cmu.edu>
	<20160203224729.GB15385@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20160203224729.GB15385@codeblueprint.co.uk>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: mark.rutland@arm.com, peter.maydell@linaro.org, mst@redhat.com, stefanha@gmail.com, qemu-devel@nongnu.org, eric@anholt.net, kraxel@redhat.com, agross@codeaurora.org, pawel.moll@arm.com, zajec5@gmail.com, rmk+kernel@arm.linux.org.uk, lersek@redhat.com, devicetree@vger.kernel.org, ehabkost@redhat.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk, "Gabriel L. Somlo" <somlo@cmu.edu>, galak@codeaurora.org, leif.lindholm@linaro.org, robh+dt@kernel.org, pbonzini@redhat.com, rth@twiddle.net, ard.biesheuvel@linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, luto@amacapital.net, hanjun.guo@linaro.org, sudeep.holla@arm.com, imammedo@redhat.com, revol@free.fr
List-Id: linux-api@vger.kernel.org

On Wed, Feb 03, 2016 at 10:47:29PM +0000, Matt Fleming wrote:
> On Thu, 28 Jan, at 09:23:10AM, Gabriel L. Somlo wrote:
> > From: "Gabriel Somlo" <somlo@cmu.edu>
> > 
> > Allow access to QEMU firmware blobs, passed into the guest VM via
> > the fw_cfg device, through SysFS entries. Blob meta-data (e.g. name,
> > size, and fw_cfg key), as well as the raw binary blob data may be
> > accessed.
> > 
> > The SysFS access location is /sys/firmware/qemu_fw_cfg/... and was
> > selected based on overall similarity to the type of information
> > exposed under /sys/firmware/dmi/entries/...
> > 
> > This functionality is primarily intended to serve as a host->guest
> > configuration data transfer mechanism that is both:
> > 
> >         - asynchronous: the host doesn't need to wait for the guest
> >                         to be ready to accept data (e.g., by starting
> >                         an agent daemon)
> > 
> >         - out-of-band:  there is no need to commandeer a guest element
> >                         normally visible and available to the guest user
> >                         (e.g., kernel cmdline, mounting floppy/cdrom, etc.)
> > 
> > QEMU now allows arbitrary fw_cfg blobs to be added via the command line,
> > so it would be nice to make them easy to retrieve from within the guest
> > OS, and the niceset and easiest way I can think of is
> > 
> >         cat /sys/firmware/qemu-fw-cfg/.../<some-blob-name>/raw
> > 
> > New since v7:
> > 
> > 	- kbuild testbot complained about a warning on ia64, so limit
> > 	  the availability of fw_cfg in Kconfig to only architectures
> > 	  on which QEMU makes it available, which include:
> > 
> > 		(ARM || ARM64 || PPC_PMAC || SPARC || X86)
> 
> This is looking pretty good now. Does anyone have remaining
> objections before this gets merged?

All now merged in my tree, thanks.

greg k-h
