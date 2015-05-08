From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Fri, 08 May 2015 10:43:01 -0400
Message-ID: <554CCB75.2040108@gmail.com>
References: <1430949612-21356-1-git-send-email-zab@redhat.com> <20150507002617.GJ4327@dastard> <20150507172053.GA659@lenny.home.zabbo.net> <alpine.DEB.2.00.1505071752520.28239@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080309030200030901010807"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1505071752520.28239-vIokxiIdD2AQNTJnQDzGJqxOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080309030200030901010807
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-05-07 21:01, Sage Weil wrote:
> On Thu, 7 May 2015, Zach Brown wrote:
>> On Thu, May 07, 2015 at 10:26:17AM +1000, Dave Chinner wrote:
>>> On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
>>>> The criteria for using O_NOMTIME is the same as for using O_NOATIME:=

>>>> owning the file or having the CAP_FOWNER capability.  If we're not
>>>> comfortable allowing owners to prevent mtime/ctime updates then we
>>>> should add a tunable to allow O_NOMTIME.  Maybe a mount option?
>>>
>>> I dislike "turn off safety for performance" options because Joe
>>> SpeedRacer will always select performance over safety.
>>
>> Well, for ceph there's no safety concern.  They never use cmtime in
>> these files.
>>
>> So are you suggesting not implementing this and making them rework the=
ir
>> IO paths to avoid the fs maintaining mtime so that we don't give Joe
>> Speedracer more rope?  Or are we talking about adding some speed bumps=

>> that ceph can flip on that might give Joe Speedracer pause?
>
> I think this is the fundamental question: who do we give the ammunition=

> to, the user or app writer, or the sysadmin?
>
> One might argue that we gave the user a similar power with O_NOATIME (t=
he
> power to break applications that assume atime is accurate).  Here we gi=
ve
> developers/users the power to not update mtime and suffer the consequen=
ces
> (like, obviously, breaking mtime-based backups).  It should be pretty
> obvious to anyone using the flag what the consequences are.
The difference is that the only widely used program that uses atime for=20
anything is Mutt (and many people who don't use Mutt just disable=20
updating it altogether to improve performance), whereas mtime is used at =

the very least by many backup tools, and pretty much all NFSv{3,2}=20
clients, as well as a number of other pieces of software.
>
> Note that we can suffer similar lapses in mtime with fdatasync followed=
 by
> a system crash.  And as Andy points out it's semi-broken for writable
> mmap.  The crash case is obviously a slightly different thing, but the
> idea that mtime can't always be trusted certainly isn't crazy talk.
>
> Or, we can be conservative and require a mount option so that the admin=

> has to explicitly allow behavior that might break some existing
> assumptions about mtime/ctime ('-o user_noatime' I guess?).
Personally, I agree that there should be a mount option.  We should make =

sure to put a big fat warning about it in the manpage however,=20
irrespective of how it is controlled.
>
> I'm happy either way, so long as in the end an unprivileged ceph daemon=

> avoids the useless work.  In our case we always own the entire mount/di=
sk,
> so a mount option is just fine.
> Thanks!
> sage
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



