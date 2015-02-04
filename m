From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Temporarily disable ex_query_device uverb
Date: Wed, 04 Feb 2015 17:31:43 +0100
Message-ID: <1423067503.3030.83.camel@opteya.com>
References: <1422797730-14571-1-git-send-email-haggaie@mellanox.com>
	 <1422882626.3030.56.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422882626.3030.56.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

Le lundi 02 f=C3=A9vrier 2015 =C3=A0 14:10 +0100, Yann Droneaud a =C3=A9=
crit :
> Le dimanche 01 f=C3=A9vrier 2015 =C3=A0 15:35 +0200, Haggai Eran a =C3=
=A9crit :
> > Commit 5a77abf9a97a ("IB/core: Add support for extended query devic=
e caps")
> > added a new extended verb to query the capabilities of RDMA devices=
, but the
> > semantics of this verb are still under debate [1].
> >=20
> > Block access to this verb from user-space until the new semantics a=
re in
> > place.
> >=20
> > Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> > Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> > [1] [PATCH v1 0/5] IB/core: extended query device caps cleanup for =
v3.19
> >     http://www.spinics.net/lists/linux-rdma/msg22904.html
> >=20
> > Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

> >  drivers/infiniband/core/uverbs_main.c | 1 -
> >  1 file changed, 1 deletion(-)
> >=20
> > diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infini=
band/core/uverbs_main.c
> > index e6c23b9eab33..5db1a8cc388d 100644
> > --- a/drivers/infiniband/core/uverbs_main.c
> > +++ b/drivers/infiniband/core/uverbs_main.c
> > @@ -123,7 +123,6 @@ static int (*uverbs_ex_cmd_table[])(struct ib_u=
verbs_file *file,
> >  				    struct ib_udata *uhw) =3D {
> >  	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	=3D ib_uverbs_ex_create_flow,
> >  	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	=3D ib_uverbs_ex_destroy_flow=
,
> > -	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	=3D ib_uverbs_ex_query_device
> >  };
> > =20
> >  static void ib_uverbs_add_one(struct ib_device *device);
>=20
> That's the smallest (and smartest) patch to be applied instead of
> reverting.
>=20

Unfortunately, I've missed the issue I was complaining about in the
first place [1]. And I feel a bit guilty having missed the issue.

The present patch is fine as it fully disable the new extended=20
QUERY_DEVICE uverb, but it doesn't disable the broken logic added in
ib_copy_to_udata() by commit 5a77abf9a97a ('IB/core: Add support for
extended query device caps'):

  diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
  index 470a011d6fa4..97a999f9e4d8 100644
  --- a/include/rdma/ib_verbs.h
  +++ b/include/rdma/ib_verbs.h
  @@ -1662,7 +1662,10 @@ static inline int ib_copy_from_udata(void *des=
t, struct ib_udata *udata, size_t
  =20
   static inline int ib_copy_to_udata(struct ib_udata *udata, void *src=
, size_t len)
   {
  -	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
  +	size_t copy_sz;
  +
  +	copy_sz =3D min_t(size_t, len, udata->outlen);
  +	return copy_to_user(udata->outbuf, src, copy_sz) ? -EFAULT : 0;
   }

That part of commit 5a77abf9a97a should be reverted as I'm not sure
it doesn't introduce regressions, especially difficult to notice ones.

Regards.

[1] Re: [PATCH v3 06/17] IB/core: Add support for extended query device=
 caps
    http://mid.gmane.org/1418733236.2779.26.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Regards.

--=20
Yann Droneaud
OPTEYA
