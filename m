From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 1/9] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Wed, 24 Jun 2015 10:56:11 +0100
Message-ID: <558A7EBB.6000304@linaro.org>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <1435014507-26181-1-git-send-email-srinivas.kandagatla@linaro.org> <1435035173.9808.35.camel@perches.com> <7BE8C921-180A-411D-A3C0-5D2A7AE3AB6A@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7BE8C921-180A-411D-A3C0-5D2A7AE3AB6A-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 23/06/15 10:26, Pantelis Antoniou wrote:
> Hi Joe,
>
>> >On Jun 23, 2015, at 05:52 , Joe Perches<joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>  wrote:
>> >
>> >On Tue, 2015-06-23 at 00:08 +0100, Srinivas Kandagatla wrote:
>>> >>This patch adds just providers part of the framework just to enab=
le easy
>>> >>review.
>> >[]
>>> >>include/linux/nvmem-provider.h |  54 ++++++
>> >
>> >Unless there are going to be users of nvmem-provider.h
>> >outside of the drivers/nvmem directory, perhaps that
>> >file (and nvmem-consumer.h) should be in drivers/nvmem/
>> >
>> >
> nvmem-consumer.h should be accessible from any driver, no?
>
> And unfortunately nvmem-provider should be accessible too.
> There are already eeprom drivers in the eeprom/misc directory that
> cannot be moved yet to drivers/nvmem (like at24).
>
> They need the provider definitions while they provide both the old
> style interface, and the new NVMEM based one.
>
> When we move them to the drivers/nvmem directory, then yes the
> provider header file should move there.

Yep, that's the plan.

---srini
>
> Regards
>
> =97 Pantelis
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
