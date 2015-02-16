From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH 05/14] ARM: call reset_controller_of_init from default
 time_init handler
Date: Mon, 16 Feb 2015 13:02:55 +0100
Message-ID: <CALszF6DqB8UDBRU0sGCfdSOyU2YvBg6GoN4Ag5mHU2GTJeDjfA@mail.gmail.com>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1423763164-5606-6-git-send-email-mcoquelin.stm32@gmail.com>
	<CAL_Jsq+Sk0C-1UHCKE18fEVwBbV=quV9mrJSKTO_UPXWcaYfCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAL_Jsq+Sk0C-1UHCKE18fEVwBbV=quV9mrJSKTO_UPXWcaYfCw@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Philipp Zabel <p.zabel@pengutronix.de>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees
List-Id: linux-api@vger.kernel.org

2015-02-15 23:17 GMT+01:00 Rob Herring <robherring2@gmail.com>:
> On Thu, Feb 12, 2015 at 11:45 AM, Maxime Coquelin
> <mcoquelin.stm32@gmail.com> wrote:
>> Some DT ARM platforms need the reset controllers to be initialized before
>> the timers.
>> This is the case of the stm32 and sunxi platforms.
>
> I would say this is the exception, not the rule and therefore should
> be handled in a machine desc function. Or it could be part of your
> timer setup. Or is the bootloader's problem (like arch timer setup).

The only valid way in my opinion would be to implement the init_time
callback (as your first proposal),
duplicating what performs the time_init() function.

Then, if other machines than sunxi and stm32 have some day the same need,
we could consider moving the call to reset_controller_of_init()
function to time_init().

>
> We just want to limit how much this mechanism gets used.

Could you elaborate the reason why we want to limit this mechanism please?
I am not sure to understand.

Thanks,
Maxime

>
> Rob
>
>>
>> This patch adds a call to reset_controller_of_init() to the default
>> .init_time callback when RESET_CONTROLLER is used by the platform.
>>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>> ---
>>  arch/arm/kernel/time.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
>> index 0cc7e58..4601b1e 100644
>> --- a/arch/arm/kernel/time.c
>> +++ b/arch/arm/kernel/time.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/irq.h>
>>  #include <linux/kernel.h>
>>  #include <linux/profile.h>
>> +#include <linux/reset-controller.h>
>>  #include <linux/sched.h>
>>  #include <linux/sched_clock.h>
>>  #include <linux/smp.h>
>> @@ -117,6 +118,9 @@ void __init time_init(void)
>>         if (machine_desc->init_time) {
>>                 machine_desc->init_time();
>>         } else {
>> +#ifdef CONFIG_RESET_CONTROLLER
>> +               reset_controller_of_init();
>> +#endif
>>  #ifdef CONFIG_COMMON_CLK
>>                 of_clk_init(NULL);
>>  #endif
>> --
>> 1.9.1
>>
