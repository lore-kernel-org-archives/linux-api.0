From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 10/14] Move USE_WCACHING to drivers/block/pktcdvd.c
Date: Mon,  9 Nov 2015 17:31:07 -0800
Message-ID: <1447119071-19392-11-git-send-email-palmer__33786.4386536696$1447119347$gmane$org@dabbelt.com>
References: <1446579994-9937-1-git-send-email-palmer@dabbelt.com>
 <1447119071-19392-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1447119071-19392-1-git-send-email-palmer@dabbelt.com>
Sender: linux-arch-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com, peterz@infradead.org
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

I don't think this was ever intended to be exposed to userspace, but
it did require an "#ifdef CONFIG_*".  Since the name is kind of
generic and was only used in one place, I've moved the definition to
the one user.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
---
 drivers/block/pktcdvd.c      | 11 +++++++++++
 include/uapi/linux/pktcdvd.h | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 2f477d4..55f0df3 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -90,6 +90,17 @@ do {									\
 
 #define MAX_SPEED 0xffff
 
+/*
+ * use drive write caching -- we need deferred error handling to be
+ * able to successfully recover with this option (drive will return good
+ * status as soon as the cdb is validated).
+ */
+#if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
+#define USE_WCACHING		1
+#else
+#define USE_WCACHING		0
+#endif
+
 static DEFINE_MUTEX(pktcdvd_mutex);
 static struct pktcdvd_device *pkt_devs[MAX_WRITERS];
 static struct proc_dir_entry *pkt_proc;
diff --git a/include/uapi/linux/pktcdvd.h b/include/uapi/linux/pktcdvd.h
index 2640b9d..05c2bee 100644
--- a/include/uapi/linux/pktcdvd.h
+++ b/include/uapi/linux/pktcdvd.h
@@ -29,17 +29,6 @@
 #define PACKET_WAIT_TIME	(HZ * 5 / 1000)
 
 /*
- * use drive write caching -- we need deferred error handling to be
- * able to successfully recover with this option (drive will return good
- * status as soon as the cdb is validated).
- */
-#if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
-#define USE_WCACHING		1
-#else
-#define USE_WCACHING		0
-#endif
-
-/*
  * No user-servicable parts beyond this point ->
  */
 
-- 
2.4.10
