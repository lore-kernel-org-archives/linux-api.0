From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/7] vfs: Add a mount-notification facility
Date: Wed, 29 May 2019 16:56:47 -0700
Message-ID: <35a3b0f9-f227-2cd7-eb87-9b3d5816c67d@schaufler-ca.com>
References: <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905933492.7587.6968545866041839538.stgit@warthog.procyon.org.uk>
 <14347.1559127657@warthog.procyon.org.uk>
 <312a138c-e5b2-4bfb-b50b-40c82c55773f@schaufler-ca.com>
 <4552118F-BE9B-4905-BF0F-A53DC13D5A82@amacapital.net>
 <058f227c-71ab-a6f4-00bf-b8782b3b2956@schaufler-ca.com>
 <2FF92095-E5B1-4811-A7F8-B7D4C32F86DD@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2FF92095-E5B1-4811-A7F8-B7D4C32F86DD@amacapital.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 5/29/2019 4:12 PM, Andy Lutomirski wrote:
>
>> On May 29, 2019, at 10:46 AM, Casey Schaufler <casey@schaufler-ca.com>=
 wrote:
>>
>>> On 5/29/2019 10:13 AM, Andy Lutomirski wrote:
>>>
>>>>> On May 29, 2019, at 8:53 AM, Casey Schaufler <casey@schaufler-ca.co=
m> wrote:
>>>>>
>>>>> On 5/29/2019 4:00 AM, David Howells wrote:
>>>>> Jann Horn <jannh@google.com> wrote:
>>>>>
>>>>>>> +void post_mount_notification(struct mount *changed,
>>>>>>> +                            struct mount_notification *notify)
>>>>>>> +{
>>>>>>> +       const struct cred *cred =3D current_cred();
>>>>>> This current_cred() looks bogus to me. Can't mount topology change=
s
>>>>>> come from all sorts of places? For example, umount_mnt() from
>>>>>> umount_tree() from dissolve_on_fput() from __fput(), which could
>>>>>> happen pretty much anywhere depending on where the last reference =
gets
>>>>>> dropped?
>>>>> IIRC, that's what Casey argued is the right thing to do from a secu=
rity PoV.
>>>>> Casey?
>>>> You need to identify the credential of the subject that triggered
>>>> the event. If it isn't current_cred(), the cred needs to be passed
>>>> in to post_mount_notification(), or derived by some other means.
>>> Taking a step back, why do we care who triggered the event?  It seems=
 to me that we should care whether the event happened and whether the *re=
ceiver* is permitted to know that.
>> There are two filesystems, "dot" and "dash". I am not allowed
>> to communicate with Fred on the system, and all precautions have
>> been taken to ensure I cannot. Fred asks for notifications on
>> all mount activity. I perform actions that result in notifications
>> on "dot" and "dash". Fred receives notifications and interprets
>> them using Morse code. This is not OK. If Wilma, who *is* allowed
>> to communicate with Fred, does the same actions, he should be
>> allowed to get the messages via Morse.
> Under this scenario, Fred should not be allowed to enable these watches=
=2E If you give yourself and Fred unconstrained access to the same FS, th=
en can communicate.

How are you going to determine at the time Fred tries to enable the watch=
es
that I am going to do something that will trigger them? I'm not saying it=
 isn't
possible, I'm curious how you would propose doing it. If you deny Fred th=
e ability
to set watches because it is possible for me to trigger them, he can't us=
e them
to get information from Wilma, either.

>
>> Other security modelers may disagree. The models they produce
>> are going to be *very* complicated and will introduce agents and
>> intermediate objects to justify Fred's reception of an event as
>> a read operation.
> I disagree. They=E2=80=99ll model the watch as something to prevent if =
they want to restrict communication.

Sorry, but that isn't sufficiently detailed to be meaningful.

>>> (And receiver means whoever subscribed, presumably, not whoever calle=
d read() or mmap().)
>> The receiver is the process that gets the event. There may
>> be more than one receiver, and the receivers may have different
>> credentials. Each needs to be checked separately.
> I think it=E2=80=99s a bit crazy to have the same event queue with two =
readers who read different things.

Look at killpg(3).

The process that creates the event has to be involved in the
access decision. Otherwise you have an uncontrolled data channel.
When the receiver reads the event queue it knows nothing about the
sender, and hence cannot make the decision unless the credential of
the sender is kept with the event message, and used when the
receiver tries to access it. I don't think that wold work well with
the mechanism as designed.
=C2=A0
