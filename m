From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] uapi: Prevent redefinition of struct iphdr
Date: Wed, 25 Dec 2019 16:34:11 -0800 (PST)
Message-ID: <20191225.163411.1590483851343305623.davem@davemloft.net>
References: <20191222060227.7089-1-AWilcox@Wilcox-Tech.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20191222060227.7089-1-AWilcox@Wilcox-Tech.com>
Sender: netdev-owner@vger.kernel.org
To: AWilcox@Wilcox-Tech.com
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, musl@lists.openwall.com
List-Id: linux-api@vger.kernel.org

From: "A. Wilcox" <AWilcox@Wilcox-Tech.com>
Date: Sun, 22 Dec 2019 00:02:27 -0600

> @@ -83,6 +83,13 @@
>  
>  #define IPV4_BEET_PHMAXLEN 8
>  
> +/* Allow libcs to deactivate this - musl has its own copy in <netinet/ip.h> */
> +
> +#ifndef __UAPI_DEF_IPHDR
> +#define __UAPI_DEF_IPHDR	1
> +#endif

How is this a musl-only problem?  I see that glibc also defines struct iphdr
in netinet/ip.h, so why doesn't it also suffer from this?

I find it really strange that this, therefore, only happens for musl
and we haven't had thousands of reports of this conflict with glibc
over the years.

I want an explanation, and suitably appropriate adjustments to the commit
message and comments of this change.

Thank you.
