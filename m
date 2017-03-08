From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH resent] uapi libc compat: allow non-glibc to opt out of
 uapi definitions
Date: Wed, 8 Mar 2017 10:53:00 -0500
Message-ID: <a360ec42-33ca-5e89-3d70-3b1c9a011c7f@redhat.com>
References: <20161111120820.GA435@nyan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161111120820.GA435@nyan>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-api@vger.kernel.org, musl@lists.openwall.com, Rich Felker <dalias@aerifal.cx>
List-Id: linux-api@vger.kernel.org

On 11/11/2016 07:08 AM, Felix Janda wrote:
> Currently, libc-compat.h detects inclusion of specific glibc headers,
> and defines corresponding _UAPI_DEF_* macros, which in turn are used in
> uapi headers to prevent definition of conflicting structures/constants.
> There is no such detection for other c libraries, for them the
> _UAPI_DEF_* macros are always defined as 1, and so none of the possibly
> conflicting definitions are suppressed.
> 
> This patch enables non-glibc c libraries to request the suppression of
> any specific interface by defining the corresponding _UAPI_DEF_* macro
> as 0.
> 
> This patch together with the recent musl libc commit
> 
> http://git.musl-libc.org/cgit/musl/commit/?id=04983f2272382af92eb8f8838964ff944fbb8258

Would it be possible to amend the musl patch to define the macros to 1.

A defined or undefined macro is typo prone.

Please see this wiki for examples of the problems it causes:
https://sourceware.org/glibc/wiki/Wundef

Having the UAPI macros always defined and be 0 or 1 allows you to create
tooling to check for problems, while an undefined macro is just that,
either a mistake or the intended value.

> fixes the following compiler errors when <linux/in6.h> is included
> after musl <netinet/in.h>:
> 
> ./linux/in6.h:32:8: error: redefinition of 'struct in6_addr'
> ./linux/in6.h:49:8: error: redefinition of 'struct sockaddr_in6'
> ./linux/in6.h:59:8: error: redefinition of 'struct ipv6_mreq'

Do you have plans for fixing the error when the inclusion order is the other way?

It will require kernel header changes to have each individual kernel header define
the requisite __UAPI_* values to 1 e.g. moving libc-compat.h into the header.

Do you plan to do that in a next step?

> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> ---
> The previous mail misspelled the kernel mailing list. I am sorry for
> this resulting spam.
> 
> There has already been one reply, which is available at
> 
> http://www.openwall.com/lists/musl/2016/11/11/2
> ---
>  include/uapi/linux/libc-compat.h | 52 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/libc-compat.h
> index 44b8a6b..c316725 100644
> --- a/include/uapi/linux/libc-compat.h
> +++ b/include/uapi/linux/libc-compat.h
> @@ -171,42 +171,94 @@
>  #else /* !defined(__GLIBC__) */

Would you please update the lead comment in libc-compat.h explaining this usage
model so glibc and other libc's can follow best practice. Any new usage model
should express how to fix header inclusion ordering in both directions.

>  /* Definitions for if.h */
> +#if !defined(__UAPI_DEF_IF_IFCONF)

Typo prone. Please use #if __UAPI_DEF_IF_IFCONF for all of this.

>  #define __UAPI_DEF_IF_IFCONF 1
> +#endif
> +#if !defined(__UAPI_DEF_IF_IFMAP)
>  #define __UAPI_DEF_IF_IFMAP 1
> +#endif
> +#if !defined(__UAPI_DEF_IFNAMSIZ)
>  #define __UAPI_DEF_IF_IFNAMSIZ 1
> +#endif
> +#if !defined(__UAPI_DEF_IFREQ)
>  #define __UAPI_DEF_IF_IFREQ 1
> +#endif
>  /* Everything up to IFF_DYNAMIC, matches net/if.h until glibc 2.23 */
> +#if !defined(__UAPI_DEF_IF_NET_DEVICE_FLAGS)
>  #define __UAPI_DEF_IF_NET_DEVICE_FLAGS 1
> +#endif
>  /* For the future if glibc adds IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO */
> +#if !defined(__UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO)
>  #define __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO 1
> +#endif
>  
>  /* Definitions for in.h */
> +#if !defined(__UAPI_DEF_IN_ADDR)
>  #define __UAPI_DEF_IN_ADDR		1
> +#endif
> +#if !defined(__UAPI_DEF_IN_IPPROTO)
>  #define __UAPI_DEF_IN_IPPROTO		1
> +#endif
> +#if !defined(__UAPI_DEF_IN_PKTINFO)
>  #define __UAPI_DEF_IN_PKTINFO		1
> +#endif
> +#if !defined(__UAPI_DEF_IP_MREQ)
>  #define __UAPI_DEF_IP_MREQ		1
> +#endif
> +#if !defined(__UAPI_DEF_SOCKADDR_IN)
>  #define __UAPI_DEF_SOCKADDR_IN		1
> +#endif
> +#if !defined(__UAPI_DEF_IN_CLASS)
>  #define __UAPI_DEF_IN_CLASS		1
> +#endif
>  
>  /* Definitions for in6.h */
> +#if !defined(__UAPI_DEF_IN6_ADDR)
>  #define __UAPI_DEF_IN6_ADDR		1
> +#endif
> +#if !defined(__UAPI_DEF_IN6_ADDR_ALT)
>  #define __UAPI_DEF_IN6_ADDR_ALT		1
> +#endif
> +#if !defined(__UAPI_DEF_SOCKADDR_IN6)
>  #define __UAPI_DEF_SOCKADDR_IN6		1
> +#endif
> +#if !defined(__UAPI_DEF_IPV6_MREQ)
>  #define __UAPI_DEF_IPV6_MREQ		1
> +#endif
> +#if !defined(__UAPI_DEF_IPPROTO_V6)
>  #define __UAPI_DEF_IPPROTO_V6		1
> +#endif
> +#if !defined(__UAPI_DEF_IPV6_OPTIONS)
>  #define __UAPI_DEF_IPV6_OPTIONS		1
> +#endif
> +#if !defined(__UAPI_DEF_IN6_PKTINFO)
>  #define __UAPI_DEF_IN6_PKTINFO		1
> +#endif
> +#if !defined(__UAPI_DEF_IP6_MTUINFO)
>  #define __UAPI_DEF_IP6_MTUINFO		1
> +#endif
>  
>  /* Definitions for ipx.h */
> +#if !defined(__UAPI_DEF_SOCKADDR_IPX)
>  #define __UAPI_DEF_SOCKADDR_IPX			1
> +#endif
> +#if !defined(__UAPI_DEF_IPX_ROUTE_DEFINITION)
>  #define __UAPI_DEF_IPX_ROUTE_DEFINITION		1
> +#endif
> +#if !defined(__UAPI_DEF_IPX_INTERFACE_DEFINITION)
>  #define __UAPI_DEF_IPX_INTERFACE_DEFINITION	1
> +#endif
> +#if !defined(__UAPI_DEF_IPX_CONFIG_DATA)
>  #define __UAPI_DEF_IPX_CONFIG_DATA		1
> +#endif
> +#if !defined(__UAPI_DEF_IPX_ROUTE_DEF)
>  #define __UAPI_DEF_IPX_ROUTE_DEF		1
> +#endif
>  
>  /* Definitions for xattr.h */
> +#if !defined(__UAPI_DEF_XATTR)
>  #define __UAPI_DEF_XATTR		1
> +#endif
>  
>  #endif /* __GLIBC__ */
>  
> 

-- 
Cheers,
Carlos.
