From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v6 3/5] acpi: pc: add fw_cfg device node to ssdt
Date: Wed, 27 Jan 2016 22:02:39 -0500
Message-ID: <1453950161-13252-4-git-send-email-somlo@cmu.edu>
References: <1453950161-13252-1-git-send-email-somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1453950161-13252-1-git-send-email-somlo@cmu.edu>
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
Cc: peter.maydell@linaro.org, ehabkost@redhat.com, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, stefanha@gmail.com, mst@redhat.com, qemu-devel@nongnu.org, leif.lindholm@linaro.org, luto@amacapital.net, kraxel@redhat.com, pbonzini@redhat.com, imammedo@redhat.com, revol@free.fr, rth@twiddle.net
List-Id: linux-api@vger.kernel.org

Add a fw_cfg device node to the ACPI SSDT. While the guest-side
firmware can't utilize this information (since it has to access
the hard-coded fw_cfg device to extract ACPI tables to begin with),
having fw_cfg listed in ACPI will help the guest kernel keep a more
accurate inventory of in-use IO port regions.

Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
Reviewed-by: Laszlo Ersek <lersek@redhat.com>
Reviewed-by: Marc Mar=C3=AD <markmb@redhat.com>
---
 hw/i386/acpi-build.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 78758e2..8a9ae9d 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -2100,6 +2100,35 @@ build_ssdt(GArray *table_data, GArray *linker,
     aml_append(scope, aml_name_decl("_S5", pkg));
     aml_append(ssdt, scope);
=20
+    /* create fw_cfg node, unconditionally */
+    {
+        /* when using port i/o, the 8-bit data register *always* overlap=
s
+         * with half of the 16-bit control register. Hence, the total si=
ze
+         * of the i/o region used is FW_CFG_CTL_SIZE; when using DMA, th=
e
+         * DMA control register is located at FW_CFG_DMA_IO_BASE + 4 */
+        uint8_t io_size =3D object_property_get_bool(OBJECT(guest_info->=
fw_cfg),
+                                                   "dma_enabled", NULL) =
?
+                          ROUND_UP(FW_CFG_CTL_SIZE, 4) + sizeof(dma_addr=
_t) :
+                          FW_CFG_CTL_SIZE;
+
+        scope =3D aml_scope("\\_SB");
+        dev =3D aml_device("FWCF");
+
+        aml_append(dev, aml_name_decl("_HID", aml_string("QEMU0002")));
+
+        /* device present, functioning, decoding, not shown in UI */
+        aml_append(dev, aml_name_decl("_STA", aml_int(0xB)));
+
+        crs =3D aml_resource_template();
+        aml_append(crs,
+            aml_io(AML_DECODE16, FW_CFG_IO_BASE, FW_CFG_IO_BASE, 0x01, i=
o_size)
+        );
+        aml_append(dev, aml_name_decl("_CRS", crs));
+
+        aml_append(scope, dev);
+        aml_append(ssdt, scope);
+    }
+
     if (misc->applesmc_io_base) {
         scope =3D aml_scope("\\_SB.PCI0.ISA");
         dev =3D aml_device("SMC");
--=20
2.4.3
