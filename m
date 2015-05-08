From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v3 01/11] coresight-etm4x: Adding CoreSight ETM4x driver
Date: Fri, 8 May 2015 07:12:48 -0600
Message-ID: <CANLsYkxoZ62qeS91NbQZYwz-fx2qNdY+Ygw6NLbLgxcoqmkc-g@mail.gmail.com>
References: <1430926047-9125-1-git-send-email-mathieu.poirier@linaro.org>
	<1430926047-9125-2-git-send-email-mathieu.poirier@linaro.org>
	<1431073649.21307.12.camel@mm-sol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431073649.21307.12.camel@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-api@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kaixu Xia <kaixu.xia@linaro.org>, Chunyan Zhang <zhang.chunyan@linaro.org>
List-Id: linux-api@vger.kernel.org

On 8 May 2015 at 02:27, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
>
> Hi Mathieu,
>
> On Wed, 2015-05-06 at 09:27 -0600, Mathieu Poirier wrote:
>>
>> +static struct amba_id etm4_ids[] = {
>> +       {       /* ETM 4.0 - Juno board */
>> +               .id     = 0x000bb95e,
>> +               .mask   = 0x000fffff,
>> +               .data   = "ETM 4.0",
>> +       },
>> +       { 0, 0},
>> +};
>> +
>>
>
> Any particular reason to remove device ID for the
> Hi6220 board? It happens to be the same ID used in
> Qualcomm 8x16 ETM components.

Efforts to push support for the Hi6220 board upstream have been
abandoned, hence the decision to remove the entry.  Apologies for the
inconvenience, I will add it back.

Mathieu

>
> Regards,
> Ivan
