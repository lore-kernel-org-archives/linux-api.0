From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] scsi: ufs: add ioctl interface for query request
Date: Wed, 07 Oct 2015 10:11:44 +0200
Message-ID: <14797522.dgtjTj5niW@wuerfel>
References: <1444204457-14935-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444204457-14935-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Noa Rubens <noag@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 07 October 2015 10:54:03 Yaniv Gardi wrote:
>  
> +/* IOCTL opcode for command - ufs set device read only */
> +#define UFS_IOCTL_BLKROSET      BLKROSET
> +

What is this for? Can't you just use the normal BLKROSET definition in user space?

> +
> +       ioctl_data = kzalloc(sizeof(struct ufs_ioctl_query_data), GFP_KERNEL);
> +       if (!ioctl_data) {
> +               err = -ENOMEM;
> +               goto out;
> +       }

ufs_ioctl_query_data is short enough to just be on the stack.

> +		}
> +		length = min_t(int, QUERY_DESC_MAX_SIZE,
> +				ioctl_data->buf_size);
> +		desc = kzalloc(length, GFP_KERNEL);
> +		if (!desc) {
> +			dev_err(hba->dev, "%s: Failed allocating %d bytes\n",
> +					__func__, length);
> +			err = -ENOMEM;
> +			goto out_release_mem;
> +		}

Better check for a maximum length as well, not just a minimum length.
For overly long requests, just return an error without trying the kzalloc.

You can also use memdup_user to avoid the extra zeroing and and simplify
the calling code.

> +/**
> + * ufshcd_ioctl - ufs ioctl callback registered in scsi_host
> + * @dev: scsi device required for per LUN queries
> + * @cmd: command opcode
> + * @buffer: user space buffer for transferring data
> + *
> + * Supported commands:
> + * UFS_IOCTL_QUERY
> + */
> +static int ufshcd_ioctl(struct scsi_device *dev, int cmd, void __user *buffer)
> +{
> +	struct ufs_hba *hba = shost_priv(dev->host);
> +	int err = 0;
> +
> +	BUG_ON(!hba);
> +	if (!buffer) {
> +		dev_err(hba->dev, "%s: User buffer is NULL!\n", __func__);
> +		return -EINVAL;
> +	}

Don't print an error here, you don't want users to be able to flood
syslog that easily, and the program that caused the error does not
see the log anyway.

> +
> +	switch (cmd) {
> +	case UFS_IOCTL_QUERY:
> +		pm_runtime_get_sync(hba->dev);
> +		err = ufshcd_query_ioctl(hba, ufshcd_scsi_to_upiu_lun(dev->lun),
> +				buffer);
> +		pm_runtime_put_sync(hba->dev);
> +		break;
> +	case UFS_IOCTL_BLKROSET:
> +		err = -ENOIOCTLCMD;
> +		break;
> +	default:
> +		err = -EINVAL;
> +		dev_err(hba->dev, "%s: Illegal ufs-IOCTL cmd %d\n", __func__,
> +				cmd);
> +		break;

same here.

> +	}
> +
> +	return err;
> +}
> +
> +/**
>   * ufshcd_async_scan - asynchronous execution for probing hba
>   * @data: data pointer to pass to this function
>   * @cookie: cookie data
> @@ -5106,6 +5322,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>  	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
>  	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
>  	.eh_timed_out		= ufshcd_eh_timed_out,
> +	.ioctl			= ufshcd_ioctl,
>  	.this_id		= -1,
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,

The ioctl data is compatible between 32-bit and 64-bit user space, so
better add a .compat_ioctl line right away to make this work on 64-bit
architectures with 32-bit user space.

> +
> +/*
> + *  IOCTL opcode for ufs queries has the following opcode after
> + *  SCSI_IOCTL_GET_PCI
> + */
> +#define UFS_IOCTL_QUERY			0x5388

Use _IOWR() to define that number with the correct argument length

> +/**
> + * struct ufs_ioctl_query_data - used to transfer data to and from
> + * user via ioctl
> + * @opcode: type of data to query (descriptor/attribute/flag)
> + * @idn: id of the data structure
> + * @buf_size: number of allocated bytes/data size on return
> + * @buffer: data location
> + *
> + * Received: buffer and buf_size (available space for transferred data)
> + * Submitted: opcode, idn, length, buf_size
> + */
> +struct ufs_ioctl_query_data {
> +	/*
> +	 * User should select one of the opcode defined in "enum query_opcode".
> +	 * Please check include/uapi/scsi/ufs/ufs.h for the definition of it.
> +	 * Note that only UPIU_QUERY_OPCODE_READ_DESC,
> +	 * UPIU_QUERY_OPCODE_READ_ATTR & UPIU_QUERY_OPCODE_READ_FLAG are
> +	 * supported as of now. All other query_opcode would be considered
> +	 * invalid.
> +	 * As of now only read query operations are supported.
> +	 */
> +	__u32 opcode;
> +	/*
> +	 * User should select one of the idn from "enum flag_idn" or "enum
> +	 * attr_idn" or "enum desc_idn" based on whether opcode above is
> +	 * attribute, flag or descriptor.
> +	 * Please check include/uapi/scsi/ufs/ufs.h for the definition of it.
> +	 */
> +	__u8 idn;
> +	/*
> +	 * User should specify the size of the buffer (buffer[0] below) where
> +	 * it wants to read the query data (attribute/flag/descriptor).
> +	 * As we might end up reading less data then what is specified in
> +	 * buf_size. So we are updating buf_size to what exactly we have read.
> +	 */
> +	__u16 buf_size;
> +	/*
> +	 * placeholder for the start of the data buffer where kernel will copy
> +	 * the query data (attribute/flag/descriptor) read from the UFS device
> +	 * Note:
> +	 * For Read Attribute you will have to allocate 4 bytes
> +	 * For Read Flag you will have to allocate 1 byte
> +	 */
> +	__u8 buffer[0];
> +};

Better rearrange the structure to avoid the implied padding, either by
making idn a __u16, or by adding an explicit __u8 member behind it.

	Arnd
