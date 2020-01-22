From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RESEND Patch v6 2/2] fpga: dfl: fme: add performance reporting
 support
Date: Wed, 22 Jan 2020 15:10:26 +0100
Message-ID: <20200122141026.GA10399@kroah.com>
References: <1579230628-22243-1-git-send-email-hao.wu@intel.com>
 <1579230628-22243-3-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1579230628-22243-3-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Luwei Kang <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xu Yilun <yilun.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 17, 2020 at 11:10:28AM +0800, Wu Hao wrote:
> +static const struct attribute_group fme_perf_fabric_events_group = {
> +	.name = "events",
> +	.attrs = fme_perf_fabric_events_attrs,
> +	.is_visible = fme_perf_fabric_events_visible,
> +};
> +

I don't see any Documentation/ABI/ entries for all of these new files.
Please properly document them so we know how to review this.

thanks,

greg k-h
