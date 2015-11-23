From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/4] devicetree: update documentation for fw_cfg ARM
 bindings
Date: Mon, 23 Nov 2015 17:35:51 +0100
Message-ID: <56534067.6040401@redhat.com>
References: <1448294264-17388-1-git-send-email-somlo@cmu.edu>
 <1448294264-17388-5-git-send-email-somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448294264-17388-5-git-send-email-somlo-D+Gtc/HYRWM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, revol-GANU6spQydw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/23/15 16:57, Gabriel L. Somlo wrote:
> From: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
> 
> Remove fw_cfg hardware interface details from
> Documentation/devicetree/bindings/arm/fw-cfg.txt,
> and replace them with a pointer to the authoritative
> documentation in the QEMU source tree.
> 
> Signed-off-by: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
> Cc: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/devicetree/bindings/arm/fw-cfg.txt | 38 ++----------------------
>  1 file changed, 2 insertions(+), 36 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/fw-cfg.txt b/Documentation/devicetree/bindings/arm/fw-cfg.txt
> index 953fb64..ce27386 100644
> --- a/Documentation/devicetree/bindings/arm/fw-cfg.txt
> +++ b/Documentation/devicetree/bindings/arm/fw-cfg.txt
> @@ -11,43 +11,9 @@ QEMU exposes the control and data register to ARM guests as memory mapped
>  registers; their location is communicated to the guest's UEFI firmware in the
>  DTB that QEMU places at the bottom of the guest's DRAM.
>  
> -The guest writes a selector value (a key) to the selector register, and then
> -can read the corresponding data (produced by QEMU) via the data register. If
> -the selected entry is writable, the guest can rewrite it through the data
> -register.
> +The authoritative guest-side hardware interface documentation to the fw_cfg
> +device ca be found in "docs/specs/fw_cfg.txt" in the QEMU source tree.

ca[n] be found

>  
> -The selector register takes keys in big endian byte order.
> -
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
> 

As long as Peter is fine with this, I don't object.

With the typo fixed:

Reviewed-by: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
