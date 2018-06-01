From: NAGARATHNAM MUTHUSAMY <nagarathnam.muthusamy@oracle.com>
Subject: Re: [PATCH RFC v5] pidns: introduce syscall translate_pid
Date: Fri, 1 Jun 2018 08:55:43 -0700
Message-ID: <2cc8a788-56ec-8e30-be04-d5d0e0791f90@oracle.com>
References: <152286911105.615669.14053871624892399807.stgit@buzz>
 <ba7b704f-1fc4-a08d-e7cf-2766160bd419@oracle.com>
 <87h8oqhagl.fsf@xmission.com>
 <112c7cac-1982-3a2e-ffc0-878bc5ae4bb6@yandex-team.ru>
 <e1402871-77a5-6a0f-a75c-ccad77b93f49@oracle.com>
 <778ab3d0-b6bc-fdb5-669a-40222e5020d4@yandex-team.ru>
 <e3a1076d-cfd7-a034-dd08-2d74fbf751f3@oracle.com>
 <3e2c285a-1bf8-f71d-1b74-4d6465c29a54@yandex-team.ru>
 <3bdd6b27-0a46-5802-8671-07268cecc1c7@oracle.com>
 <87po1bd7ky.fsf@xmission.com>
 <CALYGNiPyjJQ2dZHtF+Ug5TFjEcK2O9anLDDDG0JftXtykPAoEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALYGNiPyjJQ2dZHtF+Ug5TFjEcK2O9anLDDDG0JftXtykPAoEg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Prakash Sangappa <prakash.sangappa@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org



On 5/31/2018 11:58 PM, Konstantin Khlebnikov wrote:
> On Thu, May 31, 2018 at 9:05 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com> writes:
>>
>>> Ping? Any additional comments on this patch?
>> Konstantin's v5 no.
>>
>>    I am uncomfortable with unnecessary flexibility.  I don't want to
>>    encourage the increased usage of pids to identify namespaces.  I saw
>>    no arguments in favor of pids to identify namespaces from Konstantin.
>>
>> Your v4 updated to reflect Andrew Morton's concerns in the changelog
>> yes.
> Ok, whatever. If I the only blocker then let it be v4 design.

Thanks! I will resend the V4 patch with a plain text man page for 
translate_pid.

Thanks,
Nagarathnam.
>
>> Eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-api" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
