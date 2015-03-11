From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 41/45] include/uapi/sound/emu10k1.h: hide gpr_valid, tram_valid and code_valid in userspace
Date: Wed, 11 Mar 2015 10:46:29 +0100
Message-ID: <2168807.4Yxh5gl11Q@wuerfel>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <20150311012204.GE12550@lakka.kapsi.fi> <s5h4mpsnjw9.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <s5h4mpsnjw9.wl-tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wednesday 11 March 2015 07:11:18 Takashi Iwai wrote:
> At Wed, 11 Mar 2015 03:22:04 +0200,
> Mikko Rapeli wrote:
> >=20
> > On Tue, Feb 17, 2015 at 07:27:38AM +0100, Takashi Iwai wrote:
> > > At Tue, 17 Feb 2015 00:05:44 +0100,
> > > Mikko Rapeli wrote:
> > > >=20
> > > > The DECLARE_BITMAP macro is not available in userspace headers.
> > > > Fixes userspace compile error:
> > > > error: expected specifier-qualifier-list before =E2=80=98DECLAR=
E_BITMAP=E2=80=99
> > >=20
> > > It's nonsense.  This results in an incompatible structure, thus A=
BI
> > > would be broken completely (actually this will break the compile =
of
> > > ld10k1).
> >=20
> > None of the exported headers after 'make headers_install' have defi=
nition
> > of DECLARE_BITMAP macro. It is defined in include/linux/types.h whi=
ch is
> > different from include/uapi/linux/types.h and missing this definiti=
on and
> > a few other things.
> >=20
> > One option would be add DECLARE_BITMAP macro to include/uapi/linux/=
types.h
> > and add include/linux/bitops.h to uapi.
> >=20
> > Thoughts?
>=20
> Are there any other headers like that?  If this is the only one, leav=
e
> it as is.  The only program that reads this are some alsa-tools ones
> and they have already own DECLARE_BITMAP() definition.  Adding the
> extra definition here will even break the compilation out of sudden.

I think it's a worthy goal to have the header files be compilable
standalone, but I don't think we should make the DECLARE_BITMAP()
macro globally visible in user space, in particular because it will
clash with every instance in which user space has a macro of the
same name.

What we could do here is to add a private copy of the macro to emu10k1.=
h
under a different name, such as __EMU10K1_DECLARE_BITMAP().

	Arnd
