From: Julia Cartwright <juliac@eso.teric.us>
Subject: Re: [patch v16 1/4] drivers: jtag: Add JTAG core driver
Date: Mon, 15 Jan 2018 14:51:42 -0600
Message-ID: <20180115205142.GD2818@kryptos.localdomain>
References: <1515776909-29894-1-git-send-email-oleksandrs@mellanox.com>
 <1515776909-29894-2-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1515776909-29894-2-git-send-email-oleksandrs@mellanox.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: system-sw-low-level@mellanox.com, devicetree@vger.kernel.org, jiri@resnulli.us, arnd@arndb.de, vadimp@mellanox.com, gregkh@linuxfoundation.org, openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org, openocd-devel-owner@lists.sourceforge.net, Jiri Pirko <jiri@mellanox.com>, robh+dt@kernel.org, joel@jms.id.au, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, tklauser@distanz.ch, mchehab@kernel.org, davem@davemloft.net, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Hello Oleksandr-

I have a few comments below.

On Fri, Jan 12, 2018 at 07:08:26PM +0200, Oleksandr Shamray wrote:
> Initial patch for JTAG driver
> JTAG class driver provide infrastructure to support hardware/software
> JTAG platform drivers. It provide user layer API interface for flashing
> and debugging external devices which equipped with JTAG interface
> using standard transactions.
> 
> Driver exposes set of IOCTL to user space for:
> - XFER:
> - SIR (Scan Instruction Register, IEEE 1149.1 Data Register scan);
> - SDR (Scan Data Register, IEEE 1149.1 Instruction Register scan);
> - RUNTEST (Forces the IEEE 1149.1 bus to a run state for a specified
>   number of clocks).
> - SIOCFREQ/GIOCFREQ for setting and reading JTAG frequency.
> 
> Driver core provides set of internal APIs for allocation and
> registration:
> - jtag_register;
> - jtag_unregister;
> - jtag_alloc;
> - jtag_free;
> 
> Platform driver on registration with jtag-core creates the next
> entry in dev folder:
> /dev/jtagX
> 
> Signed-off-by: Oleksandr Shamray <oleksandrs@mellanox.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Acked-by: Philippe Ombredanne <pombredanne@nexb.com>

[..]

> +static long jtag_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct jtag *jtag = file->private_data;
> +	struct jtag_run_test_idle idle;
> +	struct jtag_xfer xfer;
> +	u8 *xfer_data;
> +	u32 data_size;
> +	u32 value;
> +	int err;
> +
> +	if (!arg)
> +		return -EINVAL;
> +
> +	switch (cmd) {
> +	case JTAG_GIOCFREQ:
> +		if (!jtag->ops->freq_get)
> +			err = -EOPNOTSUPP;
> +
> +		err = jtag->ops->freq_get(jtag, &value);
> +		if (err)
> +			break;
> +
> +		if (put_user(value, (__u32 *)arg))
> +			err = -EFAULT;
> +		break;
> +
> +	case JTAG_SIOCFREQ:
> +		if (!jtag->ops->freq_set)
> +			return -EOPNOTSUPP;
> +
> +		if (get_user(value, (__u32 *)arg))
> +			return -EFAULT;
> +		if (value == 0)
> +			return -EINVAL;
> +
> +		err = jtag->ops->freq_set(jtag, value);
> +		break;
> +
> +	case JTAG_IOCRUNTEST:
> +		if (!jtag->ops->idle)
> +			return -EOPNOTSUPP;
> +
> +		if (copy_from_user(&idle, (void *)arg,
> +				   sizeof(struct jtag_run_test_idle)))
> +			return -EFAULT;
> +
> +		if (idle.endstate > JTAG_STATE_PAUSEDR)
> +			return -EINVAL;
> +
> +		err = jtag->ops->idle(jtag, &idle);
> +		break;
> +
> +	case JTAG_IOCXFER:
> +		if (!jtag->ops->xfer)

Are all ops optional?  That seems bizarre.  I would have expected at
least one callback to be required.

[..]
> +static int jtag_open(struct inode *inode, struct file *file)
> +{
> +	struct jtag *jtag = container_of(file->private_data, struct jtag,
> +					 miscdev);
> +
> +	if (mutex_lock_interruptible(&jtag->open_lock))
> +		return -ERESTARTSYS;
> +
> +	if (jtag->opened) {
> +		mutex_unlock(&jtag->open_lock);
> +		return -EBUSY;
> +	}
> +
> +	nonseekable_open(inode, file);
> +	file->private_data = jtag;

These two can be moved out of the lock.

> +	jtag->opened = true;
> +	mutex_unlock(&jtag->open_lock);
> +	return 0;
> +}
> +
> +static int jtag_release(struct inode *inode, struct file *file)
> +{
> +	struct jtag *jtag = file->private_data;
> +
> +	mutex_lock(&jtag->open_lock);
> +	jtag->opened = false;
> +	mutex_unlock(&jtag->open_lock);
> +	return 0;
> +}
> +
> +static const struct file_operations jtag_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= jtag_open,
> +	.release	= jtag_release,
> +	.llseek		= noop_llseek,
> +	.unlocked_ioctl = jtag_ioctl,
> +};
> +
> +struct jtag *jtag_alloc(size_t priv_size, const struct jtag_ops *ops)
> +{
> +	struct jtag *jtag;
> +
> +	jtag = kzalloc(sizeof(*jtag), GFP_KERNEL);

Did you mean to allocate: sizeof(*jtag) + priv_size?

> +	if (!jtag)
> +		return NULL;
> +
> +	jtag->ops = ops;
> +	return jtag;
> +}
> +EXPORT_SYMBOL_GPL(jtag_alloc);
> +
> +void jtag_free(struct jtag *jtag)
> +{
> +	kfree(jtag);
> +}
> +EXPORT_SYMBOL_GPL(jtag_free);
> +
> +int jtag_register(struct jtag *jtag)
> +{
> +	char *name;
> +	int err;
> +	int id;
> +
> +	id = ida_simple_get(&jtag_ida, 0, 0, GFP_KERNEL);
> +	if (id < 0)
> +		return id;
> +
> +	jtag->id = id;
> +
> +	name = kzalloc(MAX_JTAG_NAME_LEN, GFP_KERNEL);
> +	if (!name) {
> +		err = -ENOMEM;
> +		goto err_jtag_alloc;
> +	}
> +
> +	err = snprintf(name, MAX_JTAG_NAME_LEN, "jtag%d", id);
> +	if (err < 0)
> +		goto err_jtag_name;
> +
> +	mutex_init(&jtag->open_lock);
> +	jtag->miscdev.fops =  &jtag_fops;
> +	jtag->miscdev.minor = MISC_DYNAMIC_MINOR;
> +	jtag->miscdev.name = name;
> +
> +	err = misc_register(&jtag->miscdev);
> +	if (err)
> +		dev_err(jtag->dev, "Unable to register device\n");
> +	else
> +		return 0;
> +	jtag->opened = false;

Well, this code flow is just confusing.

I suggest a redo with:

	err = misc_register(&jtag->miscdev);
	if (err) {
		dev_err(jtag->dev, "Unable to register device\n");
		goto err_jtag_name;
	}

If you need to initialize 'opened', do it prior to misc_register.

Thanks,
   Julia
