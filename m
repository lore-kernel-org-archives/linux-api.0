From: Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH v9 0/9] Add simple NVMEM Framework via regmap.
Date: Fri, 7 Aug 2015 09:30:06 -0700
Message-ID: <CAMAWPa_=1oTziNz-oorXV70AZ2S3JbVu4rhK_nX_=wYwjr2a3g@mail.gmail.com>
References: <1437995567-11203-1-git-send-email-srinivas.kandagatla@linaro.org>
	<7hwpx7vzyo.fsf@deeprootsystems.com>
	<55C4DA42.909@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <55C4DA42.909@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Kevin Hilman <khilman@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>, linux-api@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "sboyd@codeaurora.org" <sboyd@codeaurora.org>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, mporter@konsulko.com, Stefan Wahren <stefan.wahren@i2se.com>, Caesar Wang <wxt@rock-chips.com>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 7, 2015 at 9:18 AM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
> Thanks Kevin,
>
> On 07/08/15 17:13, Kevin Hilman wrote:
>>
>> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> writes:
>>
>>> This patchset adds a new simple NVMEM framework to kernel, and it is
>>> tested
>>> with various drivers like "QCOM thermal sensors", "QCOM cpr driver",
>>> "begal bone cape manager" and few more on the way.
>>>
>>> Can you please consider this as 4.3 material, AFAIK there are more than 3
>>> drivers
>>> depending on this framework which are wating since last 2 merge windows.
>>>
>>> Should these patches go via ARM-SOC tree or via Greg's tree?
>>
>>
>> With Greg's ack, we can take this through the arm-soc tree (unless Greg
>> wants to queue it, which is fine also.)
>>
>
> Greg already merged these patches yesterday on to
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
> in the char-misc-next branch.

Ah, great.  I missed that (still catching up on post-vacation mail backlog.)

Thanks,

Kevin
