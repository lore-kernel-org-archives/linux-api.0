From: Rob Herring <robh@kernel.org>
Subject: Re: [Qemu-devel] [PATCH v4 4/4] devicetree: update documentation for
 fw_cfg ARM bindings
Date: Sat, 14 Nov 2015 20:07:54 -0600
Message-ID: <20151115020754.GA21323@rob-hp-laptop>
References: <1447470235-13643-1-git-send-email-somlo@cmu.edu>
 <1447470235-13643-5-git-send-email-somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447470235-13643-5-git-send-email-somlo@cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Cc: gregkh@linuxfoundation.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, lersek@redhat.com, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, eric@anholt.net, hanjun.guo@linaro.org, zajec5@gmail.com, sudeep.holla@arm.com, agross@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, peter.maydell@linaro.org, matt.fleming@intel.com, mst@redhat.com, jordan.l.justen@intel.com, kernelnewbies@kernelnewbies.org, qemu-devel@nongnu.org, leif.lindholm@linaro.org, luto@amacapital.net, ard.biesheuvel@linaro.org, kraxel@redhat.com, stefanha@gmail.com, pbonzini@redhat.com
List-Id: linux-api@vger.kernel.org

On Fri, Nov 13, 2015 at 10:03:55PM -0500, Gabriel L. Somlo wrote:
> From: Gabriel Somlo <somlo@cmu.edu>
> 
> Remove redundant details from
> Documentation/devicetree/bindings/arm/fw-cfg.txt,
> and replace them with a pointer to the more comprehensive
> fw_cfg documentation privided by
> Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg,
> leaving the specific ARM DTB node description in place.

We generally don't want DT docs to depend on other kernel documentation. 
That will make separating them harder.

> 
> Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
> Cc: Laszlo Ersek <lersek@redhat.com>
> ---
>  Documentation/devicetree/bindings/arm/fw-cfg.txt | 37 ++----------------------
>  1 file changed, 2 insertions(+), 35 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/fw-cfg.txt b/Documentation/devicetree/bindings/arm/fw-cfg.txt
> index 953fb64..7aeb48a 100644
> --- a/Documentation/devicetree/bindings/arm/fw-cfg.txt
> +++ b/Documentation/devicetree/bindings/arm/fw-cfg.txt
> @@ -11,43 +11,10 @@ QEMU exposes the control and data register to ARM guests as memory mapped
>  registers; their location is communicated to the guest's UEFI firmware in the
>  DTB that QEMU places at the bottom of the guest's DRAM.
>  
> -The guest writes a selector value (a key) to the selector register, and then
> -can read the corresponding data (produced by QEMU) via the data register. If
> -the selected entry is writable, the guest can rewrite it through the data
> -register.
>  
> -The selector register takes keys in big endian byte order.
> +For a comprehensive description of the behavior of fw_cfg, please see
> +Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg.
>  
> -The data register allows accesses with 8, 16, 32 and 64-bit width (only at
> -offset 0 of the register). Accesses larger than a byte are interpreted as
> -arrays, bundled together only for better performance. The bytes constituting
> -such a word, in increasing address order, correspond to the bytes that would
> -have been transferred by byte-wide accesses in chronological order.
> -
> -The interface allows guest firmware to download various parameters and blobs
> -that affect how the firmware works and what tables it installs for the guest
> -OS. For example, boot order of devices, ACPI tables, SMBIOS tables, kernel and
> -initrd images for direct kernel booting, virtual machine UUID, SMP information,
> -virtual NUMA topology, and so on.
> -
> -The authoritative registry of the valid selector values and their meanings is
> -the QEMU source code; the structure of the data blobs corresponding to the
> -individual key values is also defined in the QEMU source code.
> -
> -The presence of the registers can be verified by selecting the "signature" blob
> -with key 0x0000, and reading four bytes from the data register. The returned
> -signature is "QEMU".
> -
> -The outermost protocol (involving the write / read sequences of the control and
> -data registers) is expected to be versioned, and/or described by feature bits.
> -The interface revision / feature bitmap can be retrieved with key 0x0001. The
> -blob to be read from the data register has size 4, and it is to be interpreted
> -as a uint32_t value in little endian byte order. The current value
> -(corresponding to the above outer protocol) is zero.
> -
> -The guest kernel is not expected to use these registers (although it is
> -certainly allowed to); the device tree bindings are documented here because
> -this is where device tree bindings reside in general.
>  
>  Required properties:
>  
> -- 
> 2.4.3
> 
> 
