From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/24] ima: require secure_boot rules in lockdown mode
Date: Wed, 11 Apr 2018 17:24:58 +0100
Message-ID: <152346389895.4030.16084163640865771766.stgit@warthog.procyon.org.uk>
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

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

Require the "secure_boot" rules, whether or not it is specified
on the boot command line, for both the builtin and custom policies
in secure boot lockdown mode.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/integrity/ima/ima_policy.c |   39 ++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index d89bebf85421..da6f55c96a61 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -443,14 +443,21 @@ void ima_update_policy_flag(void)
  */
 void __init ima_init_policy(void)
 {
-	int i, measure_entries, appraise_entries, secure_boot_entries;
+	int i;
+	int measure_entries = 0;
+	int appraise_entries = 0;
+	int secure_boot_entries = 0;
+	bool kernel_locked_down = __kernel_is_locked_down(NULL, false);
 
 	/* if !ima_policy set entries = 0 so we load NO default rules */
-	measure_entries = ima_policy ? ARRAY_SIZE(dont_measure_rules) : 0;
-	appraise_entries = ima_use_appraise_tcb ?
-			 ARRAY_SIZE(default_appraise_rules) : 0;
-	secure_boot_entries = ima_use_secure_boot ?
-			ARRAY_SIZE(secure_boot_rules) : 0;
+	if (ima_policy)
+		measure_entries = ARRAY_SIZE(dont_measure_rules);
+
+	if (ima_use_appraise_tcb)
+		appraise_entries = ARRAY_SIZE(default_appraise_rules);
+
+	if (ima_use_secure_boot || kernel_locked_down)
+		secure_boot_entries = ARRAY_SIZE(secure_boot_rules);
 
 	for (i = 0; i < measure_entries; i++)
 		list_add_tail(&dont_measure_rules[i].list, &ima_default_rules);
@@ -471,11 +478,23 @@ void __init ima_init_policy(void)
 
 	/*
 	 * Insert the appraise rules requiring file signatures, prior to
-	 * any other appraise rules.
+	 * any other appraise rules.  In secure boot lock-down mode, also
+	 * require these appraise rules for custom policies.
 	 */
-	for (i = 0; i < secure_boot_entries; i++)
-		list_add_tail(&secure_boot_rules[i].list,
-			      &ima_default_rules);
+	for (i = 0; i < secure_boot_entries; i++) {
+		struct ima_rule_entry *entry;
+
+		/* Include for builtin policies */
+		list_add_tail(&secure_boot_rules[i].list, &ima_default_rules);
+
+		/* Include for custom policies */
+		if (kernel_locked_down) {
+			entry = kmemdup(&secure_boot_rules[i], sizeof(*entry),
+					GFP_KERNEL);
+			if (entry)
+				list_add_tail(&entry->list, &ima_policy_rules);
+		}
+	}
 
 	for (i = 0; i < appraise_entries; i++) {
 		list_add_tail(&default_appraise_rules[i].list,
