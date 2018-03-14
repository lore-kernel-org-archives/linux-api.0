From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RESEND RFC] translate_pid API
Date: Wed, 14 Mar 2018 17:03:30 -0500
Message-ID: <877eqejowd.fsf@xmission.com>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
        <87vadzqqq6.fsf@xmission.com>
        <990e88fa-ab50-9645-b031-14e1afbf7ccc@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <990e88fa-ab50-9645-b031-14e1afbf7ccc@oracle.com> (Nagarathnam
        Muthusamy's message of "Wed, 14 Mar 2018 14:22:51 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, khlebnikov@yandex-team.ru, Nagarajan.Muthukrishnan@oracle.com, prakash.sangappa@oracle.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, serge.hallyn@ubuntu.com, esyr@redhat.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com> writes:

> On 03/13/2018 08:29 PM, ebiederm@xmission.com wrote:

>> The cost of that ``cheaper'' u64 that is not in any namespace is that
>> you now have to go and implement a namespace of namespaces.  You haven't
>> even attempted it.  So just no.    Anything that brings us to needing
>> a namespace of namespaces is a bad design.
>
> I am not trying to implement a namespace of namespaces.

No you are using a design that will require a namespace of namespaces
to be implemented to support CRIU (checkpoint/restart in userspace).

So when I see your patch I see a patch that only implements the easy
half of the work that needs to be done.

>>> Following patch uses a 64-bit ID for namespace exported by procfs
>>> for pid translation through a new file /proc/<pid>/ns/pidns_id.
>> And this design detail is what brings the automatic nack.
>>
>> Use file descriptros and it sounds like your use case justifies what you
>> are trying to do.
>
> File descriptors are problematic for following reasons.
> 1) I need to open a couple of file descriptors for every pid
> translation request.

You can cache descriptors across requests.  I suspect simply
by tracking the origin of the shared memory segment you can figure
out it's pid namespace.

> 2) In case of nested PID namespaces, say a new pid namespace is
> created at level 20,
>     with unique ID, I could just record this ID in a shared memory for
> interested process
>     to use. In case of file descriptors, every level has to figure out
> the process ID of the
>     newly created namespace's init process and open a file descriptor
> to track it.

Toss in a bind mount of the file in some filesystem if that helps.

But if I understand what you are talking about you are talking about
having a shared memory segment shared between processes in different
pid namespaces.

In that shared memory segment for a processes in different namespaces
you are talking about having the conversation structured as having
information structured as pid-namespace pid.

And crucuially you want anyone in any pid namespace to be able to read
that shared memory segment and to make sense of what is going on,
by just reading the pid namespace id.


Namespaces are all about making identifiers relative to their namespace.

The only way I can see you gain an advantage with your shared memory
design is by making identifiers that are not relative to their pid
namespace.   As such identifiers will completely defeat the ability
to implement CRIU support.

The closest I have to such identifiers today are bind mounts of the
namespace files.  So if you also have a common mount namespace you could
use that.


In theory a name in some other namespace is possible.  However anyone in
a container will only be able to see the names in their container or in
nested sub containers.  Which is what you have already with pids.  So I
don't think that will help.

Eric
