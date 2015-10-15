From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] selftests: memfd_test: Revised STACK_SIZE to make it
 16-byte aligned
Date: Thu, 15 Oct 2015 07:50:05 -0600
Message-ID: <561FAF0D.7040804@osg.samsung.com>
References: <1443684782-10898-1-git-send-email-zhang.chunyan@linaro.org>
 <8675019.20qUY4dC6X@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8675019.20qUY4dC6X@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/15/2015 02:44 AM, Arnd Bergmann wrote:
> On Thursday 01 October 2015 15:33:02 Chunyan Zhang wrote:
>> There is a mandate of 16-byte aligned stack on AArch64 [1], so the
>> STACK_SIZE here should also be 16-byte aligned, otherwise we would
>> get an error when calling clone().
>>
>> [1] http://lxr.free-electrons.com/source/arch/arm64/kernel/process.c#L265
>>
>> Signed-off-by: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
> 
> Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> 
> This should probably also be marked
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 

Thank you both. Now applied to linux-kselftest next for 4.4

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
