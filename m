From: Dave Jones <davej@codemonkey.org.uk>
Subject: pkeys: Remove easily triggered WARN
Date: Fri, 14 Oct 2016 14:26:24 -0400
Message-ID: <20161014182624.4yzw36n4hd7x56wi@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-arch@vger.kernel.org, Dave Hansen <dave@sr71.net>, mgorman@techsingularity.net, arnd@arndb.de, linux-api@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

This easy-to-trigger warning shows up instantly when running
Trinity on a kernel with CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS disabled.

At most this should have been a printk, but the -EINVAL alone should be more
than adequate indicator that something isn't available.

Signed-off-by: Dave Jones <davej@codemonkey.org.uk>

diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index e4c08c1ff0c5..a1bacf1150b2 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -25,7 +25,6 @@ static inline int mm_pkey_alloc(struct mm_struct *mm)
 
 static inline int mm_pkey_free(struct mm_struct *mm, int pkey)
 {
-	WARN_ONCE(1, "free of protection key when disabled");
 	return -EINVAL;
 }
 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
