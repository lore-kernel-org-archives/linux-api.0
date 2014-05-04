From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: execve is not atomic, what is the exit state of the process when
 execve fails after throwing away the original process image?
Date: Sun, 4 May 2014 22:15:11 +0200
Message-ID: <CAKgNAkhaNAoFD1OEkh4MBxW3VxFQyEP+8x8yOUcocvPibTFh_A@mail.gmail.com>
References: <faa2c0e82f8a8.536300c8@langara.bc.ca> <20140503174510.GA7720@debjann.fritz.box>
 <faa0c9e9297ad.53656b4c@langara.bc.ca> <53669485.3020007@gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c13db238683104f898ad81
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53669485.3020007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--001a11c13db238683104f898ad81
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, May 4, 2014 at 9:27 PM, Michael Kerrisk (man-pages)
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> [CC+=3DRich Felker, because the discussion started with a reference to
> http://ewontfix.com/14/ ]
>
> On 05/04/2014 12:18 AM, Steven Stewart-Gallus wrote:
>>
>> ----- Original Message -----
>> From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
>> Date: Saturday, May 3, 2014 10:45 am
>> Subject: Re: execve is not atomic, what is the exit state of the process=
 when
>> execve fails after throwing away the original process image?
>> To: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
>> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>
>>> On Fri, May 02, 2014 at 02:19:52AM +0000, Steven Stewart-Gallus wrote:
>>>> execve is not atomic, what is the exit state of the process when
>>>> execve fails after throwing away the original process image?
>>>
>>> See http://lxr.free-electrons.com/source/fs/binfmt_elf.c#L740 or
>>> so =E2=80=93 as far as I know, the kernel sends a SIGKILL. Does that he=
lp?
>>
>> Thank you Jann
>> Horn. http://lxr.free-electrons.com/source/fs/binfmt_elf.c#L740
>> answers my question.
>>
>> On reflection, the kernel code makes sense. The process must either
>> exit with an error code or raise the SIGKILL signal because SIGKILL
>> and SIGSTOP are the only unblockable signals (of course, the kernel
>> has the privileges to do whatever it wants but it tries to be
>> consistent with userspace).
>>
>> Strangely, in other places the SIGSEGV is sent when the ELF file is
>> incorrect in some places and I don't fully understand that part of the
>> code. Still, I understand enough to look at the code in more detail
>> later.
>>
>> Thank you,
>> Steven Stewart-Gallus
>>
>> P.S.
>>
>> I'm CC'ing Michael because he wanted to know this case so could
>> document it.
>
> Fair enough. I plan to add the following text to the execve(2) man
> page:
>
>        In most cases where execve()  fails,  control  returns  to  the
>        original  executable image, and the caller of execve() can then
>        handle the error.  However, in (rare) cases  (typically  caused
>        by resource exhaustion), failure may occur past the point of no
>        return: the original exectable image has been  torn  down,  but
>        the  new  image  could not be completely built.  In such cases,
>        the kernel kills the process with a SIGKILL signal.
>
> Comments?

It turns out to be not too hard to trigger this case. See, for
example, the attached pair of programs, and the shell log below.

Cheers,

Michael

# Beware: if you try the below, the OOM killer may kill something random
# (Okay, not random: probably it'll be that hog firefox ;-).)

# Disable memory overvcommit (see proc(5))
$ sudo sh -c "echo 2 > /proc/sys/vm/overcommit_memory"

$ ./multi_fork_exec ./large_image
cnt =3D 0
cnt =3D 1
cnt =3D 2
cnt =3D 3
[...]
cnt =3D 213
cnt =3D 214
cnt =3D 215
    Child PID=3D26070
    Status: child killed by signal 9 (Killed)
    Child PID=3D26062
    Status: child killed by signal 9 (Killed)
    Child PID=3D26053
    Status: child killed by signal 9 (Killed)
    Child PID=3D25900
    Status: child killed by signal 9 (Killed)
[...]

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--001a11c13db238683104f898ad81
Content-Type: text/x-csrc; charset=US-ASCII; name="multi_fork_exec.c"
Content-Disposition: attachment; filename="multi_fork_exec.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_huss1br50

LyojKiBtdWx0aV9mb3JrX2V4ZWMuYyAKIAogICBVc2Ugd2l0aCBsYXJnZV9pbWFnZS5jIHRvIHRy
aWdnZXIgdGhpcyBleGVjdmUoKSBjYXNlOgoKCiAgICAgIEluIG1vc3QgY2FzZXMgd2hlcmUgZXhl
Y3ZlKCkgIGZhaWxzLCAgY29udHJvbCAgcmV0dXJucyAgdG8gIHRoZQogICAgICBvcmlnaW5hbCAg
ZXhlY3V0YWJsZSBpbWFnZSwgYW5kIHRoZSBjYWxsZXIgb2YgZXhlY3ZlKCkgY2FuIHRoZW4KICAg
ICAgaGFuZGxlIHRoZSBlcnJvci4gIEhvd2V2ZXIsIGluIChyYXJlKSBjYXNlcyAgKHR5cGljYWxs
eSAgY2F1c2VkCiAgICAgIGJ5IHJlc291cmNlIGV4aGF1c3Rpb24pLCBmYWlsdXJlIG1heSBvY2N1
ciBwYXN0IHRoZSBwb2ludCBvZiBubwogICAgICByZXR1cm46IHRoZSBvcmlnaW5hbCBleGVjdXRh
YmxlIGltYWdlIGhhcyBiZWVuIHRvcm4gIGRvd24sICBidXQKICAgICAgdGhlICBuZXcgIGltYWdl
ICBjb3VsZCBub3QgYmUgY29tcGxldGVseSBidWlsdC4gIEluIHN1Y2ggY2FzZXMsCiAgICAgIHRo
ZSBrZXJuZWwga2lsbHMgdGhlIHByb2Nlc3Mgd2l0aCBhIFNJR0tJTEwgc2lnbmFsLgoqLwovKiMq
KgogICBDaGFuZ2UgaGlzdG9yeQoKICAgMDQgTWF5IDE0CUluaXRpYWwgY3JlYXRpb24KKi8KI2Rl
ZmluZSBfR05VX1NPVVJDRSAgCiNpbmNsdWRlIDxzeXMvd2FpdC5oPgojaW5jbHVkZSA8c3RyaW5n
Lmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxz
dGRsaWIuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRl
IDxlcnJuby5oPgoKI2RlZmluZSBlcnJFeGl0KG1zZykgCWRvIHsgcGVycm9yKG1zZyk7IGV4aXQo
RVhJVF9GQUlMVVJFKTsgXAogICAgICAgICAgICAgICAgICAgICAgICB9IHdoaWxlICgwKQoKCnN0
YXRpYyB2b2lkIAkvKiBFeGFtaW5lIGEgd2FpdCgpIHN0YXR1cyB1c2luZyB0aGUgVyogbWFjcm9z
ICovCnByaW50V2FpdFN0YXR1cyhjb25zdCBjaGFyICptc2csIGludCBzdGF0dXMpCnsKICAgIGlm
IChtc2cgIT0gTlVMTCkKICAgICAgICBwcmludGYoIiVzIiwgbXNnKTsKCiAgICBpZiAoV0lGRVhJ
VEVEKHN0YXR1cykpIHsKICAgICAgICBwcmludGYoImNoaWxkIGV4aXRlZCwgc3RhdHVzPSVkXG4i
LCBXRVhJVFNUQVRVUyhzdGF0dXMpKTsKCiAgICB9IGVsc2UgaWYgKFdJRlNJR05BTEVEKHN0YXR1
cykpIHsKICAgICAgICBwcmludGYoImNoaWxkIGtpbGxlZCBieSBzaWduYWwgJWQgKCVzKSIsCiAg
ICAgICAgICAgICAgICBXVEVSTVNJRyhzdGF0dXMpLCBzdHJzaWduYWwoV1RFUk1TSUcoc3RhdHVz
KSkpOwojaWZkZWYgV0NPUkVEVU1QICAgIAkvKiBOb3QgaW4gU1VTdjMsIG1heSBiZSBhYnNlbnQg
b24gc29tZSBzeXN0ZW1zICovCiAgICAgICAgaWYgKFdDT1JFRFVNUChzdGF0dXMpKQogICAgICAg
ICAgICBwcmludGYoIiAoY29yZSBkdW1wZWQpIik7CiNlbmRpZgogICAgICAgIHByaW50ZigiXG4i
KTsKCiAgICB9IGVsc2UgaWYgKFdJRlNUT1BQRUQoc3RhdHVzKSkgewogICAgICAgIHByaW50Zigi
Y2hpbGQgc3RvcHBlZCBieSBzaWduYWwgJWQgKCVzKVxuIiwKICAgICAgICAgICAgICAgIFdTVE9Q
U0lHKHN0YXR1cyksIHN0cnNpZ25hbChXU1RPUFNJRyhzdGF0dXMpKSk7CgojaWZkZWYgV0lGQ09O
VElOVUVEIAkvKiBTVVN2MyBoYXMgdGhpcywgYnV0IG9sZGVyIExpbnV4IHZlcnNpb25zIGFuZAog
ICAgICAgICAgICAgICAgICAgICAgICAgICBzb21lIG90aGVyIFVOSVggaW1wbGVtZW50YXRpb25z
IGRvbid0ICovCiAgICB9IGVsc2UgaWYgKFdJRkNPTlRJTlVFRChzdGF0dXMpKSB7CiAgICAgICAg
cHJpbnRmKCJjaGlsZCBjb250aW51ZWRcbiIpOwojZW5kaWYKCiAgICB9IGVsc2UgewkJLyogU2hv
dWxkIG5ldmVyIGhhcHBlbiAqLwogICAgICAgIHByaW50Zigid2hhdCBoYXBwZW5lZCB0byB0aGlz
IGNoaWxkPyAoc3RhdHVzPSV4KVxuIiwKICAgICAgICAgICAgICAgICh1bnNpZ25lZCBpbnQpIHN0
YXR1cyk7CiAgICB9Cn0KCnN0YXRpYyB2b2lkICAgICAgICAgICAgIC8qIEhhbmRsZXIgZm9yIGNo
aWxkIHRlcm1pbmF0aW9uIHNpZ25hbCAqLwpncmltUmVhcGVyKGludCBzaWcpCnsgICAKICAgIGlu
dCBzdGF0dXM7ICAgICAgICAgICAgICAgICAvKiBDaGlsZCBzdGF0dXMgZnJvbSB3YWl0cGlkKCkg
Ki8KICAgIHBpZF90IHBpZDsKICAgIGludCBzYXZlZEVycm5vOwoKICAgIHNhdmVkRXJybm8gPSBl
cnJubzsKCiAgICB3aGlsZSAoKHBpZCA9IHdhaXRwaWQoLTEsICZzdGF0dXMsIDApKSA+IDApIHsK
ICAgICAgICBpZiAocGlkID09IC0xKQogICAgICAgICAgICAgICAgZXJyRXhpdCgid2FpdHBpZCIp
OwogICAgICAgIHByaW50ZigiXHRDaGlsZCBQSUQ9JWxkXG4iLCAobG9uZykgcGlkKTsKICAgICAg
ICBwcmludFdhaXRTdGF0dXMoIlx0U3RhdHVzOiAiLCBzdGF0dXMpOwogICAgfQogICAgZXJybm8g
PSBzYXZlZEVycm5vOwp9CgppbnQKbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltdKQp7CiAgICBp
bnQgY250OwogICAgcGlkX3QgY3BpZDsKICAgIHN0cnVjdCBzaWdhY3Rpb24gc2E7CgogICAgLyog
U2V0IHVwIGhhbmRsZXIgdG8gcmVhcCBkZWFkIGNoaWxkcmVuICovCgogICAgc2Euc2FfZmxhZ3Mg
PSAwOwogICAgc2Euc2FfaGFuZGxlciA9IGdyaW1SZWFwZXI7CiAgICBzaWdlbXB0eXNldCgmc2Eu
c2FfbWFzayk7CiAgICBpZiAoc2lnYWN0aW9uKFNJR0NITEQsICZzYSwgTlVMTCkgPT0gLTEpCiAg
ICAgICAgZXJyRXhpdCgic2lnYWN0aW9uIik7CgogICAgLyogQ3JlYXRlIG11bHRpcGxlIGNoaWxk
cmVuLCBlYWNoIG9mIHdoaWNoIGV4ZWNzIHRoZSBwcm9ncmFtIG5hbWVkIGluCiAgICAgICBhcmd2
WzFdICovCgogICAgZm9yIChjbnQgPSAwOyA7IGNudCsrKSB7CiAgICAgICAgcHJpbnRmKCJjbnQg
PSAlZFxuIiwgY250KTsKCiAgICAgICAgY3BpZCA9IGZvcmsoKTsKICAgICAgICBpZiAoY3BpZCA9
PSAtMSkKICAgICAgICAgICAgZXJyRXhpdCgiZm9yayIpOwoKICAgICAgICBpZiAoY3BpZCA9PSAw
KSB7CS8qIENoaWxkICovCiAgICAgICAgICAgIGV4ZWN2KGFyZ3ZbMV0sICZhcmd2WzFdKTsKICAg
ICAgICAgICAgZXJyRXhpdCgiZXhlY3YiKTsKICAgICAgICB9CgogICAgICAgIC8qIFBhcmVudCBj
b250aW51ZXMgcm91bmQgbG9vcCAqLwogICAgfQoKICAgIGV4aXQoRVhJVF9TVUNDRVNTKTsKfQo=
--001a11c13db238683104f898ad81
Content-Type: text/x-csrc; charset=US-ASCII; name="large_image.c"
Content-Disposition: attachment; filename="large_image.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_huss1je51

LyojKiBsYXJnZV9pbWFnZS5jIAoqLwovKiMqKgogICBDaGFuZ2UgaGlzdG9yeQoKICAgMDQgTWF5
IDE0CUluaXRpYWwgY3JlYXRpb24KKi8KI2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3Rk
bGliLmg+CgovKiBNYWtlIHRoaXMgaW1hZ2UgbGFyZ2UsIHRvIGNoZXcgdXAgYSBnb29kIGJpdCBv
ZiBSQU0vc3dhcCAqLwoKY2hhciBidWZbMTAwICogMTAwMCAqIDEwMDBdOwoKaW50Cm1haW4oaW50
IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkKewogICAgc2xlZXAoMzApOwogICAgZXhpdChFWElUX1NVQ0NF
U1MpOwp9Cg==
--001a11c13db238683104f898ad81--
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
