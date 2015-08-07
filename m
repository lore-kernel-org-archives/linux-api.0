From: Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH v9 0/9] Add simple NVMEM Framework via regmap.
Date: Fri, 07 Aug 2015 09:13:35 -0700
Message-ID: <7hwpx7vzyo.fsf@deeprootsystems.com>
References: <1437995567-11203-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1437995567-11203-1-git-send-email-srinivas.kandagatla@linaro.org>
	(Srinivas Kandagatla's message of "Mon, 27 Jul 2015 12:12:47 +0100")
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com
List-Id: linux-api@vger.kernel.org

Srinivas Kandagatla <srinivas.kandagatla@linaro.org> writes:

> This patchset adds a new simple NVMEM framework to kernel, and it is tested
> with various drivers like "QCOM thermal sensors", "QCOM cpr driver",
> "begal bone cape manager" and few more on the way.
>
> Can you please consider this as 4.3 material, AFAIK there are more than 3 drivers
> depending on this framework which are wating since last 2 merge windows.
>
> Should these patches go via ARM-SOC tree or via Greg's tree?

With Greg's ack, we can take this through the arm-soc tree (unless Greg
wants to queue it, which is fine also.)

Can you collect the final Tested-by's and prepare a pull request?

Thanks,

Kevin
