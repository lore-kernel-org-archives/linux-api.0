From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH v6 4/9] nvmem: Add bindings for simple nvmem framework
Date: Tue, 23 Jun 2015 22:35:35 +0200 (CEST)
Message-ID: <1670081084.252423.1435091735127.JavaMail.open-xchange@oxbsltgw00.schlund.de>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <1435014538-26308-1-git-send-email-srinivas.kandagatla@linaro.org>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1435014538-26308-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org
Cc: wxt@rock-chips.com, linux-api@vger.kernel.org, Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, sboyd@codeaurora.org, arnd@arndb.de, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, mporter@konsulko.com, Maxime Ripard <maxime.ripard@free-electrons.com>, pantelis.antoniou@konsulko.com, devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>
List-Id: linux-api@vger.kernel.org


> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> hat am 23. Juni 2015 um
> 01:08 geschrieben:
>
>
> This patch adds bindings for simple nvmem framework which allows nvmem
> consumers to talk to nvmem providers to get access to nvmem cell data.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> [Maxime Ripard: intial version of eeprom framework]
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> Documentation/devicetree/bindings/nvmem/nvmem.txt | 85 +++++++++++++++++++++++
> 1 file changed, 85 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/nvmem/nvmem.txt
>
> diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.txt
> b/Documentation/devicetree/bindings/nvmem/nvmem.txt
> new file mode 100644
> index 0000000..d1a37e7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/nvmem/nvmem.txt
> @@ -0,0 +1,85 @@
> += NVMEM(Non Volatile Memory) Data Device Tree Bindings =
> +
> +This binding is intended to represent the location of hardware
> +configuration data stored in NVMEMs like eeprom, efuses and so on.
> +
> +On a significant proportion of boards, the manufacturer has stored
> +some data on NVMEM, for the OS to be able to retrieve these information
> +and act upon it. Obviously, the OS has to know about where to retrieve
> +these data from, and where they are stored on the storage device.
> +
> +This document is here to document this.
> +
> += Data providers =
> +Contains bindings specific to provider drivers and data cells as children
> +of this node.
> +
> +Optional properties:
> + read-only: Mark the provider as read only.
> +
> += Data cells =
> +These are the child nodes of the provider which contain data cell
> +information like offset and size in nvmem provider.
> +
> +Required properties:
> +reg: specifies the offset in byte within that storage device, start bit
> + in the byte and the length in bits of the data we care about.

Is the second parameter really in bits, not bytes?
