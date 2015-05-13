From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Wed, 13 May 2015 11:16:29 -0400
Message-ID: <55536ACD.2060604@gmail.com>
References: <alpine.DEB.2.00.1505081517470.28239@cobra.newdream.net> <CAHQdGtTFTN2XuvmarFZ9HPQV=cuhh7FosdHSrJME_U4htr=i8w@mail.gmail.com> <20150511144719.GA14088@thunk.org> <alpine.DEB.2.00.1505110920520.28239@cobra.newdream.net> <20150511231021.GC14088@thunk.org> <20150512050821.GA9404@chicago.guarana.org> <5551E7EB.8040301@gmail.com> <21842.1555.38099.868100@quad.stoffel.home> <20150512143637.GA6370@fieldses.org> <555213E9.90701@gmail.com> <20150512215145.GA4316@dastard>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010802090004060903020201"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150512215145.GA4316@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, John Stoffel <john@stoffel.org>, Kevin Easton <kevin@guarana.org>, Theodore Ts'o <tytso@mit.edu>, Sage Weil <sage@newdream.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Zach Brown <zab@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010802090004060903020201
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-05-12 17:51, Dave Chinner wrote:
> On Tue, May 12, 2015 at 10:53:29AM -0400, Austin S Hemmelgarn wrote:
>> On 2015-05-12 10:36, J. Bruce Fields wrote:
>>> On Tue, May 12, 2015 at 09:54:27AM -0400, John Stoffel wrote:
>>>>>>>>> "Austin" =3D=3D Austin S Hemmelgarn <ahferroin7@gmail.com> writ=
es:
>>>>
>>>> Austin> On 2015-05-12 01:08, Kevin Easton wrote:
>>>>>> On Mon, May 11, 2015 at 07:10:21PM -0400, Theodore Ts'o wrote:
>>>>>>> On Mon, May 11, 2015 at 09:24:09AM -0700, Sage Weil wrote:
>>>>>>>>> Let me re-ask the question that I asked last week (and was appa=
rently
>>>>>>>>> ignored).  Why not trying to use the lazytime feature instead o=
f
>>>>>>>>> pointing a head straight at the application's --- and system
>>>>>>>>> administrators' --- heads?
>>>>>>>>
>>>>>>>> Sorry Ted, I thought I responded already.
>>>>>>>>
>>>>>>>> The goal is to avoid inode writeout entirely when we can, and
>>>>>>>> as I understand it lazytime will still force writeout before the=
 inode
>>>>>>>> is dropped from the cache.  In systems like Ceph in particular, =
the
>>>>>>>> IOs can be spread across lots of files, so simply deferring writ=
eout
>>>>>>>> doesn't always help.
>>>>>>>
>>>>>>> Sure, but it would reduce the writeout by orders of magnitude.  I=
 can
>>>>>>> understand if you want to reduce it further, but it might be good=

>>>>>>> enough for your purposes.
>>>>>>>
>>>>>>> I considered doing the equivalent of O_NOMTIME for our purposes a=
t
>>>>>>> $WORK, and our use case is actually not that different from Ceph'=
s
>>>>>>> (i.e., using a local disk file system to support a cluster file
>>>>>>> system), and lazytime was (a) something I figured was something I=