--------------ms080309030200030901010807
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAxBuVTANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNTAz
MjUxOTM0MzhaFw0xNTA5MjExOTM0MzhaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCdD/zW
2rRAFCLnDfXpWxU1+ODqRVUgzHvrRO7ADUxRo1CBDc3JSX5TIW2OGmQ3DAKGOACp8Z0sgxMc
B05tzAZ/M7m4jajVrwwdVCdrwVGxTdAai7Kwg4ZCVfyMVhcwo8R2eW3QahBx34G0RKumK9sZ
ZQSQ+zULAzpY6uz7T1sAk/erMoivRXF6u8WvOsLkOD1F/Xyv1ZccSUG5YeDgZgc0nZUBvyIp
zXSHjgWerFkrxEM3y2z/Ff3eL1sgGYecV/I1F+I5S01V7Kclt/qRW10c/4JEGRcI1FmrJBPu
BtMYPbg/3Y9LZROYN+mVIFxZxOfrmjfFZ96xt/TaMXo8vcEKtWcNEjhGBjEbfMUEm4aq8ygQ
4MuEcpJc8DJCHBkg2KBk13DkbU2qNepTD6Uip1C+g+KMr0nd6KOJqSH27ZuNY4xqV4hIxFHp
ex0zY7mq6fV2o6sKBGQzRdI20FDYmNjsLJwjH6qJ8laxFphZnPRpBThmu0AjuBWE72GnI1oA
aO+bs92MQGJernt7hByCnDO82W/ykbVz+Ge3Sax8NY0m2Xdvp6WFDY/PjD9CdaJ9nwQGsUSa
N54lrZ2qMTeCI9Vauwf6U69BA42xgk65VvxvTNqji+tZ4aZbarZ7el2/QDHOb/rRwlCFplS/
z4l1f1nOrE6bnDl5RBJyW3zi74P6GwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAGvl7xb42JMRH5D/vCIDYvFY3dR2FPd5kmOqpKU/fvQ8ovmJa
p5N/FDrsCL+YdslxPY+AAn78PYmL5pFHTdRadT++07DPIMtQyy2qd+XRmz6zP8Il7vGcEDmO
WmMLYMq4xV9s/N7t7JJp6ftdIYUcoTVChUgilDaRWMLidtslCdRsBVfUjPb1bF5Ua31diKDP
e0M9/e2CU36rbcTtiNCXhptMigzuL3zJXUf2B9jyUV8pnqNEQH36fqJ7YTBLcpq3aYa2XbAH
Hgx9GehJBIqwspDmhPCFZ/QmqUXCkt+XfvinQ2NzKR6P3+OdYbwqzVX8BdMeojh7Ig8x/nIx
mQ+/ufstL1ZYp0bg13fyK/hPYSIBpayaC76vzWovkIm70DIDRIFLi20p/qTd7rfDYy831Hjm
+lDdCECF9bIXEWFk33kA97dgQIMbf5chEmlFg8S0e4iw7LMjvRqMX3eCD8GJ2+oqyZUwzZxy
S0Mx+rBld5rrN7LsXwZ671HsGqNeYbYeU25e7t7/Gcc6Bd/kPfA+adEuUGFcvUKH3trDYqNq
6mOkAd8WO/mQadlc3ztS++XDMhmIpfBre9MPAr6usqf+wc+R8Nk9KLK39kEgrqVfzc/fgf8L
MaD4rHnusdg4gca6Yi+kNrm99anw7SwaBrBvULYBp7ixNRUhaYiNW4YjTrYxggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5VMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDUwODE0NDMwMVowIwYJKoZIhvcNAQkE
MRYEFE1lWxjNUXrm8+HCio56eboNMzCaMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAGjR7hXPbLgq+VJwW+uzCFf5JismWcRB6E8Ubb/teRHfzdAw
4qeT5Q8628WRZO/RPr7lw9xOv4z08NzjM277UZB49/eIOyWorIkVs4QNvoAgyYuq+Rnm49+8
IQK4a/2Nu22QofUAnKoyyvZ4XWD3yh5W4C8v2O0R4sCAd+CwykK+oAikePtRTOebqeyMNGhv
PeNM9Sh6FcKuqnf1sdGfnmfFYtJu6g7cuVKRo9lIMxqHnXFwfoTA412pqVylYVJlEzWbgBbI
sbTn9znzEiitucafjliIuiXlAsjOiIymRwhhINr5eWaXMQPOsECEAiQd4vIrakm9KZUZp/MR
jwva5u3tlnL2/ZK8ABOydXMEWeWiYsLYk9pGsOcmKlLN3DmCLN/Ynm3QaRVimowGeYEbKhRx
02ChCRql0tU1zeSIsx0ugEJBHHF4JB3gC/MY9DHDxwgYdGPV/LNqH55iW2bt94HKw4Vu5lvX
0KsuHr8Jhe4dZK1hanWgH3nebkcY6NGcEPkABTH5Rl7J/8F6B0xzY5yJ2BEfpNmASk4GMsUR
e15OGIlGBbN5pUdBOpqJhGSCe+d1Bcix0TQpxX7Ght+qgMppT8vzOwe7g0twVatJ3zaZzgBB
mCX+D/e1zHTV0h1VDaJLYzZovVKT+LTQ+ml+eOmwMM+MDW4hTqjAE4QbgzhvAAAAAAAA
--------------ms080309030200030901010807--
