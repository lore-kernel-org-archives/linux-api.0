From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v7 09/10] tpm: Initialize TPM and get
	durations and timeouts
Date: Fri, 11 Mar 2016 21:51:04 -0500
Message-ID: <1457751065-11507-10-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1457751065-11507-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1457751065-11507-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add the retrieval of TPM 1.2 durations and timeouts. Since this requires
the startup of the TPM, do this for TPM 1.2 and TPM 2.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/char/tpm/tpm_vtpm_proxy.c | 95 +++++++++++++++++++++++++++++++++++----
 1 file changed, 86 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index d73944e..9dedf48 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -45,8 +45,11 @@ struct proxy_dev {
 	size_t req_len;              /* length of queued TPM request */
 	size_t resp_len;             /* length of queued TPM response */
 	u8 buffer[TPM_BUFSIZE];      /* request/response buffer */
+
+	struct work_struct work;     /* task that retrieves TPM timeouts */
 };
 
+static struct workqueue_struct *workqueue;
 
 static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev);
 
@@ -67,6 +70,15 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
 	size_t len;
 	int sig, rc;
 
+	mutex_lock(&proxy_dev->buf_lock);
+
+	if (!(proxy_dev->state & STATE_OPENED_FLAG)) {
+		mutex_unlock(&proxy_dev->buf_lock);
+		return -EPIPE;
+	}
+
+	mutex_unlock(&proxy_dev->buf_lock);
+
 	sig = wait_event_interruptible(proxy_dev->wq, proxy_dev->req_len != 0);
 	if (sig)
 		return -EINTR;
@@ -110,6 +122,11 @@ static ssize_t vtpm_proxy_fops_write(struct file *filp, const char __user *buf,
 
 	mutex_lock(&proxy_dev->buf_lock);
 
+	if (!(proxy_dev->state & STATE_OPENED_FLAG)) {
+		mutex_unlock(&proxy_dev->buf_lock);
+		return -EPIPE;
+	}
+
 	if (count > sizeof(proxy_dev->buffer) ||
 	    !(proxy_dev->state & STATE_WAIT_RESPONSE_FLAG)) {
 		mutex_unlock(&proxy_dev->buf_lock);
@@ -154,6 +171,9 @@ static unsigned int vtpm_proxy_fops_poll(struct file *filp, poll_table *wait)
 	if (proxy_dev->req_len)
 		ret |= POLLIN | POLLRDNORM;
 
+	if (!(proxy_dev->state & STATE_OPENED_FLAG))
+		ret |= POLLHUP;
+
 	mutex_unlock(&proxy_dev->buf_lock);
 
 	return ret;
@@ -341,6 +361,55 @@ static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
 };
 
 /*
+ * Code related to the startup of the TPM 2 and startup of TPM 1.2 +
+ * retrieval of timeouts and durations.
+ */
+
+static void vtpm_proxy_work(struct work_struct *work)
+{
+	struct proxy_dev *proxy_dev = container_of(work, struct proxy_dev,
+						   work);
+	int rc;
+
+	if (proxy_dev->flags & VTPM_PROXY_FLAG_TPM2)
+		rc = tpm2_startup(proxy_dev->chip, TPM2_SU_CLEAR);
+	else
+		rc = tpm_get_timeouts(proxy_dev->chip);
+
+	if (rc)
+		goto err;
+
+	rc = tpm_chip_register(proxy_dev->chip);
+	if (rc)
+		goto err;
+
+	return;
+
+err:
+	vtpm_proxy_fops_undo_open(proxy_dev);
+}
+
+/*
+ * vtpm_proxy_work_stop: make sure the work has finished
+ *
+ * This function is useful when user space closed the fd
+ * while the driver still determines timeouts.
+ */
+static void vtpm_proxy_work_stop(struct proxy_dev *proxy_dev)
+{
+	vtpm_proxy_fops_undo_open(proxy_dev);
+	flush_work(&proxy_dev->work);
+}
+
+/*
+ * vtpm_proxy_work_start: Schedule the work for TPM 1.2 & 2 initialization
+ */
+static inline void vtpm_proxy_work_start(struct proxy_dev *proxy_dev)
+{
+	queue_work(workqueue, &proxy_dev->work);
+}
+
+/*
  * Code related to creation and deletion of device pairs
  */
 static struct proxy_dev *vtpm_proxy_create_proxy_dev(void)
@@ -355,6 +424,7 @@ static struct proxy_dev *vtpm_proxy_create_proxy_dev(void)
 
 	init_waitqueue_head(&proxy_dev->wq);
 	mutex_init(&proxy_dev->buf_lock);
+	INIT_WORK(&proxy_dev->work, vtpm_proxy_work);
 
 	chip = tpm_chip_alloc(NULL, &vtpm_proxy_tpm_ops);
 	if (IS_ERR(chip)) {
@@ -425,9 +495,7 @@ static struct file *vtpm_proxy_create_device(
 	if (proxy_dev->flags & VTPM_PROXY_FLAG_TPM2)
 		proxy_dev->chip->flags |= TPM_CHIP_FLAG_TPM2;
 
-	rc = tpm_chip_register(proxy_dev->chip);
-	if (rc)
-		goto err_vtpm_fput;
+	vtpm_proxy_work_start(proxy_dev);
 
 	vtpm_new_dev->fd = fd;
 	vtpm_new_dev->major = MAJOR(proxy_dev->chip->dev.devt);
@@ -436,12 +504,6 @@ static struct file *vtpm_proxy_create_device(
 
 	return file;
 
-err_vtpm_fput:
-	put_unused_fd(fd);
-	fput(file);
-
-	return ERR_PTR(rc);
-
 err_put_unused_fd:
 	put_unused_fd(fd);
 
@@ -456,6 +518,8 @@ err_delete_proxy_dev:
  */
 static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev)
 {
+	vtpm_proxy_work_stop(proxy_dev);
+
 	tpm_chip_unregister(proxy_dev->chip);
 
 	vtpm_proxy_fops_undo_open(proxy_dev);
@@ -550,11 +614,24 @@ static int __init vtpm_module_init(void)
 		return rc;
 	}
 
+	workqueue = create_workqueue("tpm-vtpm");
+	if (!workqueue) {
+		pr_err("couldn't create workqueue\n");
+		rc = -ENOMEM;
+		goto err_vtpmx_cleanup;
+	}
+
 	return 0;
+
+err_vtpmx_cleanup:
+	vtpmx_cleanup();
+
+	return rc;
 }
 
 static void __exit vtpm_module_exit(void)
 {
+	destroy_workqueue(workqueue);
 	vtpmx_cleanup();
 }
 
-- 
2.4.3


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
