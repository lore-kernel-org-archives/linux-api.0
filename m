From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v3 09/11] platform/x86: asus-wmi: Control RGB keyboard backlight
Date: Fri, 10 May 2019 00:06:11 +0300
Message-ID: <CAHp75VcSVumVg74==bM3cBcZZ2iUNDnUao6h9Q6ktcyEuAKDew@mail.gmail.com>
References: <7acd57fe-604a-a96a-4ca2-a25bc88d6405@gmail.com>
 <c953b43b-6186-77e9-54b1-b1cd1d7d1eb6@gmail.com> <CAHp75Vf9uPG7_K0P26nHYCH0WB6LFX3wk8aJBpLWQ-r46kDw9w@mail.gmail.com>
 <20190508171229.GA22024@amd> <52e73640-9fbf-437b-537a-7b3dc167052f@gmail.com> <2f26dd9e-ada7-8e20-c810-a647854c338c@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2f26dd9e-ada7-8e20-c810-a647854c338c@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Murphy <dmurphy@ti.com>
Cc: Yurii Pavlovskyi <yurii.pavlovskyi@gmail.com>, Pavel Machek <pavel@ucw.cz>, Jacek Anaszewski <jacek.anaszewski@gmail.com>, Linux LED Subsystem <linux-leds@vger.kernel.org>, Corentin Chary <corentin.chary@gmail.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Daniel Drake <drake@endlessm.com>, acpi4asus-user <acpi4asus-user@lists.sourceforge.net>, Platform Driver <platform-driver-x86@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, May 9, 2019 at 11:45 PM Dan Murphy <dmurphy@ti.com> wrote:
> On 5/9/19 2:04 PM, Yurii Pavlovskyi wrote:
> We are working on a framework for this.
>
> Please see this series
> https://lore.kernel.org/patchwork/project/lkml/list/?series=390141
>
> It is still a work in progress

Side question:
Have you considered to convert existing color LED controllers? (It
seems to me that your proposal lacks of the idea to keep back
compatibility with the existing controllers whre user may create a
sysfs node based on the arbitrary label, while it's good to have
multicolor infrastructure like in your proposal. Did I miss
something?)


-- 
With Best Regards,
Andy Shevchenko
