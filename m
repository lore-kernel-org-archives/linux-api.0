From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 1/8] Introduce dynamic clock devices
Date: Mon, 8 Nov 2010 07:38:41 +0100
Message-ID: <201011080738.41871.arnd@arndb.de>
References: <cover.1288897198.git.richard.cochran@omicron.at> <031a33e771a3c8bd95ed2c88ede4820b7675ceca.1288897198.git.richard.cochran@omicron.at>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <031a33e771a3c8bd95ed2c88ede4820b7675ceca.1288897198.git.richard.cochran@omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>, John Stultz <johnstul@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

On Thursday 04 November 2010, Richard Cochran wrote:
> This patch adds support for adding and removing clock devices. The clock
> lifetime cycle is patterned after usb devices. Each clock is represented
> by a standard character device. In addition, the driver may optionally
> implemented custom character device operations.
> 
> The clock devices do not yet do anything useful. This patch merely
> provides some needed infrastructure.
> +/**
> + * create_clock_device() - register a new clock

I'd call this clock_device_create() etc, putting all clock_device functions
in a common namespace with the clock_device_ prefix

> +#define MAX_CLKDEV BITS_PER_LONG
> +static DECLARE_BITMAP(clocks_map, MAX_CLKDEV);
> +static DEFINE_MUTEX(clocks_mux); /* protects 'clocks_map' */

Using "_mux" as a postfix for the name is highly unusual, this normally
means multiplex, not mutual exlusion.

You could probably avoid the need for this mutex altogether if you use
the atomic bit operations (e.g. test_and_set_bit).

> +struct clock_device {
> +	struct file_operations fops;
> +	struct file_operations *driver_fops;
> +	struct clock_device_operations *ops;
> +	struct cdev cdev;
> +	struct kref kref;
> +	struct mutex mux;
> +	void *priv;
> +	int index;
> +	bool zombie;
> +};

You should really not need the file_operations here, neither the
struct nor the pointer. Just define a static file_operations
structure containing clock_device_open and clock_device_release,
and whatever else you might need, then add the driver's operations
to clock_device_operations, and pass the clock_device pointer
directly to them, instead of passing the file/inode pointers.

	Arnd
