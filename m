From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH RESEND] Btrfs: add autodefrag inode flag
Date: Wed, 01 Jul 2015 07:07:02 -0400
Message-ID: <5593C9D6.8000909@gmail.com>
References: <85de09b87ad7b2847ea001f5bb03c044e8b419aa.1435681574.git.osandov@fb.com> <20150630214519.GN22807@dastard>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090900080903010501030906"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150630214519.GN22807@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>, Omar Sandoval <osandov@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090900080903010501030906
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-06-30 17:45, Dave Chinner wrote:
> On Tue, Jun 30, 2015 at 09:32:20AM -0700, Omar Sandoval wrote:
>> In some cases, we may not want to enable automatic defragmentation for=

>> the whole filesystem with the "autodefrag" mount option but we still
>> want to defragment specific files or directories. Add an inode flag
>> which allows us to do specify that.
>>
>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>> ---
>> Resending this because I didn't send it to fsdevel or linux-api last
>> time and I'm adding a new user-facing inode flag.
>
> XFS has a "no defrag" inode flag to tell the defragmenter not to
> defrag the file. (XFS_XFLAG_NODEFRAG, see xfsctl(3)). With the ext4
> project quota work, this flag and interface is being pulled up to
> the VFS, so perhaps it would be a good idea to turn this around the
> other way?  i.e. autodefrag is the default behaviour, and the inode
> contains an inheritable  "no defrag" flag to prevent defrag so that
> we have the same flag, API and behaviour across filesystems?
>
+! on this suggestion, I find that there are only a few files that I=20
don't want autodefrag enabled for, and I do want it on pretty much=20
everything else.  Furthermore, userspace API consistency is a Good Thing.=




--------------ms090900080903010501030906
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcwMTExMDcwMlowIwYJKoZIhvcNAQkE
MRYEFOScn4M2QGshg908i7ys3HfbsvnZMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAAsrT0Y1NCMRBYO+qV5UavZehJZ1TSKdJZLFAf695df11E5a
M+cmSG4N50N+8iJ0ZgRs0/Nca/2vBGqtXzks7puQDqTNSe5RCMco8ZOOx8EymFwfuj6UTP9i
jRfdwtarqMNAOstigohagfqrVWg1imbauPlDElPOcc4+SYrCrMf6omg6/+TVUyln9RJI9z1i
nMyfoqu4g8mLyLwuQ4MW2KSq+sSKH+eXua4Mdb+eJ6TTurvXjY+60sxftHDhxKugB9bunFdp
FDwhHo4f8z+awFewgiekQD22UXq+5QZITeQoG2j8kWD119wPUSX6WhuV37GgXQ82e6PuEsOh
ejyLJHaNK2gF05vrnBCu9KBFiEfvs7wW785kmit8J19MBdZt+agtipsmuLyrvNvFO01+IaTm
WK09CtelZt9cxmwCAqnMKzD1p2LdX+Xoy7lyg1TYOprePKo0M9wHNkKvskmwQNEZB6jf/eVZ
amj78TNRDbgLtGwJpLrxjcilwaCIQ2bvZGPmJ5KRbhE2186z096zwk8jPNYpOhG8NiF3pREC
md7vANOTR/KJ9wNk2ciEuRWwV0cbFpfkBN3yulY/PmY3Ey6jBmQuqE+2+zWiCst2B2lLS6zb
PITDTpnXvCMxfgmksr46GxrlSZamFGcjM8FGcO35KS1jtQ/zcqgyOgS2ZS4vAAAAAAAA
--------------ms090900080903010501030906--
