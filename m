From: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/5] Coresight: Add an interface for supporting ETM3/4 Context ID tracing
Date: Tue,  7 Jul 2015 16:41:56 +0800
Message-ID: <1436258518-9339-4-git-send-email-zhang.chunyan@linaro.org>
References: <1436258518-9339-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436258518-9339-1-git-send-email-zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge.broslavsky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

If PID namespace is enabled, everytime users configure the Context ID
register to trace the specific process, there needs to be a translation
between the real PID seen from the kernel and VPID seen from the
namespace in which the user's process resides .

This patch just adds the translation interface for ETMs.

Signed-off-by: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/coresight.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/coresight.h b/include/linux/coresight.h
index 3486b90..626da69 100644
--- a/include/linux/coresight.h
+++ b/include/linux/coresight.h
@@ -248,4 +248,24 @@ static inline struct coresight_platform_data *of_get_coresight_platform_data(
 	struct device *dev, struct device_node *node) { return NULL; }
 #endif
 
+#ifdef CONFIG_PID_NS
+static inline unsigned long
+coresight_vpid_to_pid(unsigned long vpid)
+{
+	struct task_struct *task = NULL;
+	unsigned long pid = 0;
+
+	rcu_read_lock();
+	task = find_task_by_vpid(vpid);
+	if (task)
+		pid = task_pid_nr(task);
+	rcu_read_unlock();
+
+	return pid;
+}
+#else
+static inline unsigned long
+coresight_vpid_to_pid(unsigned long vpid) { return vpid; }
+#endif
+
 #endif
-- 
1.9.1
