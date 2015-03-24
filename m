From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/9] regmap: Introduce regmap_get_reg_stride.
Date: Tue, 24 Mar 2015 23:07:23 +0000
Message-ID: <5511EE2B.4040109@linaro.org>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org> <1427236200-18625-1-git-send-email-srinivas.kandagatla@linaro.org> <20150324223745.GC28997@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150324223745.GC28997-GFdadSzt00ze9xe1eoZjHA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 24/03/15 22:37, Mark Brown wrote:
> On Tue, Mar 24, 2015 at 10:30:00PM +0000, Srinivas Kandagatla wrote:
>
>> + /* regmap_get_reg_stride(): Report the register address stride
>> + *
>> + * Report the register address stride, mainly intended to for use by
>> + * generic infrastructure built on top of regmap.
>> + */
>> +int regmap_get_reg_stride(struct regmap *map)
>
> Please fix the indentation for the comment block and add kerneldoc for
> the argument.  This is an exported function so it should also be /** not
> /*
>
My bad.. I will fix it in next version.
