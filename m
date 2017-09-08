From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [patch v8 1/4] drivers: jtag: Add JTAG core driver
Date: Fri, 8 Sep 2017 21:51:43 +0200
Message-ID: <CAK8P3a2zkA5Tp4En+=zLBes4YRedHcn9xf1DhBsRufqPWrzvVQ@mail.gmail.com>
References: <1504887229-2748-1-git-send-email-oleksandrs@mellanox.com> <1504887229-2748-2-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504887229-2748-2-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: gregkh <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, OpenBMC Maillist <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org, vadimp-45czdsxZ+A5DPfheJLI6IQ@public.gmane.org, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 8, 2017 at 6:13 PM, Oleksandr Shamray
<oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
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
> Signed-off-by: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

My Ack was actually just for the device driver part, I had not
looked at the core again, sorry for not being clearer here.

The other two patches are fine, but looking at this one again,
I find a couple of things to improve:

> +
> +static __u64 jtag_copy_from_user(__u64 udata, unsigned long bit_size)
> +{
> +       unsigned long size;
> +       void *kdata;
> +
> +       size = DIV_ROUND_UP(bit_size, BITS_PER_BYTE);
> +       kdata = memdup_user(u64_to_user_ptr(udata), size);
> +
> +       return (__u64)(uintptr_t)kdata;
> +}
> +
> +static unsigned long jtag_copy_to_user(__u64 udata, __u64 kdata,
> +                                      unsigned long bit_size)
> +{
> +       unsigned long size;
> +
> +       size = DIV_ROUND_UP(bit_size, BITS_PER_BYTE);
> +
> +       return copy_to_user(u64_to_user_ptr(udata), jtag_u64_to_ptr(kdata),
> +                           size);
> +}

Only a style comment, but the casting to and from u64 multiple
times here seems overly complicated. Why not use a regular kernel
pointer here, and then pass that as a third argument to
ag->ops->xfer() ?

> +
> +       case JTAG_SIOCFREQ:
> +               err = __get_user(value, uarg);

This needs to use get_user(), not __get_user(). I think you changed
all the other instances after an earlier comment, but missed this one.

> +static int jtag_open(struct inode *inode, struct file *file)
> +{
> +       struct jtag *jtag = container_of(inode->i_cdev, struct jtag, cdev);
> +
> +       spin_lock(&jtag->lock);
> +
> +       if (jtag->open) {
> +               dev_info(NULL, "jtag already opened\n");
> +               spin_unlock(&jtag->lock);
> +               return -EBUSY;
> +       }
> +
> +       jtag->open++;
> +       file->private_data = jtag;
> +       spin_unlock(&jtag->lock);
> +       return 0;
> +}

The spinlock seems to not protect anything but the use count,
so this could be an atomic_t.


> +       mutex_lock(&jtag_mutex);
> +       list_add_tail(&jtag->list, &jtag_list);
> +       mutex_unlock(&jtag_mutex);

Similarly, you only use the mutex to protect the list_add/list_del,
but nothing ever walks the list, so I think you can simply remove
both the list and the mutex.

> +static int __init jtag_init(void)
> +{
> +       int err;
> +
> +       err = alloc_chrdev_region(&jtag_devt, 0, 1, "jtag");
> +       if (err)
> +               return err;
> +       return class_register(&jtag_class);
> +}
> +
> +static void __exit jtag_exit(void)
> +{
> +       class_unregister(&jtag_class);
> +}

This looks a bit asymmetric:

- you allocate a chardev region but don't destroy it in jtag_exit,
  so presumably this leaks a major number allocation each
  time you load/unload the module

- you allocate a single minor number at module load time,
  but the individual devices each get another number, and
  the original one does not appear to be used, unless I
  misunderstand the API here.

     Arnd
