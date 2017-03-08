From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH resent] uapi libc compat: allow non-glibc to opt out of
 uapi definitions
Date: Wed, 8 Mar 2017 11:39:08 -0500
Message-ID: <459a8faf-4585-5063-3d94-3a1fecfa8289@redhat.com>
References: <20161111120820.GA435@nyan>
 <1488977188.4347.134.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488977188.4347.134.camel@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>, Felix Janda <felix.janda@posteo.de>, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-api@vger.kernel.org, musl@lists.openwall.com
List-Id: linux-api@vger.kernel.org

On 03/08/2017 07:46 AM, David Woodhouse wrote:
> On Fri, 2016-11-11 at 07:08 -0500, Felix Janda wrote:
>> Currently, libc-compat.h detects inclusion of specific glibc headers,
>> and defines corresponding _UAPI_DEF_* macros, which in turn are used in
>> uapi headers to prevent definition of conflicting structures/constants.
>> There is no such detection for other c libraries, for them the
>> _UAPI_DEF_* macros are always defined as 1, and so none of the possibly
>> conflicting definitions are suppressed.
>>
>> This patch enables non-glibc c libraries to request the suppression of
>> any specific interface by defining the corresponding _UAPI_DEF_* macro
>> as 0.
> 
> Ick. It's fairly horrid for kernel headers to be reacting to __GLIBC__
> in any way. That's just wrong.
> 
> It makes more sense for C libraries to define the __UAPI_DEF_xxx for
> themselves as and when they add their own support for certain things,
> and for the kernel not to have incestuous knowledge of them.
> 
> The part you add here in the #else /* !__GLIBC__ */ part is what we
> should do at *all* times.
> 
> I understand that we'll want to grandfather in the glibc horridness,
> but let's make it clear that that's what it is, by letting it set the
> appropriate __UAPI_DEF_xxx macros to zero, and then continue through to
> your new part. Something like this (incremental to yours):

Any model we propose should be documented in the header of libc-compat.h
and explain how it works to solve header inclusion order in _both_ directions.
User use cases include header inclusion in _both_ directions and we should look
to support that.

> diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/libc-compat.h
> index c316725..7673158 100644
> --- a/include/uapi/linux/libc-compat.h
> +++ b/include/uapi/linux/libc-compat.h
> @@ -53,41 +53,18 @@
>  
>  /* Coordinate with glibc net/if.h header. */
>  #if defined(_NET_IF_H) && defined(__USE_MISC)
> -
>  /* GLIBC headers included first so don't define anything
>   * that would already be defined. */
> -
>  #define __UAPI_DEF_IF_IFCONF 0
>  #define __UAPI_DEF_IF_IFMAP 0
>  #define __UAPI_DEF_IF_IFNAMSIZ 0
>  #define __UAPI_DEF_IF_IFREQ 0
>  /* Everything up to IFF_DYNAMIC, matches net/if.h until glibc 2.23 */
>  #define __UAPI_DEF_IF_NET_DEVICE_FLAGS 0
> -/* For the future if glibc adds IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO */
> -#ifndef __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO
> -#define __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO 1
> -#endif /* __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO */
> -
> -#else /* _NET_IF_H */
> -
> -/* Linux headers included first, and we must define everything
> - * we need. The expectation is that glibc will check the
> - * __UAPI_DEF_* defines and adjust appropriately. */
> -
> -#define __UAPI_DEF_IF_IFCONF 1
> -#define __UAPI_DEF_IF_IFMAP 1
> -#define __UAPI_DEF_IF_IFNAMSIZ 1
> -#define __UAPI_DEF_IF_IFREQ 1
> -/* Everything up to IFF_DYNAMIC, matches net/if.h until glibc 2.23 */
> -#define __UAPI_DEF_IF_NET_DEVICE_FLAGS 1
> -/* For the future if glibc adds IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO */
> -#define __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO 1
> -

Any header needing compat with a libc includes libc-compat.h (per the 
documented way the model works). With this patch any included linux kernel
header that also includes libc-compat.h would immediately define all 
the __UAPI_DEF_* constants to 1 as-if it had defined those structures, 
but it has not.

For example, with these two patches applied, the inclusion of linux/if.h
would define __UAPI_DEF_XATTR to 1, but linux/if.h has not defined
XATTR_CREATE or other constants, so a subsequent inclusion sys/xattrs.h
from userspace would _not_ define XATTR_CREATE because __UAPI_DEF_XATTR set
to 1 indicates the kernel has.

