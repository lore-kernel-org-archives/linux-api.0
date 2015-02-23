From: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/45] drm.h: include stdlib.h in userspace
Date: Mon, 23 Feb 2015 10:26:58 +0000
Message-ID: <54EB0072.8020909@gmail.com>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <1424127948-22484-6-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424127948-22484-6-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 16/02/15 23:05, Mikko Rapeli wrote:
> Fixes <drm/drm.h> compilation error:
>=20
> drm/drm.h:132:2: error: unknown type name =E2=80=98size_t=E2=80=99
>=20
Hi Mikko,

Can you let us know how you're getting these (series-wise) errors ? I'v=
e
been meaning to sync the uapi/drm and libdrm headers and would be nice
to have an extra step to test things.

Thanks
Emil
