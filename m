From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v9 3/4] tpm: Initialize TPM and get durations and timeouts
Date: Tue, 29 Mar 2016 14:19:13 -0400
Message-ID: <1459275554-12915-4-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1459275554-12915-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459275554-12915-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add the retrieval of TPM 1.2 durations and timeouts. Since this requires
the startup of the TPM, do this for TPM 1.2 and TPM 2.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org
CC: linux-doc@vger.kernel.org
CC: linux-api@vger.kernel.org
---
 drivers/char/tpm/tpm_vtpm_proxy.c | 96 +++++++++++++++++++++++++++++++++++----
 1 file changed, 86 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 81abc4b..8936bf3 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -45,11 +45,15 @@ struct proxy_dev {
 	size_t req_len;              /* length of queued TPM request */
 	size_t resp_len;             /* length of queued TPM response */
 	u8 buffer[TPM_BUFSIZE];      /* request/response buffer */
+
+	struct work_struct work;     /* task that retrieves TPM timeouts */
 };
 
 /* all supported flags */
 #define VTPM_PROXY_FLAGS_ALL  (VTPM_PROXY_FLAG_TPM2)
 
+static struct workqueue_struct *workqueue;
+
 static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev);
 
 /*
@@ -69,12 +73,19 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
 	size_t len;
 	int sig, rc;
 
-	sig = wait_event_interruptible(proxy_dev->wq, proxy_dev->req_len != 0);
+	sig = wait_event_interruptible(proxy_dev->wq,
+		proxy_dev->req_len != 0 ||
+		!(proxy_dev->state & STATE_OPENED_FLAG));
 	if (sig)
 		return -EINTR;
 
 	mutex_lock(&proxy_dev->buf_lock);
 
+	if (!(proxy_dev->state & STATE_OPENED_FLAG)) {
+		mutex_unlock(&proxy_dev->buf_lock);
+		return -EPIPE;
+	}
+
 	len = proxy_dev->req_len;
 
 	if (count < len) {
@@ -112,6 +123,11 @@ static ssize_t vtpm_proxy_fops_write(struct file *filp, const char __user *buf,
 
 	mutex_lock(&proxy_dev->buf_lock);
 
+	if (!(proxy_dev->state & STATE_OPENED_FLAG)) {
+		mutex_unlock(&proxy_dev->buf_lock);
+		return -EPIPE;
+	}
+
 	if (count > sizeof(proxy_dev->buffer) ||
 	    !(proxy_dev->state & STATE_WAIT_RESPONSE_FLAG)) {
 		mutex_unlock(&proxy_dev->buf_lock);
@@ -156,6 +172,9 @@ static unsigned int vtpm_proxy_fops_poll(struct file *filp, poll_table *wait)
 	if (proxy_dev->req_len)
 		ret |= POLLIN | POLLRDNORM;
 
+	if (!(proxy_dev->state & STATE_OPENED_FLAG))
+		ret |= POLLHUP;
+
 	mutex_unlock(&proxy_dev->buf_lock);
 
 	return ret;
@@ -343,6 +362,55 @@ static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
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
@@ -357,6 +425,7 @@ static struct proxy_dev *vtpm_proxy_create_proxy_dev(void)
 
 	init_waitqueue_head(&proxy_dev->wq);
 	mutex_init(&proxy_dev->buf_lock);
+	INIT_WORK(&proxy_dev->work, vtpm_proxy_work);
 
 	chip = tpm_chip_alloc(NULL, &vtpm_proxy_tpm_ops);
 	if (IS_ERR(chip)) {
@@ -427,9 +496,7 @@ static struct file *vtpm_proxy_create_device(
 	if (proxy_dev->flags & VTPM_PROXY_FLAG_TPM2)
 		proxy_dev->chip->flags |= TPM_CHIP_FLAG_TPM2;
 
-	rc = tpm_chip_register(proxy_dev->chip);
-	if (rc)
-		goto err_vtpm_fput;
+	vtpm_proxy_work_start(proxy_dev);
 
 	vtpm_new_dev->fd = fd;
 	vtpm_new_dev->major = MAJOR(proxy_dev->chip->dev.devt);
@@ -438,12 +505,6 @@ static struct file *vtpm_proxy_create_device(
 
 	return file;
 
-err_vtpm_fput:
-	put_unused_fd(fd);
-	fput(file);
-
-	return ERR_PTR(rc);
-
 err_put_unused_fd:
 	put_unused_fd(fd);
 
@@ -458,6 +519,8 @@ err_delete_proxy_dev:
  */
 static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev)
 {
+	vtpm_proxy_work_stop(proxy_dev);
+
 	/*
 	 * A client may hold the 'ops' lock, so let it know that the server
 	 * side shuts down before we try to grab the 'ops' lock when
@@ -557,11 +620,24 @@ static int __init vtpm_module_init(void)
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
