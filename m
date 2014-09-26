From: Mark yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v5 1/3] drm/rockchip: Add basic drm driver
Date: Fri, 26 Sep 2014 09:26:16 +0800
Message-ID: <5424C0B8.3000402@rock-chips.com>
References: <1411524672-14524-1-git-send-email-mark.yao@rock-chips.com>
 <1411524746-14635-1-git-send-email-mark.yao@rock-chips.com>
 <CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=Wf3gyJZC8bw@mail.gmail.com>
 <5423D951.4030703@rock-chips.com> <5424067B.7090908@rock-chips.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1769245416=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <5424067B.7090908@rock-chips.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>, =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>, linux-doc@vger.kernel.org, kever.yang@rock-chips.com, dri-devel <dri-devel@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xjq@rock-chips.com, zyw@rock-chips.com, linux-api@vger.kernel.org, jeff chen <cym@rock-chips.com>, linux-rockchip@lists.infradead.org, kfx@rock-chips.com, Grant Likely <grant.likely@linaro.org>, wxt@rock-chips.com, huangtao@rock-chips.com, devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, yxj@rock-chips.com, Eddie Cai <cf@rock-chips.com>, Rob Herring <robh+dt@kernel.org>, =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>, simon xue <xxm@rock-chips.com>, xw@rock-chips.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.or>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--===============1769245416==
Content-Type: multipart/alternative;
 boundary="------------040503080203000708080305"

This is a multi-part message in MIME format.
--------------040503080203000708080305
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014=E5=B9=B409=E6=9C=8825=E6=97=A5 20:11, Mark yao wrote:
> On 2014=E5=B9=B409=E6=9C=8825=E6=97=A5 16:58, Mark yao wrote:
>> On 2014=E5=B9=B409=E6=9C=8825=E6=97=A5 00:20, Daniel Kurtz wrote:
>>> Hi Mark,
>>>
>>> Please review comments inline...
>>>
>>> On Wed, Sep 24, 2014 at 10:12 AM, Mark yao<mark.yao@rock-chips.com>  =
wrote:
>>> To match the enum name, use ROCKCHIP_OUTPUT_TYPE_*.
>>> Also, no need to explicitly set the first one to 0.
>>> However, see below.  I don't think we to modify the drm_display_mode
>>> to include an output type.
>> but vop devices need know the connector type, connector enable=20
>> register is in vop.
>> can I do that like under to  get connector type for crtc?
>>
>>     static int rockchip_get_connector_type(struct drm_crtc *crtc)
>>     {
>>           struct drm_device *dev =3D crtc->dev;
>>           struct drm_connector * connector;
>>
>>           list_for_each_entry(connector,=20
>> &dev->mode_config.connector_list, head) {
>>           if (!connector->encoder)
>>                   continue;
>>           /*
>>            * one crtc only has one connector in my case, so just find=20
>> the first connector at list.
>>            */
>>           if (connector->encoder->crtc =3D=3D crtc)
>>                   break;
>>     }
>>
>>     if (!connector)
>>             return -EINVAL;
>>
>>     return connector->connector_type;
>> }=20
> Oh, sorry, forgot to drop this comment,
> for connector type problem, I try to new a help function for encoder=20
> to call as Daniel advices.
>>>> +#define to_rockchip_plane(x) container_of(x, struct rockchip_plane,=
 base)
