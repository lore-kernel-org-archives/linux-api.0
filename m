From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not
 depend on request's comp_mask
Date: Fri, 30 Jan 2015 18:26:00 +0100
Message-ID: <1422638760.3133.260.camel@opteya.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
	 <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
	 <20150129182800.GH11842@obsidianresearch.com>
	 <1422568741.3133.247.camel@opteya.com>
	 <CAG4TOxN4DpTMMsCM-1oe6-w+5xYR4YHdJeL7p2nQpUy9gYCSjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxN4DpTMMsCM-1oe6-w+5xYR4YHdJeL7p2nQpUy9gYCSjA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

Le jeudi 29 janvier 2015 =C3=A0 15:17 -0800, Roland Dreier a =C3=A9crit=
 :
> On Thu, Jan 29, 2015 at 1:59 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>=
 wrote:
> >> Roland: I agree with Yann, these patches need to go in, or the ODP
> >> patches reverted.
>=20
> > Reverting all On Demand Paging patches seems overkill:
> > if something as to be reverted it should be commit 5a77abf9a97a
> > ("IB/core: Add support for extended query device caps") and the par=
t of
> > commit 860f10a799c8 ("IB/core: Add flags for on demand paging suppo=
rt")
> > which modify ib_uverbs_ex_query_device().
>=20
> Thank you and Jason for taking on this interface.
>=20
> At this point I feel like I do about the IPoIB changes -- we should
> revert the broken stuff and get it right for 3.20.
>=20
> If we revert the two things you describe above, is everything else OK
> to leave in 3.19 with respect to ABI?
>=20

I've tried to review every changes since v3.18 on drivers/infiniband
include/rdma and include/uapi/rdma with respect to ABI issues.

I've noticed no other issue, but I have to admit I've not well reviewed
the drivers (hw/) internal changes.

If the IB_USER_VERBS_EX_CMD_QUERY_DEVICE and ib_uverbs_ex_query_device
changes are going to be reverted for v3.19, the on-demand-paging
feature will be available (IB_DEVICE_ON_DEMAND_PAGING will be set=20
device_cap_flags in response to non extended QUERY_DEVICE for mlx5 HCA
and IB_ACCESS_ON_DEMAND access flag will be effective for REG_MR=20
uverbs), but its parameters won't be. I don't know if it's a no-go for=20
the usage of on-demand paging by userspace: I have not the chance
of owning HCA with the support for this feature, nor the patches
libibverbs / libmlx5 ... (anyway I would not have the time to test).
I've hoped people from Mellanox would have commented on the revert=20
option too.

Regards.

--=20
Yann Droneaud
OPTEYA