>>>>>>> could upstream in good conscience, and (b) was more than good eno=
ugh
>>>>>>> for us.
>>>>>>
>>>>>> A safer alternative might be a chattr file attribute that if set, =
the
>>>>>> mtime is not updated on writes, and stat() on the file always show=
s the
>>>>>> mtime as "right now".  At least that way, the file won't accidenta=
lly
>>>>>> get left out of backups that rely on the mtime.
>>>>>>
>>>>>> (If the file attribute is unset, you immediately update the mtime =
then
>>>>>> too, and from then on the file is back to normal).
>>>>>>
>>>>
>>>> Austin> I like this even better than the flag suggestion, it provide=
s
>>>> Austin> better control, means that you don't need to update
>>>> Austin> applications to get the benefits, and prevents backup softwa=
re
>>>> Austin> from breaking (although backups would be bigger).
>>>>
>>>> Me too, it fails in a safer mode, where you do more work on backups
>>>> than strictly needed.  I'm still against this as a mount option
>>>> though, way way way too many bullets in the foot gun.  And as someon=
e
>>>> else said, once you mount with O_NOMTIME, then unmount, then mount
>>>> again without O_NOMTIME, you've lost information.  Not good.
>>>
>>> That was me.  Zach also pointed out to me that'd mean figuring out wh=
ere
>>> to store that information on-disk for every filesystem you care about=
=2E
>>> I like the idea of something persistent, but maybe it's more trouble
>>> than it's worth--I honestly don't know.
>>>
>> But if we do it as a flag controlled by the API used by chattr, it
>> becomes the responsibility of the filesystems to deal with where to
>> store the information, assuming they choose to support it;
>> personally, I would be really surprised if XFS and BTRFS didn't add
>> support for this relatively soon after the API getting merged
>> upstream, and ext4 would likely follow soon afterwards.
>
> It's an on-disk format change, which means that there are all sorts
> of compatibility issues to take into account, as well as all the
> work needed to teach the filesystem userspace tools about the new
> flag. e.g. xfs_repair, xfs_db, xfsdump/restore, xfs_io, test code in
> xfstests, etc.
>
> Keep in mind that the moment we make something persistent, the
> amount of work to implement and verify the new functionality
> filesystem to implement it goes up by an order of magnitude *for
> each filesystem*.  IOWs, support of new features that require
> persistence don't just magically appear overnight...
>
I'm not saying that it will, and any sane way of safely implementing=20
this will _almost_ certainly need some kind of work done on the=20
filesystems themselves.  My only point was that it would be simpler on=20
the VFS side of things than most of the other proposals so far.

Also, BTRFS at least won't (theoretically) need a format change for=20
this, as it could just be added to the property interface.  As for the=20
other filesystems, it would probably be possible to re-purpose one of=20
the other bits for this, s (secure delete) and u (undeletion) are both=20
not honored by any filesystem in the kernel, and also not honored by any =

other UNIX filesystem implementation that I know of; s would probably be =

the better of the 2 to use for this, as it's currently assigned purpose=20
is functionally impossible to implement properly on modern hardware.



--------------ms010802090004060903020201
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDUxMzE1MTYyOVowIwYJKoZIhvcNAQkE
MRYEFNX2dNkH2nwh2a8dBuIBSbcycrRVMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAHl7J0YvKxkBtSDIRPxOnBEPBPeDLSwzPICpwJFTxu4z0MUS
217nNYbg/Q+H6glHbJddvCoOTgn6zEon9bJ6PcjYxmfmWFGDfDrZW5yv0myDqmV4v+3ULiPe
yBwHVfJ3j7ZD/g34dUWnO7+mMYRFlIHe6HTYlMqpi9p/Iu32AU6euXFZZcfVEjnSldSkA4MH
PupfdSl+qxN9uKcjlgFKXz78srcKXcBz0MQWy46n5BUKvkJ92fjYEgG9YjGfofXh1VOoQfnO
QhM9RxhlJma3j6+uw/huxmm/roSWWlOJlhJ0VRT91uoO5H0nova86DHN8dTdaJb+qJAbpjND
GvUKKhzRrl0VoRiNYAGiYJOwFEeGmlRf5FQipCdFNv/NVcQZIo/WYuW/dDDR4lmFRq7+7xzN
+SF8Rz9kEEMk9DFa/bboIyTacgk9trOtjPaSz/scgaY3r7ivlnEV/ljvXSpl2C+HeerrX9dH
2ug3H295aL6nbvMFfWQ4G91wrfPswkRVe/A2YqfyEZ/6NeTseDiyKSMDPfMQHoO+NC7elVck
rRWCAvgWS+glRGZQDlpnhjYGpHLAiK31sqyoaigo2B1QJyHdu8LH/WaJc8MBSb58D1syaWhD
FPYays6NsFk7rH0dVj9abXZwNgk8DVtCAdcm4a9XojHAa8bfju4vgpPM39cwAAAAAAAA
--------------ms010802090004060903020201--
