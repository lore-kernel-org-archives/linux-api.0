From: Dan Murphy <dmurphy@ti.com>
Subject: Re: [PATCH v3 09/11] platform/x86: asus-wmi: Control RGB keyboard
 backlight
Date: Thu, 9 May 2019 16:44:20 -0500
Message-ID: <962ec05e-b4ca-89b7-405c-f8a76f19427c@ti.com>
References: <7acd57fe-604a-a96a-4ca2-a25bc88d6405@gmail.com>
 <c953b43b-6186-77e9-54b1-b1cd1d7d1eb6@gmail.com>
 <CAHp75Vf9uPG7_K0P26nHYCH0WB6LFX3wk8aJBpLWQ-r46kDw9w@mail.gmail.com>
 <20190508171229.GA22024@amd> <52e73640-9fbf-437b-537a-7b3dc167052f@gmail.com>
 <2f26dd9e-ada7-8e20-c810-a647854c338c@ti.com>
 <CAHp75VcSVumVg74==bM3cBcZZ2iUNDnUao6h9Q6ktcyEuAKDew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VcSVumVg74==bM3cBcZZ2iUNDnUao6h9Q6ktcyEuAKDew@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Yurii Pavlovskyi <yurii.pavlovskyi@gmail.com>, Pavel Machek <pavel@ucw.cz>, Jacek Anaszewski <jacek.anaszewski@gmail.com>, Linux LED Subsystem <linux-leds@vger.kernel.org>, Corentin Chary <corentin.chary@gmail.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Daniel Drake <drake@endlessm.com>, acpi4asus-user <acpi4asus-user@lists.sourceforge.net>, Platform Driver <platform-driver-x86@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Andy

On 5/9/19 4:06 PM, Andy Shevchenko wrote:
> On Thu, May 9, 2019 at 11:45 PM Dan Murphy <dmurphy@ti.com> wrote:
>> On 5/9/19 2:04 PM, Yurii Pavlovskyi wrote:
>> We are working on a framework for this.
>>
>> Please see this series
>> https://lore.kernel.org/patchwork/project/lkml/list/?series=390141
>>
>> It is still a work in progress
> 
> Side question:
> Have you considered to convert existing color LED controllers? (It
> seems to me that your proposal lacks of the idea to keep back
> compatibility with the existing controllers whre user may create a
> sysfs node based on the arbitrary label, while it's good to have
> multicolor infrastructure like in your proposal. Did I miss
> something?)
> 
> 

Yes that is part of the work that is in progress.
The LED driver should be able to register either a single color LED or a group of colored LEDs.

This can be based on a firmware entry and which LED framework the driver chooses to register to. Either the
multicolor framework or the base LED framework.  Of course we can put this in code and keep it
out of the firmware nodes again thats why it is wip.

I have convert a couple of drivers over in my testing that support RGB modules or have a RGB cluter used to mix
colors.

If the product wants to expose a single red LED via the label then they use legacy registration.
If the product wants to expose RGBW as a single group then the multicolor framework should be registered too.


Dan
