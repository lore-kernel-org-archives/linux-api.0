From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 2/5] IB/uverbs: ex_query_device: check request's
 comp_mask
Date: Sun, 01 Feb 2015 12:55:01 +0100
Message-ID: <1422791701.3030.30.camel@opteya.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
	 <335da45738872e446f63db338ca766a34608c90a.1422553023.git.ydroneaud@opteya.com>
	 <54CDDFE4.7030003@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54CDDFE4.7030003-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

Le dimanche 01 f=C3=A9vrier 2015 =C3=A0 10:12 +0200, Haggai Eran a =C3=A9=
crit :
> On 29/01/2015 19:59, Yann Droneaud wrote:
> > This patch ensures the extended QUERY_DEVICE uverbs request's
> > comp_mask has only known and supported bits (currently none).
> >=20
> > If userspace set unknown features bits, -EINVAL will be returned,
> > ensuring current programs are not allowed to set random feature
> > bits: such bits could enable new extended features in future kernel
> > versions and those features can trigger a behavior not unsupported
> > by the older programs or make the newer kernels return an error
> > for a request which was valid on older kernels.
> >=20
> > Additionally, returning an error for unsupported feature would
> > allow userspace to probe/discover which extended features are
> > currently supported by a kernel.
>=20
> As I wrote before, I hope in the future we don't force userspace to
> probe features this way, because it may be unnecessarily complex.
>=20

I believe that most use cases won't need probing as applications are
often built according to the current kernel features in mind.

If applications need to use new features, it seems to be a small price
to pay to be prepared to get -EINVAL.

In another word: backward compatibility from application point of view:
a newer application wanting to run on older kernel must be prepared to.

> I agree though that we should have a way to extend this verb in the f=
uture.
>=20
> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20

Thanks.

> >=20
> > Link: http://mid.gmane.org/cover.1422553023.git.ydroneaud-RlY5vtjFyJ1hl2p70BpVqQ@public.gmane.org=
m
> > Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/core/uverbs_cmd.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infinib=
and/core/uverbs_cmd.c
> > index 6ef06a9b4362..fbcc54b86795 100644
> > --- a/drivers/infiniband/core/uverbs_cmd.c
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -3312,6 +3312,9 @@ int ib_uverbs_ex_query_device(struct ib_uverb=
s_file *file,
> >  	if (err)
> >  		return err;
> > =20
> > +	if (cmd.comp_mask)
> > +		return -EINVAL;
> > +
> >  	if (cmd.reserved)
> >  		return -EINVAL;
> > =20
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
