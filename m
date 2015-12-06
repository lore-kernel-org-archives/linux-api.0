From: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 01/11] stm class: Introduce an abstraction for System
 Trace Module devices
Date: Sat, 5 Dec 2015 22:40:10 -0500
Message-ID: <5663AE1A.2080808@oracle.com>
References: <1442926040-15150-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1442926040-15150-2-git-send-email-alexander.shishkin@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442926040-15150-2-git-send-email-alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/22/2015 08:47 AM, Alexander Shishkin wrote:
> +static ssize_t stm_char_write(struct file *file, const char __user *buf,
> +			      size_t count, loff_t *ppos)
> +{
> +	struct stm_file *stmf = file->private_data;
> +	struct stm_device *stm = stmf->stm;
> +	char *kbuf;
> +	int err;
> +
> +	/*
> +	 * if no m/c have been assigned to this writer up to this
> +	 * point, use "default" policy entry
> +	 */
> +	if (!stmf->output.nr_chans) {
> +		err = stm_file_assign(stmf, "default", 1);
> +		/*
> +		 * EBUSY means that somebody else just assigned this
> +		 * output, which is just fine for write()
> +		 */
> +		if (err && err != -EBUSY)
> +			return err;
> +	}
> +
> +	kbuf = kmalloc(count + 1, GFP_KERNEL);

This bit allows for user-controllable kmalloc() allocation lengths, including
a possible overflow.


Thanks,
Sasha
