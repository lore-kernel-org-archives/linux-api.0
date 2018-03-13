From: Jann Horn <jannh@google.com>
Subject: Re: [RESEND RFC] translate_pid API
Date: Tue, 13 Mar 2018 16:10:33 -0700
Message-ID: <CAG48ez0FD747Vth=VQBNeJnFVKRxmd71Xu4atU650t0WxqOuFg@mail.gmail.com>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
 <CAG48ez1ww-pVQ9R+d+P+smRR3eaEkJ-=9GW-O-QOvH-YZoFG8A@mail.gmail.com>
 <69f13674-7f84-5dc7-0bd7-e5e65e9cb3b0@oracle.com> <CAG48ez3v5rTSUg4VDTYknuOBHnv+FF9=ghZJAsknCXREU+juOg@mail.gmail.com>
 <1a8cac8b-22cc-e194-4244-b20428c8a9c2@oracle.com> <CAG48ez05MDH7Wf1_j3qgbrqjEh-GXPLQHfx-Va_pyzvT5hP=gw@mail.gmail.com>
 <df6ad381-db14-3ded-c724-a80565b549b2@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <df6ad381-db14-3ded-c724-a80565b549b2@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Nagarajan.Muthukrishnan@oracle.com, Prakash Sangappa <prakash.sangappa@oracle.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Eugene Syromiatnikov <esyr@redhat.com>, xemul@parallels.com
List-Id: linux-api@vger.kernel.org

On Tue, Mar 13, 2018 at 3:45 PM, Nagarathnam Muthusamy
<nagarathnam.muthusamy@oracle.com> wrote:
> On 03/13/2018 03:00 PM, Jann Horn wrote:
>> On Tue, Mar 13, 2018 at 2:44 PM, Nagarathnam Muthusamy
>> <nagarathnam.muthusamy@oracle.com> wrote:
>>> On 03/13/2018 02:28 PM, Jann Horn wrote:
>>>> On Tue, Mar 13, 2018 at 2:20 PM, Nagarathnam Muthusamy
>>>> <nagarathnam.muthusamy@oracle.com> wrote:
>>>>> On 03/13/2018 01:47 PM, Jann Horn wrote:
>>>>>> On Mon, Mar 12, 2018 at 10:18 AM,  <nagarathnam.muthusamy@oracle.com>
>>>>>> wrote:
[...]
>>>>>>> + */
>>>>>>> +SYSCALL_DEFINE3(translate_pid, pid_t, pid, u64, source,
>>>>>>> +               u64, target)
>>>>>>> +{
>>>>>>> +       struct pid_namespace *source_ns = NULL, *target_ns = NULL;
>>>>>>> +       struct pid *struct_pid;
>>>>>>> +       struct pid_namespace *ph;
>>>>>>> +       struct hlist_bl_head *shead = NULL;
>>>>>>> +       struct hlist_bl_head *thead = NULL;
>>>>>>> +       struct hlist_bl_node *dup_node;
>>>>>>> +       pid_t result;
>>>>>>> +
>>>>>>> +       if (!source) {
>>>>>>> +               source_ns = &init_pid_ns;
>>>>>>> +       } else {
>>>>>>> +               shead = pid_ns_hash_head(pid_ns_hash, source);
>>>>>>> +               hlist_bl_lock(shead);
>>>>>>> +               hlist_bl_for_each_entry(ph, dup_node, shead, node) {
>>>>>>> +                       if (source == ph->ns.ns_id) {
>>>>>>> +                               source_ns = ph;
>>>>>>> +                               break;
>>>>>>> +                       }
>>>>>>> +               }
>>>>>>> +               if (!source_ns) {
>>>>>>> +                       hlist_bl_unlock(shead);
>>>>>>> +                       return -EINVAL;
>>>>>>> +               }
>>>>>>> +       }
>>>>>>> +       if (!ptrace_may_access(source_ns->child_reaper,
>>>>>>> +                              PTRACE_MODE_READ_FSCREDS)) {
>>>>>>
>>>>>> AFAICS this proposal breaks the visibility restrictions that
>>>>>> namespaces normally create. If there are two namespaces-based
>>>>>> containers that use the same UID range, I don't think they should be
>>>>>> able to learn information about each other, such as which PIDs are in
>>>>>> use in the other container; but as far as I can tell, your proposal
>>>>>> makes it possible to do that (unless an LSM or so is interfering). I
>>>>>> would prefer it if this API required visibility of the targeted PID
>>>>>> namespaces in the caller's PID namespace.
>>>>>
>>>>>
>>>>> I am trying to simulate the same access restrictions allowed
>>>>> on a process's /proc/<pid>/ns/pid file. If the translator has
>>>>> access to /proc/<pid>/ns/pid file of both source and destination
>>>>> namespaces, shouldn't it be allowed to translate the pid between
>>>>> them?
>>>>
>>>> But the translator doesn't actually need to have access to those
>>>> procfs files, right?
>>>
>>> I thought it should have access to those procfs files to satisfy the
>>> visibility constraint that targeted PID namespaces should be visible
>>> in caller's PID namespace and ptrace_may_access checks that
>>> constraint.
>>
>> If there are two containers that use the same UID range,
>> ptrace_may_access() checks from a process in one container on a
>> process in another container can pass. Normally, you just can't even
>> reach the ptrace_may_access() checks because you can't reference
>> processes in another container in any way.
>
>
> If there is no way to reference the process in another container,
> there is no way to get to the /proc/<pid>/ns/pidns_id file which
> exports the ID of that container right? So, a translator has to
> first guess the container ID then try translate. Even after translation,
> unless the translator has proper privileges, I believe it cant do
> anything with just the pid right?

Well, yes to both. You'd have to guess the ID of the container, and
you wouldn't be able to do much with it, apart from finding valid PIDs
and their mapping between namespaces.

>> By the way, a related concern: The use of global identifiers will
>> probably also negatively affect Checkpoint/Restore In Userspace?
>
> Will look into this. Can you point me to the specifics of the
> usecase which could be negatively affected?

AFAICS you won't be able to reliably recreate namespace IDs when a
process is checkpointed and resumed, meaning that checkpoint/resume
won't work on processes that use these namespace IDs.
