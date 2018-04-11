From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/24] acpi: Disable ACPI table override if the kernel is
 locked down
Date: Wed, 11 Apr 2018 17:26:10 +0100
Message-ID: <152346397054.4030.6635609558509282651.stgit@warthog.procyon.org.uk>
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

From: Linn Crosetto <linn@hpe.com>

>From the kernel documentation (initrd_table_override.txt):

  If the ACPI_INITRD_TABLE_OVERRIDE compile option is true, it is possible
  to override nearly any ACPI table provided by the BIOS with an
  instrumented, modified one.

When securelevel is set, the kernel should disallow any unauthenticated
changes to kernel space.  ACPI tables contain code invoked by the kernel,
so do not allow ACPI tables to be overridden if the kernel is locked down.

Signed-off-by: Linn Crosetto <linn@hpe.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>
cc: linux-acpi@vger.kernel.org
---

 drivers/acpi/tables.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 849c4fb19b03..6c5ee7e66842 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -527,6 +527,11 @@ void __init acpi_table_upgrade(void)
 	if (table_nr == 0)
 		return;
 
+	if (kernel_is_locked_down("ACPI table override")) {
+		pr_notice("kernel is locked down, ignoring table override\n");
+		return;
+	}
+
 	acpi_tables_addr =
 		memblock_find_in_range(0, ACPI_TABLE_UPGRADE_MAX_PHYS,
 				       all_tables_size, PAGE_SIZE);
