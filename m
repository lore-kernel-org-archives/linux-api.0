From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v2] coresight-stm: adding driver for CoreSight STM component
Date: Thu, 26 Feb 2015 07:22:45 -0700
Message-ID: <CANLsYkz6c8rN21C_JDaarJCEyaNb6C3VeqBH=_y_ERBiNLtPMw@mail.gmail.com>
References: <1424907152-18808-1-git-send-email-mathieu.poirier@linaro.org>
	<20150226055320.GA20385@dragon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150226055320.GA20385@dragon>
Sender: linux-kernel-owner@vger.kernel.org
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Jon Corbet <corbet@lwn.net>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-api@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 25 February 2015 at 22:53, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Wed, Feb 25, 2015 at 04:32:32PM -0700, Mathieu Poirier wrote:
>> diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-stm b/Documentation/ABI/testing/sysfs-bus-coresight-devices-stm
>> new file mode 100644
>> index 000000000000..3ddb676831ab
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-stm
>> @@ -0,0 +1,62 @@
>> +What:                /sys/bus/coresight/devices/<memory_map>.stm/enable_source
>> +Date:                February 2015
>> +KernelVersion:       3.20
>
> A random comment - there will never be a v3.20 kernel.

That's pretty funny!  That part was obviously minted before there was
even an hint of moving to 4.0.  Thanks for pointing it out.

>
> Shawn
>
>> +Contact:     Mathieu Poirier <mathieu.poirier@linaro.org>
>> +Description: (RW) Enable/disable tracing on this specific trace macrocell.
>> +             Enabling the trace macrocell implies it has been configured
>> +             properly and a sink has been identidifed for it.  The path
>> +             of coresight components linking the source to the sink is
>> +             configured and managed automatically by the coresight framework.
