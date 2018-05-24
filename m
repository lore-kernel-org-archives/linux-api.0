From: "Dr. Philipp Tomsich" <philipp.tomsich@theobroma-systems.com>
Subject: Re: [PATCH 07/24] arm64: ilp32: add documentation on the ILP32 ABI
 for ARM64
Date: Thu, 24 May 2018 14:24:19 +0200
Message-ID: <ACC31423-0367-4DB4-B077-B85639FA416C@theobroma-systems.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
 <20180516081910.10067-8-ynorov@caviumnetworks.com>
 <20180523140620.GA27215@amd> <20180524121524.GA3873@yury-thinkpad>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524121524.GA3873@yury-thinkpad>
Sender: linux-kernel-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Pavel Machek <pavel@ucw.cz>, Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-api@vger.kernel.org

Yury & Pavel,

> On 24 May 2018, at 14:15, Yury Norov <ynorov@caviumnetworks.com> wrote:
> 
> Hi Pavel,
> 
> On Wed, May 23, 2018 at 04:06:20PM +0200, Pavel Machek wrote:
>> On Wed 2018-05-16 11:18:52, Yury Norov wrote:
>>> Based on Andrew Pinski's patch-series.
>>> 
>>> Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
>> 
>> So Andrew's signoff should be here?
> 
> Yes it should, but it lost since v4. I'll restore it.
> 
>>> ---
>>> Documentation/arm64/ilp32.txt | 45 +++++++++++++++++++++++++++++++++++
>>> 1 file changed, 45 insertions(+)
>>> create mode 100644 Documentation/arm64/ilp32.txt
>>> 
>>> diff --git a/Documentation/arm64/ilp32.txt b/Documentation/arm64/ilp32.txt
>>> new file mode 100644
>>> index 000000000000..d0fd5109c4b2
>>> --- /dev/null
>>> +++ b/Documentation/arm64/ilp32.txt
>>> @@ -0,0 +1,45 @@
>>> +ILP32 AARCH64 SYSCALL ABI
>>> +=========================
>>> +
>>> +This document describes the ILP32 syscall ABI and where it differs
>>> +from the generic compat linux syscall interface.
>> 
>> I was hoping to learn what ILP32 is / what is it good for, but no,
>> this does not tell me... it would be good to do a short explanation
>> here, and maybe reference it from cover letter of the series...
>> 								Pavel
> 
> ILP32 is ABI acronym that means "Integers, Longs and Pointers are 32-bit".
> And LP64 means "Longs and Pointers are 64-bit”.

Just a nitpick: ILP32 is in fact just the memory model, but calling from ILP32
code into the Linux kernel requires modifications to the syscall-ABI due to
datastructure layout changing (every time a pointer or a ‘long’ is present in
a structure). As such structures are passed between the userspace and the
kernel (and also due to the fact that time_t is an ‘unsigned long’ in the C
language standard), modifications to the syscall ABI in Linux are needed to
support ILP32 processes calling into the kernel.

Things get a bit more involved, as the final consensus was to pass 64bit
quantities in the lower half of 2 64bit registers instead of as a single register:
this makes the way (on AArch64) that an ILP32 process calls into the kernel
more dissimilar from a LP64 process calling the same syscall.

What this rambling boils down to is: “ILP32" is the memory model, whereas
this series deals with the “Linux/AArch64 syscall ABI for ILP32 processes”.

Thanks,
Phil.

> 
> There's AN490 - "ILP32 for AArch64 Whitepaper" from ARM which covers
> the topic:
> http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dai0490a/ar01s01.html
> 
> And some talks:
> http://connect.linaro.org/resource/bkk16/bkk16-305b/
> 
> Briefly, ILP32 is 32-bit ABI that works with AARCH64 instruction set. It looks
> better in some performance tests, and is useful for compatibility with 32-bit
> legacy code.
> 
> If you're more familiar with x86 terminology, in ARM world LP64 corresponds
> to x86_64, AARCH32_EL0 corresponds to x86_32, and ILP32 corresponds to x32
> ABI.
> 
> I'll add link to AN490 in next submission.
> 
> Yury
> 
>> -- 
>> (english) http://www.livejournal.com/~pavelmachek
>> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
