From: Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/9] HSI: cmt_speech: Add cmt-speech driver
Date: Mon, 02 Mar 2015 11:22:33 +0100
Message-ID: <1425291753.2014.5.camel@neukum.org>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
	 <1425271139-24715-2-git-send-email-sre@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425271139-24715-2-git-send-email-sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>, Kai Vehmanen <kvcontact-nQfqiRJ1PMYxHbG02/KK1g@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Pali Rohar <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>, Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kai Vehmanen <kai.vehmanen-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>, Carlos Chinea <carlos.chinea-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>, Joni Lapilainen <joni.lapilainen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


> +static ssize_t cs_char_read(struct file *file, char __user *buf, size_t count,
> +								loff_t *unused)
> +{
> +	struct cs_char *csdata = file->private_data;
> +	u32 data;
> +	ssize_t retval;
> +
> +	if (count < sizeof(data))
> +		return -EINVAL;
> +
> +	for ( ; ; ) {
> +		DEFINE_WAIT(wait);
> +
> +		spin_lock_bh(&csdata->lock);
> +		if (!list_empty(&csdata->chardev_queue)) {
> +			data = cs_pop_entry(&csdata->chardev_queue);
> +		} else if (!list_empty(&csdata->dataind_queue)) {
> +			data = cs_pop_entry(&csdata->dataind_queue);
> +			--csdata->dataind_pending;
> +
> +		} else {
> +			data = 0;
> +		}
> +		spin_unlock_bh(&csdata->lock);
> +
> +		if (data)
> +			break;
> +		if (file->f_flags & O_NONBLOCK) {
> +			retval = -EAGAIN;
> +			goto out;
> +		} else if (signal_pending(current)) {
> +			retval = -ERESTARTSYS;
> +			goto out;
> +		}
> +		prepare_to_wait_exclusive(&csdata->wait, &wait,
> +						TASK_INTERRUPTIBLE);
> +		schedule();
> +		finish_wait(&csdata->wait, &wait);
> +	}
> +
> +	retval = put_user(data, (u32 __user *)buf);
> +	if (!retval)
> +		retval = sizeof(data);
> +
> +out:
> +	return retval;
> +}
> +
> +static ssize_t cs_char_write(struct file *file, const char __user *buf,
> +						size_t count, loff_t *unused)
> +{
> +	struct cs_char *csdata = file->private_data;
> +	u32 data;
> +	int err;
> +	ssize_t	retval;
> +
> +	if (count < sizeof(data))
> +		return -EINVAL;
> +
> +	if (get_user(data, (u32 __user *)buf))
> +		retval = -EFAULT;
> +	else
> +		retval = count;

You want to execute the command even if you got -EFAULT?
That is highly unusual.

> +
> +	err = cs_hsi_command(csdata->hi, data);
> +	if (err < 0)
> +		retval = err;
> +
> +	return retval;
> +}
> +
> +static long cs_char_ioctl(struct file *file, unsigned int cmd,
> +				unsigned long arg)
> +{
> +	struct cs_char *csdata = file->private_data;
> +	int r = 0;
> +
> +	switch (cmd) {
> +	case CS_GET_STATE: {
> +		unsigned int state;
> +
> +		state = cs_hsi_get_state(csdata->hi);
> +		if (copy_to_user((void __user *)arg, &state, sizeof(state)))
> +			r = -EFAULT;
> +	}
> +		break;
> +	case CS_SET_WAKELINE: {
> +		unsigned int state;
> +
> +		if (copy_from_user(&state, (void __user *)arg, sizeof(state)))
> +			r = -EFAULT;
> +		else
> +			cs_hsi_set_wakeline(csdata->hi, state);

No sanity checking for state?

> +	}
> +		break;
> +	case CS_GET_IF_VERSION: {
> +		unsigned int ifver = CS_IF_VERSION;
> +
> +		if (copy_to_user((void __user *)arg, &ifver, sizeof(ifver)))
> +			r = -EFAULT;
> +		break;
> +	}
> +	case CS_CONFIG_BUFS: {
> +		struct cs_buffer_config buf_cfg;
> +
> +		if (copy_from_user(&buf_cfg, (void __user *)arg,
> +							sizeof(buf_cfg)))
> +			r = -EFAULT;
> +		else
> +			r = cs_hsi_buf_config(csdata->hi, &buf_cfg);

Sanity checking?

> +		break;
> +	}
> +	default:
> +		r = -ENOTTY;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	if (vma->vm_end < vma->vm_start)
> +		return -EINVAL;
> +
> +	if (((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) != 1)
> +		return -EINVAL;
> +
> +	vma->vm_flags |= VM_RESERVED;
> +	vma->vm_ops = &cs_char_vm_ops;
> +	vma->vm_private_data = file->private_data;
> +
> +	return 0;
> +}
> +
> +static int cs_char_open(struct inode *unused, struct file *file)
> +{
> +	int ret = 0;
> +
> +	spin_lock_bh(&cs_char_data.lock);
> +	if (cs_char_data.opened) {
> +		ret = -EBUSY;
> +		spin_unlock_bh(&cs_char_data.lock);
> +		goto out;
> +	}
> +	cs_char_data.mmap_base = get_zeroed_page(GFP_ATOMIC);

This could be moved outside the locked sectionand use GFP_KERNEL.

> +	if (!cs_char_data.mmap_base) {
> +		dev_err(&cs_char_data.cl->device,
> +					"Shared memory allocation failed.\n");
> +		ret = -ENOMEM;
> +		spin_unlock_bh(&cs_char_data.lock);
> +		goto out;
> +	}
> +	cs_char_data.mmap_size = CS_MMAP_SIZE;
> +	cs_char_data.dataind_pending = 0;
> +	cs_char_data.opened = 1;
> +	file->private_data = &cs_char_data;
> +	spin_unlock_bh(&cs_char_data.lock);
> +
> +	BUG_ON(cs_char_data.hi);
> +
> +	ret = cs_hsi_start(&cs_char_data.hi, cs_char_data.cl,
> +				cs_char_data.mmap_base, cs_char_data.mmap_size);
> +	if (ret) {
> +		dev_err(&cs_char_data.cl->device, "Unable to initialize HSI\n");
> +		free_page(cs_char_data.mmap_base);
> +		goto out;
> +	}
> +
> +out:
> +	return ret;
> +}
