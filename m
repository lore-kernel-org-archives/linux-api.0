From: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RESEND PATCH V4 1/4] stm class: provision for statically assigned masterIDs
Date: Thu, 31 Mar 2016 16:20:23 +0300
Message-ID: <878u0y7pig.fsf@ashishki-desk.ger.corp.intel.com>
References: <1457418835-31417-1-git-send-email-zhang.chunyan@linaro.org> <1457418835-31417-2-git-send-email-zhang.chunyan@linaro.org> <87wpow6znl.fsf@ashishki-desk.ger.corp.intel.com> <CANLsYkxsaGmkpq6cNNw+CeMDKK7wwdDoegEuG2oNPNp185_9Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANLsYkxsaGmkpq6cNNw+CeMDKK7wwdDoegEuG2oNPNp185_9Mg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: serge.broslavsky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mike Leach <mike.leach-5wv7dgnIgG8@public.gmane.org>, Michael Williams <Michael.Williams-5wv7dgnIgG8@public.gmane.org>, Al Grant <al.grant-5wv7dgnIgG8@public.gmane.org>, "Jeremiassen, Tor" <tor-l0cyMroinI0@public.gmane.org>, Nicolas GUION <nicolas.guion-qxv4g6HH51o@public.gmane.org>, Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:

> On 21 March 2016 at 01:47, Alexander Shishkin
> <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>> Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>>
>>> From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>
>>> Some architecture like ARM assign masterIDs at the HW design
>>> phase.  Those are therefore unreachable to users, making masterID
>>> management in the generic STM core irrelevant.
>>>
>>> In this kind of configuration channels are shared between masters
>>> rather than being allocated on a per master basis.
>>>
>>> This patch adds a new 'mshared' flag to struct stm_data that tells the
>>> core that this specific STM device doesn't need explicit masterID
>>> management.
>>
>> There are two kinds of 'masterIDs' that we're talking about here: the
>> ones that turn up in the STP stream and the ones that are accessible to
>> trace-side software (sw_start/sw_end). So in this case we want to
>> reflect the fact that there is no correlation between the two, because
>> hardware assigns STP channels dynamically based on the states of the
>> trace/execution environment. And although the trace side software can do
>> very little with this information, it does make sense to provide it.
>>
>> The sw_start==sw_end situation, on the other hand, is a side effect of
>> the above and, as I said in one of the previous threads, may not even be
>> the case, or at least I don't see why it has to. And when it is the
>> case, I don't see the point in handling it differently from
>> sw_start<sw_end situation.

[snip]

> Other than the above, is there anything you'd like to see modified in
> this patch, i.e how the mshared flag is used to modify the output in
> sysFS/configFS?

Yes, the two paragraphs quoted above that had gone unnoticed. I've
been thinking some more about this and came up with the following. No
need to do any extra handling in the policy code or anywhere else.

>From 8be22a8e391b94ec13d428976e7b1410aa59991e Mon Sep 17 00:00:00 2001
From: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Date: Thu, 31 Mar 2016 15:51:29 +0300
Subject: [PATCH] stm class: Support devices that override software assigned
 masters

Some STM devices adjust software assigned master numbers depending on
the trace source and its runtime state and whatnot. This patch adds
a sysfs attribute to inform the trace-side software that master numbers
assigned to software sources will not match those in the STP stream,
so that, for example, master/channel allocation policy can be adjusted
accordingly.

Signed-off-by: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-class-stm | 10 ++++++++++
 drivers/hwtracing/stm/core.c              | 15 +++++++++++++++
 include/linux/stm.h                       |  3 +++
 3 files changed, 28 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-stm b/Documentation/ABI/testing/sysfs-class-stm
index c9aa4f3fc9..77ed3da0f6 100644
--- a/Documentation/ABI/testing/sysfs-class-stm
+++ b/Documentation/ABI/testing/sysfs-class-stm
@@ -12,3 +12,13 @@ KernelVersion:	4.3
 Contact:	Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
 Description:
 		Shows the number of channels per master on this STM device.
+
+What:		/sys/class/stm/<stm>/hw_override
+Date:		March 2016
+KernelVersion:	4.7
+Contact:	Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+Description:
+		Reads as 0 if master numbers in the STP stream produced by
+		this stm device will match the master numbers assigned by
+		the software or 1 if the stm hardware overrides software
+		assigned masters.
diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index 2591442e2c..ff31108b06 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -67,9 +67,24 @@ static ssize_t channels_show(struct device *dev,
 
 static DEVICE_ATTR_RO(channels);
 
+static ssize_t hw_override_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct stm_device *stm = to_stm_device(dev);
+	int ret;
+
+	ret = sprintf(buf, "%u\n", stm->data->hw_override);
+
+	return ret;
+}
+
+static DEVICE_ATTR_RO(hw_override);
+
 static struct attribute *stm_attrs[] = {
 	&dev_attr_masters.attr,
 	&dev_attr_channels.attr,
+	&dev_attr_hw_override.attr,
 	NULL,
 };
 
diff --git a/include/linux/stm.h b/include/linux/stm.h
index 1a79ed8e43..8369d8a8ca 100644
--- a/include/linux/stm.h
+++ b/include/linux/stm.h
@@ -50,6 +50,8 @@ struct stm_device;
  * @sw_end:		last STP master available to software
  * @sw_nchannels:	number of STP channels per master
  * @sw_mmiosz:		size of one channel's IO space, for mmap, optional
+ * @hw_override:	masters in the STP stream will not match the ones
+ *			assigned by software, but are up to the STM hardware
  * @packet:		callback that sends an STP packet
  * @mmio_addr:		mmap callback, optional
  * @link:		called when a new stm_source gets linked to us, optional
@@ -85,6 +87,7 @@ struct stm_data {
 	unsigned int		sw_end;
 	unsigned int		sw_nchannels;
 	unsigned int		sw_mmiosz;
+	unsigned int		hw_override;
 	ssize_t			(*packet)(struct stm_data *, unsigned int,
 					  unsigned int, unsigned int,
 					  unsigned int, unsigned int,
-- 
2.8.0.rc3
