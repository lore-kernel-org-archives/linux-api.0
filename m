From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH V2 3/6] stm class: provision for statically assigned masterIDs
Date: Fri, 05 Feb 2016 14:52:10 +0200
Message-ID: <87mvrf5ngl.fsf@ashishki-desk.ger.corp.intel.com>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org> <1454487337-30184-4-git-send-email-zhang.chunyan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1454487337-30184-4-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Chunyan Zhang <zhang.chunyan@linaro.org>, mathieu.poirier@linaro.org
Cc: robh@kernel.org, broonie@kernel.org, pratikp@codeaurora.org, nicolas.guion@st.com, corbet@lwn.net, mark.rutland@arm.com, mike.leach@arm.com, tor@ti.com, al.grant@arm.com, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Chunyan Zhang <zhang.chunyan@linaro.org> writes:

> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>
> Some architecture like ARM assign masterIDs statically at the HW design
> phase, making masterID manipulation in the generic STM core irrelevant.
>
> This patch adds a new 'mstatic' flag to struct stm_data that tells the
> core that this specific STM device doesn't need explicit masterID
> management.

So why do we need this patch? If your STM only has master 42 allocated
for software sources, simply set sw_start = 42, sw_end = 42 and you're
good to go, software will have exactly one channel to choose from. See
also the comment from <linux/stm.h>:

 * @sw_start:           first STP master available to software
 * @sw_end:             last STP master available to software

particularly the "available to software" part. Any other kinds of
masters the STM class code doesn't care about (yet).

> In the core sw_start/end of masterID are set to '1',
> i.e there is only one masterID to deal with.

This is also a completely arbitrary and unnecessary requirement. Again,
you can set both to 42 and it will still work.

> Also this patch depends on [1], so that the number of masterID
> is '1' too.
>
> Finally the lower and upper bound for masterIDs as presented
> in ($SYSFS)/class/stm/XYZ.stm/masters and
> ($SYSFS)/../stp-policy/XYZ.stm.my_policy/some_device/masters
> are set to '-1'.  That way users can't confuse them with
> architecture where masterID management is required (where any
> other value would be valid).

Why is this a good idea? Having the actual master there will allow
software to know what it is and also tell the decoding side what it is
(assuming you have more than one source in the STP stream, it might not
be easy to figure out, unless you know it in advance).

I don't see how one master statically assigned to software sources is
different from two masters or 32 masters. And I don't see any benefit of
hiding the master id from userspace. Am I missing something?

Regards,
--
Alex
