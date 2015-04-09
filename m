From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH 05/45] drm.h: include stdlib.h in userspace
Date: Thu, 9 Apr 2015 19:09:29 +0300
Message-ID: <20150409160929.GP12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-6-git-send-email-mikko.rapeli@iki.fi>
 <54EB0072.8020909@gmail.com>
 <20150223103548.GT12550@lakka.kapsi.fi>
 <CACvgo50PA5nb27EcxQqXY49C5hmvDDxi3WOqB=op-wx_WEGd+Q@mail.gmail.com>
 <20150321121706.GW12550@lakka.kapsi.fi>
 <CACvgo50OU8mroLSS_R_Uo4D9PRtTnmLCM5p5QbxO6KQAjLWrYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACvgo50OU8mroLSS_R_Uo4D9PRtTnmLCM5p5QbxO6KQAjLWrYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Emil Velikov <emil.l.velikov@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@gmail.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, ML dri-devel <dri-devel@lists.freedesktop.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 09, 2015 at 05:00:48PM +0100, Emil Velikov wrote:
> Hi Mikko
>=20
> Pardon for the late response,
>=20
> On 21 March 2015 at 12:17, Mikko Rapeli <mikko.rapeli@iki.fi> wrote:
> > On Fri, Mar 20, 2015 at 08:25:40PM +0000, Emil Velikov wrote:
> >> On 23 February 2015 at 10:35, Mikko Rapeli <mikko.rapeli@iki.fi> w=
rote:
> >> > On Mon, Feb 23, 2015 at 10:26:58AM +0000, Emil Velikov wrote:
> >> >> On 16/02/15 23:05, Mikko Rapeli wrote:
> >> >> > Fixes <drm/drm.h> compilation error:
> >> >> >
> >> >> > drm/drm.h:132:2: error: unknown type name =E2=80=98size_t=E2=80=
=99
> >> >> >
> >> >> Hi Mikko,
> >> >>
> >> >> Can you let us know how you're getting these (series-wise) erro=
rs ? I've
> >> >> been meaning to sync the uapi/drm and libdrm headers and would =
be nice
> >> >> to have an extra step to test things.
> >> >
> >> > This should have everything needed to reproduce these compile er=
rors,
> >> > though some of the errors hide behind other errors and fixes:
> >> >
> >> > https://lkml.org/lkml/2015/2/16/525
> >> >
> >> Thanks for the link Mikko.
> >>
> >> Afaict the general consensus seems to be that one should avoid usi=
ng
> >> stdint's uint8_t, but stick to __u8 and friends. Did you had the
> >> chance to roll out another series that does so ?
> >
> > Yes, new series with these changes is on the way. I'm trying to fol=
low up to
> > all other review comments as well and get down to 100% compiling ua=
pi
> > headers; 35 failures to go...
> >
> Glad to hear that it's getting there. Might be a bit slower than
> expected but we'll get there :-) Can you please Cc me on the next
> iteration ?

Yes will Cc you too, and sorry life is getting on the way of this work.=
 Draft
version is visible at

https://github.com/torvalds/linux/compare/master...mcfrisk:headers_test=
_v03

-Mikko
