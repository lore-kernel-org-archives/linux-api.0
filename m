From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 00/11] Add simple NVMEM Framework via regmap.
Date: Fri, 29 May 2015 08:09:31 +0100
Message-ID: <556810AB.40906@linaro.org>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>	<1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org> <CAA9_cmetqnqTQPCd8ya5AJPKQw8ary8CwsE6TUv=f57O=_MH5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAA9_cmetqnqTQPCd8ya5AJPKQw8ary8CwsE6TUv=f57O=_MH5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Sascha Hauer <s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 29/05/15 02:20, Dan Williams wrote:
> On Thu, May 21, 2015 at 9:42 AM, Srinivas Kandagatla
> <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> Thankyou all for providing inputs and comments on previous versions of this patchset.
>> Here is the v5 of the patchset addressing all the issues raised as
>> part of previous versions review.
>>
>> This patchset adds a new simple NVMEM framework to kernel.
>>
>> Up until now, NVMEM drivers were stored in drivers/misc, where they all had to
>> duplicate pretty much the same code to register a sysfs file, allow in-kernel
>> users to access the content of the devices they were driving, etc.
>>
>> This was also a problem as far as other in-kernel users were involved, since
>> the solutions used were pretty much different from on driver to another, there
>> was a rather big abstraction leak.
>>
>> Introduction of this framework aims at solving this. It also introduces DT
>> representation for consumer devices to go get the data they require (MAC
>> Addresses, SoC/Revision ID, part numbers, and so on) from the NVMEMs.
>>
>> After learning few things about QCOM qfprom and other eeprom/efuses, which
>> has packed fields at bit level. Which makes it important to add support to
>> such memories. This version adds support to this type of non volatile
>> memories by adding support to bit level nvmem-cells.
>>
>> Having regmap interface to this framework would give much better
>> abstraction for nvmems on different buses.
>>
>> patch 1-2 Introduces two regmap helper functions.
>> patch 3-6 Introduces the NVMEM framework.
>> Patch 7 Adds helper functions for nvmems based on mmio.
>> Patch 8 migrates an existing driver to nvmem framework.
>> Patch 9-10 Adds Qualcomm specific qfprom driver.
>> Patch 11 adds entry in MAINTAINERS.
>>
>> Its also possible to migrate other nvmem drivers to this framework.
>>
>> Providers APIs:
>>          nvmem_register/unregister();
>>
>> Consumers APIs:
>> Cell based apis for both DT/Non-DT:
>>          nvmem_cell_get()/nvmem_cell_put();
>>          nvmem_cell_read()/nvmem_cell_write();
>>
>> Raw byte access apis for both DT/non-DT.
>>          nvmem_device_get()/nvmem_device_put()
>>          nvmem_device_read()/nvmem_device_write();
>>          nvmem_device_cell_read()/nvmem_device_cell_write();
>>
>> Device Tree:
>>
>>          /* Provider */
>>          qfprom: qfprom@00700000 {
>>                  ...
>>
>>                  /* Data cells */
>>                  tsens_calibration: calib@404 {
>>                          reg = <0x404 0x10>;
>>                  };
>>
>>                  tsens_calibration_bckp: calib_bckp@504 {
>>                          reg = <0x504 0x11>;
>>                          bit-offset = 6;
>>                          nbits = 128;
>>                  };
>>
>>                  pvs_version: pvs-version@6 {
>>                          reg = <0x6 0x2>
>>                          bit-offset = 7;
>>                          nbits = 2;
>>                  };
>>
>>                  speed_bin: speed-bin@c{
>>                          reg = <0xc 0x1>;
>>                          bit-offset = 2;
>>                          nbits   = 3;
>>
>>                  };
>>                  ...
>>          };
>>
>> userspace interface: binary file in /sys/class/nvmem/*/nvmem
>>
>> ex:
>> hexdump /sys/class/nvmem/qfprom0/nvmem
>>
>> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
>> *
>> 00000a0 db10 2240 0000 e000 0c00 0c00 0000 0c00
>> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
>> ...
>> *
>> 0001000
>>
>> Changes since v4(https://lkml.org/lkml/2015/3/30/725)
>>   * rename eeprom to nvmem suggested by Matt Porter
>
> Apologies for the bikeshed fly-by review, but given we already have
> NVME and are adding an NVDIMM driver sub-system is s/eeprom/nvmem/ a
> good idea?
>
IMO yes.

I did briefly looked at NVME before renaming the eeprom to nvmem,
NVME is aimed at defining the command/feature set for PCIe-based SSDs 
with the goals of increased and efficient performance and interoperability.

This patch-set introduces simple nvmem which is applicable for non 
volatile memories like efuses, eeprom, ROM, NVRAM .. etc, which are used 
in most boards/SBC's. Data like calibration table, mac address or opps, 
are generally stored this. This data is required by multiple drivers and 
currently there is no framework in the kernel to address/abstract this, 
resulting in code duplication.


--srini
