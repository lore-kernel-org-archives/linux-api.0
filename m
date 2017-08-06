From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 24/36] uapi linux/coda_psdev.h: move upc_req definition from uapi to kernel side headers
Date: Sun,  6 Aug 2017 18:44:15 +0200
Message-ID: <20170806164428.2273-25-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, coda@cs.cmu.edu, Jan Harkes <jaharkes@cs.cmu.edu>, codalist@coda.cs.cmu.edu
List-Id: linux-api@vger.kernel.org

Only users of upc_req in kernel side fs/coda/psdev.c and fs/coda/upcall.c
already include linux/coda_psdev.h.

Suggested by Jan Harkes <jaharkes@cs.cmu.edu> on lkml message
<20150531111913.GA23377@cs.cmu.edu>.

Fixes these include/uapi/linux/coda_psdev.h compilation errors in userspace:

./linux/coda_psdev.h:12:19: error: field ‘uc_chain’ has incomplete type
  struct list_head    uc_chain;
                   ^
./linux/coda_psdev.h:13:2: error: unknown type name ‘caddr_t’
  caddr_t             uc_data;
  ^
./linux/coda_psdev.h:14:2: error: unknown type name ‘u_short’
  u_short             uc_flags;
  ^
./linux/coda_psdev.h:15:2: error: unknown type name ‘u_short’
  u_short             uc_inSize;  /* Size is at most 5000 bytes */
  ^
./linux/coda_psdev.h:16:2: error: unknown type name ‘u_short’
  u_short             uc_outSize;
  ^
./linux/coda_psdev.h:17:2: error: unknown type name ‘u_short’
  u_short             uc_opcode;  /* copied from data to save lookup */
  ^
./linux/coda_psdev.h:19:2: error: unknown type name ‘wait_queue_head_t’
  wait_queue_head_t   uc_sleep;   /* process' wait queue */
  ^

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: coda@cs.cmu.edu
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
---
 include/linux/coda_psdev.h      | 11 +++++++++++
 include/uapi/linux/coda_psdev.h | 13 -------------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 31e4e1f1547c..8eccf94b6d25 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -18,6 +18,17 @@ struct venus_comm {
 	struct mutex	    vc_mutex;
 };
 
+/* messages between coda filesystem in kernel and Venus */
+struct upc_req {
+	struct list_head	uc_chain;
+	caddr_t			uc_data;
+	u_short			uc_flags;
+	u_short			uc_inSize;  /* Size is at most 5000 bytes */
+	u_short			uc_outSize;
+	u_short			uc_opcode;  /* copied from data to save lookup */
+	int			uc_unique;
+	wait_queue_head_t	uc_sleep;   /* process' wait queue */
+};
 
 static inline struct venus_comm *coda_vcp(struct super_block *sb)
 {
diff --git a/include/uapi/linux/coda_psdev.h b/include/uapi/linux/coda_psdev.h
index 79d05981fc4b..e2c44d2f7d5b 100644
--- a/include/uapi/linux/coda_psdev.h
+++ b/include/uapi/linux/coda_psdev.h
@@ -6,19 +6,6 @@
 #define CODA_PSDEV_MAJOR 67
 #define MAX_CODADEVS  5	   /* how many do we allow */
 
-
-/* messages between coda filesystem in kernel and Venus */
-struct upc_req {
-	struct list_head    uc_chain;
-	caddr_t	            uc_data;
-	u_short	            uc_flags;
-	u_short             uc_inSize;  /* Size is at most 5000 bytes */
-	u_short	            uc_outSize;
-	u_short	            uc_opcode;  /* copied from data to save lookup */
-	int		    uc_unique;
-	wait_queue_head_t   uc_sleep;   /* process' wait queue */
-};
-
 #define CODA_REQ_ASYNC  0x1
 #define CODA_REQ_READ   0x2
 #define CODA_REQ_WRITE  0x4
-- 
2.13.3
