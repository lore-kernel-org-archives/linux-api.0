Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.207.22.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795183603;
	b=Vn7xfmjf/yMI889jjPSVKKgHvRgaQv0q+IelOEtgObP/sufkBo1UEEmouyPUjTdwPJei
	 F+4gglNctJGoZNifUs6QNwMp0sMmnBRYzZ0EBf8tZyY8l6VWiDDa/ZQcV0L4fnB7sSgLl
	 Vd3DBzdoooaFlij9OzAwL3YRGim15DNFZB8j+bAcDKZ1U70H1VsAE7Be06wCtffSZZJ8i
	 6vVtSXWgBnyHsFnqhuuoRJmhJCU6Gg8ta6i1EqlINhn7RNCG10dbekBa0O1ZNwMgEfYeh
	 TqVu1VmHQtYrvBcS2oX4btJ6RQfYEFiIxnIL2+I4TunHOyceHBGoHvWT2Kn4tDYFZCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183603;
	h=DMARC-Filter:X-QQ-mid:X-QQ-Originating-IP:Received:X-QQ-SSF:
	 X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=nNZhtmRIM047yhBKT8X8RLzUb8LET8YKY7Oa6BiQeSc=;
	b=dWINgyurYkKbeveDlL3it+V03ufKQ/xKJdvq23m8GMnlOl1HOLaL9sYs9HesNeCtpZsn
	 H11LB9yBuJwu2nqtrUOBmNtw9wwr0szBB+NpFsE9FgoetuPgX5+/4eo98YPNyXSm5Haxa
	 FbXy9YyC7sl2Bt0Y6L+ZK1a7tbjuD3QfMTq3pZX+PSmbg2s+mnIORx8pUrUdAw1j0m+Cb
	 s+1v9tgfBdQNx6xNOkfx1QPGnZQUIDGKXpD/EmgR1HG3sXN0cgiCHo8l5Lz6+M6a9Di0Y
	 3WQKXqGpoOCJ1X+yIe/tfRRSnhSRx6jcJH40CS8ZVBjcVeXlEd7njQBcuSSzsjfPsPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=rustsbi.com;
	spf=pass smtp.mailfrom=rustsbi.com;
	arc=none smtp.remote-ip=54.207.22.56
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084DA606A325;
	Fri, 20 Nov 2026 14:06:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 084DA606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rustsbi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rustsbi.com
X-QQ-mid: zesmtpsz5t1795183587t5e1ea204
X-QQ-Originating-IP: Suueltk2ejW08uvMajlx+AId6WW+hxY2z+cJdixf2pY=
Received: from LAPTOP-H63V2Q11 ( [36.110.52.2])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 20 Nov 2026 22:06:23 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 16130469025861869900
EX-QQ-RecipientCnt: 15
From: Zhouqi Jiang <luojia@rustsbi.com>
To: linux-riscv@lists.infradead.org
Cc: Conor Dooley <conor@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Anup Patel <anup@brainfault.org>,
	Andrew Davis <afd@ti.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Alejandro Colomar <alx@kernel.org>,
	contact@rustsbi.com
