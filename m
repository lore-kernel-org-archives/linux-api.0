From: Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Mon, 19 Jan 2015 13:20:36 +0900
Message-ID: <CAAVeFu+K0W96mi0=QR8JGSe9BpH2nC5WV_9qbSvm6LJGA8gc7Q@mail.gmail.com>
References: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
 <20150116111108.GG30960@localhost> <a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a4610e13d0094d40b7e0574992509ec6-reflc3kr++NteXefQoUsnuhlVc3/7hDbVaz/vdPVXQ4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>
Cc: Johan Hovold <johan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 17, 2015 at 1:49 AM, S=C3=B6ren Brinkmann
<soren.brinkmann-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2015-01-16 at 12:11PM +0100, Johan Hovold wrote:
>> On Thu, Jan 15, 2015 at 11:49:49AM -0800, Soren Brinkmann wrote:
>> > Add an attribute 'wakeup' to the GPIO sysfs interface which allows
>> > marking/unmarking a GPIO as wake IRQ.
>> > The file 'wakeup' is created in each exported GPIOs directory, if =
an IRQ
>> > is associated with that GPIO and the irqchip implements set_wake()=
=2E
>> > Writing 'enabled' to that file will enable wake for that GPIO, whi=
le
>> > writing 'disabled' will disable wake.
>> > Reading that file will return either 'disabled' or 'enabled' depen=
ing on
>> > the currently set flag for the GPIO's IRQ.
>> >
>> > Signed-off-by: Soren Brinkmann <soren.brinkmann-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>
>> > Reviewed-by: Alexandre Courbot <acourbot-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > Hi Linus, Johan,
>> >
>> > I rebased my patch. And things look good.
>>
>> I took at closer look at this patch now and I really don't think it
>> should be merged at all.
>>
>> We have a mechanism for handling wake-up sources (documented in
>> Documentation/power/devices.txt) as well as an ABI to enable/disable
>> them using the power/wakeup device attribute from userspace.
>
> Doesn't work for GPIOs AFAIK.
>
>>
>> Implementing proper wakeup support for unclaimed GPIOs would take so=
me
>> work (if at all desired), but that is not a reason to be adding cust=
om
>> implementations that violates the kernel's power policies and new AB=
Is
>> that would need to be maintained forever.
>
> These are claimed, by the sysfs interface.
>
>>
>> [ And we really shouldn't be adding anything to the broken gpio sysf=
s
>> interface until it's been redesigned. ]
>>
>> Meanwhile you can (should) use gpio-keys if you need to wake your sy=
stem
>> on gpio events.
>
> We had that discussion and I don't think GPIO keys is the right solut=
ion
> for every use-case.

Sorry, it has been a while - can you remind us of why?

>>
>> > But the 'is_visible' things does not behave the way I expected it =
to.
>> > It seems to be only triggered on an export but not when attributes
>> > change. Hence, in my case, everything was visiible since the inita=
l
>> > state matches that, but even when changing the direction or things
>> > like that, attributes don't disappear. Is that something still wor=
ked
>> > on? Expected
>>
>> That's expected. We generally don't want attributes to appear or
>> disappear after the device has been registered (although there is a
>> mechanism for cases were it makes sense). This is no different from
>> how your v3 patch worked either.
>
> Sure, but the is_visible thing is effectively broken for GPIO. I thin=
k a
> GPIO is in a defined state when exported and the checks all work on t=
hat
> state during export. But then this state can be changed through the
> sysfs interface. So, if the initial state hides something it becomes
> unavailable for all times and, vice versa, if the initial state makes
> something visible, it will stay even when it is no longer a valid
> property to change.

Is there anything that prevents you from patching other GPIO sysfs
hooks to remove/reenable the wakeup property as needed?
