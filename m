From: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Subject: Re: [RESEND PATCH V4] pidns: introduce syscall translate_pid
Date: Tue, 3 Apr 2018 14:51:04 -0700
Message-ID: <6a117d9a-f005-e1ae-5632-25e5c61dcb8f@oracle.com>
References: <1522706249-11578-1-git-send-email-nagarathnam.muthusamy@oracle.com>
 <20180403143838.614ecc083835d07d409a699c@linux-foundation.org>
 <678f275b-8d78-9b0f-177f-5ff5c9c55657@oracle.com>
 <20180403145248.fb4cd8c5ccd270ca77fd18f3@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180403145248.fb4cd8c5ccd270ca77fd18f3@linux-foundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, khlebnikov@yandex-team.ru, serge.hallyn@ubuntu.com, oleg@redhat.com, luto@amacapital.net, jannh@google.com, prakash.sangappa@oracle.com
List-Id: linux-api@vger.kernel.org



On 04/03/2018 02:52 PM, Andrew Morton wrote:
> On Tue, 3 Apr 2018 14:45:28 -0700 Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com> wrote:
>
>>> This changelog doesn't explain what the value is to our users.  I
>>> assume it is a performance optimization because "backward translation
>>> requires scanning all tasks"?  If so, please show us real-world
>>> examples of the performance benefit from this patch, and please go to
>>> great lengths to explain to us why this optimisation is needed by our
>>> users.
>> One of the usecase by Oracle database involves multiple levels of
>> nested pid namespaces and we require pid translation between the
>> levels. Discussions on the particular usecase, why any of the existing
>> methods was not usable happened in the following thread.
>>
>> https://patchwork.kernel.org/patch/10276785/
>>
>> At the end, it was agreed that this patch along with flocks will solve the
>> issue.
> Nobody who reads this patch's changelog will know any of this.  Please
> let's get all this information into the proper place.
Sure! Will resend the patch with updated change log.

Thanks,
Nagarathnam.
>
