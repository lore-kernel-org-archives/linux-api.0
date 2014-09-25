From: Mark yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
Date: Thu, 25 Sep 2014 08:54:04 +0800
Message-ID: <542367AC.2010105@rock-chips.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>	<1411382934-1763-1-git-send-email-mark.yao@rock-chips.com>	<20140924082037.GJ15734@phenom.ffwll.local>	<54228F7B.2050608@rock-chips.com>
 <CAKMK7uHiQFDH-qyPBsyVa953F5SY2UgSv7Nbsu73AKvjqUm1jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0036658266=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CAKMK7uHiQFDH-qyPBsyVa953F5SY2UgSv7Nbsu73AKvjqUm1jw@mail.gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Mark Rutland <mark.rutland@arm.com>, =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>, linux-doc@vger.kernel.org, Kever Yang <kever.yang@rock-chips.com>, dri-devel <dri-devel@lists.freedesktop.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jianqun Xu <xjq@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>, linux-api@vger.kernel.org, jeff chen <cym@rock-chips.com>, linux-rockchip@lists.infradead.org, kfx@rock-chips.com, Grant Likely <grant.likely@linaro.org>, =?UTF-8?B?546L5pmT?= =?UTF-8?B?6IW+?= <wxt@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, yxj@rock-chips.com, Rob Herring <robh+dt@kernel.org>, =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>, simon xue <xxm@rock-chips.com>, xw@rock-chips.
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--===============0036658266==
Content-Type: multipart/alternative;
 boundary="------------000709020103010906060402"

This is a multi-part message in MIME format.
--------------000709020103010906060402
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014=E5=B9=B409=E6=9C=8824=E6=97=A5 19:20, Daniel Vetter wrote:
> On Wed, Sep 24, 2014 at 11:31 AM, Mark yao <mark.yao@rock-chips.com> wr=
ote:
>> On 2014=E5=B9=B409=E6=9C=8824=E6=97=A5 16:20, Daniel Vetter wrote:
>>> On Mon, Sep 22, 2014 at 06:48:54PM +0800, Mark yao wrote:
>>>> This patch adds the basic structure of a DRM Driver for Rockchip Soc=
s.
>>>>
>>>> Signed-off-by: Mark yao <mark.yao@rock-chips.com>
>>>> ---
>>>> Changes in v2:
>>>> - use the component framework to defer main drm driver probe
>>>>     until all VOP devices have been probed.
>>>> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
>>>>     master device and each vop device can shared the drm dma mapping=
.
>>>> - use drm_crtc_init_with_planes and drm_universal_plane_init.
>>>> - remove unnecessary middle layers.
>>>> - add cursor set, move funcs to rockchip drm crtc.
>>>> - use vop reset at first init
>>>> - reference framebuffer when used and unreference when swap out vop
>>>>
>>>> Changes in v3:
>>>> - change "crtc->fb" to "crtc->primary-fb"
>>>> Adviced by Daniel Vetter
>>>> - init cursor plane with universal api, remove unnecessary cursor
>>>> set,move
>>>>
>>>> Changes in v4:
>>>> Adviced by David Herrmann
>>>> - remove drm_platform_*() usage, use register drm device directly.
>>>> Adviced by Rob Clark
>>>> - remove special mmap ioctl, do userspace mmap with normal mmap() or=
 mmap
>>>> offset
>>>>
>>>>    drivers/gpu/drm/Kconfig                       |    2 +
>>>>    drivers/gpu/drm/Makefile                      |    1 +
>>>>    drivers/gpu/drm/rockchip/Kconfig              |   19 +
>>>>    drivers/gpu/drm/rockchip/Makefile             |   10 +
>>>>    drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  524 ++++++++++
>>>>    drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |  120 +++
>>>>    drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  201 ++++
>>>>    drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
>>>>    drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  231 +++++
>>>>    drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
>>>>    drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  404 ++++++++
>>>>    drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   72 ++
>>>>    drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1372
>>>> +++++++++++++++++++++++++
>>>>    drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  187 ++++
>>>>    include/uapi/drm/rockchip_drm.h               |   75 ++
>>> uapi is still here ... Was this an oversight?
>>> -Daniel
>>>
>> Hi, Daniel
>> this version is old, newest is v5. and I remove uapi at v5.
>> you can see v5 patch at:
>> https://lkml.org/lkml/2014/9/23/1061
>> thanks
> This version doesn't seem to be cc'ed to dri-devel, at least it didn't
> yet show up. Can you please double-check?
actually I cc the v5 version to dri-devel@lists.freedesktop.org.
and we can found the patch at=20
https://patchwork.kernel.org/patch/4967501/( *Project*: dri-devel)
>
> Thanks, Daniel
>
>
>


--------------000709020103010906060402
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta content=3D"text/html; charset=3DUTF-8" http-equiv=3D"Content-Ty=
pe">
  </head>
  <body text=3D"#000000" bgcolor=3D"#FFFFFF">
    <div class=3D"moz-cite-prefix">On 2014=E5=B9=B409=E6=9C=8824=E6=97=A5=
 19:20, Daniel Vetter
      wrote:<br>
    </div>
    <blockquote
