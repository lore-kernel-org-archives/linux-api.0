From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring: use __kernel_timespec in timeout ABI
Date: Tue, 1 Oct 2019 10:02:15 -0600
Message-ID: <77f90d5b-d6f8-b395-ba57-9d1f0ece9a00@kernel.dk>
References: <20190930202055.1748710-1-arnd@arndb.de>
 <8d5d34da-e1f0-1ab5-461e-f3145e52c48a@kernel.dk>
 <623e1d27-d3b1-3241-bfd4-eb94ce70da14@kernel.dk>
 <CAK8P3a3AAFXNmpQwuirzM+jgEQGj9tMC_5oaSs4CfiEVGmTkZg@mail.gmail.com>
 <ca0a5bbe-c20e-d5be-110e-942c604ad2d7@kernel.dk>
 <CAK8P3a19TDk0uo1eu4CcaKHvQCPUJGMjBV8Txtpgvg1ifAgW_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a19TDk0uo1eu4CcaKHvQCPUJGMjBV8Txtpgvg1ifAgW_A@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Stefan_B=c3=bchler?= <source@stbuehler.de>, Hannes Reinecke <hare@suse.com>, Jackie Liu <liuyun01@kylinos.cn>, Andrew Morton <akpm@linux-foundation.org>, Hristo Venev <hristo@venev.name>, linux-block <linux-block@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 10/1/19 9:57 AM, Arnd Bergmann wrote:
> On Tue, Oct 1, 2019 at 5:52 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/1/19 9:49 AM, Arnd Bergmann wrote:
>>> On Tue, Oct 1, 2019 at 5:38 PM Jens Axboe <axboe@kernel.dk> wrote:
> 
>>> What's wrong with using __kernel_timespec? Just the name?
>>> I suppose liburing could add a macro to give it a different name
>>> for its users.
>>
>> Just that it seems I need to make it available through liburing on
>> systems that don't have it yet. Not a big deal, though.
> 
> Ah, right. I t would not cover the case of building against kernel
> headers earlier than linux-5.1 but running on a 5.4+ kernel.
> 
> I assumed that that you would require new kernel headers anyway,
> but if you have a copy of the io_uring header, that is not necessary.

Since I rely mostly on folks using liburing, we include the header as
well. So I'm just going to use __kernel_timespec in liburing, and have
a check to define it if we don't have it.

>> One thing that struck me about this approach - we then lose the ability to
>> differentiate between "don't want a timed timeout" with ts == NULL, vs
>> tv_sec and tv_nsec both being 0.
> 
> You could always define a special constant such as
> '#define IO_URING_TIMEOUT_NEVER -1ull' if you want to
> support for 'never wait if it's not already done' and 'wait indefinitely'.

That thought did occur to me, but that seems pretty ugly... The ts == NULL
vs ts != NULL and timeout set is a more well understood pattern.

-- 
Jens Axboe
