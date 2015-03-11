From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH 24/45] hdspm.h: include stdint.h in userspace
Date: Wed, 11 Mar 2015 02:28:12 +0200
Message-ID: <20150311002812.GB12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-25-git-send-email-mikko.rapeli@iki.fi>
 <s5hwq3hox1x.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <s5hwq3hox1x.wl-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 07:46:02AM +0100, Takashi Iwai wrote:
> At Tue, 17 Feb 2015 00:05:27 +0100,
> Mikko Rapeli wrote:
> >=20
> > Fixes compilation error:
> >=20
> > sound/hdspm.h:43:2: error: unknown type name =E2=80=98uint32_t=E2=80=
=99
> >=20
> > Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
>=20
> Applied for 3.21, thanks.

Sorry, but this should maybe be dropped or reverted from the sound tree=
=2E

Arnd and others pointed out that kernel headers should be using __u32 e=
tc
types from linux/types.h instead of including stdint.h from libc and us=
ing
uint32_t et al.

I'll post a new patch version for hdspm.h too in the next revision.

-Mikko

>=20
> Takashi
>=20
> > ---
> >  include/uapi/sound/hdspm.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >=20
> > diff --git a/include/uapi/sound/hdspm.h b/include/uapi/sound/hdspm.=
h
> > index d956c35..f799828 100644
> > --- a/include/uapi/sound/hdspm.h
> > +++ b/include/uapi/sound/hdspm.h
> > @@ -20,6 +20,12 @@
> >   *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >   */
> > =20
> > +#ifdef __KERNEL__
> > +#include <linux/types.h>
> > +#else
> > +#include <stdint.h>
> > +#endif
> > +
> >  /* Maximum channels is 64 even on 56Mode you have 64playbacks to m=
atrix */
> >  #define HDSPM_MAX_CHANNELS      64
> > =20
> > --=20
> > 2.1.4
> >=20
