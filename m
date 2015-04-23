From: Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 10/11] coresight-etm4x: Controls pertaining to the
 context ID functions
Date: Thu, 23 Apr 2015 12:59:51 -0400
Message-ID: <55392507.1030103@codeaurora.org>
References: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>	<1429742451-11465-11-git-send-email-mathieu.poirier@linaro.org>	<55390B05.1050801@codeaurora.org> <CANLsYkw-XwEW9gaXVr07fqHspZU+Vo7FukN7Qz6S07L6jC5ENA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANLsYkw-XwEW9gaXVr07fqHspZU+Vo7FukN7Qz6S07L6jC5ENA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kaixu Xia <kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/23/2015 11:16 AM, Mathieu Poirier wrote:
> On 23 April 2015 at 09:08, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
>> Hi Mathieu,
>>
>> On 04/22/2015 06:40 PM, Mathieu Poirier wrote:
>>> From: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>>
>>> Adding sysfs entries to access and configure specifics about the
>>> context ID comparator functions.
>>>
>>> Signed-off-by: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>> Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> ---
>>>  .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  19 +++
>>>  drivers/hwtracing/coresight/coresight-etm4x.c      | 187 +++++++++++++++++++++
>>>  2 files changed, 206 insertions(+)
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
>>> index b5c0456290ab..8b32cb7b9723 100644
>>> --- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
>>> +++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
>>> @@ -254,3 +254,22 @@ Date:            April 2015
>>>  KernelVersion:       4.01
>>>  Contact:     Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>  Description:         (RW) Controls the selection of the resources in the trace unit.
>>> +
>>> +What:                /sys/bus/coresight/devices/<memory_map>.etm/ctxid_idx
>>> +Date:                April 2015
>>> +KernelVersion:       4.01
>>> +Contact:     Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> +Description: (RW) Select which context ID comparator to work with.
>>> +
>>> +What:                /sys/bus/coresight/devices/<memory_map>.etm/ctxid_val
>>> +Date:                April 2015
>>> +KernelVersion:       4.01
>>> +Contact:     Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> +Description: (RW) Get/Set the context ID comparator value to trigger on.
>>
>> If I'm understanding this correctly, ctxid_val is multiplexed using ctxid_idx.
>> Why not just have ctxid_val0, ctxid_val1, ...?
> 
> There can be up to 8 of them on the current implementation and who
> knows how many more in the future.  To me using and index to select
> the context ID to work on scaled better and is introducing less
> clutter in sysfs.

In theory there's a race condition if two tasks are trying to set the index
and then the value, which having individually addressable values solves, but I
don't anticipate trying to use more than one task to configure tracing.

Chris

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
