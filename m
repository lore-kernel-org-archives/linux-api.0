From: Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCHv3 resend] uapi libc compat: add fallback for unsupported
 libcs
Date: Mon, 1 Jan 2018 19:32:50 +0100
Message-ID: <03b9abfc-e945-17b6-9253-a4477fe94a41@hauke-m.de>
References: <20171112183017.GA8431@nyan> <20171203112825.GA452@altlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QOgJ4vEDTdlL1J7vY8qUKTBLqtzAlvkcn"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171203112825.GA452-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QOgJ4vEDTdlL1J7vY8qUKTBLqtzAlvkcn
Content-Type: multipart/mixed; boundary="G8qy9qF1rZvCCWWQ4JcWjmvRwgfu8w3QO";
 protected-headers="v1"
From: Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
To: Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org,
 "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Carlos O'Donell
 <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Message-ID: <03b9abfc-e945-17b6-9253-a4477fe94a41-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCHv3 resend] uapi libc compat: add fallback for unsupported
 libcs
References: <20171112183017.GA8431@nyan> <20171203112825.GA452-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20171203112825.GA452-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>

--G8qy9qF1rZvCCWWQ4JcWjmvRwgfu8w3QO
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/03/2017 12:28 PM, Dmitry V. Levin wrote:
> Hi,
>=20
> On Sun, Nov 12, 2017 at 01:30:17PM -0500, Felix Janda wrote:
>> libc-compat.h aims to prevent symbol collisions between uapi and libc
>> headers for each supported libc. This requires continuous coordination=

>> between them.
>>
>> The goal of this commit is to improve the situation for libcs (such as=

>> musl) which are not yet supported and/or do not wish to be explicitly
>> supported, while not affecting supported libcs. More precisely, with
>> this commit, unsupported libcs can request the suppression of any
>> specific uapi definition by defining the correspondings _UAPI_DEF_*
>> macro as 0. This can fix symbol collisions for them, as long as the
>> libc headers are included before the uapi headers. Inclusion in the
>> other order is outside the scope of this commit.
>>
>> All infrastructure in order to enable this fallback for unsupported
>> libcs is already in place, except that libc-compat.h unconditionally
>> defines all _UAPI_DEF_* macros to 1 for all unsupported libcs so that
>> any previous definitions are ignored. In order to fix this, this commi=
t
>> merely makes these definitions conditional.
>>
>> This commit together with the musl libc commit
>>
>> http://git.musl-libc.org/cgit/musl/commit/?id=3D04983f2272382af92eb8f8=
838964ff944fbb8258
>>
>> fixes for example the following compiler errors when <linux/in6.h> is
>> included after musl's <netinet/in.h>:
>>
>> ./linux/in6.h:32:8: error: redefinition of 'struct in6_addr'
>> ./linux/in6.h:49:8: error: redefinition of 'struct sockaddr_in6'
>> ./linux/in6.h:59:8: error: redefinition of 'struct ipv6_mreq'
>>
>> Signed-off-by: Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
>> Reviewed-by: Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
>> ---
>> v3: Fix typos, add a comment to the file and use #ifndef.
>> v2: The only change to the previous version is the commit title and
>>     message.
>> ---
>>  include/uapi/linux/libc-compat.h | 55 +++++++++++++++++++++++++++++++=
++++++++-
>>  1 file changed, 54 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/lib=
c-compat.h
>> index 44b8a6bd5fe1..65db6b26d790 100644
>> --- a/include/uapi/linux/libc-compat.h
>> +++ b/include/uapi/linux/libc-compat.h
>> @@ -167,46 +167,99 @@
>> =20
>>  /* If we did not see any headers from any supported C libraries,
>>   * or we are being included in the kernel, then define everything
>> - * that we need. */
>> + * that we need. Check for previous __UAPI_* definitions to give
>> + * unsupported C libraries a way to opt out of any kernel definition.=
 */
>>  #else /* !defined(__GLIBC__) */
>> =20
>>  /* Definitions for if.h */
>> +#ifndef __UAPI_DEF_IF_IFCONF
>>  #define __UAPI_DEF_IF_IFCONF 1
>> +#endif
>> +#ifndef __UAPI_DEF_IF_IFMAP
>>  #define __UAPI_DEF_IF_IFMAP 1
>> +#endif
>> +#ifndef __UAPI_DEF_IF_IFNAMSIZ
>>  #define __UAPI_DEF_IF_IFNAMSIZ 1
>> +#endif
>> +#ifndef __UAPI_DEF_IF_IFREQ
>>  #define __UAPI_DEF_IF_IFREQ 1
>> +#endif
>>  /* Everything up to IFF_DYNAMIC, matches net/if.h until glibc 2.23 */=

>> +#ifndef __UAPI_DEF_IF_NET_DEVICE_FLAGS
>>  #define __UAPI_DEF_IF_NET_DEVICE_FLAGS 1
>> +#endif
>>  /* For the future if glibc adds IFF_LOWER_UP, IFF_DORMANT and IFF_ECH=
O */
>> +#ifndef __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO
>>  #define __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO 1
>> +#endif
>=20
> Please double-check that mentioning glibc in comments
> of this !__GLIBC__ section is relevant.

These comments are still true for glibc, but these defines are also used
by other libc implementations. This section is also used with glibc when
the kernel headers are included before the glibc headers, but this case
is not so well supported.

