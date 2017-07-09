From: Jeffrey Altman <jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] afs: Add metadata xattrs
Date: Sat, 8 Jul 2017 22:37:53 -0400
Message-ID: <01f6dcaa-b310-63fa-f43d-2acf44d734c3@auristor.com>
References: <20170706152304.GA10584@infradead.org>
 <149935261019.29744.8564287571048506851.stgit@warthog.procyon.org.uk>
 <149935262759.29744.6299062653432480230.stgit@warthog.procyon.org.uk>
 <31934.1499357651@warthog.procyon.org.uk>
 <2863583A-79F1-4998-8AC4-1C4C9D4C060F@dilger.ca>
 <CA+55aFyFEW8LTEoyckW2YNeMrk5q_FweRsGbZKxXHWQjGLRw8w@mail.gmail.com>
 <20170709010155.3nql5ixdeozemgfd@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090802030407060405010900"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170709010155.3nql5ixdeozemgfd-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090802030407060405010900
Content-Type: multipart/mixed;
 boundary="------------497045AE335F2A0CDD70A43E"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------497045AE335F2A0CDD70A43E
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 7/8/2017 9:01 PM, Theodore Ts'o wrote:
> On Sat, Jul 08, 2017 at 12:44:54PM -0700, Linus Torvalds wrote:
>> Yeah, I think attributes are likely much better than some random crazy=

>> ioctl interface. They can be listed with generic tools, and have
>> various scripting interfaces in ways that ioctl's do not sanely have.
>=20
> I personally don't have a particular problem with these xattrs.  For
> one thing, they are read-only.  You use them just to find out the AFS
> cell, the AFS "fid", and the AFS volume name.
>=20
> I think the place where people will start getting nervous is when we
> start adding "write-only" xattrs or where writing to an xattr causes a
> side-effect to take place.

Ted,

The list of AFS pioctls and the proposed alternatives for kAFS are
listed at

  https://www.infradead.org/~dhowells/kafs/user_interface.html

While it is true that the majority of the proposed xattrs are read-only
properties of AFS objects (cell, volume, fid, servers, sec_class,
sec_mode) there is one exception that is read-write (acls).  AuriStorFS
permits acls to be set per-file; there was some per-file acl work begun
for OpenAFS but it was never completed.

Is there an alternative for fetching and setting ACLs that should be
considered?

Jeffrey Altman





--------------497045AE335F2A0CDD70A43E
Content-Type: text/x-vcard; charset=utf-8;
 name="jaltman.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="jaltman.vcf"

begin:vcard
fn:Jeffrey Altman
n:Altman;Jeffrey
org:AuriStor, Inc.
adr:Suite 6B;;255 West 94Th Street;New York;New York;10025-6985;United St=
ates
email;internet:jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org
title:Founder and CEO
tel;work:+1-212-769-9018
note;quoted-printable:LinkedIn: https://www.linkedin.com/in/jeffreyaltman=
=3D0D=3D0A=3D
	Skype: jeffrey.e.altman=3D0D=3D0A=3D
=09
url:https://www.auristor.com/
version:2.1
end:vcard


--------------497045AE335F2A0CDD70A43E--

