From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not depend
 on request's comp_mask
Date: Sat, 31 Jan 2015 22:09:21 +0200
Message-ID: <CAJ3xEMhDtD7MpJ+1Y3z2yMpTrb9C5SaUa94E8xpVLHN4pHe3fw@mail.gmail.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
	<24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
	<20150129182800.GH11842@obsidianresearch.com>
	<1422568741.3133.247.camel@opteya.com>
	<CAG4TOxN4DpTMMsCM-1oe6-w+5xYR4YHdJeL7p2nQpUy9gYCSjA@mail.gmail.com>
	<1422638760.3133.260.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422638760.3133.260.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 30, 2015, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> [..] I have not the chance
> of owning HCA with the support for this feature, nor the patches
> libibverbs / libmlx5 ... (anyway I would not have the time to test). [...]

Yann, have you ever run Linux over RDMA capable HW (IB, RoCE, iWARP or alike?)
