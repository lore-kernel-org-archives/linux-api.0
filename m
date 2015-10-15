From: Sowmini Varadhan <sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 23/79] rds.h: use __u8, __u16, __s16, __u32 and __s64
 from linux/types.h
Date: Thu, 15 Oct 2015 07:06:14 -0400
Message-ID: <20151015110614.GL948@oracle.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-24-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444888618-4506-24-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On (10/15/15 07:56), Mikko Rapeli wrote:
> Date: Thu, 15 Oct 2015 07:56:01 +0200
> From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: mikko.rapeli-X3B1VOXEql0@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Sow=
mini
>  Varadhan <sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH v4 23/79] rds.h: use __u8, __u16, __s16, __u32 and __=
s64
>  from linux/types.h
> X-Mailer: git-send-email 2.6.1
>=20
> Fixes userspace compilation errors like:
>=20
> linux/rds.h:96:2: error: unknown type name =E2=80=98uint8_t=E2=80=99

Can't you just include <stdint.h> in linux/rds.h? (similar to the
fix for linux/rds)? It would reduce the deltas significantly,=20
and portable applications are likely to expect uint8_t etc anyway.

--Sowmini
