From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: RE: [PATCH V2 3/6] stm class: provision for statically assigned masterIDs
Date: Fri, 12 Feb 2016 17:54:41 +0200
Message-ID: <87twld3ovy.fsf@ashishki-desk.ger.corp.intel.com>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org> <1454487337-30184-4-git-send-email-zhang.chunyan@linaro.org> <87mvrf5ngl.fsf@ashishki-desk.ger.corp.intel.com> <CANLsYky2twQ98u241YyHD=atYRp1N56YVHUQNY2E2Ljsq0cseA@mail.gmail.com> <87twlj49k7.fsf@ashishki-desk.ger.corp.intel.com> <CANLsYkw=mG+ch8QzxmbwWs9o+mndVNo1MuqXcrPrNJYj_SQcHQ@mail.gmail.com> <AM4PR08MB0785EAA2B628765D7EA3FDA086D50@AM4PR08MB0785.eurprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AM4PR08MB0785EAA2B628765D7EA3FDA086D50@AM4PR08MB0785.eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Grant <Al.Grant@arm.com>, Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Chunyan Zhang <zhang.chunyan@linaro.org>, "robh@kernel.org" <robh@kernel.org>, Mark Brown <broonie@kernel.org>, Pratik Patel <pratikp@codeaurora.org>, Nicolas GUION <nicolas.guion@st.com>, Jon Corbet <corbet@lwn.net>, Mark Rutland <Mark.Rutland@arm.com>, Mike Leach <Mike.Leach@arm.com>, "Jeremiassen, Tor" <tor@ti.com>, Lyra Zhang <zhang.lyra@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Al Grant <Al.Grant@arm.com> writes:

>> Mike did write "master IDs are hardwired to individual cores and core security
>> states", which make assignment for one platform very static.
>> On the flip side those will change from one system to another.
>
> It depends on your perspective.  From the perspective of a userspace
> process not pinned to a core, the master id will appear to vary
> dynamically and unpredictably as the thread migrates from one
> core to another.  (That's actually useful if the decoder wants to know
> where the thread is running at any given point, as it can find that out
> for free, without the need to track migration events.)
>
> On the other hand if you are pinned (e.g. you're the kernel on a
> particular core, or you're a per-core worker thread in some thread
> pooling system) then you have a fixed master id, and then you can
> have one instance per core all using the same range of channel
> numbers, with the master id indicating the core - this saves on
> channel space compared to having to give each core its own
> range of channel space.

What I understood from Mike's explanation is that basically nothing is
fixed from the software perspective (talking about Coresight STM). One
doesn't know the master id with which one's data will be tagged,
regardless of whether one is cpu-affine or not, because:

 * even per-core master IDs will be highly implementation dependent and
   therefore not knowable by the kernel and subsequently userspace,
 * master IDs may change based on other conditions (besides security
   states), so even if we knew per-core master IDs for sure, it wouldn't
   give us the complete picture.

So even though from the HW perspective master IDs may be "hardwired" to
hardware states, the hardware states themselves are dynamic, so from the
SW perspective these master IDs are not static or hardwired at all.

If the same mmio write done by software would always result in the exact
same master ID tagged to it, that would be more like "static" to me.

Regards,
