From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 43/45] include/uapi/linux/netfilter_bridge.h: include if.h
Date: Wed, 11 Mar 2015 03:49:53 +0200
Message-ID: <20150311014952.GF12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-44-git-send-email-mikko.rapeli@iki.fi>
 <alpine.LSU.2.11.1502170101520.32748@nerf60.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1502170101520.32748-G+YmpvGGOO3H9RFtKMg/Ng@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Engelhardt <jengelh-9+2X+4sQBs8@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netfilter Developer Mailing List <netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 01:02:50AM +0100, Jan Engelhardt wrote:
> On Tuesday 2015-02-17 00:05, Mikko Rapeli wrote:
>=20
> >Fixes userspace compilation errors like:
> >
> >error: field =E2=80=98in=E2=80=99 has incomplete type
> >struct in_addr in;
> >=20
> >+#include <linux/if.h>
>=20
> Patch 36/45 included linux/in.h instead of linux/if.h for addressing =
"in has incomplete
> type". Should this be used here too?

It could, yes. It seems I cut some corners since this was hiding behind=
 it:

In file included from ./linux/netfilter_bridge.h:11:0,
                 from ./linux/netfilter_bridge.c:1:
=2E/linux/if_pppox.h:42:11: error: =E2=80=98IFNAMSIZ=E2=80=99 undeclare=
d here (not in a function)
  char          dev[IFNAMSIZ];          /* Local device to use */

I'll fix these.

-Mikko
