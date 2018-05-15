From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [patch v21 1/4] drivers: jtag: Add JTAG core driver
Date: Wed, 16 May 2018 00:21:35 +0300
Message-ID: <CAHp75VctG5RBtLF3nT5e_j7_e9O12u=5gerJ6OMxWbABM9ft2w@mail.gmail.com>
References: <1526394095-5069-1-git-send-email-oleksandrs@mellanox.com> <1526394095-5069-2-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526394095-5069-2-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, devicetree <devicetree@vger.kernel.org>, openbmc@lists.ozlabs.org, Joel Stanley <joel@jms.id.au>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>, Tobias Klauser <tklauser@distanz.ch>, "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>, Vadim Pasternak <vadimp@mellanox.com>, system-sw-low-level@mellanox.com, Rob Herring <robh+dt@kernel.org>, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 15, 2018 at 5:21 PM, Oleksandr Shamray
<oleksandrs@mellanox.com> wrote:
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

>  0xB0   all     RATIO devices           in development:
>                                         <mailto:vgo@ratio.de>
>  0xB1   00-1F   PPPoX                   <mailto:mostrows@styx.uwaterloo.ca>
> +0xB2   00-0f   linux/jtag.h            JTAG driver
> +                                       <mailto:oleksandrs@mellanox.com>

Consider to preserve style (upper vs. lower).

> +         This provides basic core functionality support for JTAG class devices.
> +         Hardware that is equipped with a JTAG microcontroller can be
> +         supported by using this driver's interfaces.
> +         This driver exposes a set of IOCTLs to the user space for
> +         the following commands:
> +         SDR: (Scan Data Register) Performs an IEEE 1149.1 Data Register scan
> +         SIR: (Scan Instruction Register) Performs an IEEE 1149.1 Instruction
> +         Register scan.
> +         RUNTEST: Forces the IEEE 1149.1 bus to a run state for a specified
> +         number of clocks or a specified time period.

Something feels wrong with formatting here.

> +#define MAX_JTAG_NAME_LEN (sizeof("jtag") + 5)

Interesting definition. Why not to set to 10 explicitly? And why 10?
(16 sounds better)

> +struct jtag {
> +       struct miscdevice miscdev;

> +       struct device *dev;

Doesn't miscdev parent contain exactly this one?

> +       const struct jtag_ops *ops;
> +       int id;
> +       bool opened;
> +       struct mutex open_lock;
> +       unsigned long priv[0];
> +};

> +               err = copy_to_user(u64_to_user_ptr(xfer.tdio),
> +                                  (void *)(xfer_data), data_size);

Redundant parens in one case. Check the rest similar places.

> +static int jtag_open(struct inode *inode, struct file *file)
> +{

> +       struct jtag *jtag = container_of(file->private_data, struct jtag,
> +                                        miscdev);

I would don't care about length and put it on one line.

> +       if (jtag->opened) {
> +       jtag->opened = true;
> +       jtag->opened = false;

Can it be opened non exclusively several times? If so, this needs to
be a ref counter instead.

> +       if (!ops->idle || !ops->mode_set || !ops->status_get || !ops->xfer)
> +               return NULL;

Are all of them mandatory?

> +int jtag_register(struct jtag *jtag)

Perhaps devm_ variant.

> +#define jtag_u64_to_ptr(arg) ((void *)(uintptr_t)arg)

Where is this used or supposed to be used?

> +#define JTAG_MAX_XFER_DATA_LEN 65535

Is this limitation from some spec?
Otherwise why not to allow 64K?

> +/**
> + * struct jtag_ops - callbacks for jtag control functions:
> + *
> + * @freq_get: get frequency function. Filled by device driver
> + * @freq_set: set frequency function. Filled by device driver
> + * @status_get: set status function. Filled by device driver
> + * @idle: set JTAG to idle state function. Filled by device driver
> + * @xfer: send JTAG xfer function. Filled by device driver
> + */

Perhaps you need to describe which of them are _really_ mandatory and
which are optional.

-- 
With Best Regards,
Andy Shevchenko