Subject: [PATCH v2] riscv: sbi: expose firmware identity in sysfs
Date: Fri, 20 Nov 2026 22:05:58 +0800
Message-ID: <8AA327A849404B45+20261120140557.776-2-luojia@rustsbi.com>
X-Mailer: git-send-email 2.53.0.windows.2
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:rustsbi.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: M4K5nIxZYv59/6EhryRLMXjr2dRVc5qRkusdMysni4BIshNeP3fqpgbe
	I0jRSJrjh35o5jFfDtiJ/H4bXuLH8xqK6z95XvZbxcZgjuGdGlxkdfHIzOVHe19HbmedgQ2
	770krGixGqJLLJobB5OfNnXsg3WPbWsi1el9R+QRHywXPhxJY4MN4sQkALXZSlX7/G/A1Hp
	FEWAEK7DXmmpk7/jQvCaJvAHOXTyYEXFjXfJFf+xts77l9/3vpWpu7EIKhbndBiQ9RQF81r
	BASihpVZ7Tdl3g9C9500xlcX26/RFi24GlqQ1phj8lulhLR4IaVBTrH6xE5U82eNbLUb5ey
	M9q0HZgTv5q9eUZ+fk2b02PnbHnK9UJ+mmT+19pcIhkatHlSPbuzEIiM2Zh+9agwhQbMIXj
	taVoeBfF2lIbljQrqUcRsmXMBojS/4IzKY2WiM7U8taACzkP/s9+HChcljeAKnLYI0qfZ0P
	Hw8cBhkeoPtBEzpVlXpmyYeynRs346DiE90hliwVhL15THxiMwcAftYJ/cvy8LI91MSHwZ4
	LclXQ3dg9MddyPkRdyie6nY3hn5IIbHueT8cZLkAT4zjfwe/PpY+QOnGuJbhRAqtbExftvm
	Fzx036kR7rp8wZjl6LuU6rWWAx2UoUoOlPipPuDS+PNyvt2yUQ+BZMNrQzQhlVIUWM1lOFp
	MPPONyVz1kqg0osa9d0RsJ84/VBUb9soUdFTzycjzAqrTiogOK4kIRIF2rzbYufrskZrdjF
	ihQS1Gc6dL7cBczW3nstUQSooEDBMH1+83MaTuNR+Qedk2vfKOvdqfAeWAFqTlbUZ/XEoOj
	uB4QXpm+zzi4Gh5ssKpB50fkSjF0od/lY+cLrHF8uxV5Lrzk6AcQMxy91pNdafSp+w0HBy1
	py61acsVPVgulZU5kM+GPkFiBlbal38gs1xCMoAdYwY5W7lRVD2ItIwy1WDezqIaqwRNuxf
	2mJhsvUPkRfkTte8XaqVGoSRfvJquhMgou/EGyCqO7GjIHgg07CgsgQXYhgwjxI4Dpbnvul
	wM8NE4Yg9rARnW3uB6iddfifJHHlyjHvbteCHPJI+Ds4/Zf0Zp
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

Linux queries the SBI specification and implementation identity during
boot. It caches the specification version, but discards the
implementation ID and version after logging them. Userspace therefore
has no structured interface for this immutable firmware metadata.

Cache the implementation ID and version and expose the available values
as read-only attributes under /sys/firmware/sbi:

  spec_version
  impl_id
  impl_version

SBI v0.1 systems expose only spec_version because the implementation
fields were introduced by the SBI Base extension in v0.2.

Format impl_id as unsigned decimal to match the SBI implementation ID
table. Expose the implementation-specific version encoding in
hexadecimal.

This gives tools such as lssbi a native source for basic SBI identity
information and starts moving those queries away from out-of-tree
kernel modules.

Tested-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Zhouqi Jiang <luojia@rustsbi.com>
---
Changes in v2:
- Use unsigned decimal for impl_id and update the ABI documentation.

The RFC was built with a RISC-V defconfig and boot-tested on QEMU virt
with OpenSBI v1.3 and RustSBI v0.4.1. Conor tested it on PolarFire HSS.

RFC resend: https://lore.kernel.org/r/A039A2DE1DF8F274+20261119130356.1537-1-luojia@rustsbi.com

 Documentation/ABI/testing/sysfs-firmware-sbi | 29 +++++++++++++
 MAINTAINERS                                  |  1 +
 arch/riscv/kernel/sbi.c                      | 62 +++++++++++++++++++++++++++-
 3 files changed, 91 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-sbi

