From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not
 depend on request's comp_mask
Date: Mon, 02 Mar 2015 15:08:15 +0100
Message-ID: <1425305295.3069.10.camel@opteya.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
	 <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
	 <20150129182800.GH11842@obsidianresearch.com>
	 <1422568741.3133.247.camel@opteya.com>
	 <CAG4TOxN4DpTMMsCM-1oe6-w+5xYR4YHdJeL7p2nQpUy9gYCSjA@mail.gmail.com>
	 <1422638760.3133.260.camel@opteya.com>
	 <CAJ3xEMhDtD7MpJ+1Y3z2yMpTrb9C5SaUa94E8xpVLHN4pHe3fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhDtD7MpJ+1Y3z2yMpTrb9C5SaUa94E8xpVLHN4pHe3fw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Or,

Le samedi 31 janvier 2015 =C3=A0 22:09 +0200, Or Gerlitz a =C3=A9crit :
> On Fri, Jan 30, 2015, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> > [..] I have not the chance
> > of owning HCA with the support for this feature, nor the patches
> > libibverbs / libmlx5 ... (anyway I would not have the time to test)=
=2E [...]
>=20
> Yann, have you ever run Linux over RDMA capable HW (IB, RoCE, iWARP o=
r alike?)

That was a silly question.

So I've took a little time to consider answering it,
perhaps you were gently kidding me.

Anyway, please take the following links as an answer to your question:

"rdma_create_qp() and max_send_wr"
<http://mid.gmane.org/1303404264.2243.19.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>

"ibv_create_qp() and max_inline_data behavior"
<http://mid.gmane.org/d7685e13978f93890b2939c5ac2d5c7f-zgzEX58YAwA@public.gmane.org>

"[PATCH librdmacm 0/3] no IBV_SEND_INLINE thus memory registration
required on QLogic/Intel HCA"
<http://mid.gmane.org/cover.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

"[PATCH 00/22] infiniband: improve userspace input check"
<http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

I hope this would be enough to join the gang^Wclub. Where're the
by-laws ?

Regards.

--=20
Yann Droneaud
OPTEYA
