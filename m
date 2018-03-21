From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RESEND RFC] translate_pid API
Date: Tue, 20 Mar 2018 19:33:49 -0500
Message-ID: <87a7v2z2qa.fsf@xmission.com>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
        <87vadzqqq6.fsf@xmission.com>
        <990e88fa-ab50-9645-b031-14e1afbf7ccc@oracle.com>
        <877eqejowd.fsf@xmission.com>
        <3a46a03d-e4dd-59b6-e25f-0020be1b1dc9@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3a46a03d-e4dd-59b6-e25f-0020be1b1dc9@oracle.com> (Nagarathnam
        Muthusamy's message of "Tue, 20 Mar 2018 13:14:14 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, khlebnikov@yandex-team.ru, prakash.sangappa@oracle.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, serge.hallyn@ubuntu.com, esyr@redhat.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com> writes:

> (Resending the reply as there was a reject due to HTML in email)
>
> On 03/14/2018 03:03 PM, ebiederm@xmission.com wrote:
>> Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com> writes:
>>
>>> On 03/13/2018 08:29 PM, ebiederm@xmission.com wrote:
>>>> The cost of that ``cheaper'' u64 that is not in any namespace is that
>>>> you now have to go and implement a namespace of namespaces.  You haven't
>>>> even attempted it.  So just no.    Anything that brings us to needing
>>>> a namespace of namespaces is a bad design.
>>> I am not trying to implement a namespace of namespaces.
>> No you are using a design that will require a namespace of namespaces
>> to be implemented to support CRIU (checkpoint/restart in userspace).
>>
>> So when I see your patch I see a patch that only implements the easy
>> half of the work that needs to be done.
>>
>>>>> Following patch uses a 64-bit ID for namespace exported by procfs
>>>>> for pid translation through a new file /proc/<pid>/ns/pidns_id.
>>>> And this design detail is what brings the automatic nack.
>>>>
>>>> Use file descriptros and it sounds like your use case justifies what you
>>>> are trying to do.
>>> File descriptors are problematic for following reasons.
>>> 1) I need to open a couple of file descriptors for every pid
>>> translation request.
>> You can cache descriptors across requests.  I suspect simply
>> by tracking the origin of the shared memory segment you can figure
>> out it's pid namespace.
>>
>>> 2) In case of nested PID namespaces, say a new pid namespace is
>>> created at level 20,
>>>      with unique ID, I could just record this ID in a shared memory for
>>> interested process
>>>      to use. In case of file descriptors, every level has to figure out
>>> the process ID of the
>>>      newly created namespace's init process and open a file descriptor
>>> to track it.
>> Toss in a bind mount of the file in some filesystem if that helps.
>>
>> But if I understand what you are talking about you are talking about
>> having a shared memory segment shared between processes in different
>> pid namespaces.
>>
>> In that shared memory segment for a processes in different namespaces
>> you are talking about having the conversation structured as having
>> information structured as pid-namespace pid.
>>
>> And crucuially you want anyone in any pid namespace to be able to read
>> that shared memory segment and to make sense of what is going on,
>> by just reading the pid namespace id.
>
> This captures the usecase. Adding to that, every level is made up of
> a combination of User, pid and mount namespace.

You must be using sysvipc shared memory segments not posix shared memory
segments if you are sharing them in that scenario.

>> Namespaces are all about making identifiers relative to their namespace.
>>
>> The only way I can see you gain an advantage with your shared memory
>> design is by making identifiers that are not relative to their pid
>> namespace.   As such identifiers will completely defeat the ability
>> to implement CRIU support.
>>
>> The closest I have to such identifiers today are bind mounts of the
>> namespace files.  So if you also have a common mount namespace you could
>> use that.
>
> We don't have common mount namespace. Each nested level will have
> a new mount namespace. When a new nested level (User + pid + mnt) is
> created, init process of new level cannot bind mount the namespace directory,
> as the effects wont be visible to the other levels.

Do you have a ipc shared memory segment.

I just looked and realized there is a rather significant bug in ipc
shared memory segments when shared between pid namespaces, and I believe
fixing that bug will resolve your issue.

shmctl(IPC_STAT, ...) will return a struct shmid_ds.
The struct shmid_ds has a field shm_cpid.

That field is currently reported as the pid in the pid namespace that
created the segment.  Which is nonsense if you are not in the pid
namespace.

However if we were to fix that to properly return the pid in the
pid namespace of the caller of IPC_STAT.  You could find the
pid of the creator of the ipc shared memory segment by just
calling shmctl(IPC_STAT, ...).

> On other hand, the new init process could send SCM_CREDENTIALS message
> to a centralized listener running outside of the whole setup which does only
> bind mounts. Here, we have a single point of failure for the whole system and
> this listener has to run as root to be able to do bind mounts. Apart from these,
> I am not able to see the bind mount by listener being propagated to child
> namespaces in my setup. Not sure if I am missing anything or this is the
> expected behavior.

It depends on how mount propgation is configured.  You can configure
mount propgation so that these bind mounts propagate to every mount
namespace.  Which would definitely be a possible solution.

> Is it possible to have application provide the ID to be associated with
> the namespace? During dump, we can save the ID and during restore,
> we can assign the ID using the same API. There is a possibility of
> collision during restore. Is it ok to fail the restore during such
> scenario?

No. It is absolutely not ok to fail the restore during such a scenario.
For CRIU that is the entire point of having namespaces.  Not having
to worry about an id not being available during restore.

Eric
