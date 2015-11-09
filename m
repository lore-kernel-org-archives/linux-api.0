From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] selftests/mlock2: Add ULL prefix to 64-bit constants
Date: Mon,  9 Nov 2015 11:14:29 +0100
Message-ID: <1447064069-21469-3-git-send-email-geert@linux-m68k.org>
References: <1447064069-21469-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447064069-21469-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>, Thierry Reding <treding@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-api@vger.kernel.org

On 32-bit (e.g. m68k):

mlock2-tests.c: In function 'lock_check':
mlock2-tests.c:293: warning: integer constant is too large for 'long' type
mlock2-tests.c:294: warning: integer constant is too large for 'long' type
mlock2-tests.c:299: warning: integer constant is too large for 'long' type
mlock2-tests.c:300: warning: integer constant is too large for 'long' type
mlock2-tests.c: In function 'unlock_lock_check':
mlock2-tests.c:329: warning: integer constant is too large for 'long' type
mlock2-tests.c:330: warning: integer constant is too large for 'long' type
mlock2-tests.c: In function 'onfault_check':
mlock2-tests.c:398: warning: integer constant is too large for 'long' type
mlock2-tests.c:398: warning: integer constant is too large for 'long' type
mlock2-tests.c:408: warning: integer constant is too large for 'long' type
mlock2-tests.c:411: warning: integer constant is too large for 'long' type
mlock2-tests.c:416: warning: integer constant is too large for 'long' type
mlock2-tests.c: In function 'unlock_onfault_check':
mlock2-tests.c:443: warning: integer constant is too large for 'long' type
mlock2-tests.c: In function 'test_lock_onfault_of_present':
mlock2-tests.c:528: warning: integer constant is too large for 'long' type
mlock2-tests.c:529: warning: integer constant is too large for 'long' type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 tools/testing/selftests/vm/mlock2-tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vm/mlock2-tests.c b/tools/testing/selftests/vm/mlock2-tests.c
index cb247219f1f72889..02ca5e0177c539c7 100644
--- a/tools/testing/selftests/vm/mlock2-tests.c
+++ b/tools/testing/selftests/vm/mlock2-tests.c
@@ -277,8 +277,8 @@ out:
 	return ret;
 }
 
-#define PRESENT_BIT     0x8000000000000000
-#define PFN_MASK        0x007FFFFFFFFFFFFF
+#define PRESENT_BIT     0x8000000000000000ULL
+#define PFN_MASK        0x007FFFFFFFFFFFFFULL
 #define UNEVICTABLE_BIT (1UL << 18)
 
 static int lock_check(char *map)
-- 
1.9.1
