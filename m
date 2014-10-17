From: Mark yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v11 0/3] Add drm driver for Rockchip Socs
Date: Fri, 17 Oct 2014 12:22:53 +0800
Message-ID: <5440999D.5010601@rock-chips.com>
References: <1412763781-31533-1-git-send-email-mark.yao@rock-chips.com>	<5440658D.6020504@rock-chips.com> <CAPM=9twVrmni_BRV_9-QLk+JUbcgXEjAM0g-tYH6su8=sDQ35g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAPM=9twVrmni_BRV_9-QLk+JUbcgXEjAM0g-tYH6su8=sDQ35g@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Dave Airlie <airlied@gmail.com>
Cc: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>, Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>, dbehr@chromium.org, Olof
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B410=E6=9C=8817=E6=97=A5 08:46, Dave Airlie wrote:
> On 17 October 2014 10:40, Mark yao <mark.yao@rock-chips.com> wrote:
>> Hi
>> I think Rockchip drm driver is ready now, can it land?
> I probably want to wait until -rc1 though I suppose since its a new
> driver and self contained we might be able to see if Linus is
> interested in squeezing it in.
>
> Can you send me a git pull request for it against drm-next or even 3.=
17.
>
> Dave.
Hi, Dave
     the git pull request:

The following changes since commit 4db36870b92cdf5a79615aeabc68efc97df1=
3918:

   FROMLIST: iommu/rockchip: rk3288 iommu driver (2014-10-17 10:26:18 +=
0800)

are available in the git repository at:

   https://github.com/markyzq/kernel-drm-rockchip.git mydrm

for you to fetch changes up to 0db2be88bea08ab8afe5e3d13f8a2c9e637a9514=
:

   dt-bindings: video: Add documentation for rockchip vop (2014-10-17=20
10:27:15 +0800)

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
  drivers/gpu/drm/rockchip/rockchip_drm_vop.c        | 1427=20
++++++++++++++++++++
  drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  196 +++
  16 files changed, 3036 insertions(+)
  create mode 100644=20
Documentation/devicetree/bindings/video/rockchip-drm.txt
  create mode 100644=20
Documentation/devicetree/bindings/video/rockchip-vop.txt
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


