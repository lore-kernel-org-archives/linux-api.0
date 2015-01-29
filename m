From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not
 depend on request's comp_mask
Date: Thu, 29 Jan 2015 11:28:00 -0700
Message-ID: <20150129182800.GH11842@obsidianresearch.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
 <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 29, 2015 at 06:59:58PM +0100, Yann Droneaud wrote:
> As specified in "Extending Verbs API" presentation [1] by Tzahi Oved
> during OFA International Developer Workshop 2013, the request's
> comp_mask should describe the request data: it's describe the
> availability of extended fields in the request.
> Conversely, the response's comp_mask should describe the presence
> of extended fields in the response.

Roland: I agree with Yann, these patches need to go in, or the ODP
patches reverted.

>  #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> -	if (cmd.comp_mask & IB_USER_VERBS_EX_QUERY_DEVICE_ODP) {

Absolutely, a query output should never depend on the input comp_mask.

> -		resp.odp_caps.general_caps = attr.odp_caps.general_caps;
> -		resp.odp_caps.per_transport_caps.rc_odp_caps =
> -			attr.odp_caps.per_transport_caps.rc_odp_caps;
> -		resp.odp_caps.per_transport_caps.uc_odp_caps =
> -			attr.odp_caps.per_transport_caps.uc_odp_caps;
> -		resp.odp_caps.per_transport_caps.ud_odp_caps =
> -			attr.odp_caps.per_transport_caps.ud_odp_caps;
> -		resp.comp_mask |= IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
> -	}
> +	resp.odp_caps.general_caps = attr.odp_caps.general_caps;
> +	resp.odp_caps.per_transport_caps.rc_odp_caps =
> +		attr.odp_caps.per_transport_caps.rc_odp_caps;
> +	resp.odp_caps.per_transport_caps.uc_odp_caps =
> +		attr.odp_caps.per_transport_caps.uc_odp_caps;
> +	resp.odp_caps.per_transport_caps.ud_odp_caps =
> +		attr.odp_caps.per_transport_caps.ud_odp_caps;
>  #endif
> +	resp.comp_mask |= IB_USER_VERBS_EX_QUERY_DEVICE_ODP;

Not sure about this - if 0 is a valid null answer for all the _caps
then it is fine, and the comp_mask bit should just be removed as the
size alone should be enough.

This looks wrong however:

>  	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
>  	if (err)
>           return err;
>        return 0;

Why isn't this returning the filled structure size to userspace?  This
would seem to be very urgently wrong to me? Am I missing something?

Patch 3 probably should gain:

- return 0;
+ return resp_len;

This patch looks like an improvement to me:

Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason
