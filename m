From: Martin Kepplinger <martink@posteo.de>
Subject: Re: [PATCH v2] add support for Freescale's MMA8653FC 10 bit accelerometer
Date: Wed, 18 Mar 2015 17:42:13 +0100
Message-ID: <5509AAE5.1000503@posteo.de>
References: <1426694157-10866-1-git-send-email-martink@posteo.de> <2231139.ojeyer6qnI@ws-stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <2231139.ojeyer6qnI@ws-stein>
Sender: linux-input-owner@vger.kernel.org
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, dmitry.torokhov@gmail.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, linux-api@vger.kernel.org, devicetree@vger.kernel.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Kepplinger <martin.kepplinger@theobroma-systems.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>
List-Id: linux-api@vger.kernel.org

Am 2015-03-18 um 17:21 schrieb Alexander Stein:
> On Wednesday 18 March 2015 16:55:57, Martin Kepplinger wrote:
>> From: Martin Kepplinger <martin.kepplinger@theobroma-systems.com>
>>
>> The MMA8653FC is a low-power, three-axis, capacitive micromachined
>> accelerometer with 10 bits of resolution with flexible user-programmable
>> options.
>>
>> Embedded interrupt functions enable overall power savings, by relieving the
>> host processor from continuously polling data, for example using the poll()
>> system call.
>>
>> The device can be configured to generate wake-up interrupt signals from any
>> combination of the configurable embedded functions, enabling the MMA8653FC
>> to monitor events while remaining in a low-power mode during periods of
>> inactivity.
>>
>> This driver provides devicetree properties to program the device's behaviour
>> and a simple, tested and documented sysfs interface. The data sheet and more
>> information is available on Freescale's website.
>>
>> Signed-off-by: Martin Kepplinger <martin.kepplinger@theobroma-systems.com>
>> Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
>> ---
>> applies to v4.0-rc4 and the current -next.
>>
>> patch revision history
>> ......................
>> v2 corrects licensing and commit messages and adds appropriate recipients
>>
>>  .../testing/sysfs-bus-i2c-devices-fsl-mma8653fc    |  39 +
>>  .../devicetree/bindings/misc/fsl,mma8653fc.txt     |  96 +++
>>  MAINTAINERS                                        |   5 +
>>  drivers/input/misc/Kconfig                         |  11 +
>>  drivers/input/misc/Makefile                        |   1 +
>>  drivers/input/misc/mma8653fc.c                     | 913 +++++++++++++++++++++
>>  6 files changed, 1065 insertions(+)
>>  create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-devices-fsl-mma8653fc
>>  create mode 100644 Documentation/devicetree/bindings/misc/fsl,mma8653fc.txt
>>  create mode 100644 drivers/input/misc/mma8653fc.c
> 
> Shouldn't this go to drivers/iio/magnetometer instead of defining a new sysfs ABI?
> 

It could have gone to drivers/iio/accel if it would use an iio
interface, which would make more sense, you are right, but I simply
don't have the time to merge it in to iio.

It doesn't use an input interface either but I don't see a good place
for an accelerometer that uses sysfs only.

It works well, is a relatively recent chip and a clean dirver. But this
is all I can provide.

> Best regards,
> Alexander
> 

