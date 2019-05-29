From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/7] vfs: Add a mount-notification facility
Date: Wed, 29 May 2019 13:50:00 -0700
Message-ID: <1f09b97e-9533-dc27-2524-ca0a4c9d4664@schaufler-ca.com>
References: <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905933492.7587.6968545866041839538.stgit@warthog.procyon.org.uk>
 <14347.1559127657@warthog.procyon.org.uk>
 <312a138c-e5b2-4bfb-b50b-40c82c55773f@schaufler-ca.com>
 <4552118F-BE9B-4905-BF0F-A53DC13D5A82@amacapital.net>
 <058f227c-71ab-a6f4-00bf-b8782b3b2956@schaufler-ca.com>
 <CAG48ez2S+i2wxpWXVGpEAprgY9gtjxyejLfbZtrqu5YOkQ81Nw@mail.gmail.com>
 <0cd823ca-4733-19ef-c13e-ed5ac8c63a0f@schaufler-ca.com>
 <CAG48ez0X7rKw-qfZm9i+8OLq7YccBRtV3aF-7hkQsfWaiTbuXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0X7rKw-qfZm9i+8OLq7YccBRtV3aF-7hkQsfWaiTbuXg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 5/29/2019 12:47 PM, Jann Horn wrote:
> On Wed, May 29, 2019 at 9:28 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>> On 5/29/2019 11:11 AM, Jann Horn wrote:
>>> On Wed, May 29, 2019 at 7:46 PM Casey Schaufler <casey@schaufler-ca.c=
om> wrote:
>>>> On 5/29/2019 10:13 AM, Andy Lutomirski wrote:
>>>>>> On May 29, 2019, at 8:53 AM, Casey Schaufler <casey@schaufler-ca.c=
om> wrote:
>>>>>>> On 5/29/2019 4:00 AM, David Howells wrote:
>>>>>>> Jann Horn <jannh@google.com> wrote:
>>>>>>>
>>>>>>>>> +void post_mount_notification(struct mount *changed,
>>>>>>>>> +                            struct mount_notification *notify)=

>>>>>>>>> +{
>>>>>>>>> +       const struct cred *cred =3D current_cred();
>>>>>>>> This current_cred() looks bogus to me. Can't mount topology chan=
ges
>>>>>>>> come from all sorts of places? For example, umount_mnt() from
>>>>>>>> umount_tree() from dissolve_on_fput() from __fput(), which could=

>>>>>>>> happen pretty much anywhere depending on where the last referenc=
e gets
>>>>>>>> dropped?
>>>>>>> IIRC, that's what Casey argued is the right thing to do from a se=
curity PoV.
>>>>>>> Casey?
>>>>>> You need to identify the credential of the subject that triggered
>>>>>> the event. If it isn't current_cred(), the cred needs to be passed=

>>>>>> in to post_mount_notification(), or derived by some other means.
>>>>> Taking a step back, why do we care who triggered the event?  It see=
ms to me that we should care whether the event happened and whether the *=
receiver* is permitted to know that.
>>>> There are two filesystems, "dot" and "dash". I am not allowed
>>>> to communicate with Fred on the system, and all precautions have
>>>> been taken to ensure I cannot. Fred asks for notifications on
>>>> all mount activity. I perform actions that result in notifications
>>>> on "dot" and "dash". Fred receives notifications and interprets
>>>> them using Morse code. This is not OK. If Wilma, who *is* allowed
>>>> to communicate with Fred, does the same actions, he should be
>>>> allowed to get the messages via Morse.
>>> In other words, a classic covert channel. You can't really prevent tw=
o
>>> cooperating processes from communicating through a covert channel on =
a
>>> modern computer.
>> That doesn't give you permission to design them in.
>> Plus, the LSMs that implement mandatory access controls
>> are going to want to intervene. No unclassified user
>> should see notifications caused by Top Secret users.
> But that's probably because they're worried about *side* channels, not
> covert channels?

The security evaluators from the 1990's considered any channel
with greater than 1 bit/second bandwidth a show-stopper. That was
true for covert and side channels. Further, if you knew that a
mechanism had a channel, as this one does, and you didn't fix it,
you didn't get your certificate. If you know about a problem
during the design/implementation phase it's really inexcusable not
to fix it before "completing" the code.

> Talking about this in the context of (small) side channels: The
> notification types introduced in this patch are mostly things that a
> user would be able to observe anyway if they polled /proc/self/mounts,
> right?

It's supposed to be a general mechanism. Of course it would
be simpler if is was restricted to things you can get at via
/proc/self.

>  It might make sense to align access controls based on that - if
> you don't want it to be possible to observe events happening on some
> mount points through this API, you should probably lock down
> /proc/*/mounts equivalently, by introducing an LSM hook for "is @cred
> allowed to see @mnt" or something like that - and if you want to
> compare two cred structures, you could record the cred structure that
> is responsible for the creation of the mount point, or something like
> that.

I'm not going to argue against that.

> For some of the other patches, I guess things get more tricky because
> the notification exposes new information that wasn't really available
> before.

We have to look not just at the information being available,
but the mechanism used. Being able to look at information about
a process in /proc doesn't mean I should be able to look at it
using ptrace(). Access control isn't done on data, it's done on
objects. That I can get information by looking in one object provides
no assurance that I can get it through a different object containing
the same information. This happens in /dev all over the place. A
file with hard links may be accessible by one path but not another.

>
>>>  You can transmit information through the scheduler,
>>> through hyperthread resource sharing, through CPU data caches, throug=
h
>>> disk contention, through page cache state, through RAM contention, an=
d
>>> probably dozens of other ways that I can't think of right now.
>> Yeah, and there's been a lot of activity to reduce those,
>> which are hard to exploit, as opposed to this, which would
>> be trivial and obvious.
>>
>>> There
>>> have been plenty of papers that demonstrated things like an SSH
>>> connection between two virtual machines without network access runnin=
g
>>> on the same physical host (<https://gruss.cc/files/hello.pdf>),
>>> communication between a VM and a browser running on the host system,
>>> and so on.
>> So you're saying we shouldn't have mode bits on files because
>> spectre/meltdown makes them pointless?
> spectre/meltdown are vulnerabilities that are being mitigated.
> Microarchitectural covert channels are an accepted fact and I haven't
> heard of anyone seriously considering trying to get rid of them all.
