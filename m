From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] selftests: memfd_test: Revised STACK_SIZE to make it 16-byte aligned
Date: Thu, 15 Oct 2015 10:44:15 +0200
Message-ID: <8675019.20qUY4dC6X@wuerfel>
References: <1443684782-10898-1-git-send-email-zhang.chunyan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443684782-10898-1-git-send-email-zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thursday 01 October 2015 15:33:02 Chunyan Zhang wrote:
> There is a mandate of 16-byte aligned stack on AArch64 [1], so the
> STACK_SIZE here should also be 16-byte aligned, otherwise we would
> get an error when calling clone().
> 
> [1] http://lxr.free-electrons.com/source/arch/arm64/kernel/process.c#L265
> 
> Signed-off-by: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 

Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

This should probably also be marked

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
