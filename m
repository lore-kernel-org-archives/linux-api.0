From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 2/5] IB/uverbs: ex_query_device: check request's
 comp_mask
Date: Thu, 29 Jan 2015 20:22:58 +0100
Message-ID: <1422559378.3133.178.camel@opteya.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
	 <335da45738872e446f63db338ca766a34608c90a.1422553023.git.ydroneaud@opteya.com>
	 <20150129183648.GI11842@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150129183648.GI11842-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

Le jeudi 29 janvier 2015 =C3=A0 11:36 -0700, Jason Gunthorpe a =C3=A9cr=
it :
> On Thu, Jan 29, 2015 at 06:59:59PM +0100, Yann Droneaud wrote:
> > This patch ensures the extended QUERY_DEVICE uverbs request's
> > comp_mask has only known and supported bits (currently none).
>=20
> I think I would be happy to see the input comp_mask removed
> entirely. I can't see a possible use for input data to a QUERY comman=
d
> that wouldn't be better served by creating a new command
>=20
> But forcing the value to 0 seems reasonable as well.
>=20

I cannot forsee the future, but having at least one unused bit
available allow for any kind of yet unknown extension: having this
bit/these bits checked now, permit fixing mistake later.

So let it be.

> Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>=20

Thanks.

> Also, the _ex varients were supposed to be supersets of the base call=
,
> so it is wrong that query_device_ex doesn't return all the same data
> as query_device, layed out so that the original response structure is
> a prefix of the extended response structure.
>=20
> The other _ex calls in verbs were designed that way so it will be
> surprising to the user that this one is different.
>=20

It seems to me it has the layout you're expecting:

    224 struct ib_uverbs_ex_query_device_resp {
    225         struct ib_uverbs_query_device_resp base;
    226         __u32 comp_mask;
    227         __u32 reserved;
    228         struct ib_uverbs_odp_caps odp_caps;
    229 };

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
