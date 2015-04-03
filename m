From: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH 0/5] Enhancements to twl4030 phy to support better charging
 - V2
Date: Fri, 3 Apr 2015 19:08:22 +0530
Message-ID: <551E97CE.4000501@ti.com>
References: <20150322223307.21765.62974.stgit@notabene.brown> <551325B0.1090308@ti.com> <20150326082219.510ac598@notabene.brown> <55134BEE.7050406@ti.com> <20150401154102.5f57ec1e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150401154102.5f57ec1e-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>, Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, myungjoo.ham-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

+Extcon MAINTAINERS

Hi,

On Wednesday 01 April 2015 10:11 AM, NeilBrown wrote:
> On Thu, 26 Mar 2015 05:29:42 +0530 Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
> wrote:
>
>> Hi NeilBrown,
>>
>> On Thursday 26 March 2015 02:52 AM, NeilBrown wrote:
>>> On Thu, 26 Mar 2015 02:46:32 +0530 Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
>>> wrote:
>>>
>>>> Hi,
>>>>
>>>> On Monday 23 March 2015 04:05 AM, NeilBrown wrote:
>>>>> Hi Kishon,
>>>>>   I wonder if you could queue the following for the next merge window.
>>>>>   They allow the twl4030 phy to provide more information to the
>>>>>   twl4030 battery charger.
>>>>>   There are only minimal changes since the first version, particularly
>>>>>   documentation has been improved.
>>>>
>>>> There are quite a few things in this series which use the USB PHY library
>>>> interface which is kindof deprecated. We should try and use the Generic PHY
>>>> library for all of them. It would also be better to add features to the
>>>> PHY framework if the we can't achieve something with the existing PHY
>>>> framework.
>>>
>>> Hi,
>>>   are you able to more specific at all?  What is the "USB PHY library"?
>>> Where exactly is the "PHY framework"?
>>
>> There is a USB PHY library that exists in drivers/usb/phy/phy.c and there is
>> a Generic PHY framework that is present in drivers/phy/phy-core.c. twl4030
>> actually supports both the framework.
>>
>> In your patch whatever uses struct usb_phy uses the old USB PHY library and
>> whatever uses struct phy uses the generic PHY framework. (Actually your patch
>> does not use the PHY framework at all). We want to deprecate using the USB PHY
>> library and make everyone use the generic PHY framework. Adding features
>> to a driver using the USB PHY library will make the transition to generic PHY
>> framework a bit more difficult.
>>
>> Now all the features that is supported in the USB PHY library may not be
>> supported by the PHY framework. So we should start extending the PHY framework
>> instead of using the USB PHY library.
>>
>> One think I noticed in your driver is using atomic notifier chain. IMO extcon
>> framework should be used in twl4030 USB driver to notify the controller driver
>> instead of using USB PHY notifier. For all other things we have to see if it
>> can be added in the PHY framework.
>
> I've had a look at the code with these issues in mind, and there is one issue
> that I'm not sure about.
>
> In phy-twl4030-usb, the usb_phy is used to hold a reference to the
> 'struct otg', and for passing cable state changes to the notifier.

right now we directly call omap_musb_mailbox no? we don't use notifiers right?
>
> The former probably has to stay until musb can keep a reference to the otg,
> separate form the usb_phy.  The latter can be changed to use extcon - to
> some extent.  I actually have patches to do that from a couple of years back,
> but I never proceeded with them.
>
> The problem is that one thing that needs to be communicated to the charger is
> the max current that was negotiated by a "Standard Downstream Port".
> This could be 500mA from a powered hum, or much less from an unpowered hub.
> (Currently the usb gadget code does negotiated between different
> possibilities, but it could and hopefully will one day).
>
> With the notifier chain there is an easy way to communicate the allowed
> current once it is negotiated. e.g. ab8500_usb_set_power() does this.
>
> 'struct phy' has no equivalent of the 'set_power' callback  which 'struct
> usb_phy' provides, and extcon has no mechanism (that I can see) for
> communicating a number - just binary cable states.

Chanwoo Choi, Can this be modified so that we can communicate numbers like in
the case of EXTCON_CHARGE_DOWNSTREAM?
>
> Presumably a 'set_power' method could be added to 'struct phy' so the
> usb-core can communicate the number to the phy, but it is not clear to me how
> the 'phy' can communicate it to the charger.

Should the PHY be involved in all this? We can make the gadget driver
directly communicate the value to the charger no?
> The 'phy' could provide an API to request the current negotiated max current,
> but there still needs to be a way to let the charger know that this has
> changed.
> That could in theory be done via extcon, by having a secondary
> 'USB_connected' cable type, but it isn't really a cable type and pretending
> that it is seems wrong.

I think EXTCON_CHARGE_DOWNSTREAM was created for that purpose. Chanwoo?

Thanks
Kishon
