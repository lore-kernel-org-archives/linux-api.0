From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V35 25/29] kexec: Allow kexec_file() with appropriate IMA
 policy when locked down
Date: Mon, 15 Jul 2019 12:59:42 -0700
Message-ID: <20190715195946.223443-26-matthewgarrett@google.com>
References: <20190715195946.223443-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190715195946.223443-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <matthewgarrett@google.com>, Matthew Garrett <mjg59@google.com>, Mimi Zohar <zohar@linux.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-integrity@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Systems in lockdown mode should block the kexec of untrusted kernels.
For x86 and ARM we can ensure that a kernel is trustworthy by validating
a PE signature, but this isn't possible on other architectures. On those
platforms we can use IMA digital signatures instead. Add a function to
determine whether IMA has or will verify signatures for a given event type,
and if so permit kexec_file() even if the kernel is otherwise locked down.
This is restricted to cases where CONFIG_INTEGRITY_TRUSTED_KEYRING is set
in order to prevent an attacker from loading additional keys at runtime.

Signed-off-by: Matthew Garrett <mjg59@google.com>
Acked-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-integrity@vger.kernel.org
---
 include/linux/ima.h                 |  9 ++++++
 kernel/kexec_file.c                 | 12 +++++--
 security/integrity/ima/ima.h        |  2 ++
 security/integrity/ima/ima_main.c   |  2 +-
 security/integrity/ima/ima_policy.c | 50 +++++++++++++++++++++++++++++
 5 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index a20ad398d260..1c37f17f7203 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -131,4 +131,13 @@ static inline int ima_inode_removexattr(struct dentry *dentry,
 	return 0;
 }
 #endif /* CONFIG_IMA_APPRAISE */
+
+#if defined(CONFIG_IMA_APPRAISE) && defined(CONFIG_INTEGRITY_TRUSTED_KEYRING)
+extern bool ima_appraise_signature(enum kernel_read_file_id func);
+#else
+static inline bool ima_appraise_signature(enum kernel_read_file_id func)
+{
+	return false;
+}
+#endif /* CONFIG_IMA_APPRAISE && CONFIG_INTEGRITY_TRUSTED_KEYRING */
 #endif /* _LINUX_IMA_H */
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index dd06f1070d66..13c9960a5860 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -228,9 +228,17 @@ kimage_file_prepare_segments(struct kimage *image, int kernel_fd, int initrd_fd,
 			goto out;
 		}
 
-		ret = security_locked_down(LOCKDOWN_KEXEC);
-		if (ret)
+		ret = 0;
+
+		/* If IMA is guaranteed to appraise a signature on the kexec
+		 * image, permit it even if the kernel is otherwise locked
+		 * down.
+		 */
+		if (!ima_appraise_signature(READING_KEXEC_IMAGE) &&
+		    security_locked_down(LOCKDOWN_KEXEC)) {
+			ret = -EPERM;
 			goto out;
+		}
 
 		break;
 
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 011b91c79351..64dcb11cf444 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -113,6 +113,8 @@ struct ima_kexec_hdr {
 	u64 count;
 };
 
+extern const int read_idmap[];
+
 #ifdef CONFIG_HAVE_IMA_KEXEC
 void ima_load_kexec_buffer(void);
 #else
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 584019728660..b9f57503af2c 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -502,7 +502,7 @@ int ima_read_file(struct file *file, enum kernel_read_file_id read_id)
 	return 0;
 }
 
-static const int read_idmap[READING_MAX_ID] = {
+const int read_idmap[READING_MAX_ID] = {
 	[READING_FIRMWARE] = FIRMWARE_CHECK,
 	[READING_FIRMWARE_PREALLOC_BUFFER] = FIRMWARE_CHECK,
 	[READING_MODULE] = MODULE_CHECK,
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 6df7f641ff66..827f1e33fe86 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1456,3 +1456,53 @@ int ima_policy_show(struct seq_file *m, void *v)
 	return 0;
 }
 #endif	/* CONFIG_IMA_READ_POLICY */
+
+#if defined(CONFIG_IMA_APPRAISE) && defined(CONFIG_INTEGRITY_TRUSTED_KEYRING)
+/*
+ * ima_appraise_signature: whether IMA will appraise a given function using
+ * an IMA digital signature. This is restricted to cases where the kernel
+ * has a set of built-in trusted keys in order to avoid an attacker simply
+ * loading additional keys.
+ */
+bool ima_appraise_signature(enum kernel_read_file_id id)
+{
+	struct ima_rule_entry *entry;
+	bool found = false;
+	enum ima_hooks func;
+
+	if (id >= READING_MAX_ID)
+		return false;
+
+	func = read_idmap[id] ?: FILE_CHECK;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(entry, ima_rules, list) {
+		if (entry->action != APPRAISE)
+			continue;
+
+		/*
+		 * A generic entry will match, but otherwise require that it
+		 * match the func we're looking for
+		 */
+		if (entry->func && entry->func != func)
+			continue;
+
+		/*
+		 * We require this to be a digital signature, not a raw IMA
+		 * hash.
+		 */
+		if (entry->flags & IMA_DIGSIG_REQUIRED)
+			found = true;
+
+		/*
+		 * We've found a rule that matches, so break now even if it
+		 * didn't require a digital signature - a later rule that does
+		 * won't override it, so would be a false positive.
+		 */
+		break;
+	}
+
+	rcu_read_unlock();
+	return found;
+}
+#endif /* CONFIG_IMA_APPRAISE && CONFIG_INTEGRITY_TRUSTED_KEYRING */
-- 
2.22.0.510.g264f2c817a-goog
