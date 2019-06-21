From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V33 18/30] Prohibit PCMCIA CIS storage when the kernel is
 locked down
Date: Thu, 20 Jun 2019 18:19:29 -0700
Message-ID: <20190621011941.186255-19-matthewgarrett@google.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621011941.186255-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Prohibit replacement of the PCMCIA Card Information Structure when the
kernel is locked down.

Suggested-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Garrett <mjg59@google.com>
---
 drivers/pcmcia/cistpl.c      | 4 ++++
 include/linux/security.h     | 1 +
 security/lockdown/lockdown.c | 1 +
 3 files changed, 6 insertions(+)

diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index ac0672b8dfca..fb54e262578c 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -24,6 +24,7 @@
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <linux/io.h>
+#include <linux/security.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
@@ -1578,6 +1579,9 @@ static ssize_t pccard_store_cis(struct file *filp, struct kobject *kobj,
 	struct pcmcia_socket *s;
 	int error;
 
+	if (security_is_locked_down(LOCKDOWN_PCMCIA_CIS))
+		return -EPERM;
+
 	s = to_socket(container_of(kobj, struct device, kobj));
 
 	if (off)
diff --git a/include/linux/security.h b/include/linux/security.h
index 88d0f5d0cd87..87c433f1e7db 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -90,6 +90,7 @@ enum lockdown_reason {
 	LOCKDOWN_IOPORT,
 	LOCKDOWN_MSR,
 	LOCKDOWN_ACPI_TABLES,
+	LOCKDOWN_PCMCIA_CIS,
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_CONFIDENTIALITY_MAX,
 };
diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
index bfc0e088aa85..ced4ddbb36b4 100644
--- a/security/lockdown/lockdown.c
+++ b/security/lockdown/lockdown.c
@@ -26,6 +26,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_IOPORT] = "raw io port access",
 	[LOCKDOWN_MSR] = "raw MSR access",
 	[LOCKDOWN_ACPI_TABLES] = "modified ACPI tables",
+	[LOCKDOWN_PCMCIA_CIS] = "direct PCMCIA CIS storage",
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
 };
-- 
2.22.0.410.gd8fdbe21b5-goog
