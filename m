From: Gabriel Somlo <somlo@cmu.edu>
Subject: [RFC PATCH] firmware: qemu_fw_cfg.c: hold ACPI global
 lock during device access
Date: Mon, 7 Mar 2016 18:55:43 -0500
Message-ID: <20160307235543.GD2049@HEDWIG.INI.CMU.EDU>
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
To: "Michael S. Tsirkin" <mst@redhat.com>, gregkh@linuxfoundation.org, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, lersek@redhat.com, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, eric@anholt.net, hanjun.guo@linaro.org, zajec5@gmail.com, sudeep.holla@arm.com, agross@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, qemu-devel@nongnu.org, imammedo@redhat.com, peter.maydell@linaro.org, leif.lindholm@linaro.org, ard.biesheuvel@linaro.org, pbonzini@redhat.com, kraxel@redhat.com, ehabkost@redhat.com, luto@amacapital.net, stefanha@gmail.com, revol@free.fr, matt@codeblueprint.co.uk, rth@twiddle.net
List-Id: linux-api@vger.kernel.org

Allowing for the future possibility of implementing AML-based
(i.e., firmware-triggered) access to the QEMU fw_cfg device,
acquire the global ACPI lock when accessing the device on behalf
of the guest-side sysfs driver, to prevent any potential race
conditions.

Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
---

Turns out, there *is* a way to acquire a global ACPI lock from within
a "random" kernel driver after all. Luckily I have a healthy dose of
respect for Michael's opinions :) so I kept circling back through
existing kernel sources for an example I can use, and I think this
might be it.

I'm posting as RFC because I'm not really confident about assessing
the likelihood of there ever being a race condition between the kernel
fw_cfg sysfs driver and firmware on my own. Obviously Michael has
concerns about it, but any additional opinions from the QEMU camp would
be much appreciated.

Thanks again,
 --Gabriel

 drivers/firmware/qemu_fw_cfg.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
index 7bba76c..cc4c27a 100644
--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -77,12 +77,26 @@ static inline u16 fw_cfg_sel_endianness(u16 key)
 static inline void fw_cfg_read_blob(u16 key,
 				    void *buf, loff_t pos, size_t count)
 {
+#ifdef CONFIG_ACPI
+	u32 glk;
+	int status;
+	status = acpi_acquire_global_lock(ACPI_WAIT_FOREVER, &glk);
+	if (ACPI_FAILURE(status)) {
+		/* Should never get here */
+		WARN(1, "fw_cfg_read_blob: Failed to lock ACPI!\n");
+		memset(buf, 0, count);
+		return;
+	}
+#endif
 	mutex_lock(&fw_cfg_dev_lock);
 	iowrite16(fw_cfg_sel_endianness(key), fw_cfg_reg_ctrl);
 	while (pos-- > 0)
 		ioread8(fw_cfg_reg_data);
 	ioread8_rep(fw_cfg_reg_data, buf, count);
 	mutex_unlock(&fw_cfg_dev_lock);
+#ifdef CONFIG_ACPI
+	acpi_release_global_lock(glk);
+#endif
 }
 
 /* clean up fw_cfg device i/o */
-- 
2.4.3
