From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not depend
 on request's comp_mask
Date: Sun, 1 Feb 2015 13:25:15 +0200
Message-ID: <54CE0D1B.400@mellanox.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
	 <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
	 <20150129182800.GH11842@obsidianresearch.com>
	 <1422568741.3133.247.camel@opteya.com>
	 <CAG4TOxN4DpTMMsCM-1oe6-w+5xYR4YHdJeL7p2nQpUy9gYCSjA@mail.gmail.com>
 <1422638760.3133.260.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422638760.3133.260.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 30/01/2015 19:26, Yann Droneaud wrote:
> Hi,
>=20
> Le jeudi 29 janvier 2015 =C3=A0 15:17 -0800, Roland Dreier a =C3=A9cr=
it :
>> On Thu, Jan 29, 2015 at 1:59 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org=
> wrote:
>>>> Roland: I agree with Yann, these patches need to go in, or the ODP
>>>> patches reverted.
>>
>>> Reverting all On Demand Paging patches seems overkill:
>>> if something as to be reverted it should be commit 5a77abf9a97a
>>> ("IB/core: Add support for extended query device caps") and the par=
t of
>>> commit 860f10a799c8 ("IB/core: Add flags for on demand paging suppo=
rt")
>>> which modify ib_uverbs_ex_query_device().
>>
>> Thank you and Jason for taking on this interface.
>>
>> At this point I feel like I do about the IPoIB changes -- we should
>> revert the broken stuff and get it right for 3.20.
>>
>> If we revert the two things you describe above, is everything else O=
K
>> to leave in 3.19 with respect to ABI?
>>
>=20
> I've tried to review every changes since v3.18 on drivers/infiniband
> include/rdma and include/uapi/rdma with respect to ABI issues.
>=20
> I've noticed no other issue, but I have to admit I've not well review=
ed
> the drivers (hw/) internal changes.
>=20
> If the IB_USER_VERBS_EX_CMD_QUERY_DEVICE and ib_uverbs_ex_query_devic=
e
> changes are going to be reverted for v3.19, the on-demand-paging
> feature will be available (IB_DEVICE_ON_DEMAND_PAGING will be set=20
> device_cap_flags in response to non extended QUERY_DEVICE for mlx5 HC=
A
> and IB_ACCESS_ON_DEMAND access flag will be effective for REG_MR=20
> uverbs), but its parameters won't be.=20

=46or user-space to make use of on demand paging, it should verify the
specific transport and operation is supported. If they don't, they will
encounter errors when a page fault occurs.

> I don't know if it's a no-go for=20
> the usage of on-demand paging by userspace: I have not the chance
> of owning HCA with the support for this feature, nor the patches
> libibverbs / libmlx5 ... (anyway I would not have the time to test).
> I've hoped people from Mellanox would have commented on the revert=20
> option too.

I would prefer it if Yann's patches are accepted. I understand it is
very late, but they are quite short, and I think they provide the right
semantic for this new verb.

As a second option, in case you prefer to revert the extended query
device patch, I will send a patch shortly to do that.

Regards,
Haggai
