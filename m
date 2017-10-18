From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [1/2,v2] fdmap(2)
Date: Wed, 18 Oct 2017 10:47:32 -0700
Message-ID: <CALCETrW769=r4uXH2RqoQ0cQL2CakfupwAUM2_81Fr8Mo3JX=Q@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <20171010220804.GA30735@outlook.office365.com>
 <20171011181234.GB2119@avx2> <20171012080608.GA23077@outlook.office365.com> <CACVxJT_ZP=VAJQ_=D1JV0yt3bT_RZjtWTW61KcV5gCbhF8ixBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACVxJT_ZP=VAJQ_=D1JV0yt3bT_RZjtWTW61KcV5gCbhF8ixBw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Djalal Harouni <tixxdz@gmail.com>, Alexey Gladkov <gladkov.alexey@gmail.com>
List-Id: linux-api@vger.kernel.org

> On Oct 18, 2017, at 4:35 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
>> On 10/12/17, Andrei Vagin <avagin@virtuozzo.com> wrote:
>>
>> I'm agree with your points, but I think you choose a wrong set of data
>> to make an example of a new approach.
>>
>> You are talking a lot about statx, but for me it is unclear how fdmap
>> follows the idea of statx. Let's imagine that I want to extend fdmap to
>> return mnt_id for each file descriptor?
>
> fdmap() is standalone thing.
>
> Next step is to design fdinfo(2) (?) which uses descriptors from fdmap(2).
> Extending structures is done as usual: but version, add new fields to the end.
>

I very strongly disagree.  If you really want a new interface for
reading out information about other processes, design one that makes
sense as a whole.  Don't design it piecemeal. The last thing we need
is a crappy /proc alternative that covers a small fraction of use
cases.  And demonstrate that it actually has a material benefit over
fixing /proc.

Meanwhile, why not just fix /proc?
