From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 11/13] Always define MAX_RAW_MINORS as 65535 in userspace
Date: Mon, 14 Sep 2015 15:50:45 -0700
Message-ID: <1442271047-4908-12-git-send-email-palmer__15532.2349899963$1442271121$gmane$org@dabbelt.com>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

While I don't think this was ever meant to be exposed to userspace, if
anyone is using it then this will at least provide a correct (if
unlikely) definition.

MAX_RAW_MINORS used to be used in the kernel, where it's been replaced
with CONFIG_MAX_RAW_MINORS.

Note that there's a checkpatch.pl warning about a split config string
here, but I've left that alone.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
---
 drivers/char/raw.c       | 7 ++++---
 include/uapi/linux/raw.h | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 60316fbaf295..362d7a6511b9 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -36,7 +36,7 @@ static struct raw_device_data *raw_devices;
 static DEFINE_MUTEX(raw_mutex);
 static const struct file_operations raw_ctl_fops; /* forward declaration */
 
-static int max_raw_minors = MAX_RAW_MINORS;
+static int max_raw_minors = CONFIG_MAX_RAW_MINORS;
 
 module_param(max_raw_minors, int, 0);
 MODULE_PARM_DESC(max_raw_minors, "Maximum number of raw devices (1-65536)");
@@ -317,8 +317,9 @@ static int __init raw_init(void)
 
 	if (max_raw_minors < 1 || max_raw_minors > 65536) {
 		printk(KERN_WARNING "raw: invalid max_raw_minors (must be"
-			" between 1 and 65536), using %d\n", MAX_RAW_MINORS);
-		max_raw_minors = MAX_RAW_MINORS;
+			" between 1 and 65536), using %d\n",
+		       CONFIG_MAX_RAW_MINORS);
+		max_raw_minors = CONFIG_MAX_RAW_MINORS;
 	}
 
 	raw_devices = vzalloc(sizeof(struct raw_device_data) * max_raw_minors);
diff --git a/include/uapi/linux/raw.h b/include/uapi/linux/raw.h
index 62d543e70603..f0390b3e8530 100644
--- a/include/uapi/linux/raw.h
+++ b/include/uapi/linux/raw.h
@@ -13,6 +13,6 @@ struct raw_config_request
 	__u64	block_minor;
 };
 
-#define MAX_RAW_MINORS CONFIG_MAX_RAW_DEVS
+#define MAX_RAW_MINORS 65535
 
 #endif /* __LINUX_RAW_H */
-- 
2.4.6
