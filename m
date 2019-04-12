From: Daniel Drake <drake@endlessm.com>
Subject: Re: [PATCH v2 10/11] platform/x86: asus-wmi: Switch fan boost mode
Date: Fri, 12 Apr 2019 16:03:17 +0800
Message-ID: <CAD8Lp45ivFJiW0FZo+ZOyUdpV1JFwPg=o7rx7eyp_YdSAbRRkg@mail.gmail.com>
References: <a8dd77f3-1e28-6416-5f04-aff44d5bb6d6@gmail.com>
 <72b3e0aa-d53a-8a82-1505-f4f00aa2bb46@gmail.com> <fecb4870-7875-a524-bf6d-3108e25af888@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fecb4870-7875-a524-bf6d-3108e25af888@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yurii Pavlovskyi <yurii.pavlovskyi@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, acpi4asus-user <acpi4asus-user@lists.sourceforge.net>, Platform Driver <platform-driver-x86@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Endless Linux Upstreaming Team <linux@endlessm.com>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 11, 2019 at 1:47 PM Yurii Pavlovskyi
<yurii.pavlovskyi@gmail.com> wrote:
> * 0x00 - is normal,
> * 0x01 - is obviously turbo by the amount of noise, might be useful to
> avoid CPU frequency throttling on high load,
> * 0x02 - the meaning is unknown at the time as modes are not named
> in the vendor documentation, but it does look like a quiet mode as CPU
> temperature does increase about 10 degrees on maximum load.

I'm curious which vendor documentation you're working with here.

>From the spec,
0 = normal
1 = overboost
2 = silent

Also you can use DSTS on the 0x00110018 device to check the exact
capabilities supported, which you should use to refine which modes can
be cycled through.
Bit 0 = overboost supported
Bit 1 = silent supported

Thanks
Daniel
