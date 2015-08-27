From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 2/5] coresight-etm4x: Change the name of the ctxid_val to ctxid_pid
Date: Thu, 27 Aug 2015 09:54:07 -0600
Message-ID: <CANLsYkyfJX1CywxZ-e8TgK45XXs9jxkBDrp41OWAzTjC63Ggww@mail.gmail.com>
References: <1436258518-9339-1-git-send-email-zhang.chunyan@linaro.org>
	<1436258518-9339-3-git-send-email-zhang.chunyan@linaro.org>
	<55DDFE01.50201@codeaurora.org>
	<CANLsYkyA_C=PUDEUSbcA_Sa6Abqnxk1TP9ye6F9i0bWW_OxqiA@mail.gmail.com>
	<55DF2DB5.7000909@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55DF2DB5.7000909@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: Chunyan Zhang <zhang.chunyan@linaro.org>, Greg KH <gregkh@linuxfoundation.org>, Mark Brown <broonie@kernel.org>, Serge Broslavsky <serge.broslavsky@linaro.org>, Lyra Zhang <zhang.lyra@gmail.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-api@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 27 August 2015 at 09:33, Christopher Covington <cov@codeaurora.org> wrote:
> On 08/27/2015 11:12 AM, Mathieu Poirier wrote:
>> On 26 August 2015 at 11:57, Christopher Covington <cov@codeaurora.org> wrote:
>>> On 07/07/2015 04:41 AM, Chunyan Zhang wrote:
>>>> 'ctxid_val' array was used to store the value of ETM context ID comparator
>>>> which actually stores the process ID to be traced, so using 'ctxid_pid' as
>>>> its name instead make it easier to understand.
>>>
>>> Previous discussion with some ARM folks has led me to believe there isn't a
>>> guarantee that the Context ID Register will always have a PID. Why not allow
>>> filtering on thread group ID, session ID, cgroup related identifiers, etc.?
>>
>> Coresight tracers only support contextID tracing.  The HW
>> automatically does the match between the contextID comparator register
>> in the tracer with the contextID register of the core.  Tracing is
>> enabled if both values match (and the tracer is configured to do so).
>
> Is there a reason to only ever allow Process IDs to be written into the
> Coresight and CPU Context ID registers? Is there anything in the hardware that
> would prevent writing, for example, Thread Group IDs into the Coresight and
> CPU Context ID registers? If there's no hardware limitation, why should there
> be kernel or device tree architecture that states or implies that patches to
> support such a use case are unacceptable?

I'm not saying your idea is unacceptable - I actually think there is
value in it.  At this time the scheduler will automatically write the
PID to the contextID register when a task is running, a reality this
feature is exploiting.

There is no limitation as to what can be written to the coresight
contextID register - tracing will start for as long as the values and
mask are configured properly.  I do not know the limitation imposed on
the core's contextID register (if any). We'd also have to make sure
that all the code, everywhere, relying on that information has been
modified to take into account the new semantic.

>
> Thanks,
> Christopher Covington
>
> --
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