--------------ms090802030407060405010900
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DIMwggXqMIIE0qADAgECAhBAAVgjDHzXCy5hFo6GsQuLMA0GCSqGSIb3DQEBCwUAMDoxCzAJ
BgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQgQ0EgQTEy
MB4XDTE2MTEwMjAzMTkzMFoXDTE3MTEwMjAzMTkzMFowgYYxLTArBgNVBAsMJFZlcmlmaWVk
IEVtYWlsOiBqYWx0bWFuQGF1cmlzdG9yLmNvbTEjMCEGCSqGSIb3DQEJARYUamFsdG1hbkBh
dXJpc3Rvci5jb20xMDAuBgoJkiaJk/IsZAEBEyA3RjAwMDAwMTAwMDAwMTU4MjMwQzdDQTcw
MDAwMDdCMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALtO/7veyX1tdA4aDvsO
c0gS/fICCTPlhS34dpRNmZYs2mvWb/xGRCKeflva8uZLFqsCE6ybMgz2IaB9rpowRcGSr/R7
CyY6HEBl3Rw0OkkslV7HQTxgp1fBXbGGoS8gOp6/ML64d5UJsMUM6NM59SzC77v8bi0sYkaT
q31SoiJrCcPiI0F2wZiESf1tguQONl3Emt9fhEokmlLRHAlv1DkRw2XeUOyUwVHIVgF1wnzR
4Ao86aYmym62Z669a6NPla3hqLmYk9w+ydTnzcWj0X6nhvaMxb7fhOUyj06Y5Mxhqye+dJg4
bPj/G+8OoNVY9l5h/qbJaWpSbDog4I0LxaUCAwEAAaOCAp0wggKZMA4GA1UdDwEB/wQEAwIF
oDCBhAYIKwYBBQUHAQEEeDB2MDAGCCsGAQUFBzABhiRodHRwOi8vY29tbWVyY2lhbC5vY3Nw
LmlkZW50cnVzdC5jb20wQgYIKwYBBQUHMAKGNmh0dHA6Ly92YWxpZGF0aW9uLmlkZW50cnVz
dC5jb20vY2VydHMvdHJ1c3RpZGNhYTEyLnA3YzAfBgNVHSMEGDAWgBSkc9rvaTWKdcygGXsI
MvhrieRC7DAJBgNVHRMEAjAAMIIBLAYDVR0gBIIBIzCCAR8wggEbBgtghkgBhvkvAAYLATCC
AQowSgYIKwYBBQUHAgEWPmh0dHBzOi8vc2VjdXJlLmlkZW50cnVzdC5jb20vY2VydGlmaWNh
dGVzL3BvbGljeS90cy9pbmRleC5odG1sMIG7BggrBgEFBQcCAjCBrhqBq1RoaXMgVHJ1c3RJ
RCBDZXJ0aWZpY2F0ZSBoYXMgYmVlbiBpc3N1ZWQgaW4gYWNjb3JkYW5jZSB3aXRoIApJZGVu
VHJ1c3QncyBUcnVzdElEIENlcnRpZmljYXRlIFBvbGljeSBmb3VuZCBhdCBodHRwczovL3Nl
Y3VyZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRtbDBF
BgNVHR8EPjA8MDqgOKA2hjRodHRwOi8vdmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NybC90
cnVzdGlkY2FhMTIuY3JsMB8GA1UdEQQYMBaBFGphbHRtYW5AYXVyaXN0b3IuY29tMB0GA1Ud
DgQWBBT6okll+NyYQTyBKCigoq5jFBzw3DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUH
AwQwDQYJKoZIhvcNAQELBQADggEBABF9+YNU05P6tFiN8wvh52K+dgiUsQijFqN/tmwxqWHj
3TKxLwl8ZtK0F44FYcfeRXgE59bAxG8tZVRYBD7jY3qYEreri0x2DgJcA0oPfV1NHxM51t6h
ST09jpXEcthB4FJu3xWg8O6pB7Oq9Q9kkTjHfVLLru9B3BxrY+1NKZaSkaTBb0JGw6kCN2MM
rXrwPAdLlAWn5ywPRMqTIlgvhxtIQMv+dxpXhco9O5+ckMIdp1uBMJ82Hslfy3K9KCZvm6Cr
BG8C/fBo5TefVGuxKyOwROvup2gx1/KZWoIO0hyMNGzFPrijNZD5fAlZ11FcAJ9Why+pd5FY
mmJwln/BGPcwggaRMIIEeaADAgECAhEA+d5Wf8lNDHdw+WAbUtoVOzANBgkqhkiG9w0BAQsF
ADBKMQswCQYDVQQGEwJVUzESMBAGA1UEChMJSWRlblRydXN0MScwJQYDVQQDEx5JZGVuVHJ1
c3QgQ29tbWVyY2lhbCBSb290IENBIDEwHhcNMTUwMjE4MjIyNTE5WhcNMjMwMjE4MjIyNTE5
WjA6MQswCQYDVQQGEwJVUzESMBAGA1UEChMJSWRlblRydXN0MRcwFQYDVQQDEw5UcnVzdElE
IENBIEExMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANGRTTzPCic0kq5L6ZrU
JWt5LE/n6tbPXPhGt2Egv7plJMoEpvVJJDqGqDYymaAsd8Hn9ZMAuKUEFdlx5PgCkfu7jL5z
giMNnAFVD9PyrsuF+poqmlxhlQ06sFY2hbhQkVVQ00KCNgUzKcBUIvjv04w+fhNPkwGW5M7A
e5K5OGFGwOoRck9GG6MUVKvTNkBw2/vNMOd29VGVTtR0tjH5PS5yDXss48Yl1P4hDStO2L4w
TsW2P37QGD27//XGN8K6amWB6F2XOgff/PmlQjQOORT95PmLkwwvma5nj0AS0CVp8kv0K2RH
V7GonllKpFDMT0CkxMQKwoj+tWEWJTiDKSsCAwEAAaOCAoAwggJ8MIGJBggrBgEFBQcBAQR9
MHswMAYIKwYBBQUHMAGGJGh0dHA6Ly9jb21tZXJjaWFsLm9jc3AuaWRlbnRydXN0LmNvbTBH
BggrBgEFBQcwAoY7aHR0cDovL3ZhbGlkYXRpb24uaWRlbnRydXN0LmNvbS9yb290cy9jb21t
ZXJjaWFscm9vdGNhMS5wN2MwHwYDVR0jBBgwFoAU7UQZwNPwBovupHu+QucmVMiONnYwDwYD
VR0TAQH/BAUwAwEB/zCCASAGA1UdIASCARcwggETMIIBDwYEVR0gADCCAQUwggEBBggrBgEF
BQcCAjCB9DBFFj5odHRwczovL3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9w
b2xpY3kvdHMvaW5kZXguaHRtbDADAgEBGoGqVGhpcyBUcnVzdElEIENlcnRpZmljYXRlIGhh
cyBiZWVuIGlzc3VlZCBpbiBhY2NvcmRhbmNlIHdpdGggSWRlblRydXN0J3MgVHJ1c3RJRCBD
ZXJ0aWZpY2F0ZSBQb2xpY3kgZm91bmQgYXQgaHR0cHM6Ly9zZWN1cmUuaWRlbnRydXN0LmNv
bS9jZXJ0aWZpY2F0ZXMvcG9saWN5L3RzL2luZGV4Lmh0bWwwSgYDVR0fBEMwQTA/oD2gO4Y5
aHR0cDovL3ZhbGlkYXRpb24uaWRlbnRydXN0LmNvbS9jcmwvY29tbWVyY2lhbHJvb3RjYTEu
Y3JsMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAOBgNVHQ8BAf8EBAMCAYYwHQYD
VR0OBBYEFKRz2u9pNYp1zKAZewgy+GuJ5ELsMA0GCSqGSIb3DQEBCwUAA4ICAQAN4YKu0vv0
62MZfg+xMSNUXYKvHwvZIk+6H1pUmivyDI4I6A3wWzxlr83ZJm0oGIF6PBsbgKJ/fhyyIzb+
vAYFJmyI8I/0mGlc+nIQNuV2XY8cypPoVJKgpnzp/7cECXkX8R4NyPtEn8KecbNdGBdEaG4a
7AkZ3ujlJofZqYdHxN29tZPdDlZ8fR36/mAFeCEq0wOtOOc0Eyhs29+9MIZYjyxaPoTS+l8x
LcuYX3RWlirRyH6RPfeAi5kySOEhG1quNHe06QIwpigjyFT6v/vRqoIBr7WpDOSt1VzXPVbS
j1PcWBgkwyGKHlQUOuSbHbHcjOD8w8wHSDbL+L2he8hNN54doy1e1wJHKmnfb0uBAeISoxRb
JnMMWvgAlH5FVrQWlgajeH/6NbYbBSRxALuEOqEQepmJM6qz4oD2sxdq4GMN5adAdYEswkY/
o0bRKyFXTD3mdqeRXce0jYQbWm7oapqSZBccFvUgYOrB78tB6c1bxIgaQKRShtWR1zMM0Jfq
UfD9u8Fg7G5SVO0IG/GcxkSvZeRjhYcbTfqF2eAgprpyzLWmdr0mou3bv1Sq4OuBhmTQCnqx
AXr4yVTRYHkp5lCvRgeJAme1OTVpVPth/O7HJ7VuEP9GOr6kCXCXmjB4P3UJ2oU0NqfoQdcS
SSt9hliALnExTEjii20B2nSDojGCAxQwggMQAgEBME4wOjELMAkGA1UEBhMCVVMxEjAQBgNV
BAoTCUlkZW5UcnVzdDEXMBUGA1UEAxMOVHJ1c3RJRCBDQSBBMTICEEABWCMMfNcLLmEWjoax
C4swDQYJYIZIAWUDBAIBBQCgggGXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZI
hvcNAQkFMQ8XDTE3MDcwOTAyMzc1M1owLwYJKoZIhvcNAQkEMSIEIAma9AmEwbZRsMSSSxo1
PWS+6shWXpl56Hh1TO9CafQSMF0GCSsGAQQBgjcQBDFQME4wOjELMAkGA1UEBhMCVVMxEjAQ
BgNVBAoTCUlkZW5UcnVzdDEXMBUGA1UEAxMOVHJ1c3RJRCBDQSBBMTICEEABWCMMfNcLLmEW
joaxC4swXwYLKoZIhvcNAQkQAgsxUKBOMDoxCzAJBgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVu
VHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQgQ0EgQTEyAhBAAVgjDHzXCy5hFo6GsQuLMGwGCSqG
SIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggq
hkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJ
KoZIhvcNAQEBBQAEggEAsgw1wemGu6qaruobgKktJw2/4qFM+Xp8YpnzR1W3w6EL3oeqPiyM
vpweu7y5FWfYiBnhpjSSmSO4GDrsZZ3hN035fLsIvckCamvtSt75dDKNSr7QprtM8PT5ypXg
B0831X8UuJOHV2WKyCdyUOQywks4B08DShrd7jUks9nwtgzuwVq63P60lr4fNb22Shj9LytL
gbg5YawwaXg5PgT1xljbyiVGPo7oM0KB3gAnwlD246+z65vGj/zg8WjhLYjjfQVsWtwv+BDj
fAc4JgNA4+ZoY7aLFW87uOtCVg+t6p32lf0s/fsdFFw5cnKb0uab5XtaKvpmR/AKlYjFG6ad
UgAAAAAAAA==
--------------ms090802030407060405010900--
