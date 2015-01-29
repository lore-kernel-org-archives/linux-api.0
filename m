From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not depend
 on request's comp_mask
Date: Thu, 29 Jan 2015 15:17:16 -0800
Message-ID: <CAG4TOxN4DpTMMsCM-1oe6-w+5xYR4YHdJeL7p2nQpUy9gYCSjA@mail.gmail.com>
References: <cover.1422553023.git.ydroneaud@opteya.com> <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
 <20150129182800.GH11842@obsidianresearch.com> <1422568741.3133.247.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422568741.3133.247.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 29, 2015 at 1:59 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
>> Roland: I agree with Yann, these patches need to go in, or the ODP
>> patches reverted.

> Reverting all On Demand Paging patches seems overkill:
> if something as to be reverted it should be commit 5a77abf9a97a
> ("IB/core: Add support for extended query device caps") and the part of
> commit 860f10a799c8 ("IB/core: Add flags for on demand paging support")
> which modify ib_uverbs_ex_query_device().

Thank you and Jason for taking on this interface.

At this point I feel like I do about the IPoIB changes -- we should
revert the broken stuff and get it right for 3.20.

If we revert the two things you describe above, is everything else OK
to leave in 3.19 with respect to ABI?

Thanks,
  Roland
