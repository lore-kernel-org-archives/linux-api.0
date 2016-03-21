From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [RESEND PATCH V4 1/4] stm class: provision for statically assigned masterIDs
Date: Mon, 21 Mar 2016 09:47:10 +0200
Message-ID: <87wpow6znl.fsf@ashishki-desk.ger.corp.intel.com>
References: <1457418835-31417-1-git-send-email-zhang.chunyan@linaro.org> <1457418835-31417-2-git-send-email-zhang.chunyan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1457418835-31417-2-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Chunyan Zhang <zhang.chunyan@linaro.org>, mathieu.poirier@linaro.org
Cc: mike.leach@arm.com, Michael.Williams@arm.com, al.grant@arm.com, tor@ti.com, nicolas.guion@st.com, pratikp@codeaurora.org, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Chunyan Zhang <zhang.chunyan@linaro.org> writes:

> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>
> Some architecture like ARM assign masterIDs at the HW design
> phase.  Those are therefore unreachable to users, making masterID
> management in the generic STM core irrelevant.
>
> In this kind of configuration channels are shared between masters
> rather than being allocated on a per master basis.
>
> This patch adds a new 'mshared' flag to struct stm_data that tells the
> core that this specific STM device doesn't need explicit masterID
> management.

There are two kinds of 'masterIDs' that we're talking about here: the
ones that turn up in the STP stream and the ones that are accessible to
trace-side software (sw_start/sw_end). So in this case we want to
reflect the fact that there is no correlation between the two, because
hardware assigns STP channels dynamically based on the states of the
trace/execution environment. And although the trace side software can do
very little with this information, it does make sense to provide it.

The sw_start==sw_end situation, on the other hand, is a side effect of
the above and, as I said in one of the previous threads, may not even be
the case, or at least I don't see why it has to. And when it is the
case, I don't see the point in handling it differently from
sw_start<sw_end situation.

> In the core sw_start/end of masterID are set to '1',
> i.e there is only one masterID to deal with.

Why does this need to be done in the core and why '1'? IOW,
sw_{start,end} come straight from the driver, this new 'mshared' comes
straight from the driver, why do we need the core to modify the former
based on the latter?

> Also this patch depends on [1], so that the number of masterID
> is '1' too.

It's 7b3bb0e753 in Linus' tree, but I don't see the logical connection
in the statement above.

Regards,
--
Alex
