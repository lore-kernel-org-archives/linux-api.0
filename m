From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v6 2/5] pc: fw_cfg: move ioport base constant
	to pc.h
Date: Wed, 27 Jan 2016 22:02:38 -0500
Message-ID: <1453950161-13252-3-git-send-email-somlo@cmu.edu>
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

Move BIOS_CFG_IOPORT define from pc.c to pc.h, and rename
it to FW_CFG_IO_BASE.

Cc: Marc Mar=C3=AD <markmb@redhat.com>
Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
Reviewed-by: Laszlo Ersek <lersek@redhat.com>
Reviewed-by: Marc Mar=C3=AD <markmb@redhat.com>
---
 hw/i386/pc.c         | 5 ++---
 include/hw/i386/pc.h | 2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 78cf8fa..aa79dd1 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -77,7 +77,6 @@
 #define DPRINTF(fmt, ...)
 #endif
=20
-#define BIOS_CFG_IOPORT 0x510
 #define FW_CFG_ACPI_TABLES (FW_CFG_ARCH_LOCAL + 0)
 #define FW_CFG_SMBIOS_ENTRIES (FW_CFG_ARCH_LOCAL + 1)
 #define FW_CFG_IRQ0_OVERRIDE (FW_CFG_ARCH_LOCAL + 2)
@@ -755,7 +754,7 @@ static FWCfgState *bochs_bios_init(AddressSpace *as)
     int i, j;
     unsigned int apic_id_limit =3D pc_apic_id_limit(max_cpus);
=20
-    fw_cfg =3D fw_cfg_init_io_dma(BIOS_CFG_IOPORT, BIOS_CFG_IOPORT + 4, =
as);
+    fw_cfg =3D fw_cfg_init_io_dma(FW_CFG_IO_BASE, FW_CFG_IO_BASE + 4, as=
);
=20
     /* FW_CFG_MAX_CPUS is a bit confusing/problematic on x86:
      *
@@ -1269,7 +1268,7 @@ FWCfgState *xen_load_linux(PCMachineState *pcms,
=20
     assert(MACHINE(pcms)->kernel_filename !=3D NULL);
=20
-    fw_cfg =3D fw_cfg_init_io(BIOS_CFG_IOPORT);
+    fw_cfg =3D fw_cfg_init_io(FW_CFG_IO_BASE);
     rom_set_fw(fw_cfg);
=20
     load_linux(pcms, fw_cfg);
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 65e8f24..0a4e0da 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -272,6 +272,8 @@ void ioapic_init_gsi(GSIState *gsi_state, const char =
*parent_name);
=20
 ISADevice *pc_find_fdc0(void);
=20
+#define FW_CFG_IO_BASE     0x510
+
 /* acpi_piix.c */
=20
 I2CBus *piix4_pm_init(PCIBus *bus, int devfn, uint32_t smb_io_base,
--=20
2.4.3
