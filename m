From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH v6 1/9] nvmem: Add a simple NVMEM framework for nvmem providers
Date: Tue, 23 Jun 2015 10:26:28 +0100
Message-ID: <7BE8C921-180A-411D-A3C0-5D2A7AE3AB6A@konsulko.com>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <1435014507-26181-1-git-send-email-srinivas.kandagatla@linaro.org> <1435035173.9808.35.camel@perches.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1435035173.9808.35.camel@perches.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, sboyd@codeaurora.org, Matt Porter <mporter@konsulko.com>, stefan.wahren@i2se.com, wxt@rock-chips.com
List-Id: linux-api@vger.kernel.org

Hi Joe,

> On Jun 23, 2015, at 05:52 , Joe Perches <joe@perches.com> wrote:
>=20
> On Tue, 2015-06-23 at 00:08 +0100, Srinivas Kandagatla wrote:
>> This patch adds just providers part of the framework just to enable =
easy
>> review.
> []
>> include/linux/nvmem-provider.h |  54 ++++++
>=20
> Unless there are going to be users of nvmem-provider.h
> outside of the drivers/nvmem directory, perhaps that
> file (and nvmem-consumer.h) should be in drivers/nvmem/
>=20
>=20

nvmem-consumer.h should be accessible from any driver, no?

And unfortunately nvmem-provider should be accessible too.
There are already eeprom drivers in the eeprom/misc directory that
cannot be moved yet to drivers/nvmem (like at24).

They need the provider definitions while they provide both the old
style interface, and the new NVMEM based one.

When we move them to the drivers/nvmem directory, then yes the
provider header file should move there.

Regards

=97 Pantelis
