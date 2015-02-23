From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Sun, 22 Feb 2015 18:57:34 -0600
Message-ID: <CAL_JsqLqqw5DyUqCaOTSKPwF-Ms5EU4f_OPoW9YVpMCo8A_bbw@mail.gmail.com>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org>
 <CAL_Jsq+SeuoojgTpv1y_aPJ_jzDr3HqZhYEBQ3_vYGBHvcccug@mail.gmail.com>
 <54E78A31.9020306@linaro.org> <CAL_Jsq+mvpRjYfL_8OseTDCB-6aBhwhNKLBQXXJeVQLDwWm8Nw@mail.gmail.com>
 <20150222143211.GX25269@lukather>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150222143211.GX25269@lukather>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Feb 22, 2015 at 8:32 AM, Maxime Ripard
<maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org> wrote:
> On Fri, Feb 20, 2015 at 04:01:55PM -0600, Rob Herring wrote:
>> [...]
>>
>> >>> += Data consumers =
>> >>> +
>> >>> +Required properties:
>> >>> +
>> >>> +eeproms: List of phandle and data cell specifier triplet, one triplet
>> >>> +        for each data cell the device might be interested in. The
>> >>> +        triplet consists of the phandle to the eeprom provider, then
>> >>> +        the offset in byte within that storage device, and the length
>> >>> +        in byte of the data we care about.
>> >>
>> >>
>> >> The problem with this is it assumes you know who the consumer is and
>> >> that it is a DT node. For example, how would you describe a serial
>> >> number?
>> >
>> > Correct me if I miss understood.
>> > Is serial number any different?
>> > Am hoping that the eeprom consumer would be aware of offset and size of
>> > serial number in the eeprom
>> >
>> > Cant the consumer do:
>> >
>> > eeprom-consumer {
>> >         eeproms = <&at24 0 4>;
>> >         eeprom-names = "device-serial-number";
>>
>> Yes, but who is "eeprom-consumer"?
>
> Any device that should lookup values in one of the EEPROM.
>
>> DT nodes generally describe a h/w block, but it this case, the
>> consumer depends on the OS, not the h/w.
>
> Not really, or at least, not more than any similar binding we
> currently have.
>
> The fact that a MAC-address for the first ethernet chip is stored at a
> given offset in a given eeprom has nothing to do with the OS.

So MAC address would be a valid use to link to a h/w device, but there
are certainly cases that don't correspond to a device.

>> I'm not saying you can't describe where things are, but I don't
>> think you should imply who is the consumer and doing so is
>> unnecessarily complicated.
>
> If you only take the case of a serial number, indeed. If you take
> other usage into account, you can't really do without it.
>
>> Also, the layout of EEPROM is likely very much platform specific.
>
> Indeed, which is why it should be in the DT.

Agreed. I'm not saying the layout should not be.

>> Some could have a more complex structure perhaps with key ids and
>> linked list structure.
>
> Then just request the size of the whole list, and parse it afterwards
> in your driver?
>
>> I would do something more simple that is just a list of keys and their
>> location like this:
>>
>> device-serial-number = <start size>;
>> key1 = <start size>;
>> key2 = <start size>;
>
> I'm sorry, but what's the difference?

It can describe the layout completely whether the fields are tied to a
h/w device or not.

What I would like to see here is the entire layout described covering
both types of fields.

Rob
