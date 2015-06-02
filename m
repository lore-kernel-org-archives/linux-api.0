From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 18/98] include/uapi/sound/emu10k1.h: added EMU10K1
 version of DECLARE_BITMAP etc macros
Date: Tue, 2 Jun 2015 22:08:27 +0300
Message-ID: <20150602190827.GP12550@lakka.kapsi.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-19-git-send-email-mikko.rapeli@iki.fi>
 <s5h8uc58ba6.wl-tiwai@suse.de>
 <s5h1thx88tk.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <s5h1thx88tk.wl-tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, May 31, 2015 at 10:12:07AM +0200, Takashi Iwai wrote:
> At Sun, 31 May 2015 09:18:57 +0200,
> Takashi Iwai wrote:
> >=20
> > At Sat, 30 May 2015 17:38:10 +0200,
> > Mikko Rapeli wrote:
> > >=20
> > > Fixes userspace compilation error:
> > >=20
> > > error: expected specifier-qualifier-list before =E2=80=98DECLARE_=
BITMAP=E2=80=99
> > >   DECLARE_BITMAP(gpr_valid, 0x200); /* bitmask of valid initializ=
ers */
> > >=20
> > > DECLARE_BITMAP etc macros are not meant for userspace headers and=
 thus
> > > added here as private copies for emu10k.h.
> > >=20
> > > Fix was suggested by Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> in message
> > > <2168807.4Yxh5gl11Q@wuerfel> on lkml.
> > >=20
> > > Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> > > ---
> > >  include/uapi/sound/emu10k1.h | 23 ++++++++++++++++++++---
> > >  1 file changed, 20 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/include/uapi/sound/emu10k1.h b/include/uapi/sound/em=
u10k1.h
> > > index ec1535b..7575f0f 100644
> > > --- a/include/uapi/sound/emu10k1.h
> > > +++ b/include/uapi/sound/emu10k1.h
> > > @@ -34,6 +34,23 @@
> > > =20
> > >  #define EMU10K1_FX8010_PCM_COUNT		8
> > > =20
> > > +/*
> > > + * Following definitions are copies from kernel headers to suppo=
rt compiling
> > > + * this header file in userspace. The definitions are not genera=
lly available
> > > + * in uapi headers so the needed things are copied here wtih __E=
MU10k1 prefix.
> > > + */
> > > +
> > > +/* From include/linux/bitops.h */
> > > +#define __EMU10K1_BITS_PER_BYTE           8
> > > +/* From include/linux/kernel.h */
> > > +#define __EMU10K1_DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> > > +/* From include/linux/bitops.h */
> > > +#define __EMU10K1_BITS_TO_LONGS(nr) \
> > > +        __EMU10K1_DIV_ROUND_UP(nr, __EMU10K1_BITS_PER_BYTE * siz=
eof(long))
> > > +/* From include/linux/types.h */
> > > +#define __EMU10K1_DECLARE_BITMAP(name,bits) \
> > > +        unsigned long name[__EMU10K1_BITS_TO_LONGS(bits)]
> >=20
> > This is way too complicated just for a few expansion of the aligned
> > size arrays, IMO.  Rather simplify it like below with a comment:
> >=20
> > /* the array must be aligned to unsigned long (i.e. 4 or 8 bytes) *=
/
> > #define __EMU10K1_DECLARE_BITMAP(name) \
> > 	unsigned long name[(bits) / sizeof(unsigned long)]
>=20
> Crap, of course, it must be multiplied with 8.
>=20
> /* the array must be aligned to unsigned long (i.e. 32 or 64) */
> #define __EMU10K1_DECLARE_BITMAP(name) \
> 	unsigned long name[(bits) / (sizeof(unsigned long) * 8)]

Thanks, I'll use this definition instead.

-Mikko