>>  /* Definitions for in.h */
>> +#ifndef __UAPI_DEF_IN_ADDR
>>  #define __UAPI_DEF_IN_ADDR		1
>> +#endif
>> +#ifndef __UAPI_DEF_IN_IPPROTO
>>  #define __UAPI_DEF_IN_IPPROTO		1
>> +#endif
>> +#ifndef __UAPI_DEF_IN_PKTINFO
>>  #define __UAPI_DEF_IN_PKTINFO		1
>> +#endif
>> +#ifndef __UAPI_DEF_IP_MREQ
>>  #define __UAPI_DEF_IP_MREQ		1
>> +#endif
>> +#ifndef __UAPI_DEF_SOCKADDR_IN
>>  #define __UAPI_DEF_SOCKADDR_IN		1
>> +#endif
>> +#ifndef __UAPI_DEF_IN_CLASS
>>  #define __UAPI_DEF_IN_CLASS		1
>> +#endif
>> =20
>>  /* Definitions for in6.h */
>> +#ifndef __UAPI_DEF_IN6_ADDR
>>  #define __UAPI_DEF_IN6_ADDR		1
>> +#endif
>> +#ifndef __UAPI_DEF_IN6_ADDR_ALT
>>  #define __UAPI_DEF_IN6_ADDR_ALT		1
>> +#endif
>> +#ifndef __UAPI_DEF_SOCKADDR_IN6
>>  #define __UAPI_DEF_SOCKADDR_IN6		1
>> +#endif
>> +#ifndef __UAPI_DEF_IPV6_MREQ
>>  #define __UAPI_DEF_IPV6_MREQ		1
>> +#endif
>> +#ifndef __UAPI_DEF_IPPROTO_V6
>>  #define __UAPI_DEF_IPPROTO_V6		1
>> +#endif
>> +#ifndef __UAPI_DEF_IPV6_OPTIONS
>>  #define __UAPI_DEF_IPV6_OPTIONS		1
>> +#endif
>> +#ifndef __UAPI_DEF_IN6_PKTINFO
>>  #define __UAPI_DEF_IN6_PKTINFO		1
>> +#endif
>> +#ifndef __UAPI_DEF_IP6_MTUINFO
>>  #define __UAPI_DEF_IP6_MTUINFO		1
>> +#endif
>> =20
>>  /* Definitions for ipx.h */
>> +#ifndef __UAPI_DEF_SOCKADDR_IPX
>>  #define __UAPI_DEF_SOCKADDR_IPX			1
>> +#endif
>> +#ifndef __UAPI_DEF_IPX_ROUTE_DEFINITION
>>  #define __UAPI_DEF_IPX_ROUTE_DEFINITION		1
>> +#endif
>> +#ifndef __UAPI_DEF_IPX_INTERFACE_DEFINITION
>>  #define __UAPI_DEF_IPX_INTERFACE_DEFINITION	1
>> +#endif
>> +#ifndef __UAPI_DEF_IPX_CONFIG_DATA
>>  #define __UAPI_DEF_IPX_CONFIG_DATA		1
>> +#endif
>> +#ifndef __UAPI_DEF_IPX_ROUTE_DEF
>>  #define __UAPI_DEF_IPX_ROUTE_DEF		1
>> +#endif
>> =20
>>  /* Definitions for xattr.h */
>> +#ifndef __UAPI_DEF_XATTR
>>  #define __UAPI_DEF_XATTR		1
>> +#endif
>> =20
>>  #endif /* __GLIBC__ */
>=20
> As most of affected macros are related to networking (in fact, all exce=
pt
> __UAPI_DEF_XATTR affect uapi/linux/{if.h,in.h,in6.h,ipv6.h,ipx.h} only)=
,
> I think this patch should be submitted to netdev.

I will send a patch to David Miller.

Hauke


--G8qy9qF1rZvCCWWQ4JcWjmvRwgfu8w3QO--

--QOgJ4vEDTdlL1J7vY8qUKTBLqtzAlvkcn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEEyByTt/kEznHNdZethnSnH1g9EzIFAlpKftYRHGhhdWtlQGhh
dWtlLW0uZGUACgkQhnSnH1g9EzJj6g/+OprsXVNQvvmYs8GjKQna2v3mqsRQQ7c9
7r+WHKFyzhgBTUoEymO/F9vLjmzGb5WxMtMzBWklq2ORn04tOdz6pVCp3jC9MJVy
R0d3cTRfzn+am21b2yMi0OwNKXO9xvk15/n4a0E7gJpI+qTgXZozmkr0EyTTz8M9
vL1SUSMD65HFwnp5oGKgmulkpEOSiXF87+fsE65xH+8mP5Dp/royU7LNlgxg/UHm
IWDiahjjXNf3m/em8zuLHD2lY33U0SPPp2TAUgTxFF/CoJ3GHepcu8aMZVEZnkVR
4zf5QCbOkvCTHJZnZXzLlMIBNSXnJFFRdYbTDmCAlK7aJq3pKtybTFBQLN2TdejN
tGRLSf/OI2vmW3O/bf9rjdCvjsuT5L/VZknB0dfbj7+EI1QhR7V4K9y2Eku5UxHG
J364jRpsIG/8mvOVwJaf5SkcSV6axEElHUNwFThRR677jLk6XJH8YrJc8z8r+9G/
e0H58nkPHpnkeqLhx2rEqOg1TFPVEWfaE8Png9wj5dszHor/SEQqk00ttMAdVW+2
kxzuxueyNsuBuXxh+GuUP76kNQvRRQb1XEGowERAVAWdBJWjJ9P79hb6iU5AX9OS
iHWvfuJjzF5yCzNXgp9f6+pcUzwvuNwpHpWci5B6BVwm8+Zi0DurBta3RXNEJJJU
lzjtkdkizXU=
=jVd+
-----END PGP SIGNATURE-----

--QOgJ4vEDTdlL1J7vY8qUKTBLqtzAlvkcn--
