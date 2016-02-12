From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH V2 3/6] stm class: provision for statically assigned masterIDs
Date: Fri, 12 Feb 2016 13:33:58 -0700
Message-ID: <CANLsYkz1nNYdcTXrkZ+HAMHexNandm93EpM7auvYE4CY43hy6w@mail.gmail.com>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org>
	<1454487337-30184-4-git-send-email-zhang.chunyan@linaro.org>
	<87mvrf5ngl.fsf@ashishki-desk.ger.corp.intel.com>
	<CANLsYky2twQ98u241YyHD=atYRp1N56YVHUQNY2E2Ljsq0cseA@mail.gmail.com>
	<87twlj49k7.fsf@ashishki-desk.ger.corp.intel.com>
	<CANLsYkw=mG+ch8QzxmbwWs9o+mndVNo1MuqXcrPrNJYj_SQcHQ@mail.gmail.com>
	<87r3gh3nd7.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <87r3gh3nd7.fsf@ashishki-desk.ger.corp.intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Chunyan Zhang <zhang.chunyan@linaro.org>, Rob Herring <robh@kernel.org>, Mark Brown <broonie@kernel.org>, Pratik Patel <pratikp@codeaurora.org>, Nicolas GUION <nicolas.guion@st.com>, Jon Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, Mike Leach <mike.leach@arm.com>, "Jeremiassen, Tor" <tor@ti.com>, Al Grant <al.grant@arm.com>, Lyra Zhang <zhang.lyra@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 12 February 2016 at 09:27, Alexander Shishkin
<alexander.shishkin@linux.intel.com> wrote:
> Mathieu Poirier <mathieu.poirier@linaro.org> writes:
>
>> On 8 February 2016 at 06:26, Alexander Shishkin
>> <alexander.shishkin@linux.intel.com> wrote:
>>> This $end==$start situation itself may be ambiguous and can be
>>> interpreted either as having just one *static* master ID fixed for all
>>> SW writers (what I assumed from your commit message) or as having a
>>> floating master ID, which changes of its own accord and is not
>>> controllable by software.
>>
>> Some clarification here.
>>
>> On ARM from a SW point of view $end == $start and that doesn't change
>> (with regards to masterIDs) .  The ambiguity comes from the fact that
>> on other platforms where masterID configuration does change and is
>> important, the condition $end == $start could also be valid.
>
> Yes, that's what I was saying. The thing is, on the system-under-tracing
> side these two situations are not very different from one
> another. Master IDs are really just numbers without any semantics
> attached to them in the sense that they are not covered by the mipi spec
> or any other standard (to my knowledge).

We are definitely on the same page here, just using slightly different terms.

>
> The difference is in the way we map channels to masters. One way is to
> allocate a distinct set of channels for each master (the way Intel Trace
> Hub does it); another way is to share the same set of channels between
> multiple masters.

We are in total agreement.

> So we can describe this as "hardware implements the
> same set of channels across multiple masters" or something along those
> lines.

I suggest "Shared channels"?  In the end, that's really what it is...

The outstanding issue is still how to represent these to different way
of mapping things in the STM core.  I suggested a flag, called
"mstatic" (but that can be changed), and a representation of '-1' in
for masterIDs sysFS.  Whether we stick with that or not is irrelevant,
I'd be fine with another mechanism.  What I am keen on is that from
sysFS users can quickly tell which heuristic is enacted on that
specific architecture.

>
> Actually, in the latter scheme of things you can also have multiple
> masters, at least theoretically. Say, you have masters [0..15], each
> with distinct set of channels, but depending on hardware state these
> masters actually end up as $state*16+$masterID in the STP stream.
>
> So we might also think about differentiating between the hardware
> masters (0 though 15 in the above example) and STP masters.

I'm not sure I get what you mean here.  On ARM the masterIDs assigned
in HW, which will depend on the state, will show up in the STP stream.
But again, I might be missing your point.

Thanks,
Mathieu

>
> Regards,
> --
> Alex
