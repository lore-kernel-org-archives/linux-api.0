From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCHv5 01/37] ns: Introduce Time Namespace
Date: Fri, 2 Aug 2019 00:46:39 +0100
Message-ID: <4d8d8489-28c8-259f-23a9-ed2b89699b73@gmail.com>
References: <20190729215758.28405-1-dima@arista.com>
 <20190729215758.28405-2-dima@arista.com>
 <CALCETrWHEcaG9gZe6ACt5H1H+P8D0RobrJ_bf4Wf9ts40NMM9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWHEcaG9gZe6ACt5H1H+P8D0RobrJ_bf4Wf9ts40NMM9w@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Dmitry Safonov <dima@arista.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Linux Containers <containers@lists.linux-foundation.org>, criu@openvz.org, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Andy,

Thank you for the review,

On 8/1/19 6:29 AM, Andy Lutomirski wrote:
> On Mon, Jul 29, 2019 at 2:58 PM Dmitry Safonov <dima@arista.com> wrote:
>>
>> From: Andrei Vagin <avagin@openvz.org>
>>
>> Time Namespace isolates clock values.
> 
>> +static int timens_install(struct nsproxy *nsproxy, struct ns_common *new)
>> +{
>> +       struct time_namespace *ns = to_time_ns(new);
>> +
>> +       if (!thread_group_empty(current))
>> +               return -EINVAL;
> 
> You also need to check for other users of the mm.

Oops. It seems like, if the check was

if (!current_is_single_threaded())
    return -EUSERS;

instead of thread_group_empty(current), it would address the concerns
from 23/37 and 25/37 patches, too?

> 
>> +
>> +       if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
>> +           !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
>> +               return -EPERM;
>> +
>> +       get_time_ns(ns);
>> +       get_time_ns(ns);
>> +       put_time_ns(nsproxy->time_ns);
>> +       put_time_ns(nsproxy->time_ns_for_children);
>> +       nsproxy->time_ns = ns;
>> +       nsproxy->time_ns_for_children = ns;
>> +       ns->initialized = true;
> 
> I really really wish that setns() took an explicit flag for "change
> now" or "change for children", since the semantics are different.  Oh
> well.
> 

Thanks,
          Dmitry
