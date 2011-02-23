From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/5] firmware: Basic dmi-sysfs support
Date: Wed, 23 Feb 2011 12:28:46 -0800
Message-ID: <AANLkTi=+-Wc0bWdpvR+X6UszLf7MXKYgi8Oo6anN-jR8@mail.gmail.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
 <20110223015320.13068.77428.stgit@mike.mtv.corp.google.com> <AANLkTinjhY3oiFTq2xq4fwQ-mtLZ8ph435+nc5irM7wZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0cd2bd1ccb90e6049cf8f2df
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinjhY3oiFTq2xq4fwQ-mtLZ8ph435+nc5irM7wZ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Robert Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

--000e0cd2bd1ccb90e6049cf8f2df
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 23, 2011 at 11:43 AM, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Feb 22, 2011 at 5:53 PM, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> +static void __init dmi_sysfs_register_handle(const struct dmi_header *d=
h,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0void *_ret)
>> +{
>
> I'm seeing some unaligned references from this function
> on ia64. =A0Code is loading a 2-byte value from an odd
> address. We are dereferencing "dh", so looking at the
> dmi_header definition, I'd have thought that we must
> be touching dh->handle:
>
> struct dmi_header {
> =A0 =A0 =A0 =A0u8 type;
> =A0 =A0 =A0 =A0u8 length;
> =A0 =A0 =A0 =A0u16 handle;
> };
>
> I don't see any code in this function that does this,
> so I assume there is some inlining or macro stuff
> happening.

Ya, I don't think there is anything that guarantees that dmi_header is
aligned.   The access is probably the struct copy I did here:

        /* Set the key */
        entry->dh =3D *dh;

What if we changed that guy to use memcpy?  We'd probably need to
memcpy the dmi_system_event_log as well.  Patch attached (applies on
top of the entire patchset).

--000e0cd2bd1ccb90e6049cf8f2df
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkip513f0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZmlybXdhcmUvZG1pLXN5c2ZzLmMgYi9kcml2ZXJzL2Zpcm13
YXJlL2RtaS1zeXNmcy5jCmluZGV4IGE1YWZkODAuLmViMjZkNjIgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvZmlybXdhcmUvZG1pLXN5c2ZzLmMKKysrIGIvZHJpdmVycy9maXJtd2FyZS9kbWktc3lzZnMu
YwpAQCAtMjYzLDIwICsyNjMsMTYgQEAgc3RydWN0IGRtaV9zeXN0ZW1fZXZlbnRfbG9nIHsKIAl1
OAlzdXBwb3J0ZWRfbG9nX3R5cGVfZGVzY3JpcHRvc1swXTsKIH0gX19wYWNrZWQ7CiAKLXN0YXRp
YyBjb25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9ldmVudF9sb2cgKnRvX3NlbChjb25zdCBzdHJ1Y3Qg
ZG1pX2hlYWRlciAqZGgpCi17Ci0JcmV0dXJuIChjb25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9ldmVu
dF9sb2cgKilkaDsKLX0KLQogI2RlZmluZSBETUlfU1lTRlNfU0VMX0ZJRUxEKF9maWVsZCkgXAog
c3RhdGljIHNzaXplX3QgZG1pX3N5c2ZzX3NlbF8jI19maWVsZChzdHJ1Y3QgZG1pX3N5c2ZzX2Vu
dHJ5ICplbnRyeSwgXAogCQkJCSAgICAgIGNvbnN0IHN0cnVjdCBkbWlfaGVhZGVyICpkaCwgXAog
CQkJCSAgICAgIGNoYXIgKmJ1ZikgXAogeyBcCi0JY29uc3Qgc3RydWN0IGRtaV9zeXN0ZW1fZXZl
bnRfbG9nICpzZWwgPSB0b19zZWwoZGgpOyBcCi0JaWYgKHNpemVvZigqc2VsKSA+IGRtaV9lbnRy
eV9sZW5ndGgoZGgpKSBcCisJc3RydWN0IGRtaV9zeXN0ZW1fZXZlbnRfbG9nIHNlbDsgXAorCWlm
IChzaXplb2Yoc2VsKSA+IGRtaV9lbnRyeV9sZW5ndGgoZGgpKSBcCiAJCXJldHVybiAtRUlPOyBc
Ci0JcmV0dXJuIHNwcmludGYoYnVmLCAiJXVcbiIsIHNlbC0+X2ZpZWxkKTsgXAorCW1lbWNweSgm
c2VsLCBkaCwgc2l6ZW9mKHNlbCkpOyBcCisJcmV0dXJuIHNwcmludGYoYnVmLCAiJXVcbiIsIHNl
bC5fZmllbGQpOyBcCiB9IFwKIHN0YXRpYyBETUlfU1lTRlNfTUFQUEVEX0FUVFIoc2VsLCBfZmll
bGQpCiAKQEAgLTQwMywyNiArMzk5LDI4IEBAIHN0YXRpYyBzc2l6ZV90IGRtaV9zZWxfcmF3X3Jl
YWRfaGVscGVyKHN0cnVjdCBkbWlfc3lzZnNfZW50cnkgKmVudHJ5LAogCQkJCSAgICAgICB2b2lk
ICpfc3RhdGUpCiB7CiAJc3RydWN0IGRtaV9yZWFkX3N0YXRlICpzdGF0ZSA9IF9zdGF0ZTsKLQlj
b25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9ldmVudF9sb2cgKnNlbCA9IHRvX3NlbChkaCk7CisJc3Ry
dWN0IGRtaV9zeXN0ZW1fZXZlbnRfbG9nIHNlbDsKIAotCWlmIChzaXplb2YoKnNlbCkgPiBkbWlf
ZW50cnlfbGVuZ3RoKGRoKSkKKwlpZiAoc2l6ZW9mKHNlbCkgPiBkbWlfZW50cnlfbGVuZ3RoKGRo
KSkKIAkJcmV0dXJuIC1FSU87CiAKLQlzd2l0Y2ggKHNlbC0+YWNjZXNzX21ldGhvZCkgeworCW1l
bWNweSgmc2VsLCBkaCwgc2l6ZW9mKHNlbCkpOworCisJc3dpdGNoIChzZWwuYWNjZXNzX21ldGhv
ZCkgewogCWNhc2UgRE1JX1NFTF9BQ0NFU1NfTUVUSE9EX0lPODoKIAljYXNlIERNSV9TRUxfQUND
RVNTX01FVEhPRF9JTzJ4ODoKIAljYXNlIERNSV9TRUxfQUNDRVNTX01FVEhPRF9JTzE2OgotCQly
ZXR1cm4gZG1pX3NlbF9yYXdfcmVhZF9pbyhlbnRyeSwgc2VsLCBzdGF0ZS0+YnVmLAorCQlyZXR1
cm4gZG1pX3NlbF9yYXdfcmVhZF9pbyhlbnRyeSwgJnNlbCwgc3RhdGUtPmJ1ZiwKIAkJCQkJICAg
c3RhdGUtPnBvcywgc3RhdGUtPmNvdW50KTsKIAljYXNlIERNSV9TRUxfQUNDRVNTX01FVEhPRF9Q
SFlTMzI6Ci0JCXJldHVybiBkbWlfc2VsX3Jhd19yZWFkX3BoeXMzMihlbnRyeSwgc2VsLCBzdGF0
ZS0+YnVmLAorCQlyZXR1cm4gZG1pX3NlbF9yYXdfcmVhZF9waHlzMzIoZW50cnksICZzZWwsIHN0
YXRlLT5idWYsCiAJCQkJCSAgICAgICBzdGF0ZS0+cG9zLCBzdGF0ZS0+Y291bnQpOwogCWNhc2Ug
RE1JX1NFTF9BQ0NFU1NfTUVUSE9EX0dQTlY6CiAJCXByX2luZm8oImRtaS1zeXNmczogR1BOViBz
dXBwb3J0IG1pc3NpbmcuXG4iKTsKIAkJcmV0dXJuIC1FSU87CiAJZGVmYXVsdDoKIAkJcHJfaW5m
bygiZG1pLXN5c2ZzOiBVbmtub3duIGFjY2VzcyBtZXRob2QgJTAyeFxuIiwKLQkJCXNlbC0+YWNj
ZXNzX21ldGhvZCk7CisJCQlzZWwuYWNjZXNzX21ldGhvZCk7CiAJCXJldHVybiAtRUlPOwogCX0K
IH0KQEAgLTU5NSw3ICs1OTMsNyBAQCBzdGF0aWMgdm9pZCBfX2luaXQgZG1pX3N5c2ZzX3JlZ2lz
dGVyX2hhbmRsZShjb25zdCBzdHJ1Y3QgZG1pX2hlYWRlciAqZGgsCiAJfQogCiAJLyogU2V0IHRo
ZSBrZXkgKi8KLQllbnRyeS0+ZGggPSAqZGg7CisJbWVtY3B5KCZlbnRyeS0+ZGgsIGRoLCBzaXpl
b2YoKmRoKSk7CiAJZW50cnktPmluc3RhbmNlID0gaW5zdGFuY2VfY291bnRzW2RoLT50eXBlXSsr
OwogCWVudHJ5LT5wb3NpdGlvbiA9IHBvc2l0aW9uX2NvdW50Kys7CiAK
--000e0cd2bd1ccb90e6049cf8f2df--
