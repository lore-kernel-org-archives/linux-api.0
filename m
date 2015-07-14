From: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v7 5/9] Documentation: nvmem: add nvmem api level and
 how-to doc
Date: Tue, 14 Jul 2015 14:32:05 -0700
Message-ID: <20150714213205.GO30412@codeaurora.org>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1436521521-10889-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1436521521-10889-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/10, Srinivas Kandagatla wrote:
> diff --git a/Documentation/nvmem/nvmem.txt b/Documentation/nvmem/nvmem.txt
> new file mode 100644
> index 0000000..b074b71
> --- /dev/null
> +++ b/Documentation/nvmem/nvmem.txt
> @@ -0,0 +1,152 @@
> +			    NVMEM SUBSYSTEM
> +	  Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> +
> +This document explains the Simple NVMEM Framework along with the APIs provided,

Why is simple and framework capitalized? Is it the "Simple NVMEM
Framework" or just the "NVMEM" framework?

> +and how-to-use.

how to use it?

> +
> +1. Introduction
> +===============
> +*NVMEM* is the abbreviation for Non Volatile Memory layer. It is used to
> +retrieve configuration or SOC or Device specific data from a non volatile memories
                          ^                                   ^
                          of                                  remove a?

> +like eeprom, efuses and so on.
> +
> +Up until now, NVMEM drivers like eeprom were stored in drivers/misc, where they

Up until now will soon be out of date, perhaps say "before this
framework existed"?

> +all had to duplicate pretty much the same code to register a sysfs file, allow
> +in-kernel users to access the content of the devices they were driving, etc.
> +
> +This was also a problem as far as other in-kernel users were involved, since
> +the solutions used were pretty much different from on driver to another, there
                                                       ^
                                                       one

> +was a rather big abstraction leak.
> +
> +Introduction of this framework aims at solving this. It also introduces DT

This framework aims to solve these problems.

> +representation for consumer devices to go get the data they require (MAC
> +Addresses, SoC/Revision ID, part numbers, and so on) from the NVMEMs.
> +This framework is based on regmap, so that most of the abstraction
> +available in regmap can be reused, across multiple types of buses.
> +
> +NVMEM Providers
> ++++++++++++++++
> +
> +NVMEM provider refers to an entity that implements methods to initialize, read
> +and write the non-volatile memory.
> +
> +2. Registering/Unregistering the NVMEM provider
> +===============================================
> +
> +A NVMEM provider can register with NVMEM core by suppling relevant
                                                     ^
                                                    supplying

> +nvmem configuration to nvmem_register(), on success core would return a valid
> +nvmem_device pointer.
> +
> +nvmem_unregister(nvmem) is used to unregister the already registered provider.

unregister a previously registered provider?

> +
> +For example for simple qfprom case:

For example, a simple qfprom case:

> +
> +static struct nvmem_config econfig = {
> +	.name = "qfprom",
> +	.owner = THIS_MODULE,
> +};
> +
> +static int qfprom_probe(struct platform_device *pdev)
> +{
> +	...
> +	econfig.dev = &pdev->dev;
> +	nvmem = nvmem_register(&econfig);
> +	...
> +}
> +
> +It is mandatory that the NVMEM provider has a regmap associated with its
> +struct device.

How do I ensure that?

> +
> +NVMEM Consumers
> ++++++++++++++++
> +
> +NVMEM consumers are the entities which make use of the NVMEM provider to
> +read/write into NVMEM.

read from and write to NVMEM?

> +
> +3. NVMEM cell based consumer APIs.
> +=================================
> +
> +NVMEM cells are the data entries/fields in the NVMEM.
> +The NVMEM framework provides 3 APIs to read/write NVMEM cells.
> +
> +struct nvmem_cell *nvmem_cell_get(struct device *dev, const char *name);
> +struct nvmem_cell *devm_nvmem_cell_get(struct device *dev, const char *name);
> +
> +void nvmem_cell_put(struct nvmem_cell *cell);
> +void devm_nvmem_cell_put(struct device *dev, struct nvmem_cell *cell);
> +
> +void *nvmem_cell_read(struct nvmem_cell *cell, ssize_t *len);
> +int nvmem_cell_write(struct nvmem_cell *cell, void *buf, ssize_t len);
> +
> +*nvmem_cell_get() apis will get a reference to nvmem cell for a given id,
> +and nvmem_cell_read/write() can then directly read or write to the cell.

Drop "directly"?

> +Once the usage of the cell is finished the consumer should call *nvmem_cell_put()
> +to free all the allocation memory for the cell.
> +
> +4. Direct NVMEM device based consumer APIs.
                                             ^
                                             Drop the full stop?

> +==========================================
> +
> +In some instances it is necessary to directly read/write the NVMEM.
> +To facilitate such consumers NVMEM framework provides below apis.
> +
> +struct nvmem_device *nvmem_device_get(struct device *dev, const char *name);
> +struct nvmem_device *devm_nvmem_device_get(struct device *dev,
> +					   const char *name);
> +void nvmem_device_put(struct nvmem_device *nvmem);
> +int nvmem_device_read(struct nvmem_device *nvmem, unsigned int offset,
> +		      size_t bytes, void *buf);
> +int nvmem_device_write(struct nvmem_device *nvmem, unsigned int offset,
> +		       size_t bytes, void *buf);
> +int nvmem_device_cell_read(struct nvmem_device *nvmem,
> +			   struct nvmem_cell_info *info, void *buf);
> +int nvmem_device_cell_write(struct nvmem_device *nvmem,
> +			    struct nvmem_cell_info *info, void *buf);
> +
> +Before the consumers can read/write NVMEM directly, it should get hold
                                                                    ^
                                                                    a
> +of nvmem_controller from one of the *nvmem_device_get() api.
> +
> +Difference between these apis and cell based apis is that these apis
   ^
   The

> +always take nvmem_device as parameter.
> +
> +5. Releasing a reference to the NVMEM
> +=====================================
> +
> +When the consumers no longer needs the NVMEM, it has to release the reference

When a consumer no longer needs?

> +to the NVMEM it has obtained using the APIs mentioned in the above section.
> +NVMEM framework provides 2 APIs to release a reference to the NVMEM.
   ^
   The

> +
> +void nvmem_cell_put(struct nvmem_cell *cell);
> +void devm_nvmem_cell_put(struct device *dev, struct nvmem_cell *cell);
> +void nvmem_device_put(struct nvmem_device *nvmem);
> +void devm_nvmem_device_put(struct device *dev, struct nvmem_device *nvmem);
> +
> +Both these APIs are used to release a reference to the NVMEM and
> +devm_nvmem_cell_put and devm_nvmem_device_put destroys the devres associated
> +with this NVMEM.

       s/this/the/

> +
> +Userspace
> ++++++++++
> +
> +6. Userspace binary interface.
                                ^
                                Drop the full stop?

> +==============================
> +
> +Userspace can read/write the raw NVMEM file located at
> +/sys/bus/nvmem/devices/*/nvmem
> +
> +ex:
> +
> +hexdump /sys/bus/nvmem/devices/qfprom0/nvmem
> +
> +0000000 0000 0000 0000 0000 0000 0000 0000 0000
> +*
> +00000a0 db10 2240 0000 e000 0c00 0c00 0000 0c00
> +0000000 0000 0000 0000 0000 0000 0000 0000 0000
> +...
> +*
> +0001000
> +
> +7. DeviceTree Binding
> +=====================
> +
> +The documentation for NVMEM dt binding can be found @
> +Documentation/devicetree/bindings/nvmem/nvmem.txt

How about?

See Documentation/devicetree/bindings/nvmem/nvmem.txt

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
