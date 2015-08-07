From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 0/9] Add simple NVMEM Framework via regmap.
Date: Fri, 07 Aug 2015 17:18:10 +0100
Message-ID: <55C4DA42.909@linaro.org>
References: <1437995567-11203-1-git-send-email-srinivas.kandagatla@linaro.org> <7hwpx7vzyo.fsf@deeprootsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7hwpx7vzyo.fsf-1D3HCaltpLuhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Thanks Kevin,

On 07/08/15 17:13, Kevin Hilman wrote:
> Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>
>> This patchset adds a new simple NVMEM framework to kernel, and it is tested
>> with various drivers like "QCOM thermal sensors", "QCOM cpr driver",
>> "begal bone cape manager" and few more on the way.
>>
>> Can you please consider this as 4.3 material, AFAIK there are more than 3 drivers
>> depending on this framework which are wating since last 2 merge windows.
>>
>> Should these patches go via ARM-SOC tree or via Greg's tree?
>
> With Greg's ack, we can take this through the arm-soc tree (unless Greg
> wants to queue it, which is fine also.)
>

Greg already merged these patches yesterday on to 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

Now the patches are available in linux-next for more testing.

--srini
> Can you collect the final Tested-by's and prepare a pull request?
>
> Thanks,
>
> Kevin
>
