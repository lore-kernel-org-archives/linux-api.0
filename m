From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: Re: [PATCH] move_pages.2: not return ENOENT if the page are already
 on the target nodes
Date: Thu, 2 Jan 2020 14:15:12 -0800
Message-ID: <d081b674-b360-4a0a-eec3-cf7434003cc5@linux.alibaba.com>
References: <1575596090-115377-1-git-send-email-yang.shi@linux.alibaba.com>
 <0dc96e40-5f2b-a2fe-6e5f-b6f3d5e9ebde@nvidia.com>
 <95170ea5-5b62-9168-fcd9-93b43330a1b4@linux.alibaba.com>
 <092adc11-7039-9343-7067-0e0199c9dc13@gmail.com>
 <51dd767a-221f-882d-c7f6-45bd0c217a67@nvidia.com>
 <20191218101711.GB21485@dhcp22.suse.cz>
 <0059a598-5726-2488-cd37-b4b7f9b3353e@linux.alibaba.com>
 <87lfqtcfyo.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87lfqtcfyo.fsf@x220.int.ebiederm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@kernel.org>, John Hubbard <jhubbard@nvidia.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, cl@linux.com, cai@lca.pw, akpm@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On 12/30/19 7:49 PM, Eric W. Biederman wrote:
> Yang Shi <yang.shi@linux.alibaba.com> writes:
>
>> On 12/18/19 2:17 AM, Michal Hocko wrote:
>>> On Tue 17-12-19 23:36:09, John Hubbard wrote:
>>> [...]
>>>> diff --git a/man2/move_pages.2 b/man2/move_pages.2
>>>> index 2d96468fa..1bf1053f2 100644
>>>> --- a/man2/move_pages.2
>>>> +++ b/man2/move_pages.2
>>>> @@ -191,12 +191,6 @@ was specified or an attempt was made to migrate pages of a kernel thread.
>>>>    .B ENODEV
>>>>    One of the target nodes is not online.
>>>>    .TP
>>>> -.B ENOENT
>>>> -No pages were found that require moving.
>>>> -All pages are either already
>>>> -on the target node, not present, had an invalid address or could not be
>>>> -moved because they were mapped by multiple processes.
>>>> -.TP
>>>>    .B EPERM
>>>>    The caller specified
>>>>    .B MPOL_MF_MOVE_ALL
>>>>
>>>> ...But I'm not sure if we should change the implementation, instead, so
>>>> that it *can* return ENOENT. That's the main question to resolve before
>>>> creating any more patches, I think.
>>> I would start by dropping any note about ENOENT first. I am not really
>>> sure there is a reasonable usecase for it but maybe somebody comes up
>>> with something and only then we should consider it.
>>>
>>> Feel free to add
>>> Acked-by: Michal Hocko <mhocko@suse.com>
>>>
>>> ideally with a kernel commit which removed the ENOENT.
>> A quick audit doesn't show kernel code or comment notes about ENOENT
>> wrongly. The status could be set as ENOENT if the page is not present
>> (follow_page() returns NULL), and man page does match what kernel
>> does.
> Doesn't the function one layer up then consume the ENOENT?

No, it doesn't. The return value would be reset unconditionally by 
store_status(). This is what the man page patch tries to correct.

>
> Eric
