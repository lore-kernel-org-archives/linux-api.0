From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 41/45] include/uapi/sound/emu10k1.h: hide gpr_valid,
 tram_valid and code_valid in userspace
Date: Wed, 11 Mar 2015 03:22:04 +0200
Message-ID: <20150311012204.GE12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-42-git-send-email-mikko.rapeli@iki.fi>
 <s5h4mqlqch1.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <s5h4mqlqch1.wl-tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 07:27:38AM +0100, Takashi Iwai wrote:
> At Tue, 17 Feb 2015 00:05:44 +0100,
> Mikko Rapeli wrote:
> >=20
> > The DECLARE_BITMAP macro is not available in userspace headers.
> > Fixes userspace compile error:
> > error: expected specifier-qualifier-list before =E2=80=98DECLARE_BI=
TMAP=E2=80=99
>=20
> It's nonsense.  This results in an incompatible structure, thus ABI
> would be broken completely (actually this will break the compile of
> ld10k1).

None of the exported headers after 'make headers_install' have definiti=
on
of DECLARE_BITMAP macro. It is defined in include/linux/types.h which i=
s
different from include/uapi/linux/types.h and missing this definition a=
nd
a few other things.

One option would be add DECLARE_BITMAP macro to include/uapi/linux/type=
s.h
and add include/linux/bitops.h to uapi.

Thoughts?

-Mikko
