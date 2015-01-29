From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not
 depend on request's comp_mask
Date: Thu, 29 Jan 2015 19:43:29 +0100
Message-ID: <1422557009.3133.172.camel@opteya.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
	 <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
	 <20150129182800.GH11842@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150129182800.GH11842-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

Le jeudi 29 janvier 2015 =C3=A0 11:28 -0700, Jason Gunthorpe a =C3=A9cr=
it :
> On Thu, Jan 29, 2015 at 06:59:58PM +0100, Yann Droneaud wrote:
> > As specified in "Extending Verbs API" presentation [1] by Tzahi Ove=
d
> > during OFA International Developer Workshop 2013, the request's
> > comp_mask should describe the request data: it's describe the
> > availability of extended fields in the request.
> > Conversely, the response's comp_mask should describe the presence
> > of extended fields in the response.
>=20
> Roland: I agree with Yann, these patches need to go in, or the ODP
> patches reverted.
>=20
> >  #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> > -	if (cmd.comp_mask & IB_USER_VERBS_EX_QUERY_DEVICE_ODP) {
>=20
> Absolutely, a query output should never depend on the input comp_mask=
=2E
>=20

We should keep this in mind then.

> > -		resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
> > -		resp.odp_caps.per_transport_caps.rc_odp_caps =3D
> > -			attr.odp_caps.per_transport_caps.rc_odp_caps;
> > -		resp.odp_caps.per_transport_caps.uc_odp_caps =3D
> > -			attr.odp_caps.per_transport_caps.uc_odp_caps;
> > -		resp.odp_caps.per_transport_caps.ud_odp_caps =3D
> > -			attr.odp_caps.per_transport_caps.ud_odp_caps;
> > -		resp.comp_mask |=3D IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
> > -	}
> > +	resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
> > +	resp.odp_caps.per_transport_caps.rc_odp_caps =3D
> > +		attr.odp_caps.per_transport_caps.rc_odp_caps;
> > +	resp.odp_caps.per_transport_caps.uc_odp_caps =3D
> > +		attr.odp_caps.per_transport_caps.uc_odp_caps;
> > +	resp.odp_caps.per_transport_caps.ud_odp_caps =3D
> > +		attr.odp_caps.per_transport_caps.ud_odp_caps;
> >  #endif
> > +	resp.comp_mask |=3D IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
>=20
> Not sure about this - if 0 is a valid null answer for all the _caps
> then it is fine, and the comp_mask bit should just be removed as the
> size alone should be enough.
>=20

That's difficult to say. But I hope 0 are valids answers in this case.

Anyway, the response's comp_mask is needed, as it's the sole way for=20
the userspace to know the size of the response. See below.

> This looks wrong however:
>=20
> >  	err =3D ib_copy_to_udata(ucore, &resp, sizeof(resp));
> >  	if (err)
> >           return err;
> >        return 0;
>=20
> Why isn't this returning the filled structure size to userspace?  Thi=
s
> would seem to be very urgently wrong to me? Am I missing something?
>=20
> Patch 3 probably should gain:
>=20
> - return 0;
> + return resp_len;
>=20

The write() syscall must return the size buffer passed to it, or less,
but in such case it would ask for trouble as userspace would be allowed
to write() the remaining bytes.
Returning a size bigger than the one passed to write() is not acceptabl=
e
and would break any expectation.

> This patch looks like an improvement to me:
>=20
> Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>=20

Thanks a lot.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
