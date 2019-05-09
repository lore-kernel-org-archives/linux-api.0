From: Yurii Pavlovskyi <yurii.pavlovskyi@gmail.com>
Subject: Re: [PATCH v3 09/11] platform/x86: asus-wmi: Control RGB keyboard
 backlight
Date: Thu, 9 May 2019 21:04:53 +0200
Message-ID: <52e73640-9fbf-437b-537a-7b3dc167052f@gmail.com>
References: <7acd57fe-604a-a96a-4ca2-a25bc88d6405@gmail.com>
 <c953b43b-6186-77e9-54b1-b1cd1d7d1eb6@gmail.com>
 <CAHp75Vf9uPG7_K0P26nHYCH0WB6LFX3wk8aJBpLWQ-r46kDw9w@mail.gmail.com>
 <20190508171229.GA22024@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190508171229.GA22024@amd>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>, Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>, Linux LED Subsystem <linux-leds@vger.kernel.org>, Corentin Chary <corentin.chary@gmail.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Daniel Drake <drake@endlessm.com>, acpi4asus-user <acpi4asus-user@lists.sourceforge.net>, Platform Driver <platform-driver-x86@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

First of all, thanks to Andy for all the review comments!

I will implement all the ones that I didn't directly answer on as well and
update this series shortly.

Regarding this patch,

On 08.05.19 19:12, Pavel Machek wrote:
>> Shouldn't be the LED subsystem driver for this?
> 
> Yes, please. We have common interface for LED drivers; this needs to
> use it.

That is indeed a better option and I did in fact considered this first and
even did a test implementation. The discoveries were:
1. The WMI methods are write-only and only written all at once in a
transaction manner (also invoking solely first RGB-interface method has no
effect until some other keyboard backlight method is called).
2. In addition to RGB there are several control values, which switch
effects, speed and enable or disable the backlight under specific
conditions or switch whether it is set temporarily or permanently (not that
these are critical functionalities, but for the sake of completeness).
3. The EC is really slow
# time bash -c "echo 1 > /sys/devices/platform/faustus/kbbl_set"

real	0m0,691s
user	0m0,000s
sys	0m0,691s

(please ignore the sysfs-path there, it's essentially the same code running
as in this patch). It is consistently same for both temporary and permanent
configuration. Writing after every change would take about (6+)x of that.
Not that it's that unbearable though as it is not likely to be done often.

I was not quite happy with that implementation so I opted for writing sort
of sysfs wrapper instead that would allow same sort of transactions as
provided by BIOS. I agree that it's non-standard solution.

If I understood correctly, the typical current RGB led_class devices from
the Linux tree currently provide channels as separate LEDs. There are also
blink / pattern options present, I guess one could misuse them for setting
effects and speed. So one could make 3 devices for RGB + 3 for awake,
sleep, boot modes + 1 for setting effect / speed.

I'd guess the end solution might be also either something like combination
of both approaches (RGB leds + separate sysfs interface) or some extension
of the led_class device interface. Dropping support of the non-essential
features for the sake of uniformity of ABI would also be an option to
consider (exposing just three RGB LEDs with brightness only), not happy one
though.

In any case this looks like it might need some additional research,
discussion, development, and a pair of iterations so I tend to separate
this patch from the series and post it extra after the others are through
to avoid dragging 10+ patches around.

Any suggestions on how to do this properly would be appreciated. That's the
best I could come up with at the moment.

Thanks,
Yurii
