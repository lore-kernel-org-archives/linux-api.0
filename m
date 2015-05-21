From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/9] y2038: asm-generic: extend sysvipc data structures
Date: Thu, 21 May 2015 16:52:31 +0200
Message-ID: <2463292.dEmUgCQccn@wuerfel>
References: <1432134445-804487-1-git-send-email-arnd@arndb.de> <1432134445-804487-3-git-send-email-arnd@arndb.de> <CAMuHMdUtJ2x+axBLj5qdsRwod=XdRkmeYJm1N7H5V_CXLo5J0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUtJ2x+axBLj5qdsRwod=XdRkmeYJm1N7H5V_CXLo5J0g@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: y2038@lists.linaro.org, baolin.wang@linaro.org, albert.aribaud@3adev.fr, John Stultz <john.stultz@linaro.org>, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, libc-alpha@sourceware.org, Linux-Arch <linux-arch@vger.kernel.org>, Manfred Spraul <manfred@colorfullife.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thursday 21 May 2015 10:56:34 Geert Uytterhoeven wrote:
> > + * value using
> > + *
> > + * user_semid_ds.sem_otime = kernel_semid64_ds.sem_otime +
> > + *             (long long)(kernel_semid64_ds.sem_otime_high << 32)
> 
> The cast to "long long" should be inside the parentheses, to promote the
> (32-bit) sem_otime_high to a first 64-bit integer first.
> Else it will be shifted into oblivion (oh no, C undefined behavior).
> 
> 

Fixed now to say

 * user_semid_ds.sem_otime = kernel_semid64_ds.sem_otime +
 *             ((long long)kernel_semid64_ds.sem_otime_high << 32)

Thanks!

	Arnd
