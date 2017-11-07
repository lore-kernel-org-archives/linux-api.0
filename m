From: Tobias Klauser <tklauser@distanz.ch>
Subject: Re: [patch v11 4/4] Documentation: jtag: Add ABI documentation
Date: Tue, 7 Nov 2017 11:36:13 +0100
Message-ID: <20171107103613.GJ1370@distanz.ch>
References: <1509724449-26221-1-git-send-email-oleksandrs@mellanox.com>
 <1509724449-26221-5-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1509724449-26221-5-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, openbmc@lists.ozlabs.org, joel@jms.id.au, jiri@resnulli.us, linux-serial@vger.kernel.org, mec@shout.net, vadimp@mellanox.com, system-sw-low-level@mellanox.com, robh+dt@kernel.org, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, davem@davemloft.net, mchehab@kernel.org
List-Id: linux-api@vger.kernel.org

On 2017-11-03 at 16:54:09 +0100, Oleksandr Shamray <oleksandrs@mellanox.com> wrote:
> Added document that describe the ABI for JTAG class drivrer
> 
> Signed-off-by: Oleksandr Shamray <oleksandrs@mellanox.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v10->v11
> v9->v10
> Fixes added by Oleksandr:
> - change jtag-cdev to jtag-dev in documentation
> - update Kernel Version and Date in jtag-dev documentation;
> v8->v9
> v7->v8
> v6->v7
> Comments pointed by Pavel Machek <pavel@ucw.cz>
> - Added jtag-cdev documentation to Documentation/ABI/testing folder
> ---
>  Documentation/ABI/testing/jatg-dev |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/jatg-dev
> 
> diff --git a/Documentation/ABI/testing/jatg-dev b/Documentation/ABI/testing/jatg-dev
> new file mode 100644
> index 0000000..803dbab
> --- /dev/null
> +++ b/Documentation/ABI/testing/jatg-dev

Typo in the file name: s/jatg-dev/jtag-dev/

> @@ -0,0 +1,27 @@
> +What:		/dev/jtag[0-9]+
> +Date:		October 2017
> +KernelVersion:	4.15
> +Contact:	oleksandrs@mellanox.com
> +Description:
> +		The misc device files /dev/jtag* are the interface
> +		between JTAG master interfase and userspace.

Typo: s/interfase/interface/

> +
> +		The ioctl(2)-based ABI is defined and documented in
> +		[include/uapi]<linux/jtag.h>.
> +
> +		The following file operations are supported:
> +
> +		open(2)
> +		The argument flag currently support only one access
> +		mode O_RDWR.
> +
> +		ioctl(2)
> +		Initiate various actions.
> +		See the inline documentation in [include/uapi]<linux/jtag.h>
> +		for descriptions of all ioctls.
> +
> +		close(2)
> +		Stops and free up the I/O contexts that was associated
> +		with the file descriptor.
> +
> +Users:		TBD
> \ No newline at end of file
> -- 
> 1.7.1
> 
