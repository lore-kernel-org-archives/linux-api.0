From: Jann Horn <jannh@google.com>
Subject: Re: [RESEND RFC] translate_pid API
Date: Tue, 13 Mar 2018 14:28:35 -0700
Message-ID: <CAG48ez3v5rTSUg4VDTYknuOBHnv+FF9=ghZJAsknCXREU+juOg@mail.gmail.com>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
 <CAG48ez1ww-pVQ9R+d+P+smRR3eaEkJ-=9GW-O-QOvH-YZoFG8A@mail.gmail.com> <69f13674-7f84-5dc7-0bd7-e5e65e9cb3b0@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <69f13674-7f84-5dc7-0bd7-e5e65e9cb3b0@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Nagarajan.Muthukrishnan@oracle.com, Prakash Sangappa <prakash.sangappa@oracle.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Eugene Syromiatnikov <esyr@redhat.com>, xemul@parallels.com
List-Id: linux-api@vger.kernel.org

On Tue, Mar 13, 2018 at 2:20 PM, Nagarathnam Muthusamy
<nagarathnam.muthusamy@oracle.com> wrote:
> On 03/13/2018 01:47 PM, Jann Horn wrote:
>> On Mon, Mar 12, 2018 at 10:18 AM,  <nagarathnam.muthusamy@oracle.com>
>> wrote:
>>>
>>> Resending the RFC with participants of previous discussions
>>> in the list.
>>>
>>> Following patch which is a variation of a solution discussed
>>> in https://lwn.net/Articles/736330/ provides the users of
>>> pid namespace, the functionality of pid translation between
>>> namespaces using a namespace identifier. The topic of
>>> pid translation has been discussed in the community few times
>>> but there has always been a resistance to adding new solution
>>> for this problem.
>>> I will outline the planned usecase of pid namespace by oracle
>>> database and explain why any of the existing solution cannot
>>> be used to solve their problem.
>>>
>>> Consider a system in which several PID namespaces with multiple
>>> nested levels exists in parallel with monitor processes managing
>>> all the namespaces. PID translation is required for controlling
>>> and accessing information about the processes by the monitors
>>> and other processes down the hierarchy of namespaces. Controlling
>>> primarily involves sending signals or using ptrace by a process in
>>> parent namespace on any of the processes in its child namespace.
>>> Accessing information deals with the reading /proc/<pid>/* files
>>> of processes in child namespace. None of the processes have
>>> root/CAP_SYS_ADMIN privileges.
>>
>> How are you dealing with PID reuse?
>
>
> We have a monitor process which keeps track of the aliveness of
> important processes. When a process dies, monitor makes a note of
> it and hence detects if pid is reused.

How do you do that in a race-free manner?


>>> + */
>>> +SYSCALL_DEFINE3(translate_pid, pid_t, pid, u64, source,
>>> +               u64, target)
>>> +{
>>> +       struct pid_namespace *source_ns = NULL, *target_ns = NULL;
>>> +       struct pid *struct_pid;
>>> +       struct pid_namespace *ph;
>>> +       struct hlist_bl_head *shead = NULL;
>>> +       struct hlist_bl_head *thead = NULL;
>>> +       struct hlist_bl_node *dup_node;
>>> +       pid_t result;
>>> +
>>> +       if (!source) {
>>> +               source_ns = &init_pid_ns;
>>> +       } else {
>>> +               shead = pid_ns_hash_head(pid_ns_hash, source);
>>> +               hlist_bl_lock(shead);
>>> +               hlist_bl_for_each_entry(ph, dup_node, shead, node) {
>>> +                       if (source == ph->ns.ns_id) {
>>> +                               source_ns = ph;
>>> +                               break;
>>> +                       }
>>> +               }
>>> +               if (!source_ns) {
>>> +                       hlist_bl_unlock(shead);
>>> +                       return -EINVAL;
>>> +               }
>>> +       }
>>> +       if (!ptrace_may_access(source_ns->child_reaper,
>>> +                              PTRACE_MODE_READ_FSCREDS)) {
>>
>> AFAICS this proposal breaks the visibility restrictions that
>> namespaces normally create. If there are two namespaces-based
>> containers that use the same UID range, I don't think they should be
>> able to learn information about each other, such as which PIDs are in
>> use in the other container; but as far as I can tell, your proposal
>> makes it possible to do that (unless an LSM or so is interfering). I
>> would prefer it if this API required visibility of the targeted PID
>> namespaces in the caller's PID namespace.
>
>
> I am trying to simulate the same access restrictions allowed
> on a process's /proc/<pid>/ns/pid file. If the translator has
> access to /proc/<pid>/ns/pid file of both source and destination
> namespaces, shouldn't it be allowed to translate the pid between
> them?

But the translator doesn't actually need to have access to those
procfs files, right?
