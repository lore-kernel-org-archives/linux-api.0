From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH] of: Move OF flags to be visible even when !CONFIG_OF
Date: Fri, 24 Apr 2015 12:41:56 +0300
Message-ID: <1429868516-19519-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Matt Porter <mporter@konsulko.com>, Wolfram Sang <wsa@the-dreams.de>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

We need those to be visible even when compiling with CONFIG_OF
disabled, since even the empty of_node_*_flag() method use the
flag.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 include/linux/of.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 5f124f6..53d6bbdc 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -120,6 +120,12 @@ extern struct device_node *of_aliases;
 extern struct device_node *of_stdout;
 extern raw_spinlock_t devtree_lock;
 
+/* flag descriptions (need to be visible even when !CONFIG_OF) */
+#define OF_DYNAMIC	1 /* node and properties were allocated via kmalloc */
+#define OF_DETACHED	2 /* node has been detached from the device tree */
+#define OF_POPULATED	3 /* device already created for the node */
+#define OF_POPULATED_BUS	4 /* of_platform_populate recursed to children of this node */
+
 #ifdef CONFIG_OF
 static inline bool is_of_node(struct fwnode_handle *fwnode)
 {
@@ -217,12 +223,6 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 #define of_node_cmp(s1, s2)		strcasecmp((s1), (s2))
 #endif
 
-/* flag descriptions */
-#define OF_DYNAMIC	1 /* node and properties were allocated via kmalloc */
-#define OF_DETACHED	2 /* node has been detached from the device tree */
-#define OF_POPULATED	3 /* device already created for the node */
-#define OF_POPULATED_BUS	4 /* of_platform_populate recursed to children of this node */
-
 #define OF_IS_DYNAMIC(x) test_bit(OF_DYNAMIC, &x->_flags)
 #define OF_MARK_DYNAMIC(x) set_bit(OF_DYNAMIC, &x->_flags)
 
-- 
1.7.12
