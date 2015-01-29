From: Yann Droneaud <yann-WYdEh2jsUj5Wk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not
 depend on request's comp_mask
Date: Thu, 29 Jan 2015 21:42:11 +0100
Message-ID: <1422564131.3133.191.camel@droneaud.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
	 <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
	 <20150129182800.GH11842@obsidianresearch.com>
	 <1422557009.3133.172.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422557009.3133.172.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Le jeudi 29 janvier 2015 =C3=A0 19:43 +0100, Yann Droneaud a =C3=A9crit=
 :
> Le jeudi 29 janvier 2015 =C3=A0 11:28 -0700, Jason Gunthorpe a =C3=A9=
crit :
> > On Thu, Jan 29, 2015 at 06:59:58PM +0100, Yann Droneaud wrote:

> > > -		resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
> > > -		resp.odp_caps.per_transport_caps.rc_odp_caps =3D
> > > -			attr.odp_caps.per_transport_caps.rc_odp_caps;
> > > -		resp.odp_caps.per_transport_caps.uc_odp_caps =3D
> > > -			attr.odp_caps.per_transport_caps.uc_odp_caps;
> > > -		resp.odp_caps.per_transport_caps.ud_odp_caps =3D
> > > -			attr.odp_caps.per_transport_caps.ud_odp_caps;
> > > -		resp.comp_mask |=3D IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
> > > -	}
> > > +	resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
> > > +	resp.odp_caps.per_transport_caps.rc_odp_caps =3D
> > > +		attr.odp_caps.per_transport_caps.rc_odp_caps;
> > > +	resp.odp_caps.per_transport_caps.uc_odp_caps =3D
> > > +		attr.odp_caps.per_transport_caps.uc_odp_caps;
> > > +	resp.odp_caps.per_transport_caps.ud_odp_caps =3D
> > > +		attr.odp_caps.per_transport_caps.ud_odp_caps;
> > >  #endif
> > > +	resp.comp_mask |=3D IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
> >=20
> > Not sure about this - if 0 is a valid null answer for all the _caps
> > then it is fine, and the comp_mask bit should just be removed as th=
e
> > size alone should be enough.
> >=20
>=20
> That's difficult to say. But I hope 0 are valids answers in this case=
=2E
>=20

Hum, according to include/rdma/ib_verbs.h, there's a bit set
for ODP support:

    148 enum ib_odp_general_cap_bits {
    149         IB_ODP_SUPPORT =3D 1 << 0,
    150 };

So it should be safe to set everything to 0 in struct
ib_uverbs_odp_caps.

Regards.

--=20
Yann Droneaud
OPTEYA
