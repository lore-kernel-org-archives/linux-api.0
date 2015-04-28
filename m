From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 01/11] coresight-etm4x: Adding CoreSight ETM4x driver
Date: Tue, 28 Apr 2015 14:23:43 +0200
Message-ID: <CACRpkdYKmq3giv_Wyy+94puHpxaNxgooQFEtwhv-sH0sMK739g@mail.gmail.com>
References: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>
	<1429742451-11465-2-git-send-email-mathieu.poirier@linaro.org>
	<1429890108.5211.8.camel@mm-sol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429890108.5211.8.camel@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>, Greg KH <gregkh@linuxfoundation.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kaixu Xia <kaixu.xia@linaro.org>, Chunyan Zhang <zhang.chunyan@linaro.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 24, 2015 at 5:41 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> On Wed, 2015-04-22 at 16:40 -0600, Mathieu Poirier wrote:
>>
>
>> +static struct amba_id etm4_ids[] = {
>> +       {       /* ETM 4.0 - Hi6220 board */
>> +               .id     = 0x0003b95d,
>> +               .mask   = 0x0003ffff,
>> +               .data   = "ETM 4.0",
>> +       },
>> +       {       /* ETM 4.0 - Juno board */
>> +               .id     = 0x000bb95e,
>> +               .mask   = 0x000bffff,
>
> Mask looks suspicious.

I'm thinking that maybe we should have some masks predefined in
<linux/amba/bus.h> for bits in this field so we get it right.

Yours,
Linus Walleij
