From: Andrew Cooper <andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 95/98] HACK: fix include/uapi/xen/privcmd.h
 compilation in userspace
Date: Sat, 30 May 2015 18:56:25 +0100
Message-ID: <5569F9C9.8000607@citrix.com>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-96-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-96-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Alexander Yarygin <yarygin-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 30/05/15 16:39, Mikko Rapeli wrote:
> privcmd.h depends on xen/interface/xen.h which is now exported to use=
rspace.
> xen/interface/xen.h then depends on asm/xen/interface.h which is now
> exported to userspace together with its dependencies asm/xen/interfac=
e_32.h,
> asm/xen/interface_64.h and asm/pvclock-abi.h on x86 architecture.
>
> Then all of these headers were fixed to use __u8 etc from linux/types=
=2Eh
> instead of custom types.
>
> Then define uint64_t and uint32_t if needed.
>
> After all these changes these header files now compile in userspace t=
oo
> on x86.
>
> HACK since I have no idea if this is correct way to fix this.
>
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>

Historical reasons expect xen/interface/xen.h to be a verbatim copy of
the master version kept in the Xen repository.

The only things privcmd.h need from interface/xen.h are domid_t
(uint16_t), and xen_pfn_t (unsigned long, or uint64_t in arm32 iirc),
while the majority of the rest absolutely shouldn't be in Linux=92s uap=
i.

It would probably be best to provide just these two types and nuke the
"#include <xen/interface/xen.h>".  Any user of privcmd needs to include
the Xen interface themselves anyway, and will have a different copy
which includes the toolstack half of the interface (missing from the
kernel copy) which is the useful set of definitions for driving the
privcmd ioctl()s.

~Andrew
