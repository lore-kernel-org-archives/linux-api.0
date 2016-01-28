From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v6 1/5] fw_cfg: expose control register size in
	fw_cfg.h
Date: Wed, 27 Jan 2016 22:02:37 -0500
Message-ID: <1453950161-13252-2-git-send-email-somlo@cmu.edu>
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

Expose the size of the control register (FW_CFG_CTL_SIZE) in fw_cfg.h.
Add comment to fw_cfg_io_realize() pointing out that since the
8-bit data register is always subsumed by the 16-bit control
register in the port I/O case, we use the control register width
as the *total* width of the (classic, non-DMA) port I/O region reserved
for the device.

Cc: Marc Mar=C3=AD <markmb@redhat.com>
Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
Reviewed-by: Laszlo Ersek <lersek@redhat.com>
Reviewed-by: Marc Mar=C3=AD <markmb@redhat.com>
---
 hw/nvram/fw_cfg.c         | 4 +++-
 include/hw/nvram/fw_cfg.h | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
index a1d650d..06a4ff0 100644
--- a/hw/nvram/fw_cfg.c
+++ b/hw/nvram/fw_cfg.c
@@ -31,7 +31,6 @@
 #include "qemu/error-report.h"
 #include "qemu/config-file.h"
=20
-#define FW_CFG_CTL_SIZE 2
 #define FW_CFG_NAME "fw_cfg"
 #define FW_CFG_PATH "/machine/" FW_CFG_NAME
=20
@@ -881,6 +880,9 @@ static void fw_cfg_io_realize(DeviceState *dev, Error=
 **errp)
     FWCfgIoState *s =3D FW_CFG_IO(dev);
     SysBusDevice *sbd =3D SYS_BUS_DEVICE(dev);
=20
+    /* when using port i/o, the 8-bit data register ALWAYS overlaps
+     * with half of the 16-bit control register. Hence, the total size
+     * of the i/o region used is FW_CFG_CTL_SIZE */
     memory_region_init_io(&s->comb_iomem, OBJECT(s), &fw_cfg_comb_mem_op=
s,
                           FW_CFG(s), "fwcfg", FW_CFG_CTL_SIZE);
     sysbus_add_io(sbd, s->iobase, &s->comb_iomem);
diff --git a/include/hw/nvram/fw_cfg.h b/include/hw/nvram/fw_cfg.h
index 664eaf6..2667ca9 100644
--- a/include/hw/nvram/fw_cfg.h
+++ b/include/hw/nvram/fw_cfg.h
@@ -46,6 +46,9 @@
=20
 #define FW_CFG_INVALID          0xffff
=20
+/* width in bytes of fw_cfg control register */
+#define FW_CFG_CTL_SIZE         0x02
+
 #define FW_CFG_MAX_FILE_PATH    56
=20
 #ifndef NO_QEMU_PROTOS
--=20
2.4.3
