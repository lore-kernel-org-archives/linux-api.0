From: Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>
Subject: Re: [PATCH v15 1/3] drm: rockchip: Add basic drm driver
Date: Thu, 17 Mar 2016 14:49:46 +0100
Message-ID: <CAAObsKAv+05ih5U+=4kic_NsjGMhfxYheHR8xXXmacZs+p5SHw@mail.gmail.com>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com>
 <1417511739-7141-1-git-send-email-mark.yao@rock-chips.com>
 <CAAObsKANPWAHdoFG3SHK_RAwzZ6d=TVKGZP8ukk3a6CxewOajw@mail.gmail.com>
 <56E765AE.1000606@rock-chips.com> <CAAObsKCQhfofhycAC9B2ApkD5o+9BnxE4yzR+DWjfZNc1hhSug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7bb04faa7cadc9052e3ee8aa
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAObsKCQhfofhycAC9B2ApkD5o+9BnxE4yzR+DWjfZNc1hhSug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api@>
List-Id: linux-api@vger.kernel.org

--047d7bb04faa7cadc9052e3ee8aa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 16 March 2016 at 16:23, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org> wrote:
> On 15 March 2016 at 02:30, Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote:
>> On 2016=E5=B9=B403=E6=9C=8814=E6=97=A5 21:35, Tomeu Vizoso wrote:
>>>
>>> On 2 December 2014 at 10:15, Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org> wrote:
>>>>
>>>> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>>>> b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>>>> new file mode 100644
>>>> index 0000000..e7ca25b
>>>> --- /dev/null
>>>> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>>>> @@ -0,0 +1,1455 @@
>>>
>>> ...
>>>>
>>>> +static bool vop_crtc_mode_fixup(struct drm_crtc *crtc,
>>>> +                               const struct drm_display_mode *mode,
>>>> +                               struct drm_display_mode *adjusted_mode=
)
>>>> +{
>>>> +       if (adjusted_mode->htotal =3D=3D 0 || adjusted_mode->vtotal =
=3D=3D 0)
>>>> +               return false;
>>>
>>> Hi Mark,
>>>
>>> what's the rationale for this?
>>>
>>> Disabling a CRTC as in [0] will cause mode_fixup() to be called with
>>> an empty mode, failing that test.
>>>
>>> Removing the check seems to get things working fine for a short while,
>>> but a later modeset invariably gets the VOP to hang (as reported by
>>> [1]).
>>>
>>> Do you know why that check was put in place and what exactly could be
>>> causing the hw to hang?
>>>
>>> [0]
>>> https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/tree/lib/igt_kms.=
c#n1616
>>> [1]
>>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/d=
rivers/gpu/drm/rockchip/rockchip_drm_vop.c#n873
>>>
>>> Thanks,
>>>
>>> Tomeu
>>>
>> Hi Tomeu
>>
>> Just thinking that "adjusted_mode->htotal =3D=3D 0 || adjusted_mode->vto=
tal =3D=3D
>> 0" is not a good mode for vop.
>
> Ah, ok. Guess it should be removed then so we don't break userspace?
>
>> And you said VOP hang, only WARN_ON error message? or system hang, die?
>
> Sorry, the symptom was only the warning, I just went a bit too far and
> assumed the VOP had stopped working at all.
>
>> I think maybe crtc disable too fast, vblank is off, then no one can feed=
 the
>> wait_update_complete.
>> Can you test it again with following patch?
>
> Actually, in today's testing I don't see that happening any more,
> sorry about that :/
>
> What I have been looking at today is a related issue when running the
> kms_flip_event_leak test from intel-gpu-tools. If I remove the check
> mentioned above so CRTCs can be disabled with the SetCRTC IOCTL, I see
> this page fault the second and subsequent times I run the test.
>
> [   75.809031] rk_iommu ff930300.iommu: Page fault at 0x01000000 of type =
read
> [   75.809035] rk_iommu ff930300.iommu: iova =3D 0x01000000: dte_index:
> 0x4 pte_index: 0x0 page_offset: 0x0
> [   75.809040] rk_iommu ff930300.iommu: mmu_dte_addr: 0x2c258000
> dte@0x2c258010: 0x2c561001 valid: 1 pte@0x2c561000: 0x2a000006 valid:
> 0 page@0x00000000 flags: 0x0
> [   76.951288] rk_iommu ff930300.iommu: Enable stall request timed
> out, status: 0x00004b
>
> I have written a smaller standalone test that is attached in case you
> want to check it out, but I haven't been able to find out why it only
> happens when the test is rerun.
>
> Apparently the VOP is still trying to read a BO (0x01000000) right
> when the kernel frees it, but from what I can see, it should be
> scanning another BO at that point.
>
> Do you have any ideas on what could be happening?

Apparently, when the VOP is re-enabled, it will start scanning from
the framebuffer address that had been set last.

Because DMA addresses are recycled and there's going to be a low
number of framebuffers, this isn't going to be obvious unless we make
sure that there isn't a FB allocated at that DMA address any more.

The attached test case does just that.

Regards,

Tomeu

> Thanks,
>
> Tomeu
>
>> drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>> @@ -503,6 +503,8 @@ static void vop_crtc_disable(struct drm_crtc *crtc)
>>         if (!vop->is_enabled)
>>                 return;
>>  +       vop_crtc_wait_for_update(crtc);
>> +
>>         drm_crtc_vblank_off(crtc);
>>
>> Thanks.
>>
>> --
>> =EF=BC=ADark Yao
>>
>>

--047d7bb04faa7cadc9052e3ee8aa
Content-Type: text/x-csrc; charset=US-ASCII; name="page_fault.c"
Content-Disposition: attachment; filename="page_fault.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ilwc2p6j1

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
fQoKaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQp7CglpbnQgcmV0OwoJaW50IGZkOwoJ
aW50IGNydGMgPSAyNTsKCWludCBjb25uID0gMjk7CglpbnQgYm8xLCBmYjEsIGJvMiwgZmIyOwoJ
ZHJtTW9kZU1vZGVJbmZvICptb2RlOwoKCWttc2coIi0tLS0tLS0tLS0tLS0gc3RhcnQgLS0tLS0t
LS0tLS0tLS0tLVxuIik7CgoJZmQgPSBvcGVuKCIvZGV2L2RyaS9jYXJkMCIsIE9fUkRXUik7CgoJ
cmV0ID0gZHJtU2V0TWFzdGVyKGZkKTsKCglrbXNnKCIlczogcGlwZSAlZCBjb25uICVkIGNydGMg
JWRcbiIsIF9fZnVuY19fLCBwaXBlLCBjb25uLCBjcnRjKTsKCglibzEgPSBkdW1iX2NyZWF0ZShm
ZCwgMTkyMCwgMTA4MCwgNCAqIDgpOwoJa21zZygiZHVtYl9jcmVhdGUgMTogJWRcbiIsIGJvMSk7
CgoJZmIxID0gZmJfY3JlYXRlKGZkLCAxOTIwLCAxMDgwLCBEUk1fRk9STUFUX1hSR0I4ODg4LCBi
bzEsIDE5MjAgKiA0KTsKCWttc2coImZiX2NyZWF0ZSAxOiAlZFxuIiwgZmIxKTsKCgltb2RlID0g
Y29ubmVjdG9yX2dldF9kZWZhdWx0X21vZGUoZmQsIGNvbm4pOwoJa21zZygiY29ubmVjdG9yX2dl
dF9kZWZhdWx0X21vZGU6ICVzXG4iLCBtb2RlLT5uYW1lKTsKCglyZXQgPSBkcm1Nb2RlU2V0Q3J0
YyhmZCwKCQkJICAgICBjcnRjLAoJCQkgICAgIGZiMSwKCQkJICAgICAwLCAwLCAvKiB4LCB5ICov
CgkJCSAgICAgJmNvbm4sIC8qIGNvbm5lY3RvcnMgKi8KCQkJICAgICAxLCAgICAvKiBuX2Nvbm5l
Y3RvcnMgKi8KCQkJICAgICBtb2RlICAvKiBtb2RlICovKTsKCWttc2coImRybU1vZGVTZXRDcnRj
OiAlZFxuIiwgcmV0KTsKCglyZXQgPSBkcm1Nb2RlU2V0Q3J0YyhmZCwKCQkJICAgICBjcnRjLAoJ
CQkgICAgIGZiMSwKCQkJICAgICAwLCAwLCAvKiB4LCB5ICovCgkJCSAgICAgTlVMTCwgLyogY29u
bmVjdG9ycyAqLwoJCQkgICAgIDAsICAgIC8qIG5fY29ubmVjdG9ycyAqLwoJCQkgICAgIE5VTEwg
IC8qIG1vZGUgKi8pOwoKCS8qIENyZWF0ZSBhIHNlY29uZCBCTyBiZWZvcmUgZGVzdHJveWluZyB0
aGUgZmlyc3Qgb25lLCBzbyBpdCBoYXMgYQoJICogZGlmZmVyZW50IERNQSBhZGRyZXNzCgkgKi8K
CWJvMiA9IGR1bWJfY3JlYXRlKGZkLCAxOTIwLCAxMDgwLCA0ICogOCk7CglrbXNnKCJkdW1iX2Ny
ZWF0ZSAyOiAlZFxuIiwgYm8yKTsKCglmYjIgPSBmYl9jcmVhdGUoZmQsIDE5MjAsIDEwODAsIERS
TV9GT1JNQVRfWFJHQjg4ODgsIGJvMiwgMTkyMCAqIDQpOwoJa21zZygiZmJfY3JlYXRlIDI6ICVk
XG4iLCBmYjIpOwoKCS8qIE1ha2Ugc3VyZSB3ZSBkb24ndCBob2xkIGEgcmVmZXJlbmNlIHRvIHRo
ZSBmaXJzdCBCTyAqLwoJcmV0ID0gZHJtTW9kZVJtRkIoZmQsIGZiMSk7CglrbXNnKCJkcm1Nb2Rl
Um1GQjogJWRcbiIsIHJldCk7CgkKCXJldCA9IGR1bWJfZGVzdHJveShmZCwgYm8xKTsKCWttc2co
ImR1bWJfZGVzdHJveTogJWRcbiIsIHJldCk7CgoJLyogVGhlIENSVEMgd2lsbCBiZSBlbmFibGVk
IHdpdGggdGhlIG9sZCBjb25maWd1cmF0aW9uIGFuZCB0aGUgVk9QCgkgKiB3aWxsIHRyeSB0byBy
ZWFkIGZyb20gdGhlIGZpcnN0IEJPLgoJICovCglyZXQgPSBkcm1Nb2RlU2V0Q3J0YyhmZCwKCQkJ
ICAgICBjcnRjLAoJCQkgICAgIGZiMiwKCQkJICAgICAwLCAwLCAvKiB4LCB5ICovCgkJCSAgICAg
JmNvbm4sIC8qIGNvbm5lY3RvcnMgKi8KCQkJICAgICAxLCAgICAvKiBuX2Nvbm5lY3RvcnMgKi8K
CQkJICAgICBtb2RlICAvKiBtb2RlICovKTsKCWttc2coImRybU1vZGVTZXRDcnRjOiAlZFxuIiwg
cmV0KTsKCQoJcmV0ID0gZHJtRHJvcE1hc3RlcihmZCk7CgoJY2xvc2UoZmQpOwoKCWttc2coIi0t
LS0tLS0tLS0tLS0tIGVuZCAtLS0tLS0tLS0tLS0tLS0tLVxuIik7CgoJcmV0dXJuIDA7Cn0K
--047d7bb04faa7cadc9052e3ee8aa--
