From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 00/13] Mount, FS, Block and Keyrings notifications
 [ver #4]
Date: Mon, 10 Jun 2019 14:25:27 -0700
Message-ID: <25d88489-9850-f092-205e-0a4fc292f41b@schaufler-ca.com>
References: <155991702981.15579.6007568669839441045.stgit@warthog.procyon.org.uk>
 <be966d9c-e38d-7a30-8d80-fad5f25ab230@tycho.nsa.gov>
 <0cf7a49d-85f6-fba9-62ec-a378e0b76adf@schaufler-ca.com>
 <CALCETrX5O18q2=dUeC=hEtK2=t5KQpGBy9XveHxFw36OqkbNOg@mail.gmail.com>
 <dac74580-5b48-86e4-8222-cac29a9f541d@schaufler-ca.com>
 <E0925E1F-E5F2-4457-8704-47B6E64FE3F3@amacapital.net>
 <4b7d02b2-2434-8a7c-66cc-7dbebc37efbc@schaufler-ca.com>
 <CALCETrU+PKVbrKQJoXj9x_5y+vTZENMczHqyM_Xb85ca5YDZuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrU+PKVbrKQJoXj9x_5y+vTZENMczHqyM_Xb85ca5YDZuA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, USB list <linux-usb@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Paul Moore <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org

On 6/10/2019 12:53 PM, Andy Lutomirski wrote:
> On Mon, Jun 10, 2019 at 12:34 PM Casey Schaufler <casey@schaufler-ca.co=
m> wrote:
>>>>> I think you really need to give an example of a coherent policy tha=
t
>>>>> needs this.
>>>> I keep telling you, and you keep ignoring what I say.
>>>>
>>>>>  As it stands, your analogy seems confusing.
>>>> It's pretty simple. I have given both the abstract
>>>> and examples.
>>> You gave the /dev/null example, which is inapplicable to this patchse=
t.
>> That addressed an explicit objection, and pointed out
>> an exception to a generality you had asserted, which was
>> not true. It's also a red herring regarding the current
>> discussion.
> This argument is pointless.
>
> Please humor me and just give me an example.  If you think you have
> already done so, feel free to repeat yourself.  If you have no
> example, then please just say so.

To repeat the /dev/null example:

Process A and process B both open /dev/null.
A and B can write and read to their hearts content
to/from /dev/null without ever once communicating.
The mutual accessibility of /dev/null in no way implies that
A and B can communicate. If A can set a watch on /dev/null,
and B triggers an event, there still has to be an access
check on the delivery of the event because delivering an event
to A is not an action on /dev/null, but on A.


>
>>>>>  If someone
>>>>> changes the system clock, we don't restrict who is allowed to be
>>>>> notified (via, for example, TFD_TIMER_CANCEL_ON_SET) that the clock=

>>>>> was changed based on who changed the clock.
>>>> That's right. The system clock is not an object that
>>>> unprivileged processes can modify. In fact, it is not
>>>> an object at all. If you care to look, you will see that
>>>> Smack does nothing with the clock.
>>> And this is different from the mount tree how?
>> The mount tree can be modified by unprivileged users.
>> If nothing that unprivileged users can do to the mount
>> tree can trigger a notification you are correct, the
>> mount tree is very like the system clock. Is that the
>> case?
> The mount tree can't be modified by unprivileged users, unless a
> privileged user very carefully configured it as such.

"Unless" means *is* possible. In which case access control is
required. I will admit to being less then expert on the extent
to which mounts can be done without privilege.

>   An unprivileged
> user can create a new userns and a new mount ns, but then they're
> modifying a whole different mount tree.

Within those namespaces you can still have multiple users,
constrained be system access control policy.

>
>>>>>  Similarly, if someone
>>>>> tries to receive a packet on a socket, we check whether they have t=
he
>>>>> right to receive on that socket (from the endpoint in question) and=
,
>>>>> if the sender is local, whether the sender can send to that socket.=

>>>>> We do not check whether the sender can send to the receiver.
>>>> Bzzzt! Smack sure does.
>>> This seems dubious. I=E2=80=99m still trying to get you to explain to=
 a non-Smack person why this makes sense.
>> Process A sends a packet to process B.
>> If A has access to TopSecret data and B is not
>> allowed to see TopSecret data, the delivery should
>> be prevented. Is that nonsensical?
> It makes sense.  As I see it, the way that a sensible policy should do
> this is by making sure that there are no sockets, pipes, etc that
> Process A can write and that Process B can read.

You can't explain UDP controls without doing the access check
on packet delivery. The sendmsg() succeeds when the packet leaves
the sender. There doesn't even have to be a socket bound to the
port. The only opportunity you have for control is on packet
delivery, which is the only point at which you can have the
information required.

> If you really want to prevent a malicious process with TopSecret data
> from sending it to a different process, then you can't use Linux on
> x86 or ARM.  Maybe that will be fixed some day, but you're going to
> need to use an extremely tight sandbox to make this work.

I won't be commenting on that.

>
>>>>> The signal example is inapplicable.
>>>> From a modeling viewpoint the actions are identical.
>>> This seems incorrect to me
>> What would be correct then? Some convoluted combination
>> of system entities that aren't owned or controlled by
>> any mechanism?
>>
> POSIX signal restrictions aren't there to prevent two processes from
> communicating.  They're there to prevent the sender from manipulating
> or crashing the receiver without appropriate privilege.

POSIX signal restrictions have a long history. In the P10031e/2c
debates both communication and manipulation where seriously
considered. I would say both are true.

>>>  and, I think, to most everyone else reading this.
>> That's quite the assertion. You may even be correct.
>>
>>>  Can you explain?
>>>
>>> In SELinux-ese, when you write to a file, the subject is the writer a=
nd the object is the file.  When you send a signal to a process, the obje=
ct is the target process.
>> YES!!!!!!!!!!!!
>>
>> And when a process triggers a notification it is the subject
>> and the watching process is the object!
>>
>> Subject =3D=3D active entity
>> Object  =3D=3D passive entity
>>
>> Triggering an event is, like calling kill(), an action!
>>
> And here is where I disagree with your interpretation.  Triggering an
> event is a side effect of writing to the file.  There are *two*
> security relevant actions, not one, and they are:
>
> First, the write:
>
> Subject =3D=3D the writer
> Action =3D=3D write
> Object =3D=3D the file
>
> Then the event, which could be modeled in a couple of ways:
>
> Subject =3D=3D the file

Files   are   not   subjects. They are passive entities.

> Action =3D=3D notify
> Object =3D=3D the recipient
>
> or
>
> Subject =3D=3D the recipient
> Action =3D=3D watch
> Object =3D=3D the file
>
> By conflating these two actions into one, you've made the modeling
> very hard, and you start running into all these nasty questions like
> "who actually closed this open file"

No, I've made the code more difficult. You can not call
the file a subject. That is just wrong. It's not a valid
model.
