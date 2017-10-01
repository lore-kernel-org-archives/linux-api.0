From: Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCHv3] uapi libc compat: add fallback for unsupported libcs
Date: Sun, 1 Oct 2017 12:37:51 +0200
Message-ID: <6896b985-151e-1dd9-ec91-7ce1300cc45b@hauke-m.de>
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
> ---
> v3: Fix typos, add a comment to the file and use #ifndef.
> v2: The only change to the previous version is the commit title and
>     message.

Was this send to the wrong mailing lists? I would like to see this in
the mainline kernel and I am wondering why it neither gets any comments
nor shows up in linux-next.

Hauke
