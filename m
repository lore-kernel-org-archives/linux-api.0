From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] drivers/scsi/emcctd: drivers/scsi/emcctd: Client driver
 implementation for  EMC-Symmetrix GuestOS emulated Cut-Through Device
Date: Mon, 25 Jan 2016 10:26:12 +0100
Message-ID: <20160125092612.GB29561@c203.arch.suse.de>
References: <82807C73E0BDBB498164AAE7B8F6A1481C61263E@MX105CL01.corp.emc.com>
 <20160119160421.GM2742@c203.arch.suse.de>
 <82807C73E0BDBB498164AAE7B8F6A1481C6181A4@MX105CL01.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <82807C73E0BDBB498164AAE7B8F6A1481C6181A4@MX105CL01.corp.emc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Singhal, Maneesh" <Maneesh.Singhal@emc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@odin.com" <JBottomley@odin.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 23, 2016 at 05:51:50AM +0000, Singhal, Maneesh wrote:
> Thanks for your time. My replies inlined...
>=20

[...]

> > > +		}
> > > +
> >=20
> > You don't do any cleanup work at
> > ctd_scsi_response_sanity_check_complete. You
> > could just reutrn 0 here as well.=20
> [MS>] Just avoiding multiple exit points from the function

Please have a look at Documentation/CodingStyle Chapter 7: Centralized =
exiting=20
of functions. Especially this part:

<quote>
The goto statement comes in handy when a function exits from multiple
locations and some common work such as cleanup has to be done.  If ther=
e is no
cleanup needed then just return directly.
</quote>

and the example below that section.

> >=20
> > > +
> > > +		ctd_dprintk_crit(

[...]

> > > +	if (request && request->io_timeout < EMCCTD_MAX_RETRY) {
> >=20
> > The following block is a bit long and therefore it's hard to spot a=
n
> > eventual
> > error of handling the io_mgmt_lock. Can't it be factored out in a h=
elper
> > function?
> >=20
> [MS>] I know its little longer, but actually fits logically together.=
=2E. Will see if it can be factored. Not sure though.

Yes please. It's not uber important but short functions and paths are
generally favoured when debugging and reviewing code.


Thanks,
	Johannes

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
