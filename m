From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v11 0/3] Add drm driver for Rockchip Socs
Date: Mon, 20 Oct 2014 13:45:35 +0200
Message-ID: <2468336.fLbrdhjYl7@phil>
References: <1412763781-31533-1-git-send-email-mark.yao@rock-chips.com> <4044646.m0RgIJvLdJ@phil> <5440D68E.4070103@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5440D68E.4070103-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, =?ISO-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.orgO
List-Id: linux-api@vger.kernel.org

Hi Mark,

Am Freitag, 17. Oktober 2014, 16:42:54 schrieb Mark yao:
> On 2014=E5=B9=B410=E6=9C=8817=E6=97=A5 16:25, Heiko St=C3=BCbner wrot=
e:
> > Am Freitag, 17. Oktober 2014, 16:16:01 schrieb Mark yao:
> >> On 2014=E5=B9=B410=E6=9C=8817=E6=97=A5 14:24, Heiko St=C3=BCbner w=
rote:
> >>> Hi Mark,
> >>>=20
> >>> Am Freitag, 17. Oktober 2014, 12:22:53 schrieb Mark yao:
> >>>> On 2014=E5=B9=B410=E6=9C=8817=E6=97=A5 08:46, Dave Airlie wrote:
> >>>>> On 17 October 2014 10:40, Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wr=
ote:
> >>>>>> Hi
> >>>>>> I think Rockchip drm driver is ready now, can it land?
> >>>>>=20
> >>>>> I probably want to wait until -rc1 though I suppose since its a=
 new
> >>>>> driver and self contained we might be able to see if Linus is
> >>>>> interested in squeezing it in.
> >>>>>=20
> >>>>> Can you send me a git pull request for it against drm-next or e=
ven
> >>>>> 3.17.
> >>>>>=20
> >>>>> Dave.
> >>>>=20
> >>>> Hi, Dave
> >>>>=20
> >>>>        the git pull request:
> >>>> The following changes since commit
> >=20
> > 4db36870b92cdf5a79615aeabc68efc97df13918:
> >>> I think this needs a fix. Your commit 4db36870b is the pending io=
mmu
> >>> driver. Which isn't part of neither the mainline kernel nor the d=
rm tree
> >>> Dave meant.
> >>>=20
> >>> What Dave meant was to base your patches on top of his "drm-next"=
 branch
> >>> or
> >>> the raw 3.17 release.
> >>>=20
> >>> So either base the branch on drm-next from
> >>>=20
> >>> 	http://cgit.freedesktop.org/~airlied/linux/log/?h=3Ddrm-next
> >>>=20
> >>> or the 3.17 release tag from Linus Torvalds. Apply your patches o=
n top
> >>> and
> >>> create pull from there.
> >>>=20
> >>> I've just checked ... your drm patches apply cleanly against 3.17=
, so
> >>> your
> >>> branch to be pulled should probably look something like
> >>>=20
> >>> 	https://github.com/mmind/linux-rockchip/commits/tmp/drmtest
> >>>=20
> >>> Heiko
> >>=20
> >> Hi Heiko
> >>=20
> >>       thanks for you check.
> >>=20
> >> Hi Dave
> >>=20
> >>       I have reupload a branch cleanly against 3.17:
> > sorry, but I think this might need another round.
> >=20
> > Your current base commit 0429fbc0bdc2 is already part of the curren=
t 3.18
> > merge window - which Dave won't have in his tree I guess. The commi=
t you
> > should base your patches on is bfe01a5ba249 - the 3.17 release.
> >=20
> > Simply do a
> >=20
> > 	git checkout v3.17
> > 	git checkout -b drmupstream
> >=20
> > apply your patches and send the pull request with v3.17 as base.
> >=20
> >=20
> > Heiko
>=20
> I think that would be ok:

yes the pull request itself looks ok, but you may have to be more expli=
cit.
Normally a pull request mail should have its own subject and body and n=
ot
be embedded somewhere into the response thread. This enables the
maintainers to see what they're asked to do easily.

So I guess it would be better to compose a separate mail, with a correc=
t
subject, somewhat similar to [0] for example.


Heiko


[0] http://www.spinics.net/lists/arm-kernel/msg366129.html

----- 8< ----------------
Subject: [GIT PULL] core drm support for Rockchip SoCs

The following changes since commit bfe01a5ba2490f299e1d2d5508cbbbadd897=
bbe9:

   Linux 3.17 (2014-10-05 12:23:04 -0700)

are available in the git repository at:

   https://github.com/markyzq/kernel-drm-rockchip.git drmrockchip

for you to fetch changes up to 45bb5f4e7e82b30e9e7069c73441413680c9a59f=
:

   dt-bindings: video: Add documentation for rockchip vop (2014-10-17=20
16:39:31 +0800)

----------------------------------------------------------------
Mark yao (3):
       drm: rockchip: Add basic drm driver
       dt-bindings: video: Add for rockchip display subsytem
       dt-bindings: video: Add documentation for rockchip vop

  .../devicetree/bindings/video/rockchip-drm.txt     |   19 +
  .../devicetree/bindings/video/rockchip-vop.txt     |   58 +
  drivers/gpu/drm/Kconfig                            |    2 +
  drivers/gpu/drm/Makefile                           |    1 +
  drivers/gpu/drm/rockchip/Kconfig                   |   17 +
  drivers/gpu/drm/rockchip/Makefile                  |    8 +
  drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |  449 ++++++
  drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |   54 +
  drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |  200 +++
  drivers/gpu/drm/rockchip/rockchip_drm_fb.h         |   28 +
  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c      |  210 +++
  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h      |   20 +
  drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |  293 ++++
  drivers/gpu/drm/rockchip/rockchip_drm_gem.h        |   54 +
  drivers/gpu/drm/rockchip/rockchip_drm_vop.c        | 1427 +++++++++++=
+++++++++
  drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  196 +++
  16 files changed, 3036 insertions(+)
  create mode 100644 Documentation/devicetree/bindings/video/rockchip-d=
rm.txt
  create mode 100644 Documentation/devicetree/bindings/video/rockchip-v=
op.txt
  create mode 100644 drivers/gpu/drm/rockchip/Kconfig
  create mode 100644 drivers/gpu/drm/rockchip/Makefile
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.c
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.h
