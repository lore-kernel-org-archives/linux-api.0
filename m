From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 01/11] coresight-etm4x: Adding CoreSight ETM4x driver
Date: Tue, 28 Apr 2015 14:28:26 +0200
Message-ID: <CACRpkdak5-iuWEDAvhDq3uwYobK+tW_N-t-QaY+-5TUSCa7uOg@mail.gmail.com>
References: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>
	<1429742451-11465-2-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429742451-11465-2-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kaixu Xia <kaixu.xia@linaro.org>, Chunyan Zhang <zhang.chunyan@linaro.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 23, 2015 at 12:40 AM, Mathieu Poirier
<mathieu.poirier@linaro.org> wrote:

> From: Pratik Patel <pratikp@codeaurora.org>
>
> This driver manages the CoreSight ETMv4 (Embedded Trace Macrocell) IP block
> to support HW assisted tracing on ARMv7 and ARMv8 architectures.
>
> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

(...)
> +/* The number of ETMv4 currently registered */
> +static int etm4_count;
> +static struct etmv4_drvdata *etmdrvdata[NR_CPUS];

Don't you need a mutex or something around etm4_count so
as to protect it? You could also make it an atomic.

Also why is it a signed int ... unsigned int?

I know, lame comments, the runtime PM stuff looks perfect now,
someone had a refcount comment but it's doing the right thing.

Yours,
Linus Walleij
