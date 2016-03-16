From: Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>
Subject: Re: [PATCH v15 1/3] drm: rockchip: Add basic drm driver
Date: Wed, 16 Mar 2016 16:23:58 +0100
Message-ID: <CAAObsKCQhfofhycAC9B2ApkD5o+9BnxE4yzR+DWjfZNc1hhSug@mail.gmail.com>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com>
 <1417511739-7141-1-git-send-email-mark.yao@rock-chips.com>
 <CAAObsKANPWAHdoFG3SHK_RAwzZ6d=TVKGZP8ukk3a6CxewOajw@mail.gmail.com> <56E765AE.1000606@rock-chips.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a114b095e869f4c052e2c1be4
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E765AE.1000606-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api@>
List-Id: linux-api@vger.kernel.org

--001a114b095e869f4c052e2c1be4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 15 March 2016 at 02:30, Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote:
> On 2016=E5=B9=B403=E6=9C=8814=E6=97=A5 21:35, Tomeu Vizoso wrote:
>>
>> On 2 December 2014 at 10:15, Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote:
>>>
>>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>>> b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>>> new file mode 100644
>>> index 0000000..e7ca25b
>>> --- /dev/null
>>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>>> @@ -0,0 +1,1455 @@
>>
>> ...
>>>
>>> +static bool vop_crtc_mode_fixup(struct drm_crtc *crtc,
>>> +                               const struct drm_display_mode *mode,
>>> +                               struct drm_display_mode *adjusted_mode)
>>> +{
>>> +       if (adjusted_mode->htotal =3D=3D 0 || adjusted_mode->vtotal =3D=
=3D 0)
>>> +               return false;
>>
>> Hi Mark,
>>
>> what's the rationale for this?
>>
>> Disabling a CRTC as in [0] will cause mode_fixup() to be called with
>> an empty mode, failing that test.
>>
>> Removing the check seems to get things working fine for a short while,
>> but a later modeset invariably gets the VOP to hang (as reported by
>> [1]).
>>
>> Do you know why that check was put in place and what exactly could be
>> causing the hw to hang?
>>
>> [0]
>> https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/tree/lib/igt_kms.c=
#n1616
>> [1]
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/dr=
ivers/gpu/drm/rockchip/rockchip_drm_vop.c#n873
>>
>> Thanks,
>>
>> Tomeu
>>
> Hi Tomeu
>
> Just thinking that "adjusted_mode->htotal =3D=3D 0 || adjusted_mode->vtot=
al =3D=3D
> 0" is not a good mode for vop.

Ah, ok. Guess it should be removed then so we don't break userspace?

> And you said VOP hang, only WARN_ON error message? or system hang, die?

Sorry, the symptom was only the warning, I just went a bit too far and
assumed the VOP had stopped working at all.

> I think maybe crtc disable too fast, vblank is off, then no one can feed =
the
> wait_update_complete.
> Can you test it again with following patch?

Actually, in today's testing I don't see that happening any more,
sorry about that :/

What I have been looking at today is a related issue when running the
kms_flip_event_leak test from intel-gpu-tools. If I remove the check
mentioned above so CRTCs can be disabled with the SetCRTC IOCTL, I see
this page fault the second and subsequent times I run the test.

[   75.809031] rk_iommu ff930300.iommu: Page fault at 0x01000000 of type re=
ad
[   75.809035] rk_iommu ff930300.iommu: iova =3D 0x01000000: dte_index:
0x4 pte_index: 0x0 page_offset: 0x0
[   75.809040] rk_iommu ff930300.iommu: mmu_dte_addr: 0x2c258000
dte@0x2c258010: 0x2c561001 valid: 1 pte@0x2c561000: 0x2a000006 valid:
0 page@0x00000000 flags: 0x0
[   76.951288] rk_iommu ff930300.iommu: Enable stall request timed
out, status: 0x00004b

I have written a smaller standalone test that is attached in case you
want to check it out, but I haven't been able to find out why it only
happens when the test is rerun.

Apparently the VOP is still trying to read a BO (0x01000000) right
when the kernel frees it, but from what I can see, it should be
scanning another BO at that point.

Do you have any ideas on what could be happening?

Thanks,

Tomeu

> drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> @@ -503,6 +503,8 @@ static void vop_crtc_disable(struct drm_crtc *crtc)
>         if (!vop->is_enabled)
>                 return;
>  +       vop_crtc_wait_for_update(crtc);
> +
>         drm_crtc_vblank_off(crtc);
>
> Thanks.
>
> --
> =EF=BC=ADark Yao
>
>

--001a114b095e869f4c052e2c1be4
Content-Type: text/x-csrc; charset=US-ASCII; name="page_fault.c"
Content-Disposition: attachment; filename="page_fault.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iluzt8250

I2luY2x1ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5jbHVkZSA8dW5pc3Rk
Lmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxkcm0u
aD4KI2luY2x1ZGUgPGRybV9mb3VyY2MuaD4KI2luY2x1ZGUgPHhmODZkcm0uaD4KI2luY2x1ZGUg
PHhmODZkcm1Nb2RlLmg+CgpfX2F0dHJpYnV0ZV9fKChmb3JtYXQocHJpbnRmLCAxLCAyKSkpCnN0
YXRpYyB2b2lkIGttc2coY29uc3QgY2hhciAqZm9ybWF0LCAuLi4pCiNkZWZpbmUgS0VSTl9FTUVS
CSI8MD4iCiNkZWZpbmUgS0VSTl9BTEVSVAkiPDE+IgojZGVmaW5lIEtFUk5fQ1JJVAkiPDI+Igoj
ZGVmaW5lIEtFUk5fRVJSCSI8Mz4iCiNkZWZpbmUgS0VSTl9XQVJOSU5HCSI8ND4iCiNkZWZpbmUg
S0VSTl9OT1RJQ0UJIjw1PiIKI2RlZmluZSBLRVJOX0lORk8JIjw2PiIKI2RlZmluZSBLRVJOX0RF
QlVHCSI8Nz4iCnsKCXZhX2xpc3QgYXA7CglGSUxFICpmaWxlOwoKCWZpbGUgPSBmb3BlbigiL2Rl
di9rbXNnIiwgInciKTsKCWlmIChmaWxlID09IE5VTEwpCgkJcmV0dXJuOwoKCXZhX3N0YXJ0KGFw
LCBmb3JtYXQpOwoJZnByaW50ZihmaWxlLCAidXNlcnNwYWNlOiAiKTsKCXZmcHJpbnRmKGZpbGUs
IGZvcm1hdCwgYXApOwoJdmFfZW5kKGFwKTsKCglmY2xvc2UoZmlsZSk7Cn0KCnN0YXRpYyB1aW50
MzJfdCBkdW1iX2NyZWF0ZShpbnQgZmQsIGludCB3aWR0aCwgaW50IGhlaWdodCwgaW50IGJwcCkK
ewoJc3RydWN0IGRybV9tb2RlX2NyZWF0ZV9kdW1iIGNyZWF0ZSA9IHt9OwoKCWNyZWF0ZS53aWR0
aCA9IHdpZHRoOwoJY3JlYXRlLmhlaWdodCA9IGhlaWdodDsKCWNyZWF0ZS5icHAgPSBicHA7CgoJ
Y3JlYXRlLmhhbmRsZSA9IDA7Cglkcm1Jb2N0bChmZCwgRFJNX0lPQ1RMX01PREVfQ1JFQVRFX0RV
TUIsICZjcmVhdGUpOwoKCXJldHVybiBjcmVhdGUuaGFuZGxlOwp9CgpzdGF0aWMgdWludDMyX3Qg
ZmJfY3JlYXRlKGludCBmZCwgaW50IHdpZHRoLCBpbnQgaGVpZ2h0LCBpbnQgZm9ybWF0LCBpbnQg
Ym8sIGludCBwaXRjaCkKewoJc3RydWN0IGRybV9tb2RlX2ZiX2NtZDIgZiA9IHt9OwoKCWYud2lk
dGggPSB3aWR0aDsKCWYuaGVpZ2h0ID0gaGVpZ2h0OwoJZi5waXhlbF9mb3JtYXQgPSBmb3JtYXQ7
CglmLmhhbmRsZXNbMF0gPSBibzsKCWYucGl0Y2hlc1swXSA9IHBpdGNoOwoJZi5mYl9pZCA9IDA7
CgoJZHJtSW9jdGwoZmQsIERSTV9JT0NUTF9NT0RFX0FEREZCMiwgJmYpOwoKCXJldHVybiBmLmZi
X2lkOwp9Cgpkcm1Nb2RlTW9kZUluZm8gKmNvbm5lY3Rvcl9nZXRfZGVmYXVsdF9tb2RlKGludCBm
ZCwgaW50IGNvbm5faWQpCnsKCWRybU1vZGVDb25uZWN0b3JQdHIgY29ubjsKCWludCBpOwogCglj
b25uID0gZHJtTW9kZUdldENvbm5lY3RvckN1cnJlbnQoZmQsIGNvbm5faWQpOwoKCWZvciAoaSA9
IDA7IGkgPCBjb25uLT5jb3VudF9tb2RlczsgaSsrKSB7CgkJaWYgKGNvbm4tPm1vZGVzW2ldLnR5
cGUgJiBEUk1fTU9ERV9UWVBFX1BSRUZFUlJFRCkKCQkJcmV0dXJuICZjb25uLT5tb2Rlc1tpXTsK
CX0KCn0KCnN0YXRpYyBpbnQgZHVtYl9kZXN0cm95KGludCBmZCwgdWludDMyX3QgYm8pCnsKCXN0
cnVjdCBkcm1fbW9kZV9kZXN0cm95X2R1bWIgYXJnID0ge307CgoJYXJnLmhhbmRsZSA9IGJvOwoK
CXJldHVybiBkcm1Jb2N0bChmZCwgRFJNX0lPQ1RMX01PREVfREVTVFJPWV9EVU1CLCAmYXJnKTsK
fQoKdm9pZCB0ZXN0X3BpcGUoaW50IGZkLCBpbnQgcGlwZSwgaW50IGNvbm4sIGludCBjcnRjKQp7
CglpbnQgcmV0LCBibzEsIGZiMSwgYm8yLCBmYjI7Cglkcm1Nb2RlTW9kZUluZm8gKm1vZGU7Cglk
cm1WQmxhbmsgd2FpdF92YmwgPSB7fTsKCglrbXNnKCIlczogcGlwZSAlZCBjb25uICVkIGNydGMg
JWRcbiIsIF9fZnVuY19fLCBwaXBlLCBjb25uLCBjcnRjKTsKCglibzEgPSBkdW1iX2NyZWF0ZShm
ZCwgMTkyMCwgMTA4MCwgNCAqIDgpOwoJa21zZygiZHVtYl9jcmVhdGU6ICVkXG4iLCBibzEpOwoK
CWZiMSA9IGZiX2NyZWF0ZShmZCwgMTkyMCwgMTA4MCwgRFJNX0ZPUk1BVF9YUkdCODg4OCwgYm8x
LCAxOTIwICogNCk7CglrbXNnKCJmYl9jcmVhdGU6ICVkXG4iLCBmYjEpOwoKCW1vZGUgPSBjb25u
ZWN0b3JfZ2V0X2RlZmF1bHRfbW9kZShmZCwgY29ubik7CglrbXNnKCJjb25uZWN0b3JfZ2V0X2Rl
ZmF1bHRfbW9kZTogJXNcbiIsIG1vZGUtPm5hbWUpOwoKCXJldCA9IGRybU1vZGVTZXRDcnRjKGZk
LAoJCQkgICAgIGNydGMsCgkJCSAgICAgZmIxLAoJCQkgICAgIDAsIDAsIC8qIHgsIHkgKi8KCQkJ
ICAgICAmY29ubiwgLyogY29ubmVjdG9ycyAqLwoJCQkgICAgIDEsICAgIC8qIG5fY29ubmVjdG9y
cyAqLwoJCQkgICAgIG1vZGUgIC8qIG1vZGUgKi8pOwoJa21zZygiZHJtTW9kZVNldENydGM6ICVk
XG4iLCByZXQpOwoKCXdhaXRfdmJsLnJlcXVlc3QudHlwZSA9IHBpcGUgPDwgRFJNX1ZCTEFOS19I
SUdIX0NSVENfU0hJRlQgfAoJCQkJRFJNX1ZCTEFOS19SRUxBVElWRTsKCXdhaXRfdmJsLnJlcXVl
c3Quc2VxdWVuY2UgPSAxOwoKCXJldCA9IGRybVdhaXRWQmxhbmsoZmQsICZ3YWl0X3ZibCk7Cglr
bXNnKCJkcm1XYWl0VkJsYW5rOiAlZFxuIiwgcmV0KTsKCglibzIgPSBkdW1iX2NyZWF0ZShmZCwg
MTkyMCwgMTA4MCwgNCAqIDgpOwoJa21zZygiZHVtYl9jcmVhdGU6ICVkXG4iLCBibzIpOwoKCWZi
MiA9IGZiX2NyZWF0ZShmZCwgMTkyMCwgMTA4MCwgRFJNX0ZPUk1BVF9YUkdCODg4OCwgYm8yLCAx
OTIwICogNCk7CglrbXNnKCJmYl9jcmVhdGU6ICVkXG4iLCBmYjIpOwoKCXJldCA9IGRybU1vZGVQ
YWdlRmxpcChmZCwgY3J0YywgZmIyLCBEUk1fTU9ERV9QQUdFX0ZMSVBfRVZFTlQsIE5VTEwpOwoJ
a21zZygiZHJtTW9kZVBhZ2VGbGlwOiAlZFxuIiwgcmV0KTsKCQoJcmV0ID0gZHVtYl9kZXN0cm95
KGZkLCBibzIpOwoJa21zZygiZHVtYl9kZXN0cm95OiAlZFxuIiwgcmV0KTsKCQoJcmV0ID0gZHJt
TW9kZVJtRkIoZmQsIGZiMik7CglrbXNnKCJkcm1Nb2RlUm1GQjogJWRcbiIsIHJldCk7CgoJcmV0
ID0gZHVtYl9kZXN0cm95KGZkLCBibzEpOwoJa21zZygiZHVtYl9kZXN0cm95OiAlZFxuIiwgcmV0
KTsKCglyZXQgPSBkcm1Nb2RlUm1GQihmZCwgZmIxKTsKCWttc2coImRybU1vZGVSbUZCOiAlZFxu
IiwgcmV0KTsKfQoKaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQp7CglpbnQgcmV0OwoJ
aW50IGZkID0gb3BlbigiL2Rldi9kcmkvY2FyZDAiLCBPX1JEV1IpOwoKCXJldCA9IGRybVNldE1h
c3RlcihmZCk7CgoJdGVzdF9waXBlKGZkLCAwLCAyOSwgMjApOwoJdGVzdF9waXBlKGZkLCAxLCAy
OSwgMjUpOwoKCXJldCA9IGRybURyb3BNYXN0ZXIoZmQpOwoKCWNsb3NlKGZkKTsKCglyZXR1cm4g
MDsKfQo=
--001a114b095e869f4c052e2c1be4--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
