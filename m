From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [patch v9 1/4] drivers: jtag: Add JTAG core driver
Date: Fri, 20 Oct 2017 16:54:17 +0200
Message-ID: <20171020145417.GD8965@kroah.com>
References: <1505985932-27568-1-git-send-email-oleksandrs@mellanox.com>
 <1505985932-27568-2-git-send-email-oleksandrs@mellanox.com>
 <20171020115512.GA2073@kroah.com>
 <AM4PR0501MB21940531802FC14EDE8C3F75B1430@AM4PR0501MB2194.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AM4PR0501MB21940531802FC14EDE8C3F75B1430@AM4PR0501MB2194.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>, "joel@jms.id.au" <joel@jms.id.au>, "jiri@resnulli.us" <jiri@resnulli.us>, "tklauser@distanz.ch" <tklauser@distanz.ch>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "mec@shout.net" <mec@shout.net>, Vadim Pasternak <vadimp@mellanox.com>, system-sw-low-level <system-sw-low-level@mellanox.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "openocd-devel-owner@lists.sourceforge.net" <openocd-devel-owner@lists.sourceforge.net>"linux-api@vger.kernel.org" <linux->
List-Id: linux-api@vger.kernel.org

On Fri, Oct 20, 2017 at 02:34:00PM +0000, Oleksandr Shamray wrote:
> Hi Greg.
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Friday, October 20, 2017 2:55 PM
> > To: Oleksandr Shamray <oleksandrs@mellanox.com>
> > Cc: arnd@arndb.de; linux-kernel@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; devicetree@vger.kernel.org;
> > openbmc@lists.ozlabs.org; joel@jms.id.au; jiri@resnulli.us;
> > tklauser@distanz.ch; linux-serial@vger.kernel.org; mec@shout.net; Vadim
> > Pasternak <vadimp@mellanox.com>; system-sw-low-level <system-sw-low-
> > level@mellanox.com>; robh+dt@kernel.org; openocd-devel-
> > owner@lists.sourceforge.net; linux-api@vger.kernel.org;
> > davem@davemloft.net; mchehab@kernel.org; Jiri Pirko <jiri@mellanox.com>
> > Subject: Re: [patch v9 1/4] drivers: jtag: Add JTAG core driver
> > 
> > On Thu, Sep 21, 2017 at 12:25:29PM +0300, Oleksandr Shamray wrote:
> > > +struct jtag {
> > > +	struct device *dev;
> > > +	struct cdev cdev;
> > 
> > Why are you using a cdev here and not just a normal misc device? 
> 
> What the benefits to use misc instead of cdev?

Less code, simpler logic, easier to review and understand, etc.

Let me ask you, why use a cdev instead of a misc?

> > I forgot if this is what you were doing before, sorry...
> > 
> > > +	int id;
> > > +	atomic_t open;
> > 
> > Why do you need this?
> 
> This counter used to avoid open at the same time by 2 or more users.

But it isn't working :)

And why do you care?

> > > +	const struct jtag_ops *ops;
> > > +	unsigned long priv[0] __aligned(ARCH_DMA_MINALIGN);
> > 
> > Huh?  Why is this needed to be dma aligned?  Why not just use the private
> > pointer in struct device?
> > 
> 
> It is critical?

You are saying it is, so you have to justify it.  There is a pointer for
you to use, don't make new ones for no reason, right?

> > > +};
> > > +
> > > +static dev_t jtag_devt;
> > > +static DEFINE_IDA(jtag_ida);
> > > +
> > > +void *jtag_priv(struct jtag *jtag)
> > > +{
> > > +	return jtag->priv;
> > > +}
> > > +EXPORT_SYMBOL_GPL(jtag_priv);
> > > +
> > > +static u8 *jtag_copy_from_user(__u64 udata, unsigned long bit_size) {
> > > +	unsigned long size;
> > > +	void *kdata;
> > > +
> > > +	size = DIV_ROUND_UP(bit_size, BITS_PER_BYTE);
> > > +	kdata = memdup_user(u64_to_user_ptr(udata), size);
> > 
> > You only use this once, why not just open-code it?
> 
> I think it makes code more understandable.

As a reviewer, I don't :)

> > > +
> > > +	return kdata;
> > > +}
> > > +
> > > +static unsigned long jtag_copy_to_user(__u64 udata, u8 *kdata,
> > > +				       unsigned long bit_size)
> > > +{
> > > +	unsigned long size;
> > > +
> > > +	size = DIV_ROUND_UP(bit_size, BITS_PER_BYTE);
> > > +
> > > +	return copy_to_user(u64_to_user_ptr(udata), (void *)(kdata), size);
> > 
> > Same here, making this a separate function seems odd.
> 
> Same, I think it makes code more understandable.

But it doesn't.

> > > +
> > > +		if (jtag->ops->freq_set)
> > > +			err = jtag->ops->freq_set(jtag, value);
> > > +		else
> > > +			err = -EOPNOTSUPP;
> > > +		break;
> > > +
> > > +	case JTAG_IOCRUNTEST:
> > > +		if (copy_from_user(&idle, (void *)arg,
> > > +				   sizeof(struct jtag_run_test_idle)))
> > > +			return -ENOMEM;
> > > +		err = jtag_run_test_idle_op(jtag, &idle);
> > 
> > Who validates the structure fields?  Is that up to the individual jtag driver?  Why
> > not do it in the core correctly so that it only has to be done in one place and you
> > do not have to audit every individual driver?
> 
> Input parameters validated by jtag  platform driver. I think it not critical.

Not true at all.  It is very critical.  Remmeber, "All Input Is Evil!"

You have to validate this.  I as a reviewer have to find where you are
validating this data to ensure bad things do not happen.  I can't review
that here, now I have to go and review all of the individual drivers,
which is a major pain, don't you agree?

> > > +		break;
> > > +
> > > +	case JTAG_IOCXFER:
> > > +		if (copy_from_user(&xfer, (void *)arg,
> > > +				   sizeof(struct jtag_xfer)))
> > > +			return -EFAULT;
> > > +
> > > +		if (xfer.length >= JTAG_MAX_XFER_DATA_LEN)
> > > +			return -EFAULT;
> > > +
> > > +		xfer_data = jtag_copy_from_user(xfer.tdio, xfer.length);
> > > +		if (!xfer_data)
> > > +			return -ENOMEM;
> > 
> > Are you sure that's the correct error value?
> 
> I think yes, but what you suggest?

A fault happened, so -EFAULT, right?

> [..]
> > +       .unlocked_ioctl = jtag_ioctl,
> > +       .open           = jtag_open,
> > +       .release        = jtag_release,
> > +};
> 
> add a compat_ioctl pointer here, after ensuring that all ioctl
> commands are compatible between 32-bit and 64-bit user space.
> [..]

And if you do not, what happens?  You shouldn't need it as there is no
fixups necessary, or am I mistaken about that?

> > > +static int jtag_open(struct inode *inode, struct file *file) {
> > > +	struct jtag *jtag = container_of(inode->i_cdev, struct jtag, cdev);
> > > +
> > > +	if (atomic_read(&jtag->open)) {
> > > +		dev_info(NULL, "jtag already opened\n");
> > > +		return -EBUSY;
> > 
> > Why do you care if multiple opens can happen?
> 
> Jtag HW not support to using with multiple requests from different users. So we prohibit this.

Why does the kernel care?

And again, your implementation is broken, it's not actually doing this
protection.  I recommend just not doing it at all, but if you really are
insisting on it, you have to get it correct :)

thanks,

greg k-h
