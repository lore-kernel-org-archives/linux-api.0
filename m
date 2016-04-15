From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v10 4/5] tpm: Initialize TPM and get durations and
 timeouts
Date: Fri, 15 Apr 2016 11:18:46 -0600
Message-ID: <20160415171846.GB21359@obsidianresearch.com>
References: <1460728216-19563-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1460728216-19563-5-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460728216-19563-5-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, jarkko.sakkinen@linux.intel.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 15, 2016 at 09:50:15AM -0400, Stefan Berger wrote:

> @@ -69,12 +73,19 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
>  	size_t len;
>  	int sig, rc;
>  
> -	sig = wait_event_interruptible(proxy_dev->wq, proxy_dev->req_len != 0);
> +	sig = wait_event_interruptible(proxy_dev->wq,
> +		proxy_dev->req_len != 0 ||
> +		!(proxy_dev->state & STATE_OPENED_FLAG));
>  	if (sig)
>  		return -EINTR;

This hunk and related doesn't look like it belongs in this patch?

Suggest just merging this into the prior patch and be done with it, not
really any reason to have two patches anymore.

I think everything that was brought up is taken care of now..

One last read through..

> static int vtpm_proxy_tpm_op_recv(struct tpm_chip *chip, u8 *buf, size_t count)
> {
>	struct proxy_dev *proxy_dev = dev_get_drvdata(&chip->dev);
>	if (!proxy_dev)
>		return -EIO;

Is that actually possible? It shouldn't be. If not please drop it an
related.

For both:
Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Jason
