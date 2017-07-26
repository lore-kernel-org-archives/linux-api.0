From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 04/22] fpga: mgr: add region_id to fpga_image_info
Date: Wed, 26 Jul 2017 13:33:53 -0500
Message-ID: <CANk1AXT_BaeKHMFRiWnTL0owrW0ar+Y1NDDxefwvjUFhNCEO=g@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com> <1498441938-14046-5-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498441938-14046-5-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 25, 2017 at 8:52 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

Hi Hao,

> This patch adds region_id to fpga_image_info data structure, it
> allows driver to pass region id information to fpga-mgr via
> fpga_image_info for fpga reconfiguration function.
>
> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  include/linux/fpga/fpga-mgr.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/fpga/fpga-mgr.h b/include/linux/fpga/fpga-mgr.h
> index 66d0e32..b222a57 100644
> --- a/include/linux/fpga/fpga-mgr.h
> +++ b/include/linux/fpga/fpga-mgr.h
> @@ -95,6 +95,7 @@ struct fpga_image_info {
>         struct sg_table *sgt;
>         const char *buf;
>         size_t count;
> +       int region_id;

Please add a line to document this region_id above where all the other
struct members are documented.

Alan

>  #ifdef CONFIG_OF
>         struct device_node *overlay;
>  #endif
> --
> 1.8.3.1
>
