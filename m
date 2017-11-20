From: Romain Perier <romain.perier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] time: Make NTP optionnal
Date: Mon, 20 Nov 2017 17:29:53 +0100
Message-ID: <CABgxDoKXJSkx88XAN=pcL25GJtevM7wkEn4AbigZr1CYKrAWyg@mail.gmail.com>
References: <20171102182950.6129-1-romain.perier@gmail.com>
 <dd52374f-af2d-3ff1-b9cf-fbf28634a739@sony.com> <CABgxDoKm3PZuzV9H=jFnMOQoxKg2_byA7kane-kDhcVEwd9FJw@mail.gmail.com>
 <24617dd4-66ed-d7c9-4c2c-8ad2faac7b72@sony.com> <20171120160853.2a1bb7b2@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120160853.2a1bb7b2@alans-desktop>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: peter enderborg <peter.enderborg-7U/KSKJipcs@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

So even if the correspondong syscall are disabled and the
corresponding clocks too, you should return an -ENOSYS from the
do_adjtimex helper, in case that another component tries to use it in
the kernel, right ?

Regards,
Romain

2017-11-20 17:08 GMT+01:00 Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>:
> On Mon, 20 Nov 2017 16:22:06 +0100
> peter enderborg <peter.enderborg-7U/KSKJipcs@public.gmane.org> wrote:
>
>> On 11/20/2017 04:00 PM, Romain Perier wrote:
>> > Hi,
>> >
>> > 2017-11-20 15:10 GMT+01:00 peter enderborg <peter.enderborg-7U/KSKJipcs@public.gmane.org>:
>> >> I think it should return a error code at least.
>> > In which case ? The idea was to don't change the behaviour of these
>> > functions (from the "API" point of view) and to avoid regressions in
>> > the kernel components that depend on these NTP feature.
>> > (so be transparent the most as possible)
>> >
>> > Thanks,
>> > Romain
>> >
>>
>> do_adjtimex should return -ENOSYS in my opinion, however it is not in the manual
>> that it can return ENOSYS.
>
> The standards specifications state what must be returned for certain
> error cases, they don't forbid other errors being added.
>
> Old old Linx will of course already return -1,ENOSYS to this call.
>
> Alan
