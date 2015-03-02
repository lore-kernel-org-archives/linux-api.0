From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH RFC 0/3] Drivers: hv: utils: re-implement the
 kernel/userspace communication layer
Date: Mon, 2 Mar 2015 02:11:53 +0000
Message-ID: <BY2PR0301MB071107C31972876159BB360CA0100@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dexuan Cui <decui@microsoft.com>, =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Friday, February 27, 2015 8:14 AM
> To: KY Srinivasan; devel@linuxdriverproject.org
> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org; Dexuan Cui; Radim Kr=
=E8m=E1=F8;
> Greg Kroah-Hartman; linux-api@vger.kernel.org
> Subject: [PATCH RFC 0/3] Drivers: hv: utils: re-implement the
> kernel/userspace communication layer
>=20
> This series converts kvp/vss daemons to use misc char devices instead=
 of
> netlink for userspace/kernel communication and then updates fcopy to =
be
> consistent with kvp/vss.
>=20
> Userspace/kernel communication via netlink has a number of issues:
> - It is hard for userspace to figure out if the kernel part was loade=
d or not
>   and this fact can change as there is a way to enable/disable the se=
rvice from
>   host side. Racy daemon startup is also a problem.
> - When the userspace daemon restarts/dies kernel part doesn't receive=
 a
>   notification.
> - Netlink communication is not stable under heavy load.
> - ...
>=20
> RFC: I'm a bit puzzled on how to split commits 1 and 2 avoiding break=
ages.
> Commit 3 can definitely be split, however, it is consistent with comm=
its 1 and
> 2 at this moment and I'm not sure such split will simplify the review=
=2E
>=20
> Vitaly Kuznetsov (3):
>   Drivers: hv: kvp: convert userspace/kernel communication to using c=
har
>     device
>   Drivers: hv: vss: convert userspace/kernel communication to using c=
har
>     device
>   Drivers: hv: fcopy: make it consistent with vss/kvp

Vitaly,

Thank you for working on this. Before I give you detailed comments on y=
our
patches, I wanted to understand if the cost of maintaining compatibilit=
y was
carefully considered. As a first step we could look at cleanly abstract=
ing the=20
transport (between user level and the kernel) out of the kernel driver =
code=20
as well as the new daemon
code. What are your thoughts on this. Version negotiation is obviously =
key to
maintaining compatibility. One of the options we can explore is to cont=
inue to
use netlink for version negotiation and for appropriate daemon versions=
, we could use
the char device mechanism for transporting the payload.

I like the new state machine you have defined and this is orthogonal to=
 the transport
options we have. You have sought feedback on how we can split up these =
changes into
smaller patches. This is how I would proceed here:

Patch(es) to clean up  the current code:=20
	Patch(es) to clean up the state machine.
	Patch(es) to isolate the kernel/user transport
Patch(es) to implement the new transport
=20
Regards,

K. Y
>=20
>  drivers/hv/hv_fcopy.c       | 395 +++++++++++++++++++++++++---------=
------
> ---
>  drivers/hv/hv_kvp.c         | 396 +++++++++++++++++++++++++++-------=
------
> ----
>  drivers/hv/hv_snapshot.c    | 335 +++++++++++++++++++++++++++-------=
--
> -
>  include/uapi/linux/hyperv.h |  10 ++
>  tools/hv/hv_fcopy_daemon.c  |  48 ++++--
>  tools/hv/hv_kvp_daemon.c    | 187 ++++-----------------
>  tools/hv/hv_vss_daemon.c    | 141 +++-------------
>  7 files changed, 824 insertions(+), 688 deletions(-)
>=20
> --
> 1.9.3
