From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v3 03/21] fpga: mgr: add status for fpga-manager
Date: Tue, 12 Dec 2017 12:18:06 -0600
Message-ID: <CANk1AXTGdskD9rT5wty1pFeBQ9jK5BhRZFCVbkY3iG9EeEXOvQ@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com> <1511764948-20972-4-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511764948-20972-4-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu@intel.com> wrote:
> This patch adds status to fpga-manager data structure, to allow
> driver to store full/partial reconfiguration errors and other
> status information, and adds one status callback to fpga_manager_ops
> to allow fpga_manager to collect latest status when failures are
> detected.
>
> The following sysfs file is created:
> * /sys/class/fpga_manager/<fpga>/status
>   Return status of fpga manager, including reconfiguration errors.
>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> ----
> v3: add one line description for status
>     add status callback function to fpga_manager_ops
>     update fpga-mgr status if any failure or during initialization
>     s/INCOMPATIBLE_BS_ERR/INCOMPATIBLE_IMAGE_ERR/
> ---
>  Documentation/ABI/testing/sysfs-class-fpga-manager | 10 ++++++++
>  drivers/fpga/fpga-mgr.c                            | 28 ++++++++++++++++++++++
>  include/linux/fpga/fpga-mgr.h                      | 17 +++++++++++++
>  3 files changed, 55 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-class-fpga-manager b/Documentation/ABI/testing/sysfs-class-fpga-manager
> index 23056c5..01db14d 100644
> --- a/Documentation/ABI/testing/sysfs-class-fpga-manager
> +++ b/Documentation/ABI/testing/sysfs-class-fpga-manager
> @@ -35,3 +35,13 @@ Description: Read fpga manager state as a string.
>                 * write complete        = Doing post programming steps
>                 * write complete error  = Error while doing post programming
>                 * operating             = FPGA is programmed and operating
> +
> +What:          /sys/class/fpga_manager/<fpga>/status
> +Date:          November 2017
> +KernelVersion: 4.15
> +Contact:       Wu Hao <hao.wu@intel.com>
> +Description:   Read fpga manager status as a string.
> +               If FPGA programming operation fails, it could be due to crc
> +               error or incompatible bitstream image. The intent of this
> +               interface is to provide more detailed information for FPGA
> +               programming errors to userspace.

Hi Hao,

Please also add a list of status strings that can be given, such as
"reconfig operation error"  I understand that this list may grow
somewhat in the future.

Alan

> diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
> index 1fd5494..8b583ba 100644
> --- a/drivers/fpga/fpga-mgr.c
> +++ b/drivers/fpga/fpga-mgr.c
> @@ -88,6 +88,7 @@ static int fpga_mgr_write_init_buf(struct fpga_manager *mgr,
>         if (ret) {
>                 dev_err(&mgr->dev, "Error preparing FPGA for writing\n");
>                 mgr->state = FPGA_MGR_STATE_WRITE_INIT_ERR;
> +               fpga_mgr_update_status(mgr);
>                 return ret;
>         }
>
> @@ -148,6 +149,7 @@ static int fpga_mgr_write_complete(struct fpga_manager *mgr,
>         if (ret) {
>                 dev_err(&mgr->dev, "Error after writing image data to FPGA\n");
>                 mgr->state = FPGA_MGR_STATE_WRITE_COMPLETE_ERR;
> +               fpga_mgr_update_status(mgr);
>                 return ret;
>         }
>         mgr->state = FPGA_MGR_STATE_OPERATING;
> @@ -225,6 +227,7 @@ static int fpga_mgr_buf_load_mapped(struct fpga_manager *mgr,
>         if (ret) {
>                 dev_err(&mgr->dev, "Error while writing image data to FPGA\n");
>                 mgr->state = FPGA_MGR_STATE_WRITE_ERR;
> +               fpga_mgr_update_status(mgr);
>                 return ret;
>         }
>
> @@ -397,12 +400,36 @@ static ssize_t state_show(struct device *dev,
>         return sprintf(buf, "%s\n", state_str[mgr->state]);
>  }
>
> +static ssize_t status_show(struct device *dev,
> +                          struct device_attribute *attr, char *buf)
> +{
> +       struct fpga_manager *mgr = to_fpga_manager(dev);
> +       int len = 0;
> +
> +       if (mgr->status & FPGA_MGR_STATUS_OPERATION_ERR)
> +               len += sprintf(buf + len, "reconfig operation error\n");
> +       if (mgr->status & FPGA_MGR_STATUS_CRC_ERR)
> +               len += sprintf(buf + len, "reconfig CRC error\n");
> +       if (mgr->status & FPGA_MGR_STATUS_INCOMPATIBLE_IMAGE_ERR)
> +               len += sprintf(buf + len, "reconfig incompatible image\n");
> +       if (mgr->status & FPGA_MGR_STATUS_IP_PROTOCOL_ERR)
> +               len += sprintf(buf + len, "reconfig IP protocol error\n");
> +       if (mgr->status & FPGA_MGR_STATUS_FIFO_OVERFLOW_ERR)
> +               len += sprintf(buf + len, "reconfig fifo overflow error\n");
> +       if (mgr->status & FPGA_MGR_STATUS_SECURE_LOAD_ERR)
> +               len += sprintf(buf + len, "reconfig secure load error\n");
> +
> +       return len;
> +}
