From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 08/10] ARM: configs: add MPS2 defconfig
Date: Tue, 16 Feb 2016 15:14:14 +0000
Message-ID: <56C33CC6.4030509@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com> <2680417.bULLX3O66Y@wuerfel> <56C3378F.2010008@arm.com> <11778979.HbWgmZUCnF@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <11778979.HbWgmZUCnF@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org, andy.shevchenko@gmail.com, galak@codeaurora.org, linux-serial@vger.kernel.org, u.kleine-koenig@pengutronix.de, tglx@linutronix.de, linux-api@vger.kernel.org, jslaby@suse.cz
List-Id: linux-api@vger.kernel.org

On 16/02/16 15:08, Arnd Bergmann wrote:
> On Tuesday 16 February 2016 14:51:59 Vladimir Murzin wrote:
>>>
>>> Why CONFIG_EMBEDDED? You probably mean CONFIG_EXPERT, but then what do
>>> you need that for?
>>
>> TBH, I have no special requirement for this option to be set and now,
>> looking at Kconfig entry for this option, I think that I got it here
>> because I stated configuration with allnoconfig.
>>
>> OTOH, I don't see how harmful it can be since description says:
>>
>>           This option should be enabled if compiling the kernel for
>>           an embedded system so certain expert options are available
>>           for configuration
>>
>> yes, it selects CONFIG_EXPERT and that had side effect that, for
>> example, CONFIG_NAMESPACE could be compiled out.
>>
>> Have I missed something around it?
> 
> Just the history behind this symbol. We removed it a while ago in
> favor if CONFIG_EXPERT, assuming that it makes it clearer that it's
> not just for embedded systems, or for systems with small memory.
> 
> It's  basically a zombie symbol that nobody should use directly
> (independent of what the documentation says...).

Good to know! I'll drop it then.

Thanks
Vladimir

> 
> 	Arnd
> 
> 
> 
