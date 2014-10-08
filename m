From: Mark yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v9 1/3] drm: rockchip: Add basic drm driver
Date: Wed, 08 Oct 2014 09:17:28 +0800
Message-ID: <543490A8.7030807@rock-chips.com>
References: <1412081870-27535-1-git-send-email-mark.yao@rock-chips.com>	
 <1412082181-27703-1-git-send-email-mark.yao@rock-chips.com>	
 <542AB0B2.6000207@samsung.com> <54336474.1010503@rock-chips.com>	
 <54338484.5070809@samsung.com> <1412720776.2797.8.camel@snewbury.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0643982502=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1412720776.2797.8.camel@snewbury.org.uk>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Steven Newbury <steve@snewbury.org.uk>, Andrzej Hajda <a.hajda@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>, heiko@sntech.de, linux-doc@vger.kernel.org, kever.yang@rock-chips.com, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, xjq@rock-chips.com, zyw@rock-chips.com, linux-api@vger.kernel.org, cym@rock-chips.com, linux-rockchip@lists.infradead.org, kfx@rock-chips.com, Grant Likely <grant.likely@linaro.org>, wxt@rock-chips.com, huangtao@rock-chips.com, devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, yxj@rock-chips.com, cf@rock-chips.com, Rob Herring <robh+dt@kernel.org>, marcheu@chromium.org, xxm@rock-chips.com, xw@rock-chips.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, dianders@chromium.org, Kumar Gala <galak@codeaurora.org>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--===============0643982502==
Content-Type: multipart/alternative;
 boundary="------------050904020308080707000201"

This is a multi-part message in MIME format.
--------------050904020308080707000201
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Steven
     I'm glad to see you to discuss about rk29xx.

On 2014=E5=B9=B410=E6=9C=8808=E6=97=A5 06:26, Steven Newbury wrote:
> I've just been discussing how this relates to rk29xx on #etnaviv.  I
> looked through the patch and it's good to see it's not limited to
> supporting Mali GPUs.  I see no reason this wouldn't be compatible
> with etna_viv for rk29xx (or future Rockchip designs with alternative
> GPUs) as long as the rest of the infrastructure to support rk29 is in
> place iommu (ARM SMMU?) driver, for example.
Now the drm driver only test on rk3288, and future when we add=20
compatible for rk29xx, we
would consider to add a non-iommu path for it.
> IMHO it's vital to keep a logical separation between the video display
> hardware and the graphics processor on SoCs.
Sure, the graphics processor maybe change in different solutions,=20
logical separation is that we
try to keep.
Regards
-=EF=BC=ADark

--------------050904020308080707000201
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta content=3D"text/html; charset=3DUTF-8" http-equiv=3D"Content-Ty=
pe">
  </head>
  <body text=3D"#000000" bgcolor=3D"#FFFFFF">
    <div class=3D"moz-cite-prefix">Hi Steven<br>
      =C2=A0=C2=A0=C2=A0 I'm glad to see you to discuss about rk29xx.<br>
      <br>
      On 2014=E5=B9=B410=E6=9C=8808=E6=97=A5 06:26, Steven Newbury wrote:=
<br>
    </div>
    <blockquote cite=3D"mid:1412720776.2797.8.camel@snewbury.org.uk"
      type=3D"cite">
      <pre wrap=3D"">I've just been discussing how this relates to rk29xx=
 on #etnaviv.  I=20
looked through the patch and it's good to see it's not limited to=20
supporting Mali GPUs.  I see no reason this wouldn't be compatible=20
with etna_viv for rk29xx (or future Rockchip designs with alternative=20
GPUs) as long as the rest of the infrastructure to support rk29 is in=20
place iommu (ARM SMMU?) driver, for example.
</pre>
    </blockquote>
    Now the drm driver only test on rk3288, and future when we add
    compatible for rk29xx, we<br>
    would consider to add a non-iommu path for it.<span style=3D"color:
      rgb(51, 51, 51); font-family: arial; font-size: 18px; font-style:
      normal; font-variant: normal; font-weight: normal; letter-spacing:
      normal; line-height: 22px; orphans: auto; text-align: start;
      text-indent: 0px; text-transform: none; white-space: normal;
      widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px;
      background-color: rgb(255, 255, 255); display: inline !important;
      float: none;"></span>
    <blockquote cite=3D"mid:1412720776.2797.8.camel@snewbury.org.uk"
      type=3D"cite">
      <pre wrap=3D"">
IMHO it's vital to keep a logical separation between the video display=20
hardware and the graphics processor on SoCs.
</pre>
    </blockquote>
    Sure, the graphics processor maybe change in different solutions,=C2=A0
    logical separation is that we<br>
    try to keep.<br>
    <blockquote cite=3D"mid:1412720776.2797.8.camel@snewbury.org.uk"
      type=3D"cite">
      <pre wrap=3D"">
</pre>
    </blockquote>
    Regards<br>
    -=EF=BC=ADark<br>
  </body>
</html>

--------------050904020308080707000201--


--===============0643982502==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel

--===============0643982502==--
