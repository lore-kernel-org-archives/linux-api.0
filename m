From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 03/21] fpga: mgr: add status for fpga-manager
Date: Wed, 13 Dec 2017 12:48:08 +0800
Message-ID: <20171213044808.GA26748@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-4-git-send-email-hao.wu@intel.com>
 <CANk1AXTGdskD9rT5wty1pFeBQ9jK5BhRZFCVbkY3iG9EeEXOvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXTGdskD9rT5wty1pFeBQ9jK5BhRZFCVbkY3iG9EeEXOvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 12, 2017 at 12:18:06PM -0600, Alan Tull wrote:
> On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > This patch adds status to fpga-manager data structure, to allow
> > driver to store full/partial reconfiguration errors and other
> > status information, and adds one status callback to fpga_manager_ops
> > to allow fpga_manager to collect latest status when failures are
> > detected.
> >
> > The following sysfs file is created:
> > * /sys/class/fpga_manager/<fpga>/status
> >   Return status of fpga manager, including reconfiguration errors.
> >
> > Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ----
> > v3: add one line description for status
> >     add status callback function to fpga_manager_ops
> >     update fpga-mgr status if any failure or during initialization
> >     s/INCOMPATIBLE_BS_ERR/INCOMPATIBLE_IMAGE_ERR/
> > ---
> >  Documentation/ABI/testing/sysfs-class-fpga-manager | 10 ++++++++
> >  drivers/fpga/fpga-mgr.c                            | 28 ++++++++++++++++++++++
> >  include/linux/fpga/fpga-mgr.h                      | 17 +++++++++++++
> >  3 files changed, 55 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-class-fpga-manager b/Documentation/ABI/testing/sysfs-class-fpga-manager
> > index 23056c5..01db14d 100644
> > --- a/Documentation/ABI/testing/sysfs-class-fpga-manager
> > +++ b/Documentation/ABI/testing/sysfs-class-fpga-manager
> > @@ -35,3 +35,13 @@ Description: Read fpga manager state as a string.
> >                 * write complete        = Doing post programming steps
> >                 * write complete error  = Error while doing post programming
> >                 * operating             = FPGA is programmed and operating
> > +
> > +What:          /sys/class/fpga_manager/<fpga>/status
> > +Date:          November 2017
> > +KernelVersion: 4.15
> > +Contact:       Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > +Description:   Read fpga manager status as a string.
> > +               If FPGA programming operation fails, it could be due to crc
> > +               error or incompatible bitstream image. The intent of this
> > +               interface is to provide more detailed information for FPGA
> > +               programming errors to userspace.
> 
> Hi Hao,
> 
> Please also add a list of status strings that can be given, such as
> "reconfig operation error"  I understand that this list may grow
> somewhat in the future.

Sure, will add it in the next version.

Thanks
Hao

> 
> Alan
> 
> > diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
> > index 1fd5494..8b583ba 100644
> > --- a/drivers/fpga/fpga-mgr.c
> > +++ b/drivers/fpga/fpga-mgr.c
> > @@ -88,6 +88,7 @@ static int fpga_mgr_write_init_buf(struct fpga_manager *mgr,
> >         if (ret) {
> >                 dev_err(&mgr->dev, "Error preparing FPGA for writing\n");
> >                 mgr->state = FPGA_MGR_STATE_WRITE_INIT_ERR;
> > +               fpga_mgr_update_status(mgr);
> >                 return ret;
> >         }
> >
> > @@ -148,6 +149,7 @@ static int fpga_mgr_write_complete(struct fpga_manager *mgr,
> >         if (ret) {
> >                 dev_err(&mgr->dev, "Error after writing image data to FPGA\n");
> >                 mgr->state = FPGA_MGR_STATE_WRITE_COMPLETE_ERR;
> > +               fpga_mgr_update_status(mgr);
> >                 return ret;
> >         }
> >         mgr->state = FPGA_MGR_STATE_OPERATING;
> > @@ -225,6 +227,7 @@ static int fpga_mgr_buf_load_mapped(struct fpga_manager *mgr,
> >         if (ret) {
> >                 dev_err(&mgr->dev, "Error while writing image data to FPGA\n");
> >                 mgr->state = FPGA_MGR_STATE_WRITE_ERR;
> > +               fpga_mgr_update_status(mgr);
> >                 return ret;
> >         }
> >
> > @@ -397,12 +400,36 @@ static ssize_t state_show(struct device *dev,
> >         return sprintf(buf, "%s\n", state_str[mgr->state]);
> >  }
> >
> > +static ssize_t status_show(struct device *dev,
> > +                          struct device_attribute *attr, char *buf)
> > +{
> > +       struct fpga_manager *mgr = to_fpga_manager(dev);
> > +       int len = 0;
> > +
> > +       if (mgr->status & FPGA_MGR_STATUS_OPERATION_ERR)
> > +               len += sprintf(buf + len, "reconfig operation error\n");
> > +       if (mgr->status & FPGA_MGR_STATUS_CRC_ERR)
> > +               len += sprintf(buf + len, "reconfig CRC error\n");
> > +       if (mgr->status & FPGA_MGR_STATUS_INCOMPATIBLE_IMAGE_ERR)
> > +               len += sprintf(buf + len, "reconfig incompatible image\n");
> > +       if (mgr->status & FPGA_MGR_STATUS_IP_PROTOCOL_ERR)
> > +               len += sprintf(buf + len, "reconfig IP protocol error\n");
> > +       if (mgr->status & FPGA_MGR_STATUS_FIFO_OVERFLOW_ERR)
> > +               len += sprintf(buf + len, "reconfig fifo overflow error\n");
> > +       if (mgr->status & FPGA_MGR_STATUS_SECURE_LOAD_ERR)
> > +               len += sprintf(buf + len, "reconfig secure load error\n");
> > +
> > +       return len;
> > +}
