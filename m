Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C4D282F13;
	Fri, 28 Aug 2026 08:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787904273; cv=none; b=Gox2JcXxsEAI2C/Zmh4ac8G5XFA3BRo5CZ1QTygeQ7db/0yoR3FDyRp5HUjBY36OBKTumyBoj35LnuAwsACurxi2HoYWicxBtLhzCSl1VkIMCXQZqvPvYr4GqQES+h8Rma5TKhfiacFbzUT699WzB5HLnuF1QTsMmLBlfl4jwFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787904273; c=relaxed/simple;
	bh=DX6KqcRp5w/L15zA18mO5jMrLbOSBs4jpC2BO2nK/oU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tnz7CdPIh7Jdm+l2bf4mstMeXz/C38UpBR1qRgNO/fz+fY2PT5oHjXtQ3mKZNgJqPLSneZw+bfWSvcePv1wG7/g+ogDWOme27KioV2c8pDOZcbdCyfQqvtMbzuXRdcyoOZCqTCooaw6Tp6ANburO3Uhhsb9gFUeKEOS2oXaCkT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rustsbi.com; spf=pass smtp.mailfrom=rustsbi.com; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rustsbi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rustsbi.com
X-QQ-mid: esmtpgz15t1787904164t9339fc06
X-QQ-Originating-IP: Y5AW+NcdQxWYRgUCsGVXsA7/LrkzO6I5jWOK7pToFOs=
Received: from jiangzhouqi-ubuntu-4090-01.. ( [36.110.52.2])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 28 Aug 2026 16:02:41 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 951474552125263669
EX-QQ-RecipientCnt: 12
From: Zhouqi Jiang <luojia@rustsbi.com>
To: linux-riscv@lists.infradead.org
Cc: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Anup Patel <anup@brainfault.org>,
	Andrew Davis <afd@ti.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	contact@rustsbi.com
Subject: [RFC PATCH] riscv: sbi: expose firmware identity in sysfs
Date: Fri, 28 Aug 2026 16:02:34 +0800
Message-ID: <12AB33826A60C951+20260828080234.44924-1-luojia@rustsbi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:rustsbi.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: MoArgwBnifFrZB1c8w1pLpPrb/3GvocVa/nFgrJh80hUJAXoZdHY/HDU
	i1TmG6fs2gTd2+hOyWV29IW0bc8HRsAiq83hBdP6SL3IzFjcIeoSfmlKLSf0ohuPh+Qx2VO
	+//t0SAYlRWPsJgsPBjpUfO4OlRX++PwwgKS06kQ5aG3aoJzUCrd2ZFqTrpANjxfbbvKGxB
	cJUWko3bQk0BOAfDG/ghMVid97WLYHGyahTZkY3udGF/T8qE35aNQJXbrbwvj6bQvZa6/KD
	lwmJrzip7xaRuZl9Q+LZkh2j6TnFZ6T3rDAZnyh1YnTUi+Q2ahGkJGDxOSUTsetE3KBvE9N
	Skxv1QO7xbmut7855ZfHhpSIi+GVGHgqLBTYwVmuE25950wv/sUImMAWwa8VYFTeyECTOIa
	7Olho2mg3NKElUxpmD+HRH+rfRC7miO6yU//QXujbfArJ6fvYgIbnEpleRI26ra+jgbuiU/
	HBzZZ0IryxpXpoQf3sLYZ1X6Nh/1qsTRqfW927AZo8jPs5ePJSp+oEeLFqTOgDKqKcCUPLG
	2YPpnPrZU5cSo/LkXIl+N0SpwUCCas3wO2+2JzfqPOjsaVP9nfBMrapMsHNeubNaXtx0tof
	nKGKi4nUklvuOm7j3p6IhIo1VW829VtGqwHapILyU0KwnpefuhAq/lN+3Tpy1+iGv8bEcPM
	lIHsnSnqK4VLPOHe6hQaJMrhrkjn0iHPV0tmTOZDG/ChVps5zYD7gl2YW9hoYWyZ7Ofw4D3
	WTIKzvQuXC0ApgRXowUEyzXQ4RosXJX8x6N8BUaE4ohokOaeVOGM85oibR4Y0LWrygoL7+o
	YLhKkSSzXsUkkdXSyOoGzIAmLNnt6NIPG+XB3Q4hnVOuK46Gp9iQoAXPUTBdUeTA8gWsksY
	2rbCI23xZacGr6VDSNpNKBxHKXz4Zqtbfm3wRUrMkA8z7Od1FAcQgDavbcf+HAn2q0KnvS+
	1+P+qTjGPllyuamX8Ej9KRAxrJRhcxY6kCnQL9tbK9mg7RxOwoW/KAQoP5UqfB/bxBv5YvD
	EpQvrkmP/x5pBBMHtjEidM5dJ2ECd0JFx8oXIyqWV5hBX3qQdoycaPg0dr2d2GdeqwFcQfK
	+LStoXpxJ+KguvevyakFZjseS2ImuJ3MweWqc6+5eiwRxNCNOe5yEOXKzGM4IZ/U3qa4ZYl
	cPL7
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
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

This gives tools such as lssbi a native source for basic SBI identity
information and starts moving those queries away from out-of-tree
kernel modules.

Codex was prompted to research lssbi's out-of-tree SBI probe and design
a minimal in-kernel replacement. It assisted with the sysfs interface,
implementation, ABI documentation, changelog, and QEMU test setup. The
result was built with a RISC-V defconfig and boot-tested under QEMU
virt with:

  OpenSBI v1.3
  RustSBI v0.4.1

Assisted-by: Codex:GPT-5
Signed-off-by: Zhouqi Jiang <luojia@rustsbi.com>
---
 Documentation/ABI/testing/sysfs-firmware-sbi | 30 ++++++++++
 MAINTAINERS                                  |  1 +
 arch/riscv/kernel/sbi.c                      | 62 +++++++++++++++++++-
 3 files changed, 92 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-sbi

diff --git a/Documentation/ABI/testing/sysfs-firmware-sbi b/Documentation/ABI/testing/sysfs-firmware-sbi
new file mode 100644
index 000000000000..516f9e6cee79
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-sbi
@@ -0,0 +1,30 @@
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
+		The SBI implementation ID, formatted as lowercase hexadecimal with
+		a 0x prefix, no leading zero padding, and a trailing newline. For
+		example, OpenSBI is represented as "0x1". The ID is assigned by the
+		SBI specification. This attribute is present only when SBI v0.2 or
+		later is available.
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
index c443337056ab..945a6d8d4f3e 100644
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
+	return sysfs_emit(buf, "0x%lx\n", sbi_impl_id);
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
-- 
2.43.0

