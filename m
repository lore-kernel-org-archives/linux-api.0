From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 03/21] fpga: mgr: add status for fpga-manager
Date: Mon, 4 Dec 2017 14:55:42 -0600
Message-ID: <CANk1AXSPQb3=bwaRQsysuiM5NiS6KpKRazP-WNLuus-C=UP6pg@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com> <1511764948-20972-4-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511764948-20972-4-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

Hi Hao,

mgr->status isn't used anywhere except in status_show.  So we don't
need to add status to the fpga_manager struct.  Also don't need the
inline function to update it.  Just read the status in status_show, if
that ops exists.  If mops->status is NULL, return an error, as below.
This will simplify things and make sure that status_show gets status
that is not stale at all.

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
> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
> +Contact:       Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> +Description:   Read fpga manager status as a string.
> +               If FPGA programming operation fails, it could be due to crc
> +               error or incompatible bitstream image. The intent of this
> +               interface is to provide more detailed information for FPGA
> +               programming errors to userspace.
> diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
> index 1fd5494..8b583ba 100644
> --- a/drivers/fpga/fpga-mgr.c
> +++ b/drivers/fpga/fpga-mgr.c
> @@ -88,6 +88,7 @@ static int fpga_mgr_write_init_buf(struct fpga_manager *mgr,
>         if (ret) {
>                 dev_err(&mgr->dev, "Error preparing FPGA for writing\n");
>                 mgr->state = FPGA_MGR_STATE_WRITE_INIT_ERR;
> +               fpga_mgr_update_status(mgr);

Remove these fpga_mgr_update_status

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

u64 status;

if (!mgr->mops->status)
        return -ENOENT;

status = mgr->mops->status(mgr);

> +
> +       if (mgr->status & FPGA_MGR_STATUS_OPERATION_ERR)

if (status & ...)

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
> +
>  static DEVICE_ATTR_RO(name);
>  static DEVICE_ATTR_RO(state);
> +static DEVICE_ATTR_RO(status);
>
>  static struct attribute *fpga_mgr_attrs[] = {
>         &dev_attr_name.attr,
>         &dev_attr_state.attr,
> +       &dev_attr_status.attr,
>         NULL,
>  };
>  ATTRIBUTE_GROUPS(fpga_mgr);
> @@ -561,6 +588,7 @@ int fpga_mgr_register(struct fpga_manager *mgr)
>          * by bootloader or EEPROM.
>          */
>         mgr->state = mgr->mops->state(mgr);
> +       fpga_mgr_update_status(mgr);
>
>         device_initialize(&mgr->dev);
>         mgr->dev.class = fpga_mgr_class;
> diff --git a/include/linux/fpga/fpga-mgr.h b/include/linux/fpga/fpga-mgr.h
> index 6e98b66..d4faf3d 100644
> --- a/include/linux/fpga/fpga-mgr.h
> +++ b/include/linux/fpga/fpga-mgr.h
> @@ -112,6 +112,7 @@ struct fpga_image_info {
>   * struct fpga_manager_ops - ops for low level fpga manager drivers
>   * @initial_header_size: Maximum number of bytes that should be passed into write_init
>   * @state: returns an enum value of the FPGA's state
> + * @status: returns status of the FPGA, including reconfiguration error code
>   * @write_init: prepare the FPGA to receive confuration data
>   * @write: write count bytes of configuration data to the FPGA
>   * @write_sg: write the scatter list of configuration data to the FPGA
> @@ -126,6 +127,7 @@ struct fpga_image_info {
>  struct fpga_manager_ops {
>         size_t initial_header_size;
>         enum fpga_mgr_states (*state)(struct fpga_manager *mgr);
> +       u64 (*status)(struct fpga_manager *mgr);
>         int (*write_init)(struct fpga_manager *mgr,
>                           struct fpga_image_info *info,
>                           const char *buf, size_t count);
> @@ -137,6 +139,14 @@ struct fpga_manager_ops {
>         const struct attribute_group **groups;
>  };
>
> +/* FPGA manager status: Partial/Full Reconfiguration errors */
> +#define FPGA_MGR_STATUS_OPERATION_ERR          BIT(0)
> +#define FPGA_MGR_STATUS_CRC_ERR                        BIT(1)
> +#define FPGA_MGR_STATUS_INCOMPATIBLE_IMAGE_ERR BIT(2)
> +#define FPGA_MGR_STATUS_IP_PROTOCOL_ERR                BIT(3)
> +#define FPGA_MGR_STATUS_FIFO_OVERFLOW_ERR      BIT(4)
> +#define FPGA_MGR_STATUS_SECURE_LOAD_ERR                BIT(5)
> +
>  /**
>   * struct fpga_manager - fpga manager structure
>   * @name: name of low level fpga manager
> @@ -144,6 +154,7 @@ struct fpga_manager_ops {
>   * @dev: fpga manager device
>   * @ref_mutex: only allows one reference to fpga manager
>   * @state: state of fpga manager
> + * @status: status of fpga manager, including reconfiguration error.
>   * @mops: pointer to struct of fpga manager ops
>   * @priv: low level driver private date
>   */
> @@ -153,6 +164,7 @@ struct fpga_manager {
>         struct device dev;
>         struct mutex ref_mutex;
>         enum fpga_mgr_states state;
> +       u64 status;

Remove.

>         const struct fpga_manager_ops *mops;
>         void *priv;
>  };
> @@ -177,4 +189,9 @@ struct fpga_manager {
>  int fpga_mgr_register(struct fpga_manager *mgr);
>  void fpga_mgr_unregister(struct fpga_manager *mgr);
>
> +static inline void fpga_mgr_update_status(struct fpga_manager *mgr)
> +{
> +       if (mgr->mops->status)
> +               mgr->status = mgr->mops->status(mgr);
> +}

Remove fpga_mgr_update_status, not needed.

Thanks,
Alan
