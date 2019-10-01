From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC][PATCH] sysctl: Remove the sysctl system call
Date: Tue, 01 Oct 2019 17:53:27 -0500
Message-ID: <87imp8hyc8.fsf@x220.int.ebiederm.org>
References: <8736gcjosv.fsf@x220.int.ebiederm.org>
        <201910011140.EA0181F13@keescook>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201910011140.EA0181F13@keescook> (Kees Cook's message of "Tue, 1
        Oct 2019 11:46:45 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>, Cong Wang <xiyou.wangcong@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>, Apelete Seketeli <apelete@seketeli.net>, Arnd Bergmann <arnd@arndb.de>, Chee Nouk Phoon <cnphoon@altera.com>, Chris Zankel <chris@zankel.net>, Christian Ruppert <christian.ruppert@abilis.com>, Greg Ungerer <gerg@uclinux.org>, Helge Deller <deller@gmx.de>, Hongliang Tao <taohl@lemote.com>, Huacai Chen <chenhc@lemote.com>, Jonas Jensen <jonas.jensen@gmail.com>, Josh Boyer <jwboyer@gmail.com>, Jun Nie <jun.nie@linaro.org>, Lars-Peter Clausen <lars@metafoo.de>
List-Id: linux-api@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Tue, Oct 01, 2019 at 01:36:32PM -0500, Eric W. Biederman wrote:
>> 
>> This system call has been deprecated almost since it was introduced, and
>> in a survey of the linux distributions I can no longer find any of them
>> that enable CONFIG_SYSCTL_SYSCALL.  The only indication that I can find
>> that anyone might care is that a few of the defconfigs in the kernel
>> enable CONFIG_SYSCTL_SYSCALL.  However this appears in only 31 of 414
>> defconfigs in the kernel, so I suspect this symbols presence is simply
>> because it is harmless to include rather than because it is necessary.
>> 
>> As there appear to be no users of the sysctl system call, remove the
>> code.  As this removes one of the few uses of the internal kernel mount
>> of proc I hope this allows for even more simplifications of the proc
>> filesystem.
>
> I'm for it. :) I tripped over this being deprecated over a decade ago. :P
>
> I think you can actually take this further and remove (or at least
> empty) the uapi/linux/sysctl.h file too.

I copied everyone who had put this into a defconfig and I will wait a
little more to see if anyone screams.  I think it is a safe guess that
several of the affected configurations are dead (or at least
unmaintained) as I received 17 bounces when copying everyone.

I would make it a followup that removes uapi/linux/sysctl.h.  I don't
see anything in it that isn't about the sysctl system call.  I will keep
it a separate patch as I can imagine something silly that needs the
header file to compile.  A separate patch would make a revert easier
if we find something like that.

Eric
