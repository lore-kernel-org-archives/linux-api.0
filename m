From: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCHv3 resend] uapi libc compat: add fallback for unsupported
 libcs
Date: Sun, 3 Dec 2017 12:04:21 +0100
Message-ID: <c64ab844-ac60-1826-a72b-f37597fa30fc@hauke-m.de>
References: <20171112183017.GA8431@nyan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171112183017.GA8431@nyan>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, musl@lists.openwall.com, "David S. Miller" <davem@davemloft.net>, Carlos O'Donell <carlos@redhat.com>, Florian Fainelli <f.fainelli@gmail.com>
List-Id: linux-api@vger.kernel.org

On 11/12/2017 07:30 PM, Felix Janda wrote:
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
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> Reviewed-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
> v3: Fix typos, add a comment to the file and use #ifndef.
> v2: The only change to the previous version is the commit title and
>     message.
> ---
>  include/uapi/linux/libc-compat.h | 55 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 54 insertions(+), 1 deletion(-)
> 

I would really like to see this in the mainline kernel as this is needed
to use the kernel headers with the musl libc, so probably every user of
the musl libc needs this.
A similar patch is in OpenWrt / LEDE and is mandatory when building the
musl toolchain used in OpenWrt / LEDE, which is the default. I would
like to get closer to build OpenWrt / LEDE with an unmodified Linux
kernel and getting this into mainline is one part of it.

As this patch is on the mailling lists since multiple months without any
reaction it looks like there is no maintainer for:
include/uapi/linux/libc-compat.h

Should we send this in the next merge window directly to Linus?

If I am wrong please correct me.

Post on the mailling list:
patch v2: https://patchwork.kernel.org/patch/9831533/
patch v3: https://patchwork.kernel.org/patch/9869953/

Hauke
