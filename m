From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v8 1/4] firmware: introduce sysfs driver
 for QEMU's fw_cfg device
Date: Sun, 21 Feb 2016 15:14:00 +0200
Message-ID: <20160221151050-mutt-send-email-mst@redhat.com>
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
> > So for all arches which support ACPI, I think this driver
> > should just rely on ACPI.
> 
> There was a discussion about that a few versions ago, and IIRC the
> conclusion was not to expect the firmware to contend for fw_cfg access
> after the guest kernel boots:
> 
> https://lkml.org/lkml/2015/10/5/283

Interesting. Igor wanted to do this again recently ...
I'll think it over and get back to you/list on this.

> (I even had a prototype version doing what you suggested, but per the above
> reference decided to drop it -- which IMHO is for the better, since otherwise
> I'd have had to ifdef between ACPI and non-ACPI versions of the driver --
> see https://lkml.org/lkml/2015/11/4/534 )

I'm not sure I get it - won't you only ifdef the accessor function?

-- 
MST
