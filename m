From: Gabriel Somlo <somlo@cmu.edu>
Subject: [PATCH v2] firmware: qemu_fw_cfg.c: hold ACPI global
 lock during device access
Date: Tue, 8 Mar 2016 13:30:50 -0500
Message-ID: <20160308183050.GJ2049@HEDWIG.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: mark.rutland@arm.com, peter.maydell@linaro.org, matt@codeblueprint.co.uk, stefanha@gmail.com, qemu-devel@nongnu.org, eric@anholt.net, kraxel@redhat.com, linux-api@vger.kernel.org, agross@codeaurora.org, pawel.moll@arm.com, zajec5@gmail.com, rmk+kernel@arm.linux.org.uk, lersek@redhat.com, devicetree@vger.kernel.org, ehabkost@redhat.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, leif.lindholm@linaro.org, robh+dt@kernel.org, pbonzini@redhat.com, rth@twiddle.net, ard.biesheuvel@linaro.org, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, luto@amacapital.net, hanjun.guo@linaro.org, sudeep.holla@arm.com, imammedo@redhat.com, revol@free.fr
List-Id: linux-api@vger.kernel.org

Allowing for the future possibility of implementing AML-based
(i.e., firmware-triggered) access to the QEMU fw_cfg device,
acquire the global ACPI lock when accessing the device on behalf
of the guest-side sysfs driver, to prevent any potential race
conditions.

Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
---

Changes since v1:
	- no more "#ifdef CONFIG_ACPI"; instead we proceed if
	  acpi_acquire_global_lock() returns either OK or NOT_CONFIGURED,
	  and only throw a warning/error message otherwise.

	- didn't get any *negative* feedback from the QEMU crowd, so
	  this is now a bona-fide "please apply this", rather than just
	  an RFC :)

	- tested on ACPI-enabled x86_64, and acpi_less ARM (32 and 64 bit)
	  QEMU VMs (I don't have handy access to an ACPI-enabled ARM VM)

Thanks much,
  --Gabriel

 drivers/firmware/qemu_fw_cfg.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
index 7bba76c..a44dc32 100644
--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -77,12 +77,28 @@ static inline u16 fw_cfg_sel_endianness(u16 key)
 static inline void fw_cfg_read_blob(u16 key,
 				    void *buf, loff_t pos, size_t count)
 {
+	u32 glk;
+	acpi_status status;
+
+	/* If we have ACPI, ensure mutual exclusion against any potential
+	 * device access by the firmware, e.g. via AML methods:
+	 */
+	status = acpi_acquire_global_lock(ACPI_WAIT_FOREVER, &glk);
+	if (ACPI_FAILURE(status) && status != AE_NOT_CONFIGURED) {
+		/* Should never get here */
+		WARN(1, "fw_cfg_read_blob: Failed to lock ACPI!\n");
+		memset(buf, 0, count);
+		return;
+	}
+
 	mutex_lock(&fw_cfg_dev_lock);
 	iowrite16(fw_cfg_sel_endianness(key), fw_cfg_reg_ctrl);
 	while (pos-- > 0)
 		ioread8(fw_cfg_reg_data);
 	ioread8_rep(fw_cfg_reg_data, buf, count);
 	mutex_unlock(&fw_cfg_dev_lock);
+
+	acpi_release_global_lock(glk);
 }
 
 /* clean up fw_cfg device i/o */
-- 
2.4.3
