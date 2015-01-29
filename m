From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 2/5] IB/uverbs: ex_query_device: check request's
 comp_mask
Date: Thu, 29 Jan 2015 13:24:29 -0700
Message-ID: <20150129202429.GA21916@obsidianresearch.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
 <335da45738872e446f63db338ca766a34608c90a.1422553023.git.ydroneaud@opteya.com>
 <20150129183648.GI11842@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150129183648.GI11842-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 29, 2015 at 11:36:48AM -0700, Jason Gunthorpe wrote:

> Also, the _ex varients were supposed to be supersets of the base call,
> so it is wrong that query_device_ex doesn't return all the same data
> as query_device, layed out so that the original response structure is
> a prefix of the extended response structure.

Never mind this, I see the copy_query_dev_fields call now!

Thanks,
Jason
