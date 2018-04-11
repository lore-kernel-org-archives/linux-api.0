From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/24] kexec_load: Disable at runtime if the kernel is
 locked down
Date: Wed, 11 Apr 2018 17:25:18 +0100
Message-ID: <152346391877.4030.6270466586590461223.stgit@warthog.procyon.org.uk>
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

From: Matthew Garrett <mjg59@srcf.ucam.org>

The kexec_load() syscall permits the loading and execution of arbitrary
code in ring 0, which is something that lock-down is meant to prevent. It
makes sense to disable kexec_load() in this situation.

This does not affect kexec_file_load() syscall which can check for a
signature on the image to be booted.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Dave Young <dyoung@redhat.com>
Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>
Reviewed-by: James Morris <james.l.morris@oracle.com>
cc: kexec@lists.infradead.org
---

 kernel/kexec.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index aed8fb2564b3..1553ac765e73 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -199,6 +199,13 @@ static inline int kexec_load_check(unsigned long nr_segments,
 	if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
 		return -EPERM;
 
+	/*
+	 * kexec can be used to circumvent module loading restrictions, so
+	 * prevent loading in that case
+	 */
+	if (kernel_is_locked_down("kexec of unsigned images"))
+		return -EPERM;
+
 	/*
 	 * Verify we have a legal set of flags
 	 * This leaves us room for future extensions.
