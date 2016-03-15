From: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v15 1/3] drm: rockchip: Add basic drm driver
Date: Tue, 15 Mar 2016 09:30:22 +0800
Message-ID: <56E765AE.1000606@rock-chips.com>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com> <1417511739-7141-1-git-send-email-mark.yao@rock-chips.com> <CAAObsKANPWAHdoFG3SHK_RAwzZ6d=TVKGZP8ukk3a6CxewOajw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAObsKANPWAHdoFG3SHK_RAwzZ6d=TVKGZP8ukk3a6CxewOajw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>
Cc: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ap>
List-Id: linux-api@vger.kernel.org

On 2016=E5=B9=B403=E6=9C=8814=E6=97=A5 21:35, Tomeu Vizoso wrote:
> On 2 December 2014 at 10:15, Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote=
:
>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/g=
pu/drm/rockchip/rockchip_drm_vop.c
>> new file mode 100644
>> index 0000000..e7ca25b
>> --- /dev/null
>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>> @@ -0,0 +1,1455 @@
> ...
>> +static bool vop_crtc_mode_fixup(struct drm_crtc *crtc,
>> +                               const struct drm_display_mode *mode,
>> +                               struct drm_display_mode *adjusted_mo=
de)
>> +{
>> +       if (adjusted_mode->htotal =3D=3D 0 || adjusted_mode->vtotal =
=3D=3D 0)
>> +               return false;
> Hi Mark,
>
> what's the rationale for this?
>
> Disabling a CRTC as in [0] will cause mode_fixup() to be called with
> an empty mode, failing that test.
>
> Removing the check seems to get things working fine for a short while=
,
> but a later modeset invariably gets the VOP to hang (as reported by
> [1]).
>
> Do you know why that check was put in place and what exactly could be
> causing the hw to hang?
>
> [0] https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/tree/lib/ig=
t_kms.c#n1616
> [1] https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/=
tree/drivers/gpu/drm/rockchip/rockchip_drm_vop.c#n873
>
> Thanks,
>
> Tomeu
>
Hi Tomeu

Just thinking that "adjusted_mode->htotal =3D=3D 0 || adjusted_mode->vt=
otal=20
=3D=3D 0" is not a good mode for vop.

And you said VOP hang, only WARN_ON error message? or system hang, die?

I think maybe crtc disable too fast, vblank is off, then no one can fee=
d the wait_update_complete.
Can you test it again with following patch?
drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -503,6 +503,8 @@ static void vop_crtc_disable(struct drm_crtc *crtc)
         if (!vop->is_enabled)
                 return;
 =20
+       vop_crtc_wait_for_update(crtc);
+
         drm_crtc_vblank_off(crtc);

Thanks.

--=20
=EF=BC=ADark Yao


--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
