From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Thu, 26 Feb 2015 14:56:52 +0000
Message-ID: <54EF3434.6040003@linaro.org>
References: <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org> <CAL_Jsq+SeuoojgTpv1y_aPJ_jzDr3HqZhYEBQ3_vYGBHvcccug@mail.gmail.com> <54E78A31.9020306@linaro.org> <CAL_Jsq+mvpRjYfL_8OseTDCB-6aBhwhNKLBQXXJeVQLDwWm8Nw@mail.gmail.com> <20150222143211.GX25269@lukather> <CAL_JsqLqqw5DyUqCaOTSKPwF-Ms5EU4f_OPoW9YVpMCo8A_bbw@mail.gmail.com> <54EBB3AC.30000@codeaurora.org> <20150224092155.GO25269@lukather> <20150225013049.GJ24928@codeaurora.org> <54EEE46B.6090905@linaro.org> <20150226132107.GH29241@lukather>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150226132107.GH29241@lukather>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Cc: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 26/02/15 13:21, Maxime Ripard wrote:
> On Thu, Feb 26, 2015 at 09:16:27AM +0000, Srinivas Kandagatla wrote:
>> I think we are making simple eeprom framework too smart which will
>> break in future.
>>
>> IMHO, Anything on top of eeprom interface that interprets the data should
>> not go into the eeprom framework itself, it can either live some parsers/SOC
>> specific drivers/interfaces.
>
> True, but that doesn't mean that this parser support can't be built
> within the framework itself.
I was more of thinking parsers/interpreters as a layer on top of this 
framework. Allowing the simplest users direct access to framework. Also 
just eeprom_read() apis would not cater for all the parsers and I think 
it would be very difficult to come up with abstracted consumer apis for 
all the parsers which could be iterator or link-lists parsers or 
something very different.

>
>> As Stephen pointed out earlier lets start with something like this, which
>> would provide a better abstraction to the discussed use cases like
>> serial-number and packed data in eeprom.
>>
>>     qfprom@1000000 {
>>        reg = <0x1000000 0x1000>;
>>        ranges = <0 0x1000000 0x1000>;
>>        compatible = "qcom,qfprom-msm8960"
>>
>>        pvs-data: pvs-data@40 {
>>              compatible = "qcom,pvs-a";
>>              reg = <0x40 0x20>,
>>        };
>>
>>         tsens-data: tmdata@10 {
>>              reg = <0x10 40>;
>>        };
>>
>>        serial-number: serial@50 {
>>              compatible = "qcom,serial-msm8960";
>>              reg = <0x50 4>, <0x60 4>;
>>        };
>>
>>     };
>
> And I'm sorry, but I still don't get why the compatibles are needed
> here.
This is an optional property, only purpose of this would be to serve as 
parser/soc-specific identifier.

>
>> and then on the consumer side:
>>
>> 	device {
>> 		eeproms = <&serial-number>;
>> 		eeprom-names = "soc-rev-id";
>> 	};
>> 	
>> driver side:
>>
>> 	eeprom_get_cell()
>> 	eeprom_read();
>
> Looks good otherwise.
thanks
--srini
>
> Maxime
>
