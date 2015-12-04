From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v6 4/4] devicetree: update documentation for
	fw_cfg ARM bindings
Date: Fri,  4 Dec 2015 10:29:06 -0500
Message-ID: <1449242946-12062-5-git-send-email-somlo@cmu.edu>
References: <1449242946-12062-1-git-send-email-somlo@cmu.edu>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1449242946-12062-1-git-send-email-somlo@cmu.edu>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: gregkh@linuxfoundation.org, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, lersek@redhat.com, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, eric@anholt.net, hanjun.guo@linaro.org, zajec5@gmail.com, sudeep.holla@arm.com, agross@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: peter.maydell@linaro.org, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, jordan.l.justen@intel.com, mst@redhat.com, qemu-devel@nongnu.org, leif.lindholm@linaro.org, luto@amacapital.net, kraxel@redhat.com, stefanha@gmail.com, pbonzini@redhat.com, revol@free.fr
List-Id: linux-api@vger.kernel.org

From: Gabriel Somlo <somlo@cmu.edu>

Remove fw_cfg hardware interface details from
Documentation/devicetree/bindings/arm/fw-cfg.txt,
and replace them with a pointer to the authoritative
documentation in the QEMU source tree.

Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
Cc: Laszlo Ersek <lersek@redhat.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Laszlo Ersek <lersek@redhat.com>
---
 Documentation/devicetree/bindings/arm/fw-cfg.txt | 38 ++----------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/fw-cfg.txt b/Documentation/devicetree/bindings/arm/fw-cfg.txt
index 953fb64..fd54e1d 100644
--- a/Documentation/devicetree/bindings/arm/fw-cfg.txt
+++ b/Documentation/devicetree/bindings/arm/fw-cfg.txt
@@ -11,43 +11,9 @@ QEMU exposes the control and data register to ARM guests as memory mapped
 registers; their location is communicated to the guest's UEFI firmware in the
 DTB that QEMU places at the bottom of the guest's DRAM.
 
-The guest writes a selector value (a key) to the selector register, and then
-can read the corresponding data (produced by QEMU) via the data register. If
-the selected entry is writable, the guest can rewrite it through the data
-register.
+The authoritative guest-side hardware interface documentation to the fw_cfg
+device can be found in "docs/specs/fw_cfg.txt" in the QEMU source tree.
 
-The selector register takes keys in big endian byte order.
-
-The data register allows accesses with 8, 16, 32 and 64-bit width (only at
-offset 0 of the register). Accesses larger than a byte are interpreted as
-arrays, bundled together only for better performance. The bytes constituting
-such a word, in increasing address order, correspond to the bytes that would
-have been transferred by byte-wide accesses in chronological order.
-
-The interface allows guest firmware to download various parameters and blobs
-that affect how the firmware works and what tables it installs for the guest
-OS. For example, boot order of devices, ACPI tables, SMBIOS tables, kernel and
-initrd images for direct kernel booting, virtual machine UUID, SMP information,
-virtual NUMA topology, and so on.
-
-The authoritative registry of the valid selector values and their meanings is
-the QEMU source code; the structure of the data blobs corresponding to the
-individual key values is also defined in the QEMU source code.
-
-The presence of the registers can be verified by selecting the "signature" blob
-with key 0x0000, and reading four bytes from the data register. The returned
-signature is "QEMU".
-
-The outermost protocol (involving the write / read sequences of the control and
-data registers) is expected to be versioned, and/or described by feature bits.
-The interface revision / feature bitmap can be retrieved with key 0x0001. The
-blob to be read from the data register has size 4, and it is to be interpreted
-as a uint32_t value in little endian byte order. The current value
-(corresponding to the above outer protocol) is zero.
-
-The guest kernel is not expected to use these registers (although it is
-certainly allowed to); the device tree bindings are documented here because
-this is where device tree bindings reside in general.
 
 Required properties:
 
-- 
2.4.3
