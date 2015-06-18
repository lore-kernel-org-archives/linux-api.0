From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 06/11] nvmem: Add bindings for simple nvmem framework
Date: Thu, 18 Jun 2015 14:01:40 +0100
Message-ID: <5582C134.50709@linaro.org>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org> <1432226652-8947-1-git-send-email-srinivas.kandagatla@linaro.org> <5580A900.9070902@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5580A900.9070902-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 16/06/15 23:53, Stephen Boyd wrote:
> On 05/21/2015 09:44 AM, Srinivas Kandagatla wrote:
>> diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.txt b/Documentation/devicetree/bindings/nvmem/nvmem.txt
>> new file mode 100644
>> index 0000000..ecea654
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/nvmem/nvmem.txt
>> @@ -0,0 +1,84 @@
>> += NVMEM Data Device Tree Bindings =
>> +
>> +This binding is intended to represent the location of hardware
>> +configuration data stored in NVMEMs.
>
> It would be worthwhile spelling out what NVMEM stands for.
>
>> +
>> +On a significant proportion of boards, the manufacturer has stored
>> +some data on NVMEM, for the OS to be able to retrieve these information
>> +and act upon it. Obviously, the OS has to know about where to retrieve
>> +these data from, and where they are stored on the storage device.
>> +
>> +This document is here to document this.
>> +
>> += Data providers =
>> +Contains bindings specific to provider drivers and data cells as children
>> +to this node.
>
> children of this node?
>
Yep, will fix the text
>> +
>> +Optional properties:
>> + read-only: Mark the provider as read only.
>> +
>> += Data cells =
>> +These are the child nodes of the provider which contain data cell
>> +information like offset and size in nvmem provider.
>> +
>> +Required properties:
>> +reg:	specifies the offset in byte within that storage device, start bit
>> +	in the byte and the length in bits of the data we care about.
>> +	There could be more then one offset-length pairs in this property.
>
> s/then/than/
Yep.
>
>> +
>> +Optional properties:
>> +
>> +bit-offset: specifies the offset in bit within the address range specified
>> +	by reg property. Can take values from 0-7.
>> +nbits: specifies number of bits this cell occupies starting from bit-offset.
>> +
>
> Hopefully the consumer knows the endianness of the data stored.

As we read byte-byte, does it matter, as long as consumer gets them in 
the same order as its stored.


>
>> +For example:
>> +
>> +	/* Provider */
>> +	qfprom: qfprom@00700000 {
>> +		...
>> +
>> +		/* Data cells */
>> +		tsens_calibration: calib@404 {
>> +			reg = <0x404 0x10>;
>> +		};
>> +
>> +		tsens_calibration_bckp: calib_bckp@504 {
>> +			reg = <0x504 0x11>;
>> +			bit-offset = 6;
>> +			nbits = 128;
>> +		};
>> +
>> +		pvs_version: pvs-version@6 {
>> +			reg = <0x6 0x2>
>> +			bit-offset = 7;
>> +			nbits = 2;
>> +		};
>> +
>> +		speed_bin: speed-bin@c{
>> +			reg = <0xc 0x1>;
>> +			bit-offset = 2;
>> +			nbits	= 3;
>> +
>> +		};
>> +		...
>> +	};
>> +
>> += Data consumers =
>> +Are device nodes which consume nvmem data cells/providers.
>> +
>> +Required-properties:
>> +nvmem-cell: list of phandle to the nvmem data cells.
>> +nvmem-cell-names: names for the each nvmem-cell specified
>> +
>> +Optional-properties:
>> +nvmem	: list of phandles to nvmem providers.
>> +nvmem-names: names for the each nvmem provider.
>
> Is nvmem-names required if nvmem is used?
Yes, will fix it.
>
