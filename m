From: Andrew Shadura <andrew.shadura@collabora.co.uk>
Subject: [PATCH RESEND] tools-powerpc: Return false instead of -1
Date: Wed,  9 Nov 2016 09:55:04 +0100
Message-ID: <20161109085504.10799-1-andrew.shadura@collabora.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Shuah Khan <shuah@kernel.org>, Cyril Bur <cyrilbur@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Returning a negative value for a boolean function seem to have the
undesired effect of returning true. require_paranoia_below() is a
boolean function, but the variable used to store the return value is an
integer, receiving -1 or 0. This patch convert rc to bool, replace -1
by false, and 0 by true.

This issue was found by the following Coccinelle semantic patch:
<smpl>
@@
identifier f, ret;
constant C;
typedef bool;
@@
bool f (...){
<+...
ret = -C;
...
* return ret;
...+>
}
</smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Andrew Shadura <andrew.shadura@collabora.co.uk>
---
 tools/testing/selftests/powerpc/pmu/lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/powerpc/pmu/lib.c b/tools/testing/selftests/powerpc/pmu/lib.c
index 8b992fa..5bf5dd4 100644
--- a/tools/testing/selftests/powerpc/pmu/lib.c
+++ b/tools/testing/selftests/powerpc/pmu/lib.c
@@ -193,9 +193,9 @@ bool require_paranoia_below(int level)
 	long current;
 	char *end, buf[16];
 	FILE *f;
-	int rc;
+	bool rc;
 
-	rc = -1;
+	rc = false;
 
 	f = fopen(PARANOID_PATH, "r");
 	if (!f) {
@@ -218,7 +218,7 @@ bool require_paranoia_below(int level)
 	if (current >= level)
 		goto out_close;
 
-	rc = 0;
+	rc = true;
 out_close:
 	fclose(f);
 out:
-- 
2.9.3
