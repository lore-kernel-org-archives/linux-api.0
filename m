From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH V2 3/6] stm class: provision for statically assigned masterIDs
Date: Mon, 08 Feb 2016 15:26:48 +0200
Message-ID: <87twlj49k7.fsf@ashishki-desk.ger.corp.intel.com>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org> <1454487337-30184-4-git-send-email-zhang.chunyan@linaro.org> <87mvrf5ngl.fsf@ashishki-desk.ger.corp.intel.com> <CANLsYky2twQ98u241YyHD=atYRp1N56YVHUQNY2E2Ljsq0cseA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CANLsYky2twQ98u241YyHD=atYRp1N56YVHUQNY2E2Ljsq0cseA@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Chunyan Zhang <zhang.chunyan@linaro.org>, robh@kernel.org, Mark Brown <broonie@kernel.org>, Pratik Patel <pratikp@codeaurora.org>, Nicolas GUION <nicolas.guion@st.com>, Jon Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, Mike Leach <mike.leach@arm.com>, "Jeremiassen, Tor" <tor@ti.com>, Al Grant <al.grant@arm.com>, Lyra Zhang <zhang.lyra@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Mathieu Poirier <mathieu.poirier@linaro.org> writes:

> On 5 February 2016 at 05:52, Alexander Shishkin
> <alexander.shishkin@linux.intel.com> wrote:
>> Chunyan Zhang <zhang.chunyan@linaro.org> writes:
>>
>>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>>>
>>> Some architecture like ARM assign masterIDs statically at the HW design
>>> phase, making masterID manipulation in the generic STM core irrelevant.
>>>
>>> This patch adds a new 'mstatic' flag to struct stm_data that tells the
>>> core that this specific STM device doesn't need explicit masterID
>>> management.
>>
>> So why do we need this patch? If your STM only has master 42 allocated
>> for software sources, simply set sw_start = 42, sw_end = 42 and you're
>> good to go, software will have exactly one channel to choose from. See
>> also the comment from <linux/stm.h>:
>
> On ARM each source, i.e entity capable of accessing STM channels, has
> a different master ID set in HW.  We can't assume the IDs are
> contiguous and from a SW point of view there is no way to probe the
> values.

Ok, it's the 'static' word that got me confused. From Mike's explanation
it seems to me that it's the antithesis of static; the master ID
assignment is so dynamic that it's not controllable by the software and
may or may not reflect core id, power state, phase of the moon, etc.

>>> In the core sw_start/end of masterID are set to '1',
>>> i.e there is only one masterID to deal with.
>>
>> This is also a completely arbitrary and unnecessary requirement. Again,
>> you can set both to 42 and it will still work.
>
> True - any value will do. The important thing to remember is that on
> ARM, there is only one masterID channel (from an STM core point of
> view).  But we could also proceed differently, see below for more
> details.

Well, we have the masters attribute with two numbers in it that define
the range of master IDs that the software can choose from. More
specifically to this situation:

 * the number of channel ID spaces available to the SW is
   $end - $start + 1, that is, in your case, just 1;
 * the number of master IDs for the SW to choose from is $end - $start;
 * if $end==$start, their actual numeric value doesn't really matter,
   either for the policy definition or for the actual writers.

This $end==$start situation itself may be ambiguous and can be
interpreted either as having just one *static* master ID fixed for all
SW writers (what I assumed from your commit message) or as having a
floating master ID, which changes of its own accord and is not
controllable by software.

These two situations are really the same thing from the perspective of
the system under tracing. Also, both of these situations should already
work if the driver sets both sw_start and sw_end to the same
value.

Regards,
--
Alex
