From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/2] pidmap(2)
Date: Thu, 7 Sep 2017 12:47:11 +0300
Message-ID: <CACVxJT_HWMY3ZGqU31aab5Fg-iW61FTb9K64s3KJxOz5J+bANw@mail.gmail.com>
References: <20170905190500.GA13746@avx2> <20170905155320.a683a4853b21a3be32d8b529@linux-foundation.org>
 <d538b917-3e3e-827c-7ca0-5493961cf6f1@infradead.org> <CACVxJT_vg7DnxSGmMtRT5aLCL=jutD94-yXaNOBwrJc-G+g_1w@mail.gmail.com>
 <CALCETrUFnfncs9QdZ4LTeFemVTCx-27bu88M=3U=RKBT8Oykwg@mail.gmail.com> <CAEiveUfwZs+ECNSdiVRfHMXZTiYus33DAkmD3Kr6KczZheCr8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEiveUfwZs+ECNSdiVRfHMXZTiYus33DAkmD3Kr6KczZheCr8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Tatsiana Brouka <Tatsiana_Brouka@epam.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1@epam.com>, Alexey Gladkov <gladkov.alexey@gmail.com>
List-Id: linux-api@vger.kernel.org

On 9/7/17, Djalal Harouni <tixxdz@gmail.com> wrote:
> Hi Alexey,
>
> On Thu, Sep 7, 2017 at 4:04 AM, Andy Lutomirski <luto@amacapital.net>
> wrote:
>> On Wed, Sep 6, 2017 at 2:04 AM, Alexey Dobriyan <adobriyan@gmail.com>
>> wrote:
>>> On 9/6/17, Randy Dunlap <rdunlap@infradead.org> wrote:
>>>> On 09/05/17 15:53, Andrew Morton wrote:
> [...]
>>>>
>>>> also, I expect that the tiny kernel people will want kconfig options
>>>> for
>>>> these syscalls.
>>>
>>> We'll add it but the question if it is a good idea. Ideally these system
>>> calls
>>> should be mandatory and /proc optional.
>>>
>>> $ size kernel/pidmap.o fs/fdmap.o
>>>    text    data     bss     dec     hex filename
>>>     560       0       0     560     230 kernel/pidmap.o
>>>     617       0       0     617     269 fs/fdmap.o
>>
>> After much discussion at LPC/KS last year, I thought the idea was to
>> try to speed up /proc rather than replacing it outright.  The two
>> specific ideas I recall were:
>>
>> 1. Add a syscall like readfileat() that you can use to, in a single
>> operation, open, read, and close a /proc file (or other file).  This
>> should vastly reduce locking and RCU overhead.
>>
>> 2. Add a /proc file that has a nice binary format for task info.
>> (nl_attr?)
>>
>> I don't see why pidmap() deserves to be significantly faster than
>> getdents().
>>
>> Also, a pidmap() syscall like this inherently bypasses any security
>> restrictions implied by the way that /proc is mounted.  It can respect
>> hidepid, but hidepid (as a per-namespace concept) is an enormous turd
>> that badly needs to be deprecated, and Djalal is working on exactly
>> that.
>
> Yes as noted by Andy, me and Alexey Gladkov are working on modernizing
> procfs [1] and to reduce/remove ties within pid namespaces which has lot
> of problems now.
> ...

Kudos for digging into this mess.
But the question will remain: how get pids of existing processes quickly.
