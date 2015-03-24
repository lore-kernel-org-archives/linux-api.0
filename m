From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3 1/9] regmap: Introduce regmap_get_max_register.
Date: Tue, 24 Mar 2015 16:23:15 -0700
Message-ID: <1427239395.12126.22.camel@perches.com>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
	 <1427236179-18580-1-git-send-email-srinivas.kandagatla@linaro.org>
	 <20150324223637.GB28997@sirena.org.uk> <5511EDD7.40202@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5511EDD7.40202@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
List-Id: linux-api@vger.kernel.org

On Tue, 2015-03-24 at 23:05 +0000, Srinivas Kandagatla wrote:
> On 24/03/15 22:36, Mark Brown wrote:
> >> +int regmap_get_max_register(struct regmap *map)
> >> +{
> >> +	return map->max_register ? : -EINVAL;
> >> +}
> >
> > Please write the logic out properly, don't abuse the ternery operator.
> Am happy to change it to your preference in next version, but this GNU 
> extensions widely used in the kernel
> 
> $  grep -rR "return.*? :" ./linux | wc -l
> 115

Double that when you add the ?: variants

$ git grep -E "return.*\?\s*:" | wc -l
253

There are ~530 uses like:

	return <foo> ? <foo> :
