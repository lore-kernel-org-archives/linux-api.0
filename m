From: Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCHv3] uapi libc compat: add fallback for unsupported libcs
Date: Sat, 26 Aug 2017 22:31:21 +0200
Message-ID: <26584c95-dba0-6a70-0ac6-cd9041b1a983@hauke-m.de>
References: <20170729140259.GA28081@nyan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170729140259.GA28081@nyan>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/29/2017 04:02 PM, Felix Janda wrote:
> libc-compat.h aims to prevent symbol collisions between uapi and libc
> headers for each supported libc. This requires continuous coordination
> between them.
> 
> The goal of this commit is to improve the situation for libcs (such as
> musl) which are not yet supported and/or do not wish to be explicitly
> supported, while not affecting supported libcs. More precisely, with
> this commit, unsupported libcs can request the suppression of any
> specific uapi definition by defining the correspondings _UAPI_DEF_*
> macro as 0. This can fix symbol collisions for them, as long as the
> libc headers are included before the uapi headers. Inclusion in the
> other order is outside the scope of this commit.
> 
> All infrastructure in order to enable this fallback for unsupported
> libcs is already in place, except that libc-compat.h unconditionally
> defines all _UAPI_DEF_* macros to 1 for all unsupported libcs so that
> any previous definitions are ignored. In order to fix this, this commit
> merely makes these definitions conditional.
> 
> This commit together with the musl libc commit
> 
> http://git.musl-libc.org/cgit/musl/commit/?id=04983f2272382af92eb8f8838964ff944fbb8258
> 
> fixes for example the following compiler errors when <linux/in6.h> is
> included after musl's <netinet/in.h>:
> 
> ./linux/in6.h:32:8: error: redefinition of 'struct in6_addr'
> ./linux/in6.h:49:8: error: redefinition of 'struct sockaddr_in6'
> ./linux/in6.h:59:8: error: redefinition of 'struct ipv6_mreq'
> 
> Signed-off-by: Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>

Reviewed-by: Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>

With this patch + a patch which protects "struct ethhdr" I was able to
build LEDE with musl libc using these kernel headers without a problem
include building iproute2.

I would like to send my patch to protect "struct ethhdr", but it depends
ion this one.

> ---
> v3: Fix typos, add a comment to the file and use #ifndef.
> v2: The only change to the previous version is the commit title and
>     message.
> ---
>  include/uapi/linux/libc-compat.h | 55 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/libc-compat.h
> index 44b8a6bd5fe1..65db6b26d790 100644
> --- a/include/uapi/linux/libc-compat.h
> +++ b/include/uapi/linux/libc-compat.h
> @@ -167,46 +167,99 @@
>  
>  /* If we did not see any headers from any supported C libraries,
>   * or we are being included in the kernel, then define everything
> - * that we need. */
> + * that we need. Check for previous __UAPI_* definitions to give
> + * unsupported C libraries a way to opt out of any kernel definition. */
>  #else /* !defined(__GLIBC__) */
>  
>  /* Definitions for if.h */
> +#ifndef __UAPI_DEF_IF_IFCONF
>  #define __UAPI_DEF_IF_IFCONF 1
> +#endif
> +#ifndef __UAPI_DEF_IF_IFMAP
>  #define __UAPI_DEF_IF_IFMAP 1
> +#endif
> +#ifndef __UAPI_DEF_IF_IFNAMSIZ
>  #define __UAPI_DEF_IF_IFNAMSIZ 1
> +#endif
> +#ifndef __UAPI_DEF_IF_IFREQ
>  #define __UAPI_DEF_IF_IFREQ 1
> +#endif
>  /* Everything up to IFF_DYNAMIC, matches net/if.h until glibc 2.23 */
> +#ifndef __UAPI_DEF_IF_NET_DEVICE_FLAGS
>  #define __UAPI_DEF_IF_NET_DEVICE_FLAGS 1
> +#endif
>  /* For the future if glibc adds IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO */
> +#ifndef __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO
>  #define __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO 1
> +#endif
>  
>  /* Definitions for in.h */
> +#ifndef __UAPI_DEF_IN_ADDR
>  #define __UAPI_DEF_IN_ADDR		1
> +#endif
> +#ifndef __UAPI_DEF_IN_IPPROTO
>  #define __UAPI_DEF_IN_IPPROTO		1
> +#endif
> +#ifndef __UAPI_DEF_IN_PKTINFO
>  #define __UAPI_DEF_IN_PKTINFO		1
> +#endif
> +#ifndef __UAPI_DEF_IP_MREQ
>  #define __UAPI_DEF_IP_MREQ		1
> +#endif
> +#ifndef __UAPI_DEF_SOCKADDR_IN
>  #define __UAPI_DEF_SOCKADDR_IN		1
> +#endif
> +#ifndef __UAPI_DEF_IN_CLASS
>  #define __UAPI_DEF_IN_CLASS		1
> +#endif
>  
>  /* Definitions for in6.h */
> +#ifndef __UAPI_DEF_IN6_ADDR
>  #define __UAPI_DEF_IN6_ADDR		1
> +#endif
> +#ifndef __UAPI_DEF_IN6_ADDR_ALT
>  #define __UAPI_DEF_IN6_ADDR_ALT		1
> +#endif
> +#ifndef __UAPI_DEF_SOCKADDR_IN6
>  #define __UAPI_DEF_SOCKADDR_IN6		1
> +#endif
> +#ifndef __UAPI_DEF_IPV6_MREQ
>  #define __UAPI_DEF_IPV6_MREQ		1
> +#endif
> +#ifndef __UAPI_DEF_IPPROTO_V6
>  #define __UAPI_DEF_IPPROTO_V6		1
> +#endif
> +#ifndef __UAPI_DEF_IPV6_OPTIONS
>  #define __UAPI_DEF_IPV6_OPTIONS		1
> +#endif
> +#ifndef __UAPI_DEF_IN6_PKTINFO
>  #define __UAPI_DEF_IN6_PKTINFO		1
> +#endif
> +#ifndef __UAPI_DEF_IP6_MTUINFO
>  #define __UAPI_DEF_IP6_MTUINFO		1
> +#endif
>  
>  /* Definitions for ipx.h */
> +#ifndef __UAPI_DEF_SOCKADDR_IPX
>  #define __UAPI_DEF_SOCKADDR_IPX			1
> +#endif
> +#ifndef __UAPI_DEF_IPX_ROUTE_DEFINITION
>  #define __UAPI_DEF_IPX_ROUTE_DEFINITION		1
> +#endif
> +#ifndef __UAPI_DEF_IPX_INTERFACE_DEFINITION
>  #define __UAPI_DEF_IPX_INTERFACE_DEFINITION	1
> +#endif
> +#ifndef __UAPI_DEF_IPX_CONFIG_DATA
>  #define __UAPI_DEF_IPX_CONFIG_DATA		1
> +#endif
> +#ifndef __UAPI_DEF_IPX_ROUTE_DEF
>  #define __UAPI_DEF_IPX_ROUTE_DEF		1
> +#endif
>  
>  /* Definitions for xattr.h */
> +#ifndef __UAPI_DEF_XATTR
>  #define __UAPI_DEF_XATTR		1
> +#endif
>  
>  #endif /* __GLIBC__ */
>  
> 
