From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v6 03/29] fpga: mgr: add status for fpga-manager
Date: Tue, 12 Jun 2018 10:57:16 -0500
Message-ID: <CANk1AXQqix_eK1XRtSVGWNe-9wQm+OGOFr61MhqOY1_fzKNXRA@mail.gmail.com>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com> <1528798243-2029-4-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528798243-2029-4-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 12, 2018 at 5:10 AM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

>  Documentation/ABI/testing/sysfs-class-fpga-manager | 24 +++++++++++++++++++
>  drivers/fpga/fpga-mgr.c                            | 28 ++++++++++++++++++++++
>  include/linux/fpga/fpga-mgr.h                      |  9 +++++++
>  3 files changed, 61 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-class-fpga-manager b/Documentation/ABI/testing/sysfs-class-fpga-manager
> index 23056c5..2aadf59 100644
> --- a/Documentation/ABI/testing/sysfs-class-fpga-manager
> +++ b/Documentation/ABI/testing/sysfs-class-fpga-manager
> @@ -35,3 +35,27 @@ Description: Read fpga manager state as a string.
>                 * write complete        = Doing post programming steps
>                 * write complete error  = Error while doing post programming
>                 * operating             = FPGA is programmed and operating
> +
> +What:          /sys/class/fpga_manager/<fpga>/status
> +Date:          June 2018
> +KernelVersion: 4.18

4.19

Greg is queuing new functionality for 4.19 after 4.18-rc1 is done.

> +Contact:       Wu Hao <hao.wu@intel.com>
> +Description:   Read fpga manager status as a string.
