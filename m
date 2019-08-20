From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V40 09/29] kexec_file: Restrict at runtime if the kernel is
 locked down
Date: Mon, 19 Aug 2019 17:17:45 -0700
Message-ID: <20190820001805.241928-10-matthewgarrett@google.com>
References: <20190820001805.241928-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820001805.241928-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>, kexec@lists.infradead.org
List-Id: linux-api@vger.kernel.org

From: Jiri Bohac <jbohac@suse.cz>

When KEXEC_SIG is not enabled, kernel should not load images through
kexec_file systemcall if the kernel is locked down.

[Modified by David Howells to fit with modifications to the previous patch
 and to return -EPERM if the kernel is locked down for consistency with
 other lockdowns. Modified by Matthew Garrett to remove the IMA
 integration, which will be replaced by integrating with the IMA
 architecture policy patches.]

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Garrett <mjg59@google.com>
cc: kexec@lists.infradead.org
---
 kernel/kexec_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 972931201995..43109ef4d6bf 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -208,7 +208,7 @@ kimage_validate_signature(struct kimage *image)
 			return ret;
 		}
 
-		return 0;
+		return security_locked_down(LOCKDOWN_KEXEC);
 
 		/* All other errors are fatal, including nomem, unparseable
 		 * signatures and signature check failures - even if signatures
-- 
2.23.0.rc1.153.gdeed80330f-goog
