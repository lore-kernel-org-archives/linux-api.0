From: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [musl] [PATCH] arm64: uapi: Fix user space compile with musl libc
Date: Sat, 19 Oct 2019 23:51:51 +0200
Message-ID: <8fcff553-3309-7153-b245-6593d2728678@hauke-m.de>
References: <20191019201717.15358-1-hauke@hauke-m.de>
 <20191019202950.GC16318@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20191019202950.GC16318@brightrain.aerifal.cx>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: musl@lists.openwall.com, Rich Felker <dalias@libc.org>
Cc: catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/19/19 10:29 PM, Rich Felker wrote:
> On Sat, Oct 19, 2019 at 10:17:17PM +0200, Hauke Mehrtens wrote:
>> musl libc also defines the structures in their arch/aarch64/bits/signal.h
>> header file. Some applications like strace and gdb include both of them
>> and then the structure definitions are clashing and the build of these
>> user space applications fails.
>>
>> This patch allows a libc to define a constant which tells the kernel
>> header file that the libc already defined these structures and that they
>> should not be defined by the kernel uapi header files any more to
>> prevent clashes. This is done in a similar way as it is already done for
>> other header files.
>>
>> When this patch was accepted into the kernel I will also update musl
>> libc to define these constants.
> 
> I don't entirely object to this outright, but I'd really like to avoid
> adding further __UAPI_DEF_* suppressions. AIUI asm/sigcontext.h is not
> intended to be used with userspace headers. Is it still being
> indirectly included via some other uapi headers? (I thought that was
> fixed..) If so, that should really be fixed first, and then we can see
> if there's still motivation for the patch here.
> 
> Rich
> 
Hi Rich,

I did some more research and it looks like this patch also fixes my
problem with strace and gdb compile:
https://git.kernel.org/linus/9966a05c7b80f075f2bc7e48dbb108d3f2927234

I will backport it in OpenWrt to kernel 4.19.

Please drop my patch.

It would be nice if it could go into the stable 4.19 kernel.

Hauke
