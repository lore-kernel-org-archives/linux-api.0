From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH v4 23/79] rds.h: use __u8, __u16, __s16, __u32 and __s64
 from linux/types.h
Date: Fri, 16 Oct 2015 01:00:25 +0300
Message-ID: <20151015220025.GG6104@lakka.kapsi.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-24-git-send-email-mikko.rapeli@iki.fi>
 <20151015110614.GL948@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151015110614.GL948-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sowmini Varadhan <sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 07:06:14AM -0400, Sowmini Varadhan wrote:
> On (10/15/15 07:56), Mikko Rapeli wrote:
> > Date: Thu, 15 Oct 2015 07:56:01 +0200
> > From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> > To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: mikko.rapeli-X3B1VOXEql0@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, S=
owmini
> >  Varadhan <sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: [PATCH v4 23/79] rds.h: use __u8, __u16, __s16, __u32 and =
__s64
> >  from linux/types.h
> > X-Mailer: git-send-email 2.6.1
> >=20
> > Fixes userspace compilation errors like:
> >=20
> > linux/rds.h:96:2: error: unknown type name =E2=80=98uint8_t=E2=80=99
>=20
> Can't you just include <stdint.h> in linux/rds.h? (similar to the
> fix for linux/rds)? It would reduce the deltas significantly,=20
> and portable applications are likely to expect uint8_t etc anyway.

What kind of portability should exported userspace headers from Linux k=
ernel
need?

Reviews to my previous changes NACKed <stdint.h> usage and
Documentation/CodingStyle chapter 5 says:

 (e) Types safe for use in userspace.

     In certain structures which are visible to userspace, we cannot
     require C99 types and cannot use the 'u32' form above. Thus, we
     use __u32 and similar types in all structures which are shared
     with userspace.

-Mikko
