From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Tue, 12 May 2015 10:53:29 -0400
Message-ID: <555213E9.90701@gmail.com>
References: <CAHQdGtQjMHA8rVPkggB2zMz=k3O667+APH_1EY_2FtYmHL7-hw@mail.gmail.com> <20150508221325.GM4327@dastard> <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net> <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com> <20150511144719.GA14088@thunk.org> <alpine.DEB.2.00.1505110920520.28239@cobra.newdream.net> <20150511231021.GC14088@thunk.org> <20150512050821.GA9404@chicago.guarana.org> <5551E7EB.8040301@gmail.com> <21842.1555.38099.868100@quad.stoffel.home> <20150512143637.GA6370@fieldses.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040807000500060501050804"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150512143637.GA6370-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, John Stoffel <john-HgN6juyGXH5AfugRpC6u6w@public.gmane.org>
Cc: Kevin Easton <kevin-RFfraI6bZkdAfugRpC6u6w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms040807000500060501050804
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-05-12 10:36, J. Bruce Fields wrote:
> On Tue, May 12, 2015 at 09:54:27AM -0400, John Stoffel wrote:
>>>>>>> "Austin" =3D=3D Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes=
:
>>
>> Austin> On 2015-05-12 01:08, Kevin Easton wrote:
>>>> On Mon, May 11, 2015 at 07:10:21PM -0400, Theodore Ts'o wrote:
>>>>> On Mon, May 11, 2015 at 09:24:09AM -0700, Sage Weil wrote:
>>>>>>> Let me re-ask the question that I asked last week (and was appare=
ntly
>>>>>>> ignored).  Why not trying to use the lazytime feature instead of
>>>>>>> pointing a head straight at the application's --- and system
>>>>>>> administrators' --- heads?
>>>>>>
>>>>>> Sorry Ted, I thought I responded already.
>>>>>>
>>>>>> The goal is to avoid inode writeout entirely when we can, and
>>>>>> as I understand it lazytime will still force writeout before the i=
node
>>>>>> is dropped from the cache.  In systems like Ceph in particular, th=
e
>>>>>> IOs can be spread across lots of files, so simply deferring writeo=
ut
>>>>>> doesn't always help.
>>>>>
>>>>> Sure, but it would reduce the writeout by orders of magnitude.  I c=
an
>>>>> understand if you want to reduce it further, but it might be good
>>>>> enough for your purposes.
>>>>>
>>>>> I considered doing the equivalent of O_NOMTIME for our purposes at
>>>>> $WORK, and our use case is actually not that different from Ceph's
>>>>> (i.e., using a local disk file system to support a cluster file
>>>>> system), and lazytime was (a) something I figured was something I
>>>>> could upstream in good conscience, and (b) was more than good enoug=
h
>>>>> for us.
>>>>
>>>> A safer alternative might be a chattr file attribute that if set, th=
e
>>>> mtime is not updated on writes, and stat() on the file always shows =
the
>>>> mtime as "right now".  At least that way, the file won't accidentall=
y
>>>> get left out of backups that rely on the mtime.
>>>>
>>>> (If the file attribute is unset, you immediately update the mtime th=
en
>>>> too, and from then on the file is back to normal).
>>>>
>>
>> Austin> I like this even better than the flag suggestion, it provides
>> Austin> better control, means that you don't need to update
>> Austin> applications to get the benefits, and prevents backup software=

>> Austin> from breaking (although backups would be bigger).
>>
>> Me too, it fails in a safer mode, where you do more work on backups
>> than strictly needed.  I'm still against this as a mount option
>> though, way way way too many bullets in the foot gun.  And as someone
>> else said, once you mount with O_NOMTIME, then unmount, then mount
>> again without O_NOMTIME, you've lost information.  Not good.
>
> That was me.  Zach also pointed out to me that'd mean figuring out wher=
e
> to store that information on-disk for every filesystem you care about.
> I like the idea of something persistent, but maybe it's more trouble
> than it's worth--I honestly don't know.
>
But if we do it as a flag controlled by the API used by chattr, it=20
becomes the responsibility of the filesystems to deal with where to=20
store the information, assuming they choose to support it; personally, I =

would be really surprised if XFS and BTRFS didn't add support for this=20
relatively soon after the API getting merged upstream, and ext4 would=20
likely follow soon afterwards.

As far as support goes, I really think this will be easier to _safely_=20
implement (mount options are just too easy to arbitrarily change without =

knowing the consequences), although I think that reporting mtime as the=20
current wall time for files under this effect is important regardless of =

what methodology get's implemented.



--------------ms040807000500060501050804
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDUxMjE0NTMyOVowIwYJKoZIhvcNAQkE
MRYEFFYrKy1eOw04JgOTP23bs3FI7cELMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAIPEPTUaM9Ps3AvfygoWkHvVBDg/fo0hRLaPojeChJzCNddU
ONserz0T+EwUnfWS4PLUmm/yxHTBitRe1/TELWApMrEdDleGPi7WecDCUyoEWgBmGvT2YZDF
A8uQNPhnqBcjDqNJNk85UPawyFe/gqbE/JNxMj6yZn8apV0ym8P5H8uKL3316WFW6AnRcNVw
KpJ94R4n1Qz4fBVFBzxxt3e9qRXO28ONcVbWISJtnDUbVG49guOyjDQsSdMdzSlqGPwW7DWn
e/uLbRThzDqR/oRw4DBDYUz/iDLjmc8AWBfkHPT4jZzG4mjV9BAgrXOSHuPHxssojF729yKm
RGRSeRsPQ/nEBbV1Vnd1g3mLtnz+0VmH2iijGsbNHm93or8fcDNuP1SiAd/jXk/w1nchLpqa
pefSexFSxOicaaFjAmV98jv2HpCvY91zvQvI9Vv/HEjFwO9DwXOrM0wE6KZyZXfjK3mICZOG
KxlIBNh5Ip+CwHQbTlS8v4OHeA3qfU70jitH8CzPvaXTO5he9+0vLwm2I4q9yHtGhWFiFlyx
y3XUOewu9A7zgz4FeceuGq/5wv28+ef9cukXdViA7oqSLlNLO1HUX6H6fEx4rUWXpwqiZBK2
deP5dJulMA0Q7TLoV8WsC7cRtf4H7iA/GF/6CINiEs/22grwYKLEY91hz060AAAAAAAA
--------------ms040807000500060501050804--
