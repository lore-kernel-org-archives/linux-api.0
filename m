From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 05/45] drm.h: include stdlib.h in userspace
Date: Mon, 23 Feb 2015 12:35:49 +0200
Message-ID: <20150223103548.GT12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-6-git-send-email-mikko.rapeli@iki.fi>
 <54EB0072.8020909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54EB0072.8020909-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 23, 2015 at 10:26:58AM +0000, Emil Velikov wrote:
> On 16/02/15 23:05, Mikko Rapeli wrote:
> > Fixes <drm/drm.h> compilation error:
> >=20
> > drm/drm.h:132:2: error: unknown type name =E2=80=98size_t=E2=80=99
> >=20
> Hi Mikko,
>=20
> Can you let us know how you're getting these (series-wise) errors ? I=
've
> been meaning to sync the uapi/drm and libdrm headers and would be nic=
e
> to have an extra step to test things.

This should have everything needed to reproduce these compile errors,
though some of the errors hide behind other errors and fixes:

https://lkml.org/lkml/2015/2/16/525

-Mikko
