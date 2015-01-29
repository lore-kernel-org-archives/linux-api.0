From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 2/5] IB/uverbs: ex_query_device: check request's
 comp_mask
Date: Thu, 29 Jan 2015 11:36:48 -0700
Message-ID: <20150129183648.GI11842@obsidianresearch.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
 <335da45738872e446f63db338ca766a34608c90a.1422553023.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <335da45738872e446f63db338ca766a34608c90a.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 29, 2015 at 06:59:59PM +0100, Yann Droneaud wrote:
> This patch ensures the extended QUERY_DEVICE uverbs request's
> comp_mask has only known and supported bits (currently none).

I think I would be happy to see the input comp_mask removed
entirely. I can't see a possible use for input data to a QUERY command
that wouldn't be better served by creating a new command

But forcing the value to 0 seems reasonable as well.

Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Also, the _ex varients were supposed to be supersets of the base call,
so it is wrong that query_device_ex doesn't return all the same data
as query_device, layed out so that the original response structure is
a prefix of the extended response structure.

The other _ex calls in verbs were designed that way so it will be
surprising to the user that this one is different.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
