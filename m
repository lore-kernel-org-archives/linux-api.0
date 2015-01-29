From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 3/5] IB/uverbs: ex_query_device: answer must depend on
 response buffer's size
Date: Thu, 29 Jan 2015 11:38:39 -0700
Message-ID: <20150129183839.GJ11842@obsidianresearch.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
 <a7b2b5adb3b207ec2a4330067a03ce7e4c2225aa.1422553023.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a7b2b5adb3b207ec2a4330067a03ce7e4c2225aa.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 29, 2015 at 07:00:00PM +0100, Yann Droneaud wrote:
> As specified in "Extending Verbs API" presentation [1] by Tzahi Oved
> during OFA International Developer Workshop 2013, the request's
> comp_mask should describe the request data: it's describe the
> availability of extended fields in the request.
> Conversely, the response's comp_mask should describe the presence
> of extended fields in the response.

This makes sense to me as well.

> -	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
> +end:
> +	err = ib_copy_to_udata(ucore, &resp, resp_len);
>  	if (err)
>  		return err;
>  

I think resp_len should be returned, not 0?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
