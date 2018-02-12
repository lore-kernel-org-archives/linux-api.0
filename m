From: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] uapi/if_ether.h: move __UAPI_DEF_ETHHDR libc define
Date: Tue, 13 Feb 2018 00:01:26 +0100
Message-ID: <1dafbb8b-19c2-373b-3f11-2224275dac23@hauke-m.de>
References: <20180212225951.24708-1-hauke@hauke-m.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180212225951.24708-1-hauke@hauke-m.de>
Content-Language: de-LU
Sender: stable-owner@vger.kernel.org
To: davem@davemloft.net
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org, g.nault@alphalink.fr, "# 4 . 15" <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 02/12/2018 11:59 PM, Hauke Mehrtens wrote:
> This fixes a compile problem of some user space applications by not
> including linux/libc-compat.h in uapi/if_ether.h.
> 
> linux/libc-compat.h checks which "features" the header files, included
> from the libc, provide to make the Linux kernel uapi header files only
> provide no conflicting structures and enums. If a user application mixes
> kernel headers and libc headers it could happen that linux/libc-compat.h
> gets included too early where not all other libc headers are included
> yet. Then the linux/libc-compat.h would not prevent all the
> redefinitions and we run into compile problems.
> This patch removes the include of linux/libc-compat.h from
> uapi/if_ether.h to fix the recently introduced case, but not all as this
> is more or less impossible.
> 
> It is no problem to do the check directly in the if_ether.h file and not
> in libc-compat.h as this does not need any fancy glibc header detection
> as glibc never provided struct ethhdr and should define
> __UAPI_DEF_ETHHDR by them self when they will provide this.
> 
> The following test program did not compile correctly any more:
> 
> int main(void)
> {
>         return 0;
> }

git removed the included here:

#include <linux/if_ether.h>
#include <netinet/in.h>
#include <linux/in.h>

int main(void)
{
	return 0;
}
