From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v6 1/9] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Mon, 22 Jun 2015 21:52:53 -0700
Message-ID: <1435035173.9808.35.camel@perches.com>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org>
	 <1435014507-26181-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1435014507-26181-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com
List-Id: linux-api@vger.kernel.org

On Tue, 2015-06-23 at 00:08 +0100, Srinivas Kandagatla wrote:
> This patch adds just providers part of the framework just to enable easy
> review.
[]
>  include/linux/nvmem-provider.h |  54 ++++++

Unless there are going to be users of nvmem-provider.h
outside of the drivers/nvmem directory, perhaps that
file (and nvmem-consumer.h) should be in drivers/nvmem/
