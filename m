From: Prakash Sangappa <prakash.sangappa@oracle.com>
Subject: Re: [RESEND RFC PATCH 0/1] CAP_SYS_NICE inside user namespace
Date: Thu, 21 Nov 2019 17:54:13 -0800
Message-ID: <4593138d-421e-5770-6dd5-e31f103911c5@oracle.com>
References: <1574096478-11520-1-git-send-email-prakash.sangappa@oracle.com>
 <CAG48ez3HfUx2aRvqR_bWnGoTshrHnUzxUNt7K6Sv7cqtPDWaWw@mail.gmail.com>
 <9a63f7ae-562e-67a6-8f40-050c58c08933@oracle.com>
 <c7949242-385f-3256-b290-87640acd0577@metux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c7949242-385f-3256-b290-87640acd0577@metux.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Enrico Weigelt, metux IT consult" <lkml@metux.net>, Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org



On 11/21/19 10:33 AM, Enrico Weigelt, metux IT consult wrote:
> On 18.11.19 21:34, Prakash Sangappa wrote:
>
>> It is more the latter. Admin should be able to explicitly decide that  container A
>> workload is to be given priority over other containers.
> I guess, you're talking about the host's admin, correct ?

Yes, Specifically host's admin decides which container gets the 
privilege to increase priority of processes inside that container.

>
> Shouldn't this already be possibly by tweaking the container's cgroups ?

Don't think so. The use case is that admin/user inside the container 
needs to be able to increase the priority of some the critical processes 
running in the container.

>
>
> --mtx
>
