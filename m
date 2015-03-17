From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v3 05/15] dt-bindings: Document the STM32 reset bindings
Date: Tue, 17 Mar 2015 17:57:47 +0100
Message-ID: <CALszF6AVKnSPzOhyBQaOnQJwo34gx-rwRdb3RgL_pDNaX1FpNg@mail.gmail.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
	<1426197361-19290-6-git-send-email-maxime.coquelin@st.com>
	<55022AC0.7090403@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55022AC0.7090403@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft>
List-Id: linux-api@vger.kernel.org

Hi Chanwoo,

2015-03-13 1:09 GMT+01:00 Chanwoo Choi <cw00.choi@samsung.com>:
> Hi Maxime,
>
> On 03/13/2015 06:55 AM, Maxime Coquelin wrote:
>> From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>
>> This adds documentation of device tree bindings for the
>> STM32 reset controller.
>>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>> ---
>>  .../devicetree/bindings/reset/st,stm32-rcc.txt     | 102 +++++++++++++++++++++
>>  1 file changed, 102 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>>
>> diff --git a/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt b/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>> new file mode 100644
>> index 0000000..962f961
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
<snip>

>> + - can1: 281
>> + - can2: 282
>> + - pwr: 284
>> + - dac: 285
>> + - uart7: 286
>> + - uart8: 287
>> + - tim1: 288
>> + - tim8: 289
>> + - usart1: 292
>> + - usart6: 293
>> + - adc: 296
>> + - sdio: 299
>> + - spi1: 300
>> + - spi4: 301
>> + - syscfg: 302
>> + - tim9: 304
>> + - tim10: 305
>> + - tim11: 306
>> + - spi5: 308
>> + - spi6: 309
>> + - sai1: 310
>> + - ltdc: 31
>> +
>>
>
> Last line is un-necessary. When I applied this patch for test
> "new blank line at EOF" happen.

Thanks, that will be fixed in v4.

Kind regards,
Maxime
>
> +++ b/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
> @@ -99,4 +99,3 @@ List of indexes for STM32F429:
>   - spi6: 309
>   - sai1: 310
>   - ltdc: 31
> -
>
> Thanks,
> Chanwoo Choi
>
