From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/24] acpi: Ignore acpi_rsdp kernel param when the kernel
 has been locked down
Date: Wed, 11 Apr 2018 17:26:04 +0100
Message-ID: <152346396411.4030.4824200967123540129.stgit@warthog.procyon.org.uk>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This option allows userspace to pass the RSDP address to the kernel, which
makes it possible for a user to modify the workings of hardware .  Reject
the option when the kernel is locked down.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>
cc: Dave Young <dyoung@redhat.com>
cc: linux-acpi@vger.kernel.org
---

 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 7ca41bf023c9..34e4ce7939f4 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -192,7 +192,7 @@ acpi_physical_address __init acpi_os_get_root_pointer(void)
 	acpi_physical_address pa;
 
 #ifdef CONFIG_KEXEC
-	if (acpi_rsdp)
+	if (acpi_rsdp && !kernel_is_locked_down("ACPI RSDP specification"))
 		return acpi_rsdp;
 #endif
 	pa = acpi_arch_get_root_pointer();
