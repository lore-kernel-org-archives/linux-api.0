From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC][PATCH] sysctl: Remove the sysctl system call
Date: Wed, 02 Oct 2019 09:41:00 -0500
Message-ID: <87a7aji51f.fsf@x220.int.ebiederm.org>
References: <8736gcjosv.fsf@x220.int.ebiederm.org>
        <201910011140.EA0181F13@keescook>
        <87imp8hyc8.fsf@x220.int.ebiederm.org>
        <CAK8P3a1zLATC7rzYxSpAK-z=NJ1rw7-3ZgHqCOJUUf6b9HwK1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1zLATC7rzYxSpAK-z=NJ1rw7-3ZgHqCOJUUf6b9HwK1A@mail.gmail.com>
        (Arnd Bergmann's message of "Wed, 2 Oct 2019 09:31:01 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>, Cong Wang <xiyou.wangcong@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>, Apelete Seketeli <apelete@seketeli.net>, Chee Nouk Phoon <cnphoon@altera.com>, Chris Zankel <chris@zankel.net>, Christian Ruppert <christian.ruppert@abilis.com>, Greg Ungerer <gerg@uclinux.org>, Helge Deller <deller@gmx.de>, Hongliang Tao <taohl@lemote.com>, Huacai Chen <chenhc@lemote.com>, Jonas Jensen <jonas.jensen@gmail.com>, Josh Boyer <jwboyer@gmail.com>, Jun Nie <jun.nie@linaro.org>
List-Id: linux-api@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Wed, Oct 2, 2019 at 12:54 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Kees Cook <keescook@chromium.org> writes:
>> > On Tue, Oct 01, 2019 at 01:36:32PM -0500, Eric W. Biederman wrote:
>> >
>> > I think you can actually take this further and remove (or at least
>> > empty) the uapi/linux/sysctl.h file too.
>>
>> I copied everyone who had put this into a defconfig and I will wait a
>> little more to see if anyone screams.  I think it is a safe guess that
>> several of the affected configurations are dead (or at least
>> unmaintained) as I received 17 bounces when copying everyone.
>
> Looking at the arm defconfigs:
>
>> arch/arm/configs/axm55xx_defconfig:CONFIG_SYSCTL_SYSCALL=y
>
> No notable work on this platform since it got sold to Intel in 2014.
> I think they still use it but not with mainline kernels that lack support
> for most drivers and the later chips.
>
>> arch/arm/configs/keystone_defconfig:CONFIG_SYSCTL_SYSCALL=y
>
> Not that old either, but this hardware is mostly obsoleted by newer variants
> that we support with the arm64 defconfig.
>
>> arch/arm/configs/lpc32xx_defconfig:CONFIG_SYSCTL_SYSCALL=y
>> arch/arm/configs/moxart_defconfig:CONFIG_SYSCTL_SYSCALL=y
>
> Ancient hardware, but still in active use. These tend to have very little
> RAM, but they both enable CONFIG_PROC_FS.
>
>> arch/arm/configs/qcom_defconfig:CONFIG_SYSCTL_SYSCALL=y
>> arch/arm/configs/zx_defconfig:CONFIG_SYSCTL_SYSCALL=y
>
> These are for older Qualcomm and LG chips that tend to be used
> with Android rather than the defconfig here. Maybe double-check
> if the official android-common tree enables SYSCTL_SYSCALL.

I just looked quickly at:
https://android.googlesource.com/kernel/configs/

I don't see the string SYSCTL mentioned anywhere.  Much less
SYSCTL_SYSCALL.

Eric
