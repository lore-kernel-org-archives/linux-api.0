From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [RESEND PATCH V4 1/4] stm class: provision for statically
 assigned masterIDs
Date: Mon, 21 Mar 2016 13:04:41 -0600
Message-ID: <CANLsYkxsaGmkpq6cNNw+CeMDKK7wwdDoegEuG2oNPNp185_9Mg@mail.gmail.com>
References: <1457418835-31417-1-git-send-email-zhang.chunyan@linaro.org>
 <1457418835-31417-2-git-send-email-zhang.chunyan@linaro.org>
 <87wpow6znl.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <87wpow6znl.fsf@ashishki-desk.ger.corp.intel.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Al Grant <al.grant@arm.com>, Michael Williams <Michael.Williams@arm.com>, linux-doc@vger.kernel.org, Lyra Zhang <zhang.lyra@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Jeremiassen,
 Tor" <tor@ti.com>, Mike Leach <mike.leach@arm.com>, linux-api@vger.kernel.org, Chunyan Zhang <zhang.chunyan@linaro.org>, Pratik Patel <pratikp@codeaurora.org>, Nicolas GUION <nicolas.guion@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-api@vger.kernel.org

On 21 March 2016 at 01:47, Alexander Shishkin
<alexander.shishkin@linux.intel.com> wrote:
> Chunyan Zhang <zhang.chunyan@linaro.org> writes:
>
>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>>
>> Some architecture like ARM assign masterIDs at the HW design
>> phase.  Those are therefore unreachable to users, making masterID
>> management in the generic STM core irrelevant.
>>
>> In this kind of configuration channels are shared between masters
>> rather than being allocated on a per master basis.
>>
>> This patch adds a new 'mshared' flag to struct stm_data that tells the
>> core that this specific STM device doesn't need explicit masterID
>> management.
>
> There are two kinds of 'masterIDs' that we're talking about here: the
> ones that turn up in the STP stream and the ones that are accessible to
> trace-side software (sw_start/sw_end). So in this case we want to
> reflect the fact that there is no correlation between the two, because
> hardware assigns STP channels dynamically based on the states of the
> trace/execution environment. And although the trace side software can do
> very little with this information, it does make sense to provide it.
>
> The sw_start==sw_end situation, on the other hand, is a side effect of
> the above and, as I said in one of the previous threads, may not even be
> the case, or at least I don't see why it has to. And when it is the
> case, I don't see the point in handling it differently from
> sw_start<sw_end situation.
>
>> In the core sw_start/end of masterID are set to '1',
>> i.e there is only one masterID to deal with.
>
> Why does this need to be done in the core and why '1'? IOW,
> sw_{start,end} come straight from the driver, this new 'mshared' comes
> straight from the driver, why do we need the core to modify the former
> based on the latter?

The logic here was to account for drivers that only set the 'mshared'
flag.  One could (wrongly) assume that if mshared is set in the
driver, sw_{start,end} are don't need to be set.  That way errors are
caught quicker.  I'm fine with removing that part.

Other than the above, is there anything you'd like to see modified in
this patch, i.e how the mshared flag is used to modify the output in
sysFS/configFS?

Thanks,
Mathieu

>
>> Also this patch depends on [1], so that the number of masterID
>> is '1' too.
>
> It's 7b3bb0e753 in Linus' tree, but I don't see the logical connection
> in the statement above.

That statement should have appeared in the cover letter rather than
this patch's blurb - that way it applies cleanly.

>
> Regards,
> --
> Alex