I don't want to read into the model you are proposing and would rather you
document the semantics clearly so we can all see what you mean.

>  #endif /* _NET_IF_H */
>  
>  /* Coordinate with glibc netinet/in.h header. */
>  #if defined(_NETINET_IN_H)
> -
>  /* GLIBC headers included first so don't define anything
>   * that would already be defined. */
>  #define __UAPI_DEF_IN_ADDR		0
> @@ -104,8 +81,6 @@
>   * additional in6_addr macros e.g. s6_addr16, and s6_addr32. */
>  #if defined(__USE_MISC) || defined (__USE_GNU)
>  #define __UAPI_DEF_IN6_ADDR_ALT		0
> -#else
> -#define __UAPI_DEF_IN6_ADDR_ALT		1
>  #endif
>  #define __UAPI_DEF_SOCKADDR_IN6		0
>  #define __UAPI_DEF_IPV6_MREQ		0
> @@ -113,62 +88,23 @@
>  #define __UAPI_DEF_IPV6_OPTIONS		0
>  #define __UAPI_DEF_IN6_PKTINFO		0
>  #define __UAPI_DEF_IP6_MTUINFO		0
> -
> -#else
> -
> -/* Linux headers included first, and we must define everything
> - * we need. The expectation is that glibc will check the
> - * __UAPI_DEF_* defines and adjust appropriately. */
> -#define __UAPI_DEF_IN_ADDR		1
> -#define __UAPI_DEF_IN_IPPROTO		1
> -#define __UAPI_DEF_IN_PKTINFO		1
> -#define __UAPI_DEF_IP_MREQ		1
> -#define __UAPI_DEF_SOCKADDR_IN		1
> -#define __UAPI_DEF_IN_CLASS		1
> -
> -#define __UAPI_DEF_IN6_ADDR		1
> -/* We unconditionally define the in6_addr macros and glibc must
> - * coordinate. */
> -#define __UAPI_DEF_IN6_ADDR_ALT		1
> -#define __UAPI_DEF_SOCKADDR_IN6		1
> -#define __UAPI_DEF_IPV6_MREQ		1
> -#define __UAPI_DEF_IPPROTO_V6		1
> -#define __UAPI_DEF_IPV6_OPTIONS		1
> -#define __UAPI_DEF_IN6_PKTINFO		1
> -#define __UAPI_DEF_IP6_MTUINFO		1
> -
>  #endif /* _NETINET_IN_H */
>  
>  /* Coordinate with glibc netipx/ipx.h header. */
>  #if defined(__NETIPX_IPX_H)
> -
>  #define __UAPI_DEF_SOCKADDR_IPX			0
>  #define __UAPI_DEF_IPX_ROUTE_DEFINITION		0
>  #define __UAPI_DEF_IPX_INTERFACE_DEFINITION	0
>  #define __UAPI_DEF_IPX_CONFIG_DATA		0
>  #define __UAPI_DEF_IPX_ROUTE_DEF		0
> -
> -#else /* defined(__NETIPX_IPX_H) */
> -
> -#define __UAPI_DEF_SOCKADDR_IPX			1
> -#define __UAPI_DEF_IPX_ROUTE_DEFINITION		1
> -#define __UAPI_DEF_IPX_INTERFACE_DEFINITION	1
> -#define __UAPI_DEF_IPX_CONFIG_DATA		1
> -#define __UAPI_DEF_IPX_ROUTE_DEF		1
> -
>  #endif /* defined(__NETIPX_IPX_H) */
>  
>  /* Definitions for xattr.h */
>  #if defined(_SYS_XATTR_H)
>  #define __UAPI_DEF_XATTR		0
> -#else
> -#define __UAPI_DEF_XATTR		1
>  #endif
>  
> -/* If we did not see any headers from any supported C libraries,
> - * or we are being included in the kernel, then define everything
> - * that we need. */
> -#else /* !defined(__GLIBC__) */
> +#endif /* __GLIBC__ */
>  
>  /* Definitions for if.h */
>  #if !defined(__UAPI_DEF_IF_IFCONF)
> @@ -260,6 +196,4 @@
>  #define __UAPI_DEF_XATTR		1
>  #endif
>  
> -#endif /* __GLIBC__ */
> -
>  #endif /* _UAPI_LIBC_COMPAT_H */
> 
> 
> 
> 
> 


-- 
Cheers,
Carlos.