diff --git a/Documentation/ABI/testing/sysfs-firmware-sbi b/Documentation/ABI/testing/sysfs-firmware-sbi
new file mode 100644
index 000000000000..ade66f3608ac
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-sbi
@@ -0,0 +1,29 @@
+What:		/sys/firmware/sbi/spec_version
+Date:		August 2026
+Contact:	Linux RISC-V mailing list <linux-riscv@lists.infradead.org>
+Description:
+		The SBI specification version available to Linux, formatted as two
+		unsigned decimal integers separated by a period and followed by a
+		newline. For example, SBI v0.2 is represented as "0.2".
+Users:		lssbi
+
+What:		/sys/firmware/sbi/impl_id
+Date:		August 2026
+Contact:	Linux RISC-V mailing list <linux-riscv@lists.infradead.org>
+Description:
+		The SBI implementation ID, formatted as an unsigned decimal
+		integer followed by a newline. For example, OpenSBI is
+		represented as "1". The ID is assigned by the SBI specification.
+		This attribute is present only when SBI v0.2 or later is available.
+Users:		lssbi
+
+What:		/sys/firmware/sbi/impl_version
+Date:		August 2026
+Contact:	Linux RISC-V mailing list <linux-riscv@lists.infradead.org>
+Description:
+		The SBI implementation version, formatted as lowercase hexadecimal
+		with a 0x prefix, no leading zero padding, and a trailing newline.
+		Its encoding is specific to the SBI implementation identified by
+		impl_id. This attribute is present only when SBI v0.2 or
+		later is available.
+Users:		lssbi
diff --git a/MAINTAINERS b/MAINTAINERS
index 0b42e898f4d8..707afa1af1a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23494,6 +23494,7 @@ Q:	https://patchwork.kernel.org/project/linux-riscv/list/
 C:	irc://irc.libera.chat/riscv
 P:	Documentation/arch/riscv/patch-acceptance.rst
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git
+F:	Documentation/ABI/testing/sysfs-firmware-sbi
 F:	arch/riscv/
 N:	riscv
 K:	riscv
diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index c443337056ab..cb3b87f1bfdc 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -7,6 +7,7 @@
 
 #include <linux/bits.h>
 #include <linux/init.h>
+#include <linux/kobject.h>
 #include <linux/mm.h>
 #include <linux/pm.h>
 #include <linux/reboot.h>
@@ -18,6 +19,9 @@
 unsigned long sbi_spec_version __ro_after_init = SBI_SPEC_VERSION_DEFAULT;
 EXPORT_SYMBOL(sbi_spec_version);
 
+static unsigned long sbi_impl_id __ro_after_init;
+static unsigned long sbi_impl_version __ro_after_init;
+
 static void (*__sbi_set_timer)(uint64_t stime) __ro_after_init;
 static void (*__sbi_send_ipi)(unsigned int cpu) __ro_after_init;
 static int (*__sbi_rfence)(int fid, const struct cpumask *cpu_mask,
@@ -659,8 +663,10 @@ void __init sbi_init(void)
 		sbi_major_version(), sbi_minor_version());
 
 	if (!sbi_spec_is_0_1()) {
+		sbi_impl_id = sbi_get_firmware_id();
+		sbi_impl_version = sbi_get_firmware_version();
 		pr_info("SBI implementation ID=0x%lx Version=0x%lx\n",
-			sbi_get_firmware_id(), sbi_get_firmware_version());
+			sbi_impl_id, sbi_impl_version);
 		if (sbi_probe_extension(SBI_EXT_TIME)) {
 			__sbi_set_timer = __sbi_set_timer_v02;
 			pr_info("SBI TIME extension detected\n");
@@ -707,3 +713,57 @@ void __init sbi_init(void)
 	if (!srst_power_off)
 		sbi_set_power_off();
 }
+
+static ssize_t spec_version_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu.%lu\n",
+			  sbi_major_version(), sbi_minor_version());
+}
+
+static ssize_t impl_id_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", sbi_impl_id);
+}
+
+static ssize_t impl_version_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "0x%lx\n", sbi_impl_version);
+}
+
+static struct kobj_attribute spec_version_attr = __ATTR_RO(spec_version);
+static struct kobj_attribute impl_id_attr = __ATTR_RO(impl_id);
+static struct kobj_attribute impl_version_attr = __ATTR_RO(impl_version);
+
+static umode_t sbi_attr_is_visible(struct kobject *kobj,
+				   struct attribute *attr, int n)
+{
+	if (sbi_spec_is_0_1() && attr != &spec_version_attr.attr)
+		return 0;
+
+	return attr->mode;
+}
+
+static struct attribute *sbi_attrs[] = {
+	&spec_version_attr.attr,
+	&impl_id_attr.attr,
+	&impl_version_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group sbi_attr_group = {
+	.name = "sbi",
+	.is_visible = sbi_attr_is_visible,
+	.attrs = sbi_attrs,
+};
+
+static int __init sbi_sysfs_init(void)
+{
+	if (!firmware_kobj)
+		return -ENOMEM;
+
+	return sysfs_create_group(firmware_kobj, &sbi_attr_group);
+}
+subsys_initcall(sbi_sysfs_init);

base-commit: 1b78070aaef63512688aebfbc82365ef9d6660f1
