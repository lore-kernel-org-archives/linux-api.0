From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v5 03/11] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Wed, 24 Jun 2015 11:05:46 +0100
Message-ID: <558A80FA.3020603@linaro.org>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org> <1432226583-8775-1-git-send-email-srinivas.kandagatla@linaro.org> <5580A678.4080304@codeaurora.org> <5582BDAE.5040008@linaro.org> <5589F8C2.3030502@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <5589F8C2.3030502@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, pantelis.antoniou@konsulko.com, mporter@konsulko.com
List-Id: linux-api@vger.kernel.org



On 24/06/15 01:24, Stephen Boyd wrote:
> Can you assign the attributes to the device_type in the nvmem::struct
> device? I don't see why these attributes need to be part of the class.
>
I will fix this.
>>> >>
>>>> >>>+{
>>>> >>>+    return class_register(&nvmem_class);
>>> >>
>>> >>I thought class was on the way out? Aren't we supposed to use bus types
>>> >>for new stuff?
>> >Do you remember any conversation on the list about this? I could not
>> >find it on web.
>> >
>> >on the other hand, nvmem is not really a bus, making it a bus type
>> >sounds incorrect to me.
>> >
> I found this post on the cpu class that Sudeep tried to introduce[1].
> And there's this post from Kay that alludes to a unification of busses
> and classes[2]. And some other post where Kay says class is dead [3].
Thanks for the links,
Yep, looks like Class is dead, I will change the code to use bus type 
instead.

>
> [1]https://lkml.org/lkml/2014/8/21/191
> [2]https://lwn.net/Articles/471821/
> [3]https://lkml.org/lkml/2010/11/11/17
--srini
