From: Mark yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v12 1/3] drm: rockchip: Add basic drm driver
Date: Wed, 19 Nov 2014 10:02:53 +0800
Message-ID: <546BFA4D.3090700@rock-chips.com>
References: <1416297587-18959-1-git-send-email-mark.yao@rock-chips.com>
 <1416297629-19024-1-git-send-email-mark.yao@rock-chips.com>
 <20141118083234.GZ25711@phenom.ffwll.local>
 <20141118142130.6c12ab50@bbrezillon>
 <20141118142447.GC25711@phenom.ffwll.local> <546BEDD9.1000205@rock-chips.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1186294743=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <546BEDD9.1000205@rock-chips.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>, heiko@sntech.de, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, cf@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.c
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--===============1186294743==
Content-Type: multipart/alternative;
 boundary="------------040705000000090100050609"

This is a multi-part message in MIME format.
--------------040705000000090100050609
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014=E5=B9=B411=E6=9C=8819=E6=97=A5 09:09, Mark yao wrote:
> On 2014=E5=B9=B411=E6=9C=8818=E6=97=A5 22:24, Daniel Vetter wrote:
>> On Tue, Nov 18, 2014 at 02:21:30PM +0100, Boris Brezillon wrote:
>>> Hi Daniel,
>>>
>>> On Tue, 18 Nov 2014 09:32:34 +0100
>>> Daniel Vetter <daniel@ffwll.ch> wrote:
>>>
>>>> On Tue, Nov 18, 2014 at 04:00:29PM +0800, Mark Yao wrote:
>>>>> From: Mark yao <mark.yao@rock-chips.com>
>>>>>
>>>>> This patch adds the basic structure of a DRM Driver for Rockchip=20
>>>>> Socs.
>>>>>
>>>>> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
>>>>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>>>>> Acked-by: Daniel Vetter <daniel@ffwll.ch>
>>>>> Reviewed-by: Rob Clark <robdclark@gmail.com>
>>>>> ---
>>>>> Changes in v2:
>>>>> - use the component framework to defer main drm driver probe
>>>>>    until all VOP devices have been probed.
>>>>> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
>>>>>    master device and each vop device can shared the drm dma mapping=
.
>>>>> - use drm_crtc_init_with_planes and drm_universal_plane_init.
>>>>> - remove unnecessary middle layers.
>>>>> - add cursor set, move funcs to rockchip drm crtc.
>>>>> - use vop reset at first init
>>>>> - reference framebuffer when used and unreference when swap out vop
>>>>>
>>>>> Changes in v3:
>>>>> - change "crtc->fb" to "crtc->primary-fb"
>>>>> Adviced by Daniel Vetter
>>>>> - init cursor plane with universal api, remove unnecessary cursor=20
>>>>> set,move
>>>>>
>>>>> Changes in v4:
>>>>> Adviced by David Herrmann
>>>>> - remove drm_platform_*() usage, use register drm device directly.
>>>> Minor fixup for that part below.
>>>>
>>>> [snip]
>>>>
>>>>> +static int rockchip_drm_bind(struct device *dev)
>>>>> +{
>>>>> +    struct drm_device *drm;
>>>>> +    int ret;
>>>>> +
>>>>> +    drm =3D drm_dev_alloc(&rockchip_drm_driver, dev);
>>>>> +    if (!drm)
>>>>> +        return -ENOMEM;
>>>>> +
>>>>> +    ret =3D drm_dev_set_unique(drm, "%s", dev_name(dev));
>>>>> +    if (ret)
>>>>> +        goto err_free;
>>>> Please call rockchip_drm_load here directly and don't put it as the=20
>>>> ->load
>>>> function into the driver vtable. The point of the alloc/register=20
>>>> split is
>>>> that the driver can be completely set up _before_ we register=20
>>>> anything.
>>>> But for backwards compat and historical reasons ->load is called=20
>>>> somewhere
>>>> in the middle (so that you could access the minor nodes if needed,=20
>>>> since
>>>> some drivers do that).
>>> I tried to do the same in the atmel-hlcdc DRM driver, but I need the
>>> primary drm_minor to register the connectors (see this kernel
>>> backtrace [1]), which means I either initialize the connector in the
>>> wrong place (currently part of the drm load process), or I just can't
>>> call atmel_hlcdc_dc_load before registering the drm device...
>> Hm right, wonder who that works with rockchip tbh.
>>
>> We did split up the drm_connector setup into _init and register, so=20
>> if you
>> want to do this then you need to move the call to drm_connector_regist=
er
>> below the call to drm_dev_register.
>>
>> We should probably have a drm_connectors_register_all helper which doe=
s
>> this for all connectors on the connector list. And also grabs the
>> appropriate lock.
>>
>> I guess it's somewhat obvious that no one yet actually tried this ;-)
>> -Daniel
> right, I re-test the driver with it, get the same problem with Boris.
> I should move drm_connector_register below the drm_dev_register.
I try move connector_register below drm_dev_register, but unfortunately,=20
drm_dev_register call
drm_mode_group_init_legacy_group to save crtc, connector into list, it=20
need below  connector_register.
so that problem is that now: connector_register need bewteen minor node=20
create and
drm_mode_group_init_legacy_group.
=EF=BC=A9'm consider to revert the drm/rockchip v13.


--------------040705000000090100050609
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta content=3D"text/html; charset=3DUTF-8" http-equiv=3D"Content-Ty=
pe">
  </head>
  <body text=3D"#000000" bgcolor=3D"#FFFFFF">
    <div class=3D"moz-cite-prefix">On 2014=E5=B9=B411=E6=9C=8819=E6=97=A5=
 09:09, Mark yao wrote:<br>
    </div>
    <blockquote cite=3D"mid:546BEDD9.1000205@rock-chips.com" type=3D"cite=
">On
      2014=E5=B9=B411=E6=9C=8818=E6=97=A5 22:24, Daniel Vetter wrote:
      <br>
      <blockquote type=3D"cite">On Tue, Nov 18, 2014 at 02:21:30PM +0100,
        Boris Brezillon wrote:
        <br>
        <blockquote type=3D"cite">Hi Daniel,
          <br>
          <br>
          On Tue, 18 Nov 2014 09:32:34 +0100
          <br>
          Daniel Vetter <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto=
:daniel@ffwll.ch">&lt;daniel@ffwll.ch&gt;</a> wrote:
          <br>
          <br>
          <blockquote type=3D"cite">On Tue, Nov 18, 2014 at 04:00:29PM
            +0800, Mark Yao wrote:
            <br>
            <blockquote type=3D"cite">From: Mark yao
              <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:mark.yao@=
rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</a>
              <br>
              <br>
              This patch adds the basic structure of a DRM Driver for
              Rockchip Socs.
              <br>
              <br>
              Signed-off-by: Mark Yao <a class=3D"moz-txt-link-rfc2396E" =
href=3D"mailto:mark.yao@rock-chips.com">&lt;mark.yao@rock-chips.com&gt;</=
a>
              <br>
              Signed-off-by: Daniel Kurtz <a class=3D"moz-txt-link-rfc239=
6E" href=3D"mailto:djkurtz@chromium.org">&lt;djkurtz@chromium.org&gt;</a>
              <br>
              Acked-by: Daniel Vetter <a class=3D"moz-txt-link-rfc2396E" =
href=3D"mailto:daniel@ffwll.ch">&lt;daniel@ffwll.ch&gt;</a>
              <br>
              Reviewed-by: Rob Clark <a class=3D"moz-txt-link-rfc2396E" h=
ref=3D"mailto:robdclark@gmail.com">&lt;robdclark@gmail.com&gt;</a>
              <br>
              ---
              <br>
              Changes in v2:
              <br>
              - use the component framework to defer main drm driver
              probe
              <br>
              =C2=A0=C2=A0 until all VOP devices have been probed.
              <br>
              - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma
              mapping by
              <br>
              =C2=A0=C2=A0 master device and each vop device can shared t=
he drm
              dma mapping.
              <br>
              - use drm_crtc_init_with_planes and
              drm_universal_plane_init.
              <br>
              - remove unnecessary middle layers.
              <br>
              - add cursor set, move funcs to rockchip drm crtc.
              <br>
              - use vop reset at first init
              <br>
              - reference framebuffer when used and unreference when
              swap out vop
              <br>
              <br>
              Changes in v3:
              <br>
              - change "crtc-&gt;fb" to "crtc-&gt;primary-fb"
              <br>
              Adviced by Daniel Vetter
              <br>
              - init cursor plane with universal api, remove unnecessary
              cursor set,move
              <br>
              <br>
              Changes in v4:
              <br>
              Adviced by David Herrmann
              <br>
              - remove drm_platform_*() usage, use register drm device
              directly.
              <br>
            </blockquote>
            Minor fixup for that part below.
            <br>
            <br>
            [snip]
            <br>
            <br>
            <blockquote type=3D"cite">+static int rockchip_drm_bind(struc=
t
              device *dev)
              <br>
              +{
              <br>
              +=C2=A0=C2=A0=C2=A0 struct drm_device *drm;
              <br>
              +=C2=A0=C2=A0=C2=A0 int ret;
              <br>
              +
              <br>
              +=C2=A0=C2=A0=C2=A0 drm =3D drm_dev_alloc(&amp;rockchip_drm=
_driver, dev);
              <br>
              +=C2=A0=C2=A0=C2=A0 if (!drm)
              <br>
              +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
              <br>
              +
              <br>
              +=C2=A0=C2=A0=C2=A0 ret =3D drm_dev_set_unique(drm, "%s", d=
ev_name(dev));
              <br>
              +=C2=A0=C2=A0=C2=A0 if (ret)
              <br>
              +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_free;
              <br>
            </blockquote>
            Please call rockchip_drm_load here directly and don't put it
            as the -&gt;load
            <br>
            function into the driver vtable. The point of the
            alloc/register split is
            <br>
            that the driver can be completely set up _before_ we
            register anything.
            <br>
            But for backwards compat and historical reasons -&gt;load is
            called somewhere
            <br>
            in the middle (so that you could access the minor nodes if
            needed, since
            <br>
            some drivers do that).
            <br>
          </blockquote>
          I tried to do the same in the atmel-hlcdc DRM driver, but I
          need the
          <br>
          primary drm_minor to register the connectors (see this kernel
          <br>
          backtrace [1]), which means I either initialize the connector
          in the
          <br>
          wrong place (currently part of the drm load process), or I
          just can't
          <br>
          call atmel_hlcdc_dc_load before registering the drm device...
          <br>
        </blockquote>
        Hm right, wonder who that works with rockchip tbh.
        <br>
        <br>
        We did split up the drm_connector setup into _init and register,
        so if you
        <br>
        want to do this then you need to move the call to
        drm_connector_register
        <br>
        below the call to drm_dev_register.
        <br>
        <br>
        We should probably have a drm_connectors_register_all helper
        which does
        <br>
        this for all connectors on the connector list. And also grabs
        the
        <br>
        appropriate lock.
        <br>
        <br>
        I guess it's somewhat obvious that no one yet actually tried
        this ;-)
        <br>
        -Daniel
        <br>
      </blockquote>
      right, I re-test the driver with it, get the same problem with
      Boris.
      <br>
      I should move drm_connector_register below the drm_dev_register.
      <br>
    </blockquote>
    I try move connector_register below drm_dev_register, but
    unfortunately<span style=3D"color: rgb(51, 51, 51); font-family:
      arial; font-size: 18px; font-style: normal; font-variant: normal;
      font-weight: normal; letter-spacing: normal; line-height: 22px;
      orphans: auto; text-align: start; text-indent: 0px;
      text-transform: none; white-space: normal; widows: auto;
      word-spacing: 0px; -webkit-text-stroke-width: 0px;
      background-color: rgb(255, 255, 255); display: inline !important;
      float: none;">, </span>drm_dev_register call<br>
    drm_mode_group_init_legacy_group to save crtc, connector into list,
    it need below=C2=A0 connector_register.<br>
    so that problem is that now: connector_register need bewteen minor
    node create and<br>
    drm_mode_group_init_legacy_group.<br>
    =EF=BC=A9'm consider to revert the drm/rockchip v13.<br>
    <br>
  </body>
</html>

--------------040705000000090100050609--


--===============1186294743==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK

--===============1186294743==--