cite=3D"mid:CAKMK7uHiQFDH-qyPBsyVa953F5SY2UgSv7Nbsu73AKvjqUm1jw@mail.gmai=
l.com"
      type=3D"cite">
      <pre wrap=3D"">On Wed, Sep 24, 2014 at 11:31 AM, Mark yao <a class=3D=
"moz-txt-link-rfc2396E" href=3D"mailto:mark.yao@rock-chips.com">&lt;mark.=
yao@rock-chips.com&gt;</a> wrote:
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">On 2014=E5=B9=B409=E6=9C=8824=E6=97=A5 16:20, Dani=
el Vetter wrote:
</pre>
        <blockquote type=3D"cite">
          <pre wrap=3D"">
On Mon, Sep 22, 2014 at 06:48:54PM +0800, Mark yao wrote:
</pre>
          <blockquote type=3D"cite">
            <pre wrap=3D"">
This patch adds the basic structure of a DRM Driver for Rockchip Socs.

Signed-off-by: Mark yao <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto=
:mark.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
---
Changes in v2:
- use the component framework to defer main drm driver probe
   until all VOP devices have been probed.
- use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
   master device and each vop device can shared the drm dma mapping.
- use drm_crtc_init_with_planes and drm_universal_plane_init.
- remove unnecessary middle layers.
- add cursor set, move funcs to rockchip drm crtc.
- use vop reset at first init
- reference framebuffer when used and unreference when swap out vop

Changes in v3:
- change "crtc-&gt;fb" to "crtc-&gt;primary-fb"
Adviced by Daniel Vetter
- init cursor plane with universal api, remove unnecessary cursor
set,move

Changes in v4:
Adviced by David Herrmann
- remove drm_platform_*() usage, use register drm device directly.
Adviced by Rob Clark
- remove special mmap ioctl, do userspace mmap with normal mmap() or mmap
offset

  drivers/gpu/drm/Kconfig                       |    2 +
  drivers/gpu/drm/Makefile                      |    1 +
  drivers/gpu/drm/rockchip/Kconfig              |   19 +
  drivers/gpu/drm/rockchip/Makefile             |   10 +
  drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  524 ++++++++++
  drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |  120 +++
  drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  201 ++++
  drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  231 +++++
  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
  drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  404 ++++++++
  drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   72 ++
  drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1372
+++++++++++++++++++++++++
  drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  187 ++++
  include/uapi/drm/rockchip_drm.h               |   75 ++
</pre>
          </blockquote>
          <pre wrap=3D"">
uapi is still here ... Was this an oversight?
-Daniel

</pre>
        </blockquote>
        <pre wrap=3D"">Hi, Daniel
this version is old, newest is v5. and I remove uapi at v5.
you can see v5 patch at:
<a class=3D"moz-txt-link-freetext" href=3D"https://lkml.org/lkml/2014/9/2=
3/1061">https://lkml.org/lkml/2014/9/23/1061</a>
thanks
</pre>
      </blockquote>
      <pre wrap=3D"">
This version doesn't seem to be cc'ed to dri-devel, at least it didn't
yet show up. Can you please double-check?</pre>
    </blockquote>
    actually I cc the v5 version to <a class=3D"moz-txt-link-abbreviated"=
 href=3D"mailto:dri-devel@lists.freedesktop.org">dri-devel@lists.freedesk=
top.org</a>. <br>
    and we can found the patch at
    <a class=3D"moz-txt-link-freetext" href=3D"https://patchwork.kernel.o=
rg/patch/4967501/(">https://patchwork.kernel.org/patch/4967501/(</a>
    <meta http-equiv=3D"content-type" content=3D"text/html; charset=3DUTF=
-8">
    <strong style=3D"color: rgb(0, 0, 0); font-family: 'DejaVu Sans',
      'Bitstream Vera Sans', Verdana, sans-serif; font-size: 12px;
      font-style: normal; font-variant: normal; letter-spacing: normal;
      line-height: normal; orphans: auto; text-align: start;
      text-indent: 0px; text-transform: none; white-space: normal;
      widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px;
      background-color: rgb(232, 232, 232);">Project</strong><span
      style=3D"color: rgb(0, 0, 0); font-family: 'DejaVu Sans', 'Bitstrea=
m
      Vera Sans', Verdana, sans-serif; font-size: 12px; font-style:
      normal; font-variant: normal; font-weight: normal; letter-spacing:
      normal; line-height: normal; orphans: auto; text-align: start;
      text-indent: 0px; text-transform: none; white-space: normal;
      widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px;
      background-color: rgb(232, 232, 232); display: inline !important;
      float: none;">: dri-devel<span class=3D"Apple-converted-space"></sp=
an></span>)<br>
    <blockquote
cite=3D"mid:CAKMK7uHiQFDH-qyPBsyVa953F5SY2UgSv7Nbsu73AKvjqUm1jw@mail.gmai=
l.com"
      type=3D"cite">
      <pre wrap=3D"">

Thanks, Daniel



</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------000709020103010906060402--


--===============0036658266==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel

--===============0036658266==--
