From: Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/2] iio: Add support for waveform output
Date: Mon, 01 Dec 2014 20:56:38 +0100
Message-ID: <547CC7F6.2050900@metafoo.de>
References: <1417038344-3801-1-git-send-email-george.mccollister@gmail.com>	<54764F01.20005@metafoo.de>
 <CAFSKS=PdS7cLuHEKawKsQ-tePRg-t9Q8wDA5e51f1ejW91=N4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <CAFSKS=PdS7cLuHEKawKsQ-tePRg-t9Q8wDA5e51f1ejW91=N4A@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: George McCollister <george.mccollister@gmail.com>
Cc: Daniel Baluta <daniel.baluta@intel.com>, "open list:IIO SUBSYSTEM AND..." <devel@driverdev.osuosl.org>, list@osuosl.org, Reyad Attiyat <reyad.attiyat@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hartmut Knaack <knaack.h@gmx.de>, open list <linux-kernel@vger.kernel.org>, Harald Geyer <harald@ccbib.org>, Sebastian Reichel <sre@debian.org>, Peter Meerwald <pmeerw@pmeerw.net>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, open@osuosl.org, ABI/API <linux-api@vger.kernel.org>, Jonathan Cameron <jic23@kernel.org>
List-Id: linux-api@vger.kernel.org

On 12/01/2014 03:57 PM, George McCollister wrote:
> On Wed, Nov 26, 2014 at 4:06 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> On 11/26/2014 10:45 PM, George McCollister wrote:
>>>
>>> Output can be held high or low for a specified period of time.
>>> Support for waveform capture could be added in the future.
>>>
>>
>> That's a PWM device?
>
> The device I'm adding only generates a single pulse per write, but my
> intention was to leave the door open for other types of devices.
>

Can you try to elaborate more on how exactly this interface is supposed to 
be used, what kind of the devices it is used for, the use case of the device 
and so on. This patch is adding userspace ABI which we have to maintain 
forever so we should try to give this proper review, which is not easy 
without knowing what it actually is.

- Lars
