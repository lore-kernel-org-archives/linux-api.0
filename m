From: Mike Leach <Mike.Leach@arm.com>
Subject: RE: [PATCH V2 3/6] stm class: provision for statically assigned
 masterIDs
Date: Fri, 5 Feb 2016 16:31:32 +0000
Message-ID: <DB3PR08MB0041B8843C61FCEB049B2BB58CD20@DB3PR08MB0041.eurprd08.prod.outlook.com>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org>
 <1454487337-30184-4-git-send-email-zhang.chunyan@linaro.org>
 <87mvrf5ngl.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87mvrf5ngl.fsf@ashishki-desk.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>, Chunyan Zhang <zhang.chunyan@linaro.org>, "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>
Cc: "robh@kernel.org" <robh@kernel.org>, "broonie@kernel.org" <broonie@kernel.org>, "pratikp@codeaurora.org" <pratikp@codeaurora.org>, "nicolas.guion@st.com" <nicolas.guion@st.com>, "corbet@lwn.net" <corbet@lwn.net>, Mark Rutland <Mark.Rutland@arm.com>, "tor@ti.com" <tor@ti.com>, Al Grant <Al.Grant@arm.com>, "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi,

I think a quick clarification of the ARM hardware STM architecture may be of value here.

The ARM hardware STM, when implemented as recommend in a hardware design, the master IDs are not under driver control, but have a hardwire association with source devices in the system. The master IDs are hardwired to individual cores and core security states, and there could be other IDs associated with hardware trace sources requiring output via the hardware STM. (an example of this is the ARM Juno development board).

Therefore in multi-core systems many masters may be associated with a single software STM stream. A user-space application running on Core 1, may have a master ID of 0x11 in the STPv2 trace stream, but if this application is context switched and later continues running on Core 2, then master ID could change to 0x21.  Masters identify a hardware source in this scheme, the precise values used will be implementation dependent.

So the number of masters "available to the software" depends on your interpretation of the phrase.
If you mean "master IDs on which software trace will appear" then that will be many - it depends on which core is running the application. However as described above, this is not predictable by any decoder, and the master set used may not be contiguous.
If you mean "master IDs selectable/allocated by the driver" then that will be 0 - the driver has no control, and possibly no knowledge of which master is associated with the current execution context. (this is of course system dependent - it may well be possible to have some configuration database associating cores with hardware IDs, but this will be implementation and board support dependant).

Therefore, there is a requirement to tell both the user-space STM client and decoder that not only is master ID management not needed - it is in fact not possible and the key to identify the software source for a given STM packet is the channel alone. In addition we have a nominal single Master ID "available to the software", to satisfy the requirements of the generic ST module API.

So on Juno for example, while we do have 128 masters, each with 65536 channels, the master allocation is not visible to system software - each core sees a single master with 65536 channels. Therefore differentiation between software sources in the STM trace is by channel number allocations only.

Best Regards

Mike.

----------------------------------------------------------------
Mike Leach                           +44 (0)1254 893911 (Direct)
Principal Engineer                   +44 (0)1254 893900 (Main)
Arm Blackburn Design Centre          +44 (0)1254 893901 (Fax)
Belthorn House
Walker Rd                            mailto:mike.leach@arm.com
Guide
Blackburn
BB1 2QE
----------------------------------------------------------------


> -----Original Message-----
> From: Alexander Shishkin [mailto:alexander.shishkin@linux.intel.com]
> Sent: 05 February 2016 12:52
> To: Chunyan Zhang; mathieu.poirier@linaro.org
> Cc: robh@kernel.org; broonie@kernel.org; pratikp@codeaurora.org;
> nicolas.guion@st.com; corbet@lwn.net; Mark Rutland; Mike Leach;
> tor@ti.com; Al Grant; zhang.lyra@gmail.com; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; linux-api@vger.kernel.org; linux-
> doc@vger.kernel.org
> Subject: Re: [PATCH V2 3/6] stm class: provision for statically assigned
> masterIDs
>
> Chunyan Zhang <zhang.chunyan@linaro.org> writes:
>
> > From: Mathieu Poirier <mathieu.poirier@linaro.org>
> >
> > Some architecture like ARM assign masterIDs statically at the HW design
> > phase, making masterID manipulation in the generic STM core irrelevant.
> >
> > This patch adds a new 'mstatic' flag to struct stm_data that tells the
> > core that this specific STM device doesn't need explicit masterID
> > management.
>
> So why do we need this patch? If your STM only has master 42 allocated
> for software sources, simply set sw_start = 42, sw_end = 42 and you're
> good to go, software will have exactly one channel to choose from. See
> also the comment from <linux/stm.h>:
>
>  * @sw_start:           first STP master available to software
>  * @sw_end:             last STP master available to software
>
> particularly the "available to software" part. Any other kinds of
> masters the STM class code doesn't care about (yet).
>
> > In the core sw_start/end of masterID are set to '1',
> > i.e there is only one masterID to deal with.
>
> This is also a completely arbitrary and unnecessary requirement. Again,
> you can set both to 42 and it will still work.
>
> > Also this patch depends on [1], so that the number of masterID
> > is '1' too.
> >
> > Finally the lower and upper bound for masterIDs as presented
> > in ($SYSFS)/class/stm/XYZ.stm/masters and
> > ($SYSFS)/../stp-policy/XYZ.stm.my_policy/some_device/masters
> > are set to '-1'.  That way users can't confuse them with
> > architecture where masterID management is required (where any
> > other value would be valid).
>
> Why is this a good idea? Having the actual master there will allow
> software to know what it is and also tell the decoding side what it is
> (assuming you have more than one source in the STP stream, it might not
> be easy to figure out, unless you know it in advance).
>
> I don't see how one master statically assigned to software sources is
> different from two masters or 32 masters. And I don't see any benefit of
> hiding the master id from userspace. Am I missing something?
>
> Regards,
> --
> Alex

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
