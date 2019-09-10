From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH 2/2] kexec: Fix file verification on S390
Date: Tue, 10 Sep 2019 03:03:18 -0700
Message-ID: <20190910100318.204420-3-matthewgarrett@google.com>
References: <20190910100318.204420-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190910100318.204420-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <matthewgarrett@google.com>, Matthew Garrett <mjg59@google.com>, Philipp Rudo <prudo@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

I accidentally typoed this #ifdef, so verification would always be
disabled.

Signed-off-by: Matthew Garrett <mjg59@google.com>
Reported-by: Philipp Rudo <prudo@linux.ibm.com>
---
 arch/s390/kernel/kexec_elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/kexec_elf.c b/arch/s390/kernel/kexec_elf.c
index 9b4f37a4edf1..9da6fa30c447 100644
--- a/arch/s390/kernel/kexec_elf.c
+++ b/arch/s390/kernel/kexec_elf.c
@@ -130,7 +130,7 @@ static int s390_elf_probe(const char *buf, unsigned long len)
 const struct kexec_file_ops s390_kexec_elf_ops = {
 	.probe = s390_elf_probe,
 	.load = s390_elf_load,
-#ifdef CONFIG_KEXEC__SIG
+#ifdef CONFIG_KEXEC_SIG
 	.verify_sig = s390_verify_sig,
 #endif /* CONFIG_KEXEC_SIG */
 };
-- 
2.23.0.162.g0b9fbb3734-goog
