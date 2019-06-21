From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V33 16/30] acpi: Ignore acpi_rsdp kernel param when the kernel
 has been locked down
Date: Thu, 20 Jun 2019 18:19:27 -0700
Message-ID: <20190621011941.186255-17-matthewgarrett@google.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621011941.186255-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>, Dave Young <dyoung@redhat.com>, linux-acpi@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This option allows userspace to pass the RSDP address to the kernel, which
makes it possible for a user to modify the workings of hardware .  Reject
the option when the kernel is locked down.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Garrett <mjg59@google.com>
cc: Dave Young <dyoung@redhat.com>
cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/osl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index f29e427d0d1d..1f8f394fce34 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -40,6 +40,7 @@
 #include <linux/list.h>
 #include <linux/jiffies.h>
 #include <linux/semaphore.h>
+#include <linux/security.h>
 
 #include <asm/io.h>
 #include <linux/uaccess.h>
@@ -194,7 +195,7 @@ acpi_physical_address __init acpi_os_get_root_pointer(void)
 	acpi_physical_address pa;
 
 #ifdef CONFIG_KEXEC
-	if (acpi_rsdp)
+	if (acpi_rsdp && !security_is_locked_down(LOCKDOWN_ACPI_TABLES))
 		return acpi_rsdp;
 #endif
 	pa = acpi_arch_get_root_pointer();
-- 
2.22.0.410.gd8fdbe21b5-goog
