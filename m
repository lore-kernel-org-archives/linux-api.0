From: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 11/13] Always define MAX_RAW_MINORS as 65535 in userspace
Date: Mon, 14 Sep 2015 15:50:45 -0700
Message-ID: <1442271047-4908-12-git-send-email-palmer__18517.920948989$1442276344$gmane$org@dabbelt.com>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1442271047-4908-1-git-send-email-palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: dave-gkUM19QKKo4@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, 3chas3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org

While I don't think this was ever meant to be exposed to userspace, if
anyone is using it then this will at least provide a correct (if
unlikely) definition.

MAX_RAW_MINORS used to be used in the kernel, where it's been replaced
with CONFIG_MAX_RAW_MINORS.

Note that there's a checkpatch.pl warning about a split config string
here, but I've left that alone.

Signed-off-by: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Andrew Waterman <waterman-aFE07iDfcCIb0cFwG/AQJIdd74u8MsAO@public.gmane.org>
Reviewed-by: Albert Ou <aou-aFE07iDfcCIb0cFwG/AQJIdd74u8MsAO@public.gmane.org>
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
