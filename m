From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [REVIEW][PATCH 09/11] ipc/shm: Fix shmctl(..., IPC_STAT, ...) between pid namespaces.
Date: Wed, 28 Mar 2018 18:04:22 -0500
Message-ID: <87woxvajk9.fsf@xmission.com>
References: <87vadmobdw.fsf_-_@xmission.com>
        <20180323191614.32489-9-ebiederm@xmission.com>
        <7df62190-2407-bfd4-d144-7304a8ea8ae3@oracle.com>
        <87lgeio4tb.fsf@xmission.com>
        <1091a91e-f8ee-b091-6d95-78b33520fb2d@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1091a91e-f8ee-b091-6d95-78b33520fb2d@oracle.com> (NAGARATHNAM
        MUTHUSAMY's message of "Fri, 23 Mar 2018 14:41:29 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: NAGARATHNAM MUTHUSAMY <nagarathnam.muthusamy@oracle.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, khlebnikov@yandex-team.ru, prakash.sangappa@oracle.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, serge.hallyn@ubuntu.com, esyr@redhat.com, jannh@google.com, linux-security-module@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org

NAGARATHNAM MUTHUSAMY <nagarathnam.muthusamy@oracle.com> writes:

> On 3/23/2018 2:33 PM, ebiederm@xmission.com wrote:
>> NAGARATHNAM MUTHUSAMY <nagarathnam.muthusamy@oracle.com> writes:
>>
>>> Thanks!
>>>
>>> Reviewed-by: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
>> Does this look like it will address the issue you have been fighting
>> with pids?
>
> We do use IPC shared memory but it is a single large one, shared by multiple
> levels. We are currently looking into using a similar solution based on file
> locks.
> When a new level is created, a file representing that level could be created in
> a common path which could be locked by the init process of that level.
> Parent levels could query the locking pid of that file to get the pid
> translation
> of the init process of the required level. Then it could open a file descriptor
> and use the translate_pid API for further translations.

Do you want to resend the translate_pid API with file descriptors as it
was in the lwn article?  That I will apply.

Eric
