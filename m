From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH resent] uapi libc compat: allow non-glibc to opt out of
 uapi definitions
Date: Wed, 08 Mar 2017 13:46:28 +0100
Message-ID: <1488977188.4347.134.camel@infradead.org>
References: <20161111120820.GA435@nyan>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/x-pkcs7-signature"; boundary="=-H0OBZ90qPCC55fuF/Sap"
Return-path: <musl-return-11132-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
In-Reply-To: <20161111120820.GA435@nyan>
To: Felix Janda <felix.janda@posteo.de>, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-api@vger.kernel.org, musl@lists.openwall.com, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org


--=-H0OBZ90qPCC55fuF/Sap
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-11-11 at 07:08 -0500, Felix Janda wrote:
> Currently, libc-compat.h detects inclusion of specific glibc headers,
> and defines corresponding _UAPI_DEF_* macros, which in turn are used in
> uapi headers to prevent definition of conflicting structures/constants.
> There is no such detection for other c libraries, for them the
> _UAPI_DEF_* macros are always defined as 1, and so none of the possibly
> conflicting definitions are suppressed.
>=20
> This patch enables non-glibc c libraries to request the suppression of
> any specific interface by defining the corresponding _UAPI_DEF_* macro
> as 0.

Ick. It's fairly horrid for kernel headers to be reacting to __GLIBC__
in any way. That's just wrong.

It makes more sense for C libraries to define the __UAPI_DEF_xxx for
themselves as and when they add their own support for certain things,
and for the kernel not to have incestuous knowledge of them.

The part you add here in the #else /* !__GLIBC__ */ part is what we
should do at *all* times.

I understand that we'll want to grandfather in the glibc horridness,
but let's make it clear that that's what it is, by letting it set the
appropriate __UAPI_DEF_xxx macros to zero, and then continue through to
your new part. Something like this (incremental to yours):

diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/libc-com=
pat.h
index c316725..7673158 100644
--- a/include/uapi/linux/libc-compat.h
+++ b/include/uapi/linux/libc-compat.h
@@ -53,41 +53,18 @@
=C2=A0
=C2=A0/* Coordinate with glibc net/if.h header. */
=C2=A0#if defined(_NET_IF_H) && defined(__USE_MISC)
-
=C2=A0/* GLIBC headers included first so don't define anything
=C2=A0 * that would already be defined. */
-
=C2=A0#define __UAPI_DEF_IF_IFCONF 0
=C2=A0#define __UAPI_DEF_IF_IFMAP 0
=C2=A0#define __UAPI_DEF_IF_IFNAMSIZ 0
=C2=A0#define __UAPI_DEF_IF_IFREQ 0
=C2=A0/* Everything up to IFF_DYNAMIC, matches net/if.h until glibc 2.23 */
=C2=A0#define __UAPI_DEF_IF_NET_DEVICE_FLAGS 0
-/* For the future if glibc adds IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO */
-#ifndef __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO
-#define __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO 1
-#endif /* __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO */
-
-#else /* _NET_IF_H */
-
-/* Linux headers included first, and we must define everything
- * we need. The expectation is that glibc will check the
- * __UAPI_DEF_* defines and adjust appropriately. */
-
-#define __UAPI_DEF_IF_IFCONF 1
-#define __UAPI_DEF_IF_IFMAP 1
-#define __UAPI_DEF_IF_IFNAMSIZ 1
-#define __UAPI_DEF_IF_IFREQ 1
-/* Everything up to IFF_DYNAMIC, matches net/if.h until glibc 2.23 */
-#define __UAPI_DEF_IF_NET_DEVICE_FLAGS 1
-/* For the future if glibc adds IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO */
-#define __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO 1
-
=C2=A0#endif /* _NET_IF_H */
=C2=A0
=C2=A0/* Coordinate with glibc netinet/in.h header. */
=C2=A0#if defined(_NETINET_IN_H)
-
=C2=A0/* GLIBC headers included first so don't define anything
=C2=A0 * that would already be defined. */
=C2=A0#define __UAPI_DEF_IN_ADDR		0
@@ -104,8 +81,6 @@
=C2=A0 * additional in6_addr macros e.g. s6_addr16, and s6_addr32. */
=C2=A0#if defined(__USE_MISC) || defined (__USE_GNU)
=C2=A0#define __UAPI_DEF_IN6_ADDR_ALT		0
-#else
-#define __UAPI_DEF_IN6_ADDR_ALT		1
=C2=A0#endif
=C2=A0#define __UAPI_DEF_SOCKADDR_IN6		0
=C2=A0#define __UAPI_DEF_IPV6_MREQ		0
@@ -113,62 +88,23 @@
=C2=A0#define __UAPI_DEF_IPV6_OPTIONS		0
=C2=A0#define __UAPI_DEF_IN6_PKTINFO		0
=C2=A0#define __UAPI_DEF_IP6_MTUINFO		0
-
-#else
-
-/* Linux headers included first, and we must define everything
- * we need. The expectation is that glibc will check the
- * __UAPI_DEF_* defines and adjust appropriately. */
-#define __UAPI_DEF_IN_ADDR		1
-#define __UAPI_DEF_IN_IPPROTO		1
-#define __UAPI_DEF_IN_PKTINFO		1
-#define __UAPI_DEF_IP_MREQ		1
-#define __UAPI_DEF_SOCKADDR_IN		1
-#define __UAPI_DEF_IN_CLASS		1
-
-#define __UAPI_DEF_IN6_ADDR		1
-/* We unconditionally define the in6_addr macros and glibc must
- * coordinate. */
-#define __UAPI_DEF_IN6_ADDR_ALT		1
-#define __UAPI_DEF_SOCKADDR_IN6		1
-#define __UAPI_DEF_IPV6_MREQ		1
-#define __UAPI_DEF_IPPROTO_V6		1
-#define __UAPI_DEF_IPV6_OPTIONS		1
-#define __UAPI_DEF_IN6_PKTINFO		1
-#define __UAPI_DEF_IP6_MTUINFO		1
-
=C2=A0#endif /* _NETINET_IN_H */
=C2=A0
=C2=A0/* Coordinate with glibc netipx/ipx.h header. */
=C2=A0#if defined(__NETIPX_IPX_H)
-
=C2=A0#define __UAPI_DEF_SOCKADDR_IPX			0
=C2=A0#define __UAPI_DEF_IPX_ROUTE_DEFINITION		0
=C2=A0#define __UAPI_DEF_IPX_INTERFACE_DEFINITION	0
=C2=A0#define __UAPI_DEF_IPX_CONFIG_DATA		0
=C2=A0#define __UAPI_DEF_IPX_ROUTE_DEF		0
-
-#else /* defined(__NETIPX_IPX_H) */
-
-#define __UAPI_DEF_SOCKADDR_IPX			1
-#define __UAPI_DEF_IPX_ROUTE_DEFINITION		1
-#define __UAPI_DEF_IPX_INTERFACE_DEFINITION	1
-#define __UAPI_DEF_IPX_CONFIG_DATA		1
-#define __UAPI_DEF_IPX_ROUTE_DEF		1
-
=C2=A0#endif /* defined(__NETIPX_IPX_H) */
=C2=A0
=C2=A0/* Definitions for xattr.h */
=C2=A0#if defined(_SYS_XATTR_H)
=C2=A0#define __UAPI_DEF_XATTR		0
-#else
-#define __UAPI_DEF_XATTR		1
=C2=A0#endif
=C2=A0
-/* If we did not see any headers from any supported C libraries,
- * or we are being included in the kernel, then define everything
- * that we need. */
-#else /* !defined(__GLIBC__) */
+#endif /* __GLIBC__ */
=C2=A0
=C2=A0/* Definitions for if.h */
=C2=A0#if !defined(__UAPI_DEF_IF_IFCONF)
@@ -260,6 +196,4 @@
=C2=A0#define __UAPI_DEF_XATTR		1
=C2=A0#endif
=C2=A0
-#endif /* __GLIBC__ */
-
=C2=A0#endif /* _UAPI_LIBC_COMPAT_H */






