From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH 1/2] security: constify some arrays in lockdown LSM
Date: Tue, 10 Sep 2019 03:03:17 -0700
Message-ID: <20190910100318.204420-2-matthewgarrett@google.com>
References: <20190910100318.204420-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190910100318.204420-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <matthewgarrett@google.com>, Matthew Garrett <mjg59@google.com>, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

No reason for these not to be const.

Signed-off-by: Matthew Garrett <mjg59@google.com>
Suggested-by: David Howells <dhowells@redhat.com>
---
 security/lockdown/lockdown.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
index 0068cec77c05..8a10b43daf74 100644
--- a/security/lockdown/lockdown.c
+++ b/security/lockdown/lockdown.c
@@ -16,7 +16,7 @@
 
 static enum lockdown_reason kernel_locked_down;
 
-static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
+static const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_NONE] = "none",
 	[LOCKDOWN_MODULE_SIGNATURE] = "unsigned module loading",
 	[LOCKDOWN_DEV_MEM] = "/dev/mem,kmem,port",
@@ -40,7 +40,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
 };
 
-static enum lockdown_reason lockdown_levels[] = {LOCKDOWN_NONE,
+static const enum lockdown_reason lockdown_levels[] = {LOCKDOWN_NONE,
 						 LOCKDOWN_INTEGRITY_MAX,
 						 LOCKDOWN_CONFIDENTIALITY_MAX};
 
-- 
2.23.0.162.g0b9fbb3734-goog
