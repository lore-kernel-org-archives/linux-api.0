From: Matthew Garrett <matthewgarrett-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V38 08/29] kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG
 and KEXEC_SIG_FORCE
Date: Wed,  7 Aug 2019 17:07:00 -0700
Message-ID: <20190808000721.124691-9-matthewgarrett@google.com>
References: <20190808000721.124691-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20190808000721.124691-1-matthewgarrett-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
Cc: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>

This is a preparatory patch for kexec_file_load() lockdown.  A locked down
kernel needs to prevent unsigned kernel images from being loaded with
kexec_file_load().  Currently, the only way to force the signature
verification is compiling with KEXEC_VERIFY_SIG.  This prevents loading
usigned images even when the kernel is not locked down at runtime.

This patch splits KEXEC_VERIFY_SIG into KEXEC_SIG and KEXEC_SIG_FORCE.
Analogous to the MODULE_SIG and MODULE_SIG_FORCE for modules, KEXEC_SIG
turns on the signature verification but allows unsigned images to be
loaded.  KEXEC_SIG_FORCE disallows images without a valid signature.

Signed-off-by: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
Reviewed-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
---
 arch/x86/Kconfig                       | 20 +++++++++----
 crypto/asymmetric_keys/verify_pefile.c |  4 ++-
 include/linux/kexec.h                  |  4 +--
 kernel/kexec_file.c                    | 41 ++++++++++++++++++++++----
 4 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 05e78acb187c..fd2cd4f861cc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2032,20 +2032,30 @@ config KEXEC_FILE
 config ARCH_HAS_KEXEC_PURGATORY
 	def_bool KEXEC_FILE
 
-config KEXEC_VERIFY_SIG
+config KEXEC_SIG
 	bool "Verify kernel signature during kexec_file_load() syscall"
 	depends on KEXEC_FILE
 	---help---
-	  This option makes kernel signature verification mandatory for
-	  the kexec_file_load() syscall.
 
-	  In addition to that option, you need to enable signature
+	  This option makes the kexec_file_load() syscall check for a valid
+	  signature of the kernel image.  The image can still be loaded without
+	  a valid signature unless you also enable KEXEC_SIG_FORCE, though if
+	  there's a signature that we can check, then it must be valid.
+
+	  In addition to this option, you need to enable signature
 	  verification for the corresponding kernel image type being
 	  loaded in order for this to work.
 
+config KEXEC_SIG_FORCE
+	bool "Require a valid signature in kexec_file_load() syscall"
+	depends on KEXEC_SIG
+	---help---
+	  This option makes kernel signature verification mandatory for
+	  the kexec_file_load() syscall.
+
 config KEXEC_BZIMAGE_VERIFY_SIG
 	bool "Enable bzImage signature verification support"
-	depends on KEXEC_VERIFY_SIG
+	depends on KEXEC_SIG
 	depends on SIGNED_PE_FILE_VERIFICATION
 	select SYSTEM_TRUSTED_KEYRING
 	---help---
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 3b303fe2f061..cc9dbcecaaca 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -96,7 +96,7 @@ static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
 
 	if (!ddir->certs.virtual_address || !ddir->certs.size) {
 		pr_debug("Unsigned PE binary\n");
-		return -EKEYREJECTED;
+		return -ENODATA;
 	}
 
 	chkaddr(ctx->header_size, ddir->certs.virtual_address,
@@ -403,6 +403,8 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
  *  (*) 0 if at least one signature chain intersects with the keys in the trust
  *	keyring, or:
  *
+ *  (*) -ENODATA if there is no signature present.
+ *
  *  (*) -ENOPKG if a suitable crypto module couldn't be found for a check on a
  *	chain.
  *
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 305f6a5ca4fe..998f77c3a0e1 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -125,7 +125,7 @@ typedef void *(kexec_load_t)(struct kimage *image, char *kernel_buf,
 			     unsigned long cmdline_len);
 typedef int (kexec_cleanup_t)(void *loader_data);
 
-#ifdef CONFIG_KEXEC_VERIFY_SIG
+#ifdef CONFIG_KEXEC_SIG
 typedef int (kexec_verify_sig_t)(const char *kernel_buf,
 				 unsigned long kernel_len);
 #endif
@@ -134,7 +134,7 @@ struct kexec_file_ops {
 	kexec_probe_t *probe;
 	kexec_load_t *load;
 	kexec_cleanup_t *cleanup;
-#ifdef CONFIG_KEXEC_VERIFY_SIG
+#ifdef CONFIG_KEXEC_SIG
 	kexec_verify_sig_t *verify_sig;
 #endif
 };
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index b8cc032d5620..875482c34154 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -88,7 +88,7 @@ int __weak arch_kimage_file_post_load_cleanup(struct kimage *image)
 	return kexec_image_post_load_cleanup_default(image);
 }
 
-#ifdef CONFIG_KEXEC_VERIFY_SIG
+#ifdef CONFIG_KEXEC_SIG
 static int kexec_image_verify_sig_default(struct kimage *image, void *buf,
 					  unsigned long buf_len)
 {
@@ -186,7 +186,8 @@ kimage_file_prepare_segments(struct kimage *image, int kernel_fd, int initrd_fd,
 			     const char __user *cmdline_ptr,
 			     unsigned long cmdline_len, unsigned flags)
 {
-	int ret = 0;
+	const char *reason;
+	int ret;
 	void *ldata;
 	loff_t size;
 
@@ -202,14 +203,42 @@ kimage_file_prepare_segments(struct kimage *image, int kernel_fd, int initrd_fd,
 	if (ret)
 		goto out;
 
-#ifdef CONFIG_KEXEC_VERIFY_SIG
+#ifdef CONFIG_KEXEC_SIG
 	ret = arch_kexec_kernel_verify_sig(image, image->kernel_buf,
 					   image->kernel_buf_len);
-	if (ret) {
-		pr_debug("kernel signature verification failed.\n");
+	switch (ret) {
+	case 0:
+		break;
+
+		/* Certain verification errors are non-fatal if we're not
+		 * checking errors, provided we aren't mandating that there
+		 * must be a valid signature.
+		 */
+	case -ENODATA:
+		reason = "kexec of unsigned image";
+		goto decide;
+	case -ENOPKG:
+		reason = "kexec of image with unsupported crypto";
+		goto decide;
+	case -ENOKEY:
+		reason = "kexec of image with unavailable key";
+	decide:
+		if (IS_ENABLED(CONFIG_KEXEC_SIG_FORCE)) {
+			pr_notice("%s rejected\n", reason);
+			goto out;
+		}
+
+		ret = 0;
+		break;
+
+		/* All other errors are fatal, including nomem, unparseable
+		 * signatures and signature check failures - even if signatures
+		 * aren't required.
+		 */
+	default:
+		pr_notice("kernel signature verification failed (%d).\n", ret);
 		goto out;
 	}
-	pr_debug("kernel signature verification successful.\n");
 #endif
 	/* It is possible that there no initramfs is being loaded */
 	if (!(flags & KEXEC_FILE_NO_INITRAMFS)) {
-- 
2.22.0.770.g0f2c4a37fd-goog
