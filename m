From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/8] lib/vsprintf: simplify UUID printing
Date: Mon,  4 Apr 2016 16:30:03 +0300
Message-ID: <1459776610-68469-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Theodore Ts'o <tytso@mit.edu>, Matt Fleming <matt@codeblueprint.co.uk>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Since we have hex_byte_pack_upper() we may use it directly and avoid second
loop.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/vsprintf.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index ccb664b..be0e7cf 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1324,7 +1324,10 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	}
 
 	for (i = 0; i < 16; i++) {
-		p = hex_byte_pack(p, addr[index[i]]);
+		if (uc)
+			p = hex_byte_pack_upper(p, addr[index[i]]);
+		else
+			p = hex_byte_pack(p, addr[index[i]]);
 		switch (i) {
 		case 3:
 		case 5:
@@ -1337,13 +1340,6 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 
 	*p = 0;
 
-	if (uc) {
-		p = uuid;
-		do {
-			*p = toupper(*p);
-		} while (*(++p));
-	}
-
 	return string(buf, end, uuid, spec);
 }
 
-- 
2.8.0.rc3