--=-H0OBZ90qPCC55fuF/Sap
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCDzUw
ggSvMIIDl6ADAgECAhEA4CPLFRKDU4mtYW56VGdrITANBgkqhkiG9w0BAQsFADBvMQswCQYDVQQG
EwJTRTEUMBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFkZFRydXN0IEV4dGVybmFsIFRU
UCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBFeHRlcm5hbCBDQSBSb290MB4XDTE0MTIyMjAw
MDAwMFoXDTIwMDUzMDEwNDgzOFowgZsxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1h
bmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMUEw
PwYDVQQDEzhDT01PRE8gU0hBLTI1NiBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBF
bWFpbCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAImxDdp6UxlOcFIdvFamBia3
uEngludRq/HwWhNJFaO0jBtgvHpRQqd5jKQi3xdhTpHVdiMKFNNKAn+2HQmAbqUEPdm6uxb+oYep
LkNSQxZ8rzJQyKZPWukI2M+TJZx7iOgwZOak+FaA/SokFDMXmaxE5WmLo0YGS8Iz1OlAnwawsayT
QLm1CJM6nCpToxDbPSBhPFUDjtlOdiUCISn6o3xxdk/u4V+B6ftUgNvDezVSt4TeIj0sMC0xf1m9
UjewM2ktQ+v61qXxl3dnUYzZ7ifrvKUHOHaMpKk4/9+M9QOsSb7K93OZOg8yq5yVOhM9DkY6V3Rh
UL7GQD/L5OKfoiECAwEAAaOCARcwggETMB8GA1UdIwQYMBaAFK29mHo0tCb3+sQmVO8DveAky1Qa
MB0GA1UdDgQWBBSSYWuC4aKgqk/sZ/HCo/e0gADB7DAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/
BAgwBgEB/wIBADAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwEQYDVR0gBAowCDAGBgRV
HSAAMEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9BZGRUcnVzdEV4
dGVybmFsQ0FSb290LmNybDA1BggrBgEFBQcBAQQpMCcwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3Nw
LnVzZXJ0cnVzdC5jb20wDQYJKoZIhvcNAQELBQADggEBABsqbqxVwTqriMXY7c1V86prYSvACRAj
mQ/FZmpvsfW0tXdeDwJhAN99Bf4Ss6SAgAD8+x1banICCkG8BbrBWNUmwurVTYT7/oKYz1gb4yJj
nFL4uwU2q31Ypd6rO2Pl2tVz7+zg+3vio//wQiOcyraNTT7kSxgDsqgt1Ni7QkuQaYUQ26Y3NOh7
4AEQpZzKOsefT4g0bopl0BqKu6ncyso20fT8wmQpNa/WsadxEdIDQ7GPPprsnjJT9HaSyoY0B7ks
yuYcStiZDcGG4pCS+1pCaiMhEOllx/XVu37qjIUgAmLq0ToHLFnFmTPyOInltukWeh95FPZKEBom
+nyK+5swggU9MIIEJaADAgECAhBqC1BYlVMtBFBN4igR/howMA0GCSqGSIb3DQEBCwUAMIGbMQsw
CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3Jk
MRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDFBMD8GA1UEAxM4Q09NT0RPIFNIQS0yNTYgQ2xp
ZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTYxMjIwMDAwMDAwWhcN
MTcxMjIwMjM1OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwbTrFaiGdvN2pThnR9q+4eaXB2wQZQNqhter5ZrJ
pPO47e87bZ+f1tmYoh6+rB90G/XN24NErPRfvU4zVzNT9pCtCzSSVnBlZQBpaEYMKhcXo5PGKNsm
An8BoGwNXjlxwbBNRaNO+ky0wNCaMNd1JLxEuvqg9J7rrcpHhWmnpXD5IKa8gv9GyVAJgOpiBOts
p91sShc2kHvWJ5waPEWPCHDH9J+twGGKqKIIU7fdbURLUgUL1wlDSAHf/lgIAVCSj2H2HpoGqHpy
HgOAClX9iRSLNa0Znj8HTaqfOwxXevsz1KkLFY+Ahm426GIEqdfkK2iT6Hhgc7tjNO3f8i5ALQID
AQABo4IB8TCCAe0wHwYDVR0jBBgwFoAUkmFrguGioKpP7GfxwqP3tIAAwewwHQYDVR0OBBYEFILE
dmHLtK6oxmFJZvBhTQhvqrS0MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMCAGA1UdJQQZ
MBcGCCsGAQUFBwMEBgsrBgEEAbIxAQMFAjARBglghkgBhvhCAQEEBAMCBSAwRgYDVR0gBD8wPTA7
BgwrBgEEAbIxAQIBAQEwKzApBggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9D
UFMwXQYDVR0fBFYwVDBSoFCgToZMaHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RPU0hBMjU2
Q2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNybDCBkAYIKwYBBQUHAQEEgYMw
gYAwWAYIKwYBBQUHMAKGTGh0dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1NIQTI1NkNsaWVu
dEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9v
Y3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZyYWRlYWQub3JnMA0GCSqGSIb3
DQEBCwUAA4IBAQA+AfvNhFwtapF5Lzjapgul3zYuEnMfR538Ya1vhP8wuOkcoJeT2gEFXzVO2WUu
eWM0g0/DumnRB53htV/Qq/+vsL0i6a2+iOO7kHi5O7bZkgbdNv0t2lzonDUHi6LTa7NUj+tv+j6y
hW+iNquC3ACP1dIZH8gJmicHblW63qRgp6wxhn315MLBeavi3uiSag2eeKFePiTIwJjN2UYq6kWg
PL5G/Ycf9x/xN1XBTfJiURc0FsXhrA98VMWnt52C5Lo4txhGjzTI+IZg40b3YDs6E7mTYb5KKmbc
QZA9priOFDdj1z5W9BdWhU6I/D0P9y8Z4Tr6+ZscMUVD0RqWy2LeMIIFPTCCBCWgAwIBAgIQagtQ
WJVTLQRQTeIoEf4aMDANBgkqhkiG9w0BAQsFADCBmzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdy
ZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExp
bWl0ZWQxQTA/BgNVBAMTOENPTU9ETyBTSEEtMjU2IENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQg
U2VjdXJlIEVtYWlsIENBMB4XDTE2MTIyMDAwMDAwMFoXDTE3MTIyMDIzNTk1OVowJDEiMCAGCSqG
SIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAMG06xWohnbzdqU4Z0favuHmlwdsEGUDaobXq+WayaTzuO3vO22fn9bZmKIevqwfdBv1zduD
RKz0X71OM1czU/aQrQs0klZwZWUAaWhGDCoXF6OTxijbJgJ/AaBsDV45ccGwTUWjTvpMtMDQmjDX
dSS8RLr6oPSe663KR4Vpp6Vw+SCmvIL/RslQCYDqYgTrbKfdbEoXNpB71iecGjxFjwhwx/SfrcBh
iqiiCFO33W1ES1IFC9cJQ0gB3/5YCAFQko9h9h6aBqh6ch4DgApV/YkUizWtGZ4/B02qnzsMV3r7
M9SpCxWPgIZuNuhiBKnX5Ctok+h4YHO7YzTt3/IuQC0CAwEAAaOCAfEwggHtMB8GA1UdIwQYMBaA
FJJha4LhoqCqT+xn8cKj97SAAMHsMB0GA1UdDgQWBBSCxHZhy7SuqMZhSWbwYU0Ib6q0tDAOBgNV
HQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAgBgNVHSUEGTAXBggrBgEFBQcDBAYLKwYBBAGyMQED
BQIwEQYJYIZIAYb4QgEBBAQDAgUgMEYGA1UdIAQ/MD0wOwYMKwYBBAGyMQECAQEBMCswKQYIKwYB
BQUHAgEWHWh0dHBzOi8vc2VjdXJlLmNvbW9kby5uZXQvQ1BTMF0GA1UdHwRWMFQwUqBQoE6GTGh0
dHA6Ly9jcmwuY29tb2RvY2EuY29tL0NPTU9ET1NIQTI1NkNsaWVudEF1dGhlbnRpY2F0aW9uYW5k
U2VjdXJlRW1haWxDQS5jcmwwgZAGCCsGAQUFBwEBBIGDMIGAMFgGCCsGAQUFBzAChkxodHRwOi8v
Y3J0LmNvbW9kb2NhLmNvbS9DT01PRE9TSEEyNTZDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3Vy
ZUVtYWlsQ0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0R
BBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAPgH7zYRcLWqReS84
2qYLpd82LhJzH0ed/GGtb4T/MLjpHKCXk9oBBV81TtllLnljNINPw7pp0Qed4bVf0Kv/r7C9Iumt
vojju5B4uTu22ZIG3Tb9Ldpc6Jw1B4ui02uzVI/rb/o+soVvojargtwAj9XSGR/ICZonB25Vut6k
YKesMYZ99eTCwXmr4t7okmoNnnihXj4kyMCYzdlGKupFoDy+Rv2HH/cf8TdVwU3yYlEXNBbF4awP
fFTFp7edguS6OLcYRo80yPiGYONG92A7OhO5k2G+Sipm3EGQPaa4jhQ3Y9c+VvQXVoVOiPw9D/cv
GeE6+vmbHDFFQ9Ealsti3jGCA9MwggPPAgEBMIGwMIGbMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0Eg
TGltaXRlZDFBMD8GA1UEAxM4Q09NT0RPIFNIQS0yNTYgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFu
ZCBTZWN1cmUgRW1haWwgQ0ECEGoLUFiVUy0EUE3iKBH+GjAwDQYJYIZIAWUDBAIBBQCgggHzMBgG
CSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE3MDMwODEyNDYyOFowLwYJ
KoZIhvcNAQkEMSIEIDzXRCbhWJSvjUQB0eNaOFI6+qDbBW9DYLmpymp6nzXxMIHBBgkrBgEEAYI3
EAQxgbMwgbAwgZsxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAO
BgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMUEwPwYDVQQDEzhDT01P
RE8gU0hBLTI1NiBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIQagtQ
WJVTLQRQTeIoEf4aMDCBwwYLKoZIhvcNAQkQAgsxgbOggbAwgZsxCzAJBgNVBAYTAkdCMRswGQYD
VQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9E
TyBDQSBMaW1pdGVkMUEwPwYDVQQDEzhDT01PRE8gU0hBLTI1NiBDbGllbnQgQXV0aGVudGljYXRp
b24gYW5kIFNlY3VyZSBFbWFpbCBDQQIQagtQWJVTLQRQTeIoEf4aMDANBgkqhkiG9w0BAQEFAASC
AQBEbLsTnw90ilKutO8k663EDZeFCci6YTeToNfr0z59tkqihFe+S5Zbr38Z2GgYx+rjCy2Xps8w
6ZcmNunBicuhqfv8yjJYNW7xnvyLYGSlWllePB5zYZ7ZBNKTL4OtDRA0BFZ1QNh6KyvChEwZlHIO
bC0cXwg65QJ7sV/HIgiNKLNB5zX+e92C2dr3yG4uFMToFPpemMGGbCjkKXEm24qqnNfvyxXDtCW1
Tr3GH48rD3T9ZPYLd9jBrlgVt9uuxUBvwDYpvSqsjjYnNYt329WuCdxz7bgwrI1vx/58ZRiqy4iA
c5nQJI8uAHGRFevpAsg0+EZjvi/vXlj3Xg/1WMeVAAAAAAAA


--=-H0OBZ90qPCC55fuF/Sap--
