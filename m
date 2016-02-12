From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH V3 6/6] coresight-stm: adding driver for CoreSight STM component
Date: Fri, 12 Feb 2016 12:02:27 -0700
Message-ID: <CANLsYkxTiwbE9WM4yR0hThPopv5ESJM0_B0+Qcay=aiTvaeJ0g@mail.gmail.com>
References: <1454756672-12790-1-git-send-email-zhang.chunyan@linaro.org>
	<1454756672-12790-7-git-send-email-zhang.chunyan@linaro.org>
	<87y4aq2bjj.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <87y4aq2bjj.fsf@ashishki-desk.ger.corp.intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Chunyan Zhang <zhang.chunyan@linaro.org>, Mike Leach <mike.leach@arm.com>, Michael Williams <Michael.Williams@arm.com>, Al Grant <al.grant@arm.com>, "Jeremiassen, Tor" <tor@ti.com>, Nicolas GUION <nicolas.guion@st.com>, Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>, Pratik Patel <pratikp@codeaurora.org>, Jon Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, Lyra Zhang <zhang.lyra@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 12 February 2016 at 08:28, Alexander Shishkin
<alexander.shishkin@linux.intel.com> wrote:
> Chunyan Zhang <zhang.chunyan@linaro.org> writes:
>
>> +static long stm_generic_set_options(struct stm_data *stm_data,
>> +                                 unsigned int master,
>> +                                 unsigned int channel,
>> +                                 unsigned int nr_chans,
>> +                                 unsigned long options)
>> +{
>> +     struct stm_drvdata *drvdata = container_of(stm_data,
>> +                                                struct stm_drvdata, stm);
>> +     if (!(drvdata && drvdata->enable))
>> +             return -EINVAL;
>> +
>> +     if (channel >= drvdata->numsp)
>> +             return -EINVAL;
>> +
>> +     switch (options) {
>> +     case STM_OPTION_GUARANTEED:
>> +             set_bit(channel, drvdata->chs.guaranteed);
>> +             break;
>> +
>> +     case STM_OPTION_INVARIANT:
>> +             clear_bit(channel, drvdata->chs.guaranteed);
>> +             break;
>
> This is a bad interface. Firstly, neither option is described
> anywhere. Secondly, I'm pretty sure "invariant" does not mean "not
> guaranteed" in english, although this function seems to imply this.

Regardless of the semantic associated to the word "invariant" in the
English language, the documentation characterises a channel configured
in best effort delivery mode as "invariant".  This is also the
opposite of the "guaranteed" mode where packets are guaranteed to be
delivered.  Adding a few comments here is probably a good idea.

>
>> +
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static long stm_generic_get_options(struct stm_data *stm_data,
>> +                                 unsigned int master,
>> +                                 unsigned int channel,
>> +                                 unsigned int nr_chans,
>> +                                 u64 *options)
>> +{
>> +     struct stm_drvdata *drvdata = container_of(stm_data,
>> +                                                struct stm_drvdata, stm);
>> +     if (!(drvdata && drvdata->enable))
>> +             return -EINVAL;
>> +
>> +     if (channel >= drvdata->numsp)
>> +             return -EINVAL;
>> +
>> +     switch (*options) {
>> +     case STM_OPTION_GUARANTEED:
>> +             *options = test_bit(channel, drvdata->chs.guaranteed);
>> +             break;
>
> This just doesn't work. @options here is an on-stack variable in
> stm_char_ioctl(), hitherto uninitialized. The get_options ioctl command
> as you implemented it doesn't fetch @options from userspace either, it
> just passes a pointer to it to this callback, expecting that the
> callback will set it so that it can be copy_to_user()ed back to the
> user.

Yes, that was the intended behaviour - to allow user space to see in
what mode channels are configured (guaranteed/invariant).

>
> Then, when we figure this out, there is again the question of what
> should one make of STM_OPTION_{GUARANTEED,INVARIANT} and how do they fit
> into *options.

The interface asks if the channel is configured in "guaranteed" mode.
If not and because there isn't another mode available, it is
automatically in "invariant" mode.

But as I pointed out in my earlier email this may no longer needed.
One has to issue a system call anyway, might as well just go ahead
with the configuration request.

Thanks,
Mathieu

>
> The idea behind set_options ioctl is that the user specifies a bit mask
> of options that he/she wants to set.
>
> [snip]
>
>> +#ifndef __UAPI_CORESIGHT_STM_H_
>> +#define __UAPI_CORESIGHT_STM_H_
>> +
>> +#define STM_FLAG_TIMESTAMPED   BIT(3)
>> +#define STM_FLAG_GUARANTEED    BIT(7)
>> +
>> +enum {
>> +     STM_OPTION_GUARANTEED = 0,
>> +     STM_OPTION_INVARIANT,
>> +};
>
> Each of these guys could also use an explanation.
>
> Regards,
> --
> Alex
