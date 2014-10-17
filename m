From: Mark yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v11 0/3] Add drm driver for Rockchip Socs
Date: Fri, 17 Oct 2014 16:42:54 +0800
Message-ID: <5440D68E.4070103@rock-chips.com>
References: <1412763781-31533-1-git-send-email-mark.yao@rock-chips.com> <282711393.zuCWIeu2Oz@phil> <5440D041.9020300@rock-chips.com> <4044646.m0RgIJvLdJ@phil>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4044646.m0RgIJvLdJ@phil>
Sender: linux-doc-owner@vger.kernel.org
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
Cc: Dave Airlie <airlied@gmail.com>, Boris BREZILLON <boris.brezillon@free-electrons.com>, Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>, dbehr@chromium.org
List-Id: linux-api@vger.kernel.org

On 2014=E5=B9=B410=E6=9C=8817=E6=97=A5 16:25, Heiko St=C3=BCbner wrote:
> Am Freitag, 17. Oktober 2014, 16:16:01 schrieb Mark yao:
>> On 2014=E5=B9=B410=E6=9C=8817=E6=97=A5 14:24, Heiko St=C3=BCbner wro=
te:
>>> Hi Mark,
>>>
>>> Am Freitag, 17. Oktober 2014, 12:22:53 schrieb Mark yao:
>>>> On 2014=E5=B9=B410=E6=9C=8817=E6=97=A5 08:46, Dave Airlie wrote:
>>>>> On 17 October 2014 10:40, Mark yao <mark.yao@rock-chips.com> wrot=
e:
>>>>>> Hi
>>>>>> I think Rockchip drm driver is ready now, can it land?
>>>>> I probably want to wait until -rc1 though I suppose since its a n=
ew
>>>>> driver and self contained we might be able to see if Linus is
>>>>> interested in squeezing it in.
>>>>>
>>>>> Can you send me a git pull request for it against drm-next or eve=
n 3.17.
>>>>>
>>>>> Dave.
>>>> Hi, Dave
>>>>
>>>>        the git pull request:
>>>> The following changes since commit
> 4db36870b92cdf5a79615aeabc68efc97df13918:
>>> I think this needs a fix. Your commit 4db36870b is the pending iomm=
u
>>> driver. Which isn't part of neither the mainline kernel nor the drm=
 tree
>>> Dave meant.
>>>
>>> What Dave meant was to base your patches on top of his "drm-next" b=
ranch
>>> or
>>> the raw 3.17 release.
>>>
>>> So either base the branch on drm-next from
>>>
>>> 	http://cgit.freedesktop.org/~airlied/linux/log/?h=3Ddrm-next
>>>
>>> or the 3.17 release tag from Linus Torvalds. Apply your patches on =
top and
>>> create pull from there.
>>>
>>> I've just checked ... your drm patches apply cleanly against 3.17, =
so your
>>> branch to be pulled should probably look something like
>>>
>>> 	https://github.com/mmind/linux-rockchip/commits/tmp/drmtest
>>>
>>> Heiko
>> Hi Heiko
>>       thanks for you check.
>>
>> Hi Dave
>>       I have reupload a branch cleanly against 3.17:
> sorry, but I think this might need another round.
>
> Your current base commit 0429fbc0bdc2 is already part of the current =
3.18
> merge window - which Dave won't have in his tree I guess. The commit =
you
> should base your patches on is bfe01a5ba249 - the 3.17 release.
>
> Simply do a
> 	git checkout v3.17
> 	git checkout -b drmupstream
>
> apply your patches and send the pull request with v3.17 as base.
>
>
> Heiko
>

I think that would be ok:

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



