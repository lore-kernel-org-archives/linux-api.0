From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/11] UAPI: netfilter: Fix symbol collision issues
Date: Wed, 05 Sep 2018 16:55:16 +0100
Message-ID: <153616291694.23468.3826354165095743891.stgit@warthog.procyon.org.uk>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-kernel@vger.kernel.org, dhowells@redhat.com
List-Id: linux-api@vger.kernel.org

The netfilter UAPI headers have some symbol collision issues:

 (1) "enum nfnl_acct_msg_types" is defined twice, and each definition is
     completely different.

     Fix this by renaming the one in nfnetlink_cthelper.h to be "enum
     nfnl_cthelper_types" to be consistent with the other things in that
     file.

 (2) There's a disagreement between ipt_ECN.h and ipt_ecn.h over the
     definition of various IPT_ECN_* constants, leading to an error over
     IPT_ECN_IP_MASK being substituted when being defined as an enum value
     in ipt_ecn.h if ipt_ECN.h is #included first.

     Fix this by removing the conflicting constants from ipt_ECN.h and
     including ipt_ecn.h instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: netfilter-devel@vger.kernel.org
cc: coreteam@netfilter.org
---

 include/uapi/linux/netfilter/nfnetlink_cthelper.h |    2 +-
 include/uapi/linux/netfilter_ipv4/ipt_ECN.h       |    9 +--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_cthelper.h b/include/uapi/linux/netfilter/nfnetlink_cthelper.h
index a13137afc429..b9313ed0c313 100644
--- a/include/uapi/linux/netfilter/nfnetlink_cthelper.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cthelper.h
@@ -5,7 +5,7 @@
 #define NFCT_HELPER_STATUS_DISABLED	0
 #define NFCT_HELPER_STATUS_ENABLED	1
 
-enum nfnl_acct_msg_types {
+enum nfnl_cthelper_types {
 	NFNL_MSG_CTHELPER_NEW,
 	NFNL_MSG_CTHELPER_GET,
 	NFNL_MSG_CTHELPER_DEL,
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
index e3630fd045b8..d582119ad62a 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
@@ -12,14 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/netfilter/xt_DSCP.h>
-
-#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
-
-#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
-#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
-#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
-
-#define IPT_ECN_OP_MASK		0xce
+#include <linux/netfilter_ipv4/ipt_ecn.h>
 
 struct ipt_ECN_info {
 	__u8 operation;	/* bitset of operations */
