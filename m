From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v6 3/9] nvmem: Add nvmem_device based consumer apis.
Date: Wed, 24 Jun 2015 10:52:38 +0100
Message-ID: <558A7DE6.9060000@linaro.org>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <1435014527-26265-1-git-send-email-srinivas.kandagatla@linaro.org> <1344600420.252283.1435091331020.JavaMail.open-xchange@oxbsltgw00.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1344600420.252283.1435091331020.JavaMail.open-xchange@oxbsltgw00.schlund.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Stefan Wahren <stefan.wahren@i2se.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org
Cc: wxt@rock-chips.com, linux-api@vger.kernel.org, Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, sboyd@codeaurora.org, arnd@arndb.de, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, mporter@konsulko.com, Maxime Ripard <maxime.ripard@free-electrons.com>, pantelis.antoniou@konsulko.com, devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>
List-Id: linux-api@vger.kernel.org



On 23/06/15 21:28, Stefan Wahren wrote:
>> >@@ -26,6 +35,21 @@ void devm_nvmem_cell_put(struct device *dev, struct
>> >nvmem_cell *cell);
>> >void *nvmem_cell_read(struct nvmem_cell *cell, ssize_t *len);
>> >int nvmem_cell_write(struct nvmem_cell *cell, void *buf, ssize_t len);
>> >
>> >+/* direct nvmem device read/write interface */
>> >+struct nvmem_device *nvmem_device_get(struct device *dev, const char *name);
>> >+struct nvmem_device *devm_nvmem_device_get(struct device *dev,
>> >+ const char *name);
>> >+void nvmem_device_put(struct nvmem_device *nvmem);
>> >+void devm_nvmem_device_put(struct device *dev, struct nvmem_device *nvmem);
>> >+int nvmem_device_read(struct nvmem_device *nvmem, unsigned int offset,
>> >+ size_t bytes, void *buf);
>> >+int nvmem_device_write(struct nvmem_device *nvmem, unsigned int offset,
>> >+ size_t bytes, void *buf);
> Maybe i mixed something but those functions use the datatype unsigned int for
> offset
> and the offset in the structs use datatype int. Looks a little bit inconsistent.
thanks for comments,

I will have a relook at this and see if I can fix it.

thanks,
srini
