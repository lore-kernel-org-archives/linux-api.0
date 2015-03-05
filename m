From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 3/6] eeprom: Add bindings for simple eeprom framework
Date: Thu, 05 Mar 2015 22:34:30 +0000
Message-ID: <54F8D9F6.3040003@linaro.org>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org> <1425548765-13019-1-git-send-email-srinivas.kandagatla@linaro.org> <CAL_Jsq+wrZYn82otDfLsTVpgmhLFWtzRHQ4v+qn-Ks--ZpXR8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_Jsq+wrZYn82otDfLsTVpgmhLFWtzRHQ4v+qn-Ks--ZpXR8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>> +
>> +For example:
>> +
>> +       /* Provider */
>> +       qfprom: qfprom@00700000 {
>> +               compatible      = "qcom,qfprom";
>> +               reg             = <0x00700000 0x1000>;
>> +               ...
>> +
>> +               /* Data cells */
>> +               tsens_calibration: calib@404 {
>> +                       reg = <0x404 0x10>;
>> +               };
>> +
>> +               serial_number: sn {
>> +                       reg = <0x104 0x4>, <0x204 0x4>, <0x30c 0x4>;
>> +
>> +               };
>> +               ...
>> +       };
>> +
>> += Data consumers =
>> +Are drivers which consume eeprom data cells.
>
> s/drivers/device nodes/
>
Thats true, "device nodes" makes sense.
>> +
>> +Required properties:
>> +
>> +eeproms: List of phandle and data cell the device might be interested in.
>> +
>> +Optional properties:
>> +
>> +eeprom-names: List of data cell name strings sorted in the same order
>> +             as the resets property. Consumers drivers will use
>
> resets?
Opps..
I remember fixing this, I will take care of it in next version.
>
>> +             eeprom-names to differentiate between multiple cells,
>> +             and hence being able to know what these cells are for.
>
> Is this still needed? The sub-node name defines the name. Or you can
> use reg-names with-in the sub-node.
Yes, eeprom-names is needed in the consumer nodes, where there are 
multiple eeproms cells, its easy to lookup by name rather than 
index,which depends on the order of the entries.

reg-names inside the "data cells" is ok, but I can't think of its use 
immediately. May be useful for debug?

--srini
 >
>
> Rob
>
>> +
>> +For example:
>> +
>> +       tsens {
>> +               ...
>> +               eeproms = <&tsens_calibration>;
>> +               eeprom-names = "calibration";
>> +       };
>> --
>> 1.9.1
>>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
