From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4] uapi libc compat: add fallback for unsupported libcs
Date: Wed, 03 Jan 2018 10:53:02 -0500 (EST)
Message-ID: <20180103.105302.242805691780026749.davem@davemloft.net>
References: <20180101183320.24409-1-hauke@hauke-m.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180101183320.24409-1-hauke@hauke-m.de>
Sender: linux-kernel-owner@vger.kernel.org
To: hauke@hauke-m.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, musl@lists.openwall.com, felix.janda@posteo.de, f.fainelli@gmail.com, carlos@redhat.com, ldv@altlinux.org
List-Id: linux-api@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Mon,  1 Jan 2018 19:33:20 +0100

> From: Felix Janda <felix.janda@posteo.de>
> 
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
> The comments referencing glibc are still correct, but this file is not
> only used for glibc any more.
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> Reviewed-by: Hauke Mehrtens <hauke@hauke-m.de>

Ok, applied, thank you.
