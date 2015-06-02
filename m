From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 29/98] scsi_netlink_fc.h: include stdint.h in userspace
Date: Tue, 2 Jun 2015 22:14:54 +0300
Message-ID: <20150602191454.GQ12550@lakka.kapsi.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-30-git-send-email-mikko.rapeli@iki.fi>
 <20150530201730.GC15645@bugger.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150530201730.GC15645-LuJdRk73L+f/9pzu0YdTqQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frans Klaver <fransklaver-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, May 30, 2015 at 10:17:30PM +0200, Frans Klaver wrote:
> On Sat, May 30, 2015 at 05:38:21PM +0200, Mikko Rapeli wrote:
> > Fixes compilation error:
> >=20
> > scsi/scsi_netlink_fc.h:60:2: error: expected specifier-qualifier-li=
st before =E2=80=98uint64_t=E2=80=99
> >=20
> > Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> > ---
> >  include/uapi/scsi/scsi_netlink_fc.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> >=20
> > diff --git a/include/uapi/scsi/scsi_netlink_fc.h b/include/uapi/scs=
i/scsi_netlink_fc.h
> > index 2493a0f..b857e34 100644
> > --- a/include/uapi/scsi/scsi_netlink_fc.h
> > +++ b/include/uapi/scsi/scsi_netlink_fc.h
> > @@ -21,6 +21,11 @@
> >  #ifndef SCSI_NETLINK_FC_H
> >  #define SCSI_NETLINK_FC_H
> > =20
> > +#ifdef __KERNEL__
> > +#include <linux/types.h>
> > +#else
> > +#include <stdint.h>
> > +#endif
> >  #include <scsi/scsi_netlink.h>
> > =20
> >  /*
>=20
> Shouldn't we be using __u64 and __u16 in this header instead?

Indeed, this was a rebase/merge botch. Thanks!

-Mikko