>>>> +
>>>> +struct rockchip_plane {
>>>> +       int id;
>>>> +       struct drm_plane base;
>>>> +       const struct vop_win *win;
>>>> +       struct vop_context *ctx;
>>> Isn't ctx just: to_vop_ctx(base->crtc)
>>>
>> OK. we can use to_vop_ctx(base->crtc) to get ctx.=20
> I have do a test to use "to_vop_ctx(base->crtc)", but found that=20
> "base->crtc" maybe not init.
> for cursor plane, base->crtc always is NULL. and disable_plane will fai=
l.
> maybe we can add "base->crtc =3D crtc" at update_plane, but it seems no=
t=20
> good.
> so I think still use "rockchip_plane->ctx" would be better.
>
> -Mark
I found that: plane->crtc will be set if update_plane success, and will=20
be set NULL if disable_plane success.
so disable_plane must after update_plane.
disable_plane get crtc=3D=3DNULL problem is that disable_plane was called=
=20
before update_plane or been called  twice.
for this reason we can just check if crtc is NULL at disable_plane.

-Mark





--------------040503080203000708080305
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta content=3D"text/html; charset=3DUTF-8" http-equiv=3D"Content-Ty=
pe">
  </head>
  <body text=3D"#000000" bgcolor=3D"#FFFFFF">
    <div class=3D"moz-cite-prefix">On 2014=E5=B9=B409=E6=9C=8825=E6=97=A5=
 20:11, Mark yao wrote:<br>
    </div>
    <blockquote cite=3D"mid:5424067B.7090908@rock-chips.com" type=3D"cite=
">
      <meta content=3D"text/html; charset=3DUTF-8" http-equiv=3D"Content-=
Type">
      <div class=3D"moz-cite-prefix">On 2014=E5=B9=B409=E6=9C=8825=E6=97=A5=
 16:58, Mark yao wrote:<br>
      </div>
      <blockquote cite=3D"mid:5423D951.4030703@rock-chips.com" type=3D"ci=
te">
        <meta content=3D"text/html; charset=3DUTF-8"
          http-equiv=3D"Content-Type">
        <div class=3D"moz-cite-prefix">On 2014=E5=B9=B409=E6=9C=8825=E6=97=
=A5 00:20, Daniel Kurtz
          wrote:<br>
        </div>
        <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
          type=3D"cite">
          <pre wrap=3D"">Hi Mark,

Please review comments inline...

On Wed, Sep 24, 2014 at 10:12 AM, Mark yao <a moz-do-not-send=3D"true" cl=
ass=3D"moz-txt-link-rfc2396E" href=3D"mailto:mark.yao@rock-chips.com">&lt=
;mark.yao@rock-chips.com&gt;</a> wrote:
</pre>
        </blockquote>
        <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
          type=3D"cite">
          <blockquote type=3D"cite"> </blockquote>
          <pre wrap=3D"">To match the enum name, use ROCKCHIP_OUTPUT_TYPE=
_*.
Also, no need to explicitly set the first one to 0.
However, see below.  I don't think we to modify the drm_display_mode
to include an output type.
</pre>
        </blockquote>
        but vop devices need know the connector type, connector enable
        register is in vop.<br>
        can I do that like under to=C2=A0 get connector type for crtc?<br=
>
        <br>
        =C2=A0=C2=A0=C2=A0 static int rockchip_get_connector_type(struct =
drm_crtc
        *crtc)<br>
        =C2=A0=C2=A0=C2=A0 {<br>
        =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct drm=
_device *dev =3D crtc-&gt;dev;<br>
        =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct drm=
_connector * connector;<br>
        <br>
        =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_for_e=
ach_entry(connector,
        &amp;dev-&gt;mode_config.connector_list, head) {<br>
        =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!connector-=
&gt;encoder)<br>
        =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 continue;<br>
        =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*<br>
        =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * on=
e crtc only has one connector in my case, so just
        find the first connector at list.<br>
        =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */<b=
r>
        =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (connector-&=
gt;encoder-&gt;crtc =3D=3D crtc)<br>
        =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;<br>
        =C2=A0=C2=A0=C2=A0 }<br>
        <br>
        =C2=A0=C2=A0=C2=A0 if (!connector)<br>
        =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
urn -EINVAL;<br>
        <br>
        =C2=A0=C2=A0=C2=A0 return connector-&gt;connector_type;<br>
        } </blockquote>
      Oh, sorry, forgot to drop this comment, <br>
      for connector type problem, I try to new a help function for
      encoder to call as Daniel advices.<br>
      <blockquote cite=3D"mid:5423D951.4030703@rock-chips.com" type=3D"ci=
te">
        <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
          type=3D"cite">
          <blockquote type=3D"cite">
            <pre wrap=3D"">
+#define to_rockchip_plane(x) container_of(x, struct rockchip_plane, base=
)
+
+struct rockchip_plane {
+       int id;
+       struct drm_plane base;
+       const struct vop_win *win;
+       struct vop_context *ctx;
</pre>
          </blockquote>
        </blockquote>
        <blockquote
cite=3D"mid:CAGS+omBKKktuqOfiek0VN5Nk6KGC64Yc7i_HbM=3DWf3gyJZC8bw@mail.gm=
ail.com"
          type=3D"cite">
          <blockquote type=3D"cite"> </blockquote>
          <pre wrap=3D"">Isn't ctx just: to_vop_ctx(base-&gt;crtc)

</pre>
        </blockquote>
        OK. we can use to_vop_ctx(base-&gt;crtc) to get ctx. </blockquote=
>
      I have do a test to use "to_vop_ctx(base-&gt;crtc)", but found
      that "base-&gt;crtc" maybe not init.<br>
      for cursor plane, base-&gt;crtc always is NULL. and disable_plane
      will fail.<br>
      maybe we can add "base-&gt;crtc =3D crtc" at update_plane, but it
      seems not good.<br>
      so I think still use "rockchip_plane-&gt;ctx" would be better.<br>
      <br>
      -Mark<br>
    </blockquote>
    I found that: plane-&gt;crtc will be set if update_plane success,
    and will be set NULL if disable_plane <span style=3D"color: rgb(51,
      51, 51); font-family: arial; font-size: 14px; font-style: normal;
      font-variant: normal; font-weight: normal; letter-spacing: normal;
      line-height: 22px; orphans: auto; text-align: start; text-indent:
      0px; text-transform: none; white-space: normal; widows: auto;
      word-spacing: 0px; -webkit-text-stroke-width: 0px;
      background-color: rgb(255, 255, 255); display: inline !important;
      float: none;"></span>success.<br>
    so disable_plane must after update_plane.<br>
    disable_plane get crtc=3D=3DNULL problem is that disable_plane was
    called before update_plane or been called=C2=A0 twice.<br>
    for this reason we can just check if crtc is NULL at disable_plane.<b=
r>
    <br>
    -Mark<br>
    <br>
    <br>
    <br>
    <br>
  </body>
</html>

--------------040503080203000708080305--


--===============1769245416==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel

--===============1769245416==--
