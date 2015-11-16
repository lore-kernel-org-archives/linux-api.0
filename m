From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: Re: [Qemu-devel] [PATCH v4 4/4] devicetree: update documentation for
 fw_cfg ARM bindings
Date: Mon, 16 Nov 2015 08:51:52 -0500
Message-ID: <20151116135152.GE23241@HEDWIG.INI.CMU.EDU>
References: <1447470235-13643-1-git-send-email-somlo@cmu.edu>
 <1447470235-13643-5-git-send-email-somlo@cmu.edu>
 <20151115020754.GA21323@rob-hp-laptop>
 <564995FA.40308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564995FA.40308@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rob Herring <robh@kernel.org>, gregkh@linuxfoundation.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, lersek@redhat.com, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, eric@anholt.net, hanjun.guo@linaro.org, zajec5@gmail.com, sudeep.holla@arm.com, agross@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, peter.maydell@linaro.org, matt.fleming@intel.com, mst@redhat.com, jordan.l.justen@intel.com, kernelnewbies@kernelnewbies.org, qemu-devel@nongnu.org, leif.lindholm@linaro.org, luto@amacapital.net, ard.biesheuvel@linaro.org, kraxel@redhat.com, stefanha@gmail.com
List-Id: linux-api@vger.kernel.org

On Mon, Nov 16, 2015 at 09:38:18AM +0100, Paolo Bonzini wrote:
> On 15/11/2015 03:07, Rob Herring wrote:
> > We generally don't want DT docs to depend on other kernel documentation.
> 
> DT docs do not contain a copy of the data sheets, either.  There is no
> reason to say how to use the device (and even then, only doing so
> partially) in the DT docs.

I believe "Documentation/devicetree/bindings/arm/fw-cfg.txt"
was added by Laszlo (via commit 53275a61) mainly to document
the (base,size) DT node for ARM fw_cfg register set (based on
the idea that Documentation/devicetree/... is the authoritative
place to park DT node information like that.

The additional bits about how fw_cfg works were added for context,
since at the time the kernel itself didn't have anything else to
do with fw_cfg.

Since the sysfs driver I'm proposing (to allow fw_cfg data to be
viewed from userspace) works on a wider set of architectures (x86,
ARM, ppc/mac and sun4*), documentation on fw_cfg behavior belongs
in a more cross-platform location, such as
Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg.

So Documentation/devicetree/bindings/arm/fw-cfg.txt should probably
be limited to specifying the DT node details for ARM only. I figured
it'd be nice to point at the new interface doc file to compensate
for removing that information, but I'd be happy to not do that and
just remove the redundant bits.

Probably some of the stuff I just wrote should go into the commit
log for the next version of the patch :)

Thanks much,
--Gabriel
