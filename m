From: "Singhal, Maneesh" <Maneesh.Singhal-mb1K0bWo544@public.gmane.org>
Subject: RE: [PATCH] drivers/scsi/emcctd: drivers/scsi/emcctd: Client driver
 implementation for  EMC-Symmetrix GuestOS emulated Cut-Through Device
Date: Mon, 25 Jan 2016 09:30:47 +0000
Message-ID: <82807C73E0BDBB498164AAE7B8F6A1481C61AE33@MX105CL01.corp.emc.com>
References: <82807C73E0BDBB498164AAE7B8F6A1481C61263E@MX105CL01.corp.emc.com>
 <20160119160421.GM2742@c203.arch.suse.de>
 <82807C73E0BDBB498164AAE7B8F6A1481C6181A4@MX105CL01.corp.emc.com>
 <20160125092612.GB29561@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160125092612.GB29561-3LAbnSA0sDC4fIQPS+WK3rNAH6kLmebB@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "JBottomley-wo1vFcy6AUs@public.gmane.org" <JBottomley-wo1vFcy6AUs@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thanks Johannes for generously reviewing my patch. It indeed is going t=
o improve the thing a lot. I agree with all your comments so far, and w=
ill submit a newer patch soon.=20
Since this is my first patch, I have couple of questions regarding subm=
itting the patch:

1.  Is there a page/place where I can see the review comments rather ne=
atly ?, finding out all the comments and infact reading to entire code =
on text file is cumbersome. If there is no way, then its fine,... I can=
 live with it.
2. When I address the review comments and want to resubmit the patch, d=
o I need to submit the incremental patch or the entire code patch again=
 ? git-format-patch gives me incremental patch only.

Thanks
Maneesh

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn-l3A5Bk7waGM@public.gmane.org]
> Sent: Monday, January 25, 2016 2:56 PM
> To: Singhal, Maneesh
> Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> JBottomley-wo1vFcy6AUs@public.gmane.org; martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org; linux-
> api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] drivers/scsi/emcctd: drivers/scsi/emcctd: Client
> driver implementation for EMC-Symmetrix GuestOS emulated Cut-
> Through Device
>=20
> On Sat, Jan 23, 2016 at 05:51:50AM +0000, Singhal, Maneesh wrote:
> > Thanks for your time. My replies inlined...
> >
>=20
> [...]
>=20
> > > > +		}
> > > > +
> > >
> > > You don't do any cleanup work at
> > > ctd_scsi_response_sanity_check_complete. You could just reutrn 0
> > > here as well.
> > [MS>] Just avoiding multiple exit points from the function
>=20
> Please have a look at Documentation/CodingStyle Chapter 7:
> Centralized exiting of functions. Especially this part:
>=20
> <quote>
> The goto statement comes in handy when a function exits from
> multiple locations and some common work such as cleanup has to be
> done.  If there is no cleanup needed then just return directly.
> </quote>
>=20
> and the example below that section.
>=20
> > >
> > > > +
> > > > +		ctd_dprintk_crit(
>=20
> [...]
>=20
> > > > +	if (request && request->io_timeout < EMCCTD_MAX_RETRY) {
> > >
> > > The following block is a bit long and therefore it's hard to spot=
 an
> > > eventual error of handling the io_mgmt_lock. Can't it be factored
> > > out in a helper function?
> > >
> > [MS>] I know its little longer, but actually fits logically togethe=
r... Will
> see if it can be factored. Not sure though.
>=20
> Yes please. It's not uber important but short functions and paths are
> generally favoured when debugging and reviewing code.
>=20
>=20
> Thanks,
> 	Johannes
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton HRB 21284 (AG
> N=FCrnberg) Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 96=
9D
> 2D76 0850
