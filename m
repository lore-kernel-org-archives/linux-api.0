From: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 02/21] fpga: mgr: add region_id to fpga_image_info
Date: Tue, 28 Nov 2017 22:11:07 -0800
Message-ID: <20171129061107.w62q5tk5dplq2zmr@us-aus-ras-130-164-29-6.amer.corp.natinst.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-3-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511764948-20972-3-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Hao,

On Mon, Nov 27, 2017 at 02:42:09PM +0800, Wu Hao wrote:
> This patch adds region_id to fpga_image_info data structure, it
> allows driver to pass region id information to fpga-mgr via
> fpga_image_info for fpga reconfiguration function.
> 
> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ----
> v3: add one line comment for region_id
> ---
>  include/linux/fpga/fpga-mgr.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/fpga/fpga-mgr.h b/include/linux/fpga/fpga-mgr.h
> index 1ad4822..6e98b66 100644
> --- a/include/linux/fpga/fpga-mgr.h
> +++ b/include/linux/fpga/fpga-mgr.h
> @@ -88,6 +88,7 @@ enum fpga_mgr_states {
>   * @sgt: scatter/gather table containing FPGA image
>   * @buf: contiguous buffer containing FPGA image
>   * @count: size of buf
> + * @region_id: id of target region
>   * @dev: device that owns this
>   * @overlay: Device Tree overlay
>   */
> @@ -100,6 +101,7 @@ struct fpga_image_info {
>  	struct sg_table *sgt;
>  	const char *buf;
>  	size_t count;
> +	int region_id;
>  	struct device *dev;
>  #ifdef CONFIG_OF
>  	struct device_node *overlay;
> -- 
> 1.8.3.1
> 

Moritz
