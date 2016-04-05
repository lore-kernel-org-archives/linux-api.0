From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [v9,3/4] tpm: Initialize TPM and get durations and timeouts
Date: Tue, 5 Apr 2016 12:58:12 +0300
Message-ID: <20160405095812.GB12854@intel.com>
References: <1459275554-12915-4-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160331082435.GA9657@intel.com>
 <56FD1F07.3010705@linux.vnet.ibm.com>
 <20160405095626.GA12854@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160405095626.GA12854@intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 05, 2016 at 12:56:26PM +0300, Jarkko Sakkinen wrote:
> On Thu, Mar 31, 2016 at 08:58:47AM -0400, Stefan Berger wrote:
> > On 03/31/2016 04:24 AM, Jarkko Sakkinen wrote:
> > >On Tue, Mar 29, 2016 at 02:19:13PM -0400, Stefan Berger wrote:
> > >>Add the retrieval of TPM 1.2 durations and timeouts. Since this requires
> > >>the startup of the TPM, do this for TPM 1.2 and TPM 2.
> > 
> > >>@@ -343,6 +362,55 @@ static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
> > >>  };
> > >>  /*
> > >>+ * Code related to the startup of the TPM 2 and startup of TPM 1.2 +
> > >>+ * retrieval of timeouts and durations.
> > >>+ */
> > >>+
> > >>+static void vtpm_proxy_work(struct work_struct *work)
> > >>+{
> > >>+	struct proxy_dev *proxy_dev = container_of(work, struct proxy_dev,
> > >>+						   work);
> > >>+	int rc;
> > >>+
> > >>+	if (proxy_dev->flags & VTPM_PROXY_FLAG_TPM2)
> > >>+		rc = tpm2_startup(proxy_dev->chip, TPM2_SU_CLEAR);
> > >>+	else
> > >>+		rc = tpm_get_timeouts(proxy_dev->chip);
> > >>+
> > >>+	if (rc)
> > >>+		goto err;
> > >>+
> > >>+	rc = tpm_chip_register(proxy_dev->chip);
> > >>+	if (rc)
> > >>+		goto err;
> > >>+
> > >>+	return;
> > >>+
> > >>+err:
> > >>+	vtpm_proxy_fops_undo_open(proxy_dev);
> > >>+}
> > >>+
> > >>+/*
> > >>+ * vtpm_proxy_work_stop: make sure the work has finished
> > >>+ *
> > >>+ * This function is useful when user space closed the fd
> > >>+ * while the driver still determines timeouts.
> > >>+ */
> > >>+static void vtpm_proxy_work_stop(struct proxy_dev *proxy_dev)
> > >>+{
> > >>+	vtpm_proxy_fops_undo_open(proxy_dev);
> > >>+	flush_work(&proxy_dev->work);
> > >The main proxy driver patch should implement cancel() callback and then
> > >these could be swapped. This whole use of OPENED callback looks like a
> > >hack that is done because cancel is not implemented.
> > 
> > What OPENED callback are you referring to? We have a OPENED flag but not a
> > callback.
> > 
> > The above handles the case where the vTPM process for example dies [during
> > TPM_Startup()] and the file descriptor is closed.
> > vtpm_proxy_fops_undo_open() ensures that the vtpm thread is not stuck
> > waiting for the response to the TPM_Startup(). The subsequent flush_work()
> > ensures that the thread has finished before we continue shutting down the
> > instance. This cannot be swapped.
> 
> Got you.
> 
> 
> > >A new flag CANCELED could be added and functions would return -ECANCEL
> > >if it is set. This should be part of original vTPM proxy driver
> > >functionally.
> > 
> > The above has nothing to do with cancellation from what I can see. We have
> > an OPENED flag now which is set when the driver is fully operational and
> > cleared when it is not. We could instead use a SHUTDOWN or CLOSED flag that
> > works with the reverse meaning, clearing it where OPENED is set now and
> > setting it where OPENED is cleared. Would this help?
> > 
> > >
> > >The current solution is unclean and hard to follow. It looks like "it
> > >could work" but the OPENED flag has too many hats that it wears IMHO.
> > 
> > It has only one meaning which can be replaced with a flag as indicated
> > above.
> > 
> > That it is tested in vtpm_tpm_req_canceled is due to it indicating that the
> > driver is not operational for the current command anymore, which gets it out
> > of the loop in tpm_transmit. It would probably be worse to return a status
> > flag from the status() callback and return a flag in the req_complete_mask
> > that would then end up calling the recv() callback when there is nothing to
> > receive. So the way it is now it triggers -ECANCELED in the tpm_transmit
> > loop, which seems appropriate.
> 
> Reviewd-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I apply all your remaining patches to my master and I've also run tests
with all of them succesfully (multiple times).

/Jarkko

> >    Stefan
> 
> 
> /Jarkko
> 
> > 
> > 
> > 
> > >
> > >/Jarkko
> > >
> > >>+}
> > >>+
> > >>+/*
> > >>+ * vtpm_proxy_work_start: Schedule the work for TPM 1.2 & 2 initialization
> > >>+ */
> > >>+static inline void vtpm_proxy_work_start(struct proxy_dev *proxy_dev)
> > >>+{
> > >>+	queue_work(workqueue, &proxy_dev->work);
> > >>+}
> > >>+
> > >>+/*
> > >>   * Code related to creation and deletion of device pairs
> > >>   */
> > >>  static struct proxy_dev *vtpm_proxy_create_proxy_dev(void)
> > >>@@ -357,6 +425,7 @@ static struct proxy_dev *vtpm_proxy_create_proxy_dev(void)
> > >>  	init_waitqueue_head(&proxy_dev->wq);
> > >>  	mutex_init(&proxy_dev->buf_lock);
> > >>+	INIT_WORK(&proxy_dev->work, vtpm_proxy_work);
> > >>  	chip = tpm_chip_alloc(NULL, &vtpm_proxy_tpm_ops);
> > >>  	if (IS_ERR(chip)) {
> > >>@@ -427,9 +496,7 @@ static struct file *vtpm_proxy_create_device(
> > >>  	if (proxy_dev->flags & VTPM_PROXY_FLAG_TPM2)
> > >>  		proxy_dev->chip->flags |= TPM_CHIP_FLAG_TPM2;
> > >>-	rc = tpm_chip_register(proxy_dev->chip);
> > >>-	if (rc)
> > >>-		goto err_vtpm_fput;
> > >>+	vtpm_proxy_work_start(proxy_dev);
> > >>  	vtpm_new_dev->fd = fd;
> > >>  	vtpm_new_dev->major = MAJOR(proxy_dev->chip->dev.devt);
> > >>@@ -438,12 +505,6 @@ static struct file *vtpm_proxy_create_device(
> > >>  	return file;
> > >>-err_vtpm_fput:
> > >>-	put_unused_fd(fd);
> > >>-	fput(file);
> > >>-
> > >>-	return ERR_PTR(rc);
> > >>-
> > >>  err_put_unused_fd:
> > >>  	put_unused_fd(fd);
> > >>@@ -458,6 +519,8 @@ err_delete_proxy_dev:
> > >>   */
> > >>  static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev)
> > >>  {
> > >>+	vtpm_proxy_work_stop(proxy_dev);
> > >>+
> > >>  	/*
> > >>  	 * A client may hold the 'ops' lock, so let it know that the server
> > >>  	 * side shuts down before we try to grab the 'ops' lock when
> > >>@@ -557,11 +620,24 @@ static int __init vtpm_module_init(void)
> > >>  		return rc;
> > >>  	}
> > >>+	workqueue = create_workqueue("tpm-vtpm");
> > >>+	if (!workqueue) {
> > >>+		pr_err("couldn't create workqueue\n");
> > >>+		rc = -ENOMEM;
> > >>+		goto err_vtpmx_cleanup;
> > >>+	}
> > >>+
> > >>  	return 0;
> > >>+
> > >>+err_vtpmx_cleanup:
> > >>+	vtpmx_cleanup();
> > >>+
> > >>+	return rc;
> > >>  }
> > >>  static void __exit vtpm_module_exit(void)
> > >>  {
> > >>+	destroy_workqueue(workqueue);
> > >>  	vtpmx_cleanup();
> > >>  }
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
