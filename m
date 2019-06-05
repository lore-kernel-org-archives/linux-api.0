From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 0/8] Mount, FS, Block and Keyrings notifications [ver
 #2]
Date: Wed, 5 Jun 2019 11:12:21 -0700
Message-ID: <8e1d19ee-d2c0-189e-d70e-5c3daa3a274a@schaufler-ca.com>
References: <50c2ea19-6ae8-1f42-97ef-ba5c95e40475@schaufler-ca.com>
 <155966609977.17449.5624614375035334363.stgit@warthog.procyon.org.uk>
 <CALCETrWzDR=Ap8NQ5-YrVhXCEBgr+hwpjw9fBn0m2NkZzZ7XLQ@mail.gmail.com>
 <20192.1559724094@warthog.procyon.org.uk>
 <e4c19d1b-9827-5949-ecb8-6c3cb4648f58@schaufler-ca.com>
 <CALCETrVSBwHEm-1pgBXxth07PZ0XF6FD+7E25=WbiS7jxUe83A@mail.gmail.com>
 <9a9406ba-eda4-e3ec-2100-9f7cf1d5c130@schaufler-ca.com>
 <15CBE0B8-2797-433B-B9D7-B059FD1B9266@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <15CBE0B8-2797-433B-B9D7-B059FD1B9266@amacapital.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 6/5/2019 10:47 AM, Andy Lutomirski wrote:
>> On Jun 5, 2019, at 10:01 AM, Casey Schaufler <casey@schaufler-ca.com> =
wrote:
>>
>>> On 6/5/2019 9:04 AM, Andy Lutomirski wrote:
>>>> On Wed, Jun 5, 2019 at 7:51 AM Casey Schaufler <casey@schaufler-ca.c=
om> wrote:
>>>>> On 6/5/2019 1:41 AM, David Howells wrote:
>>>>> Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>>
>>>>>> I will try to explain the problem once again. If process A
>>>>>> sends a signal (writes information) to process B the kernel
>>>>>> checks that either process A has the same UID as process B
>>>>>> or that process A has privilege to override that policy.
>>>>>> Process B is passive in this access control decision, while
>>>>>> process A is active. In the event delivery case, process A
>>>>>> does something (e.g. modifies a keyring) that generates an
>>>>>> event, which is then sent to process B's event buffer.
>>>>> I think this might be the core sticking point here.  It looks like =
two
>>>>> different situations:
>>>>>
>>>>> (1) A explicitly sends event to B (eg. signalling, sendmsg, etc.)
>>>>>
>>>>> (2) A implicitly and unknowingly sends event to B as a side effect =
of some
>>>>>     other action (eg. B has a watch for the event A did).
>>>>>
>>>>> The LSM treats them as the same: that is B must have MAC authorisat=
ion to send
>>>>> a message to A.
>>>> YES!
>>>>
>>>> Threat is about what you can do, not what you intend to do.
>>>>
>>>> And it would be really great if you put some thought into what
>>>> a rational model would be for UID based controls, too.
>>>>
>>>>> But there are problems with not sending the event:
>>>>>
>>>>> (1) B's internal state is then corrupt (or, at least, unknowingly i=
nvalid).
>>>> Then B is a badly written program.
>>> Either I'm misunderstanding you or I strongly disagree.
>> A program needs to be aware of the conditions under
>> which it gets event, *including the possibility that
>> it may not get an event that it's not allowed*. Do you
>> regularly write programs that go into corrupt states
>> if an open() fails? Or where read() returns less than
>> the amount of data you ask for?
> I do not regularly write programs that handle read() omitting data in t=
he middle of a TCP stream.  I also don=E2=80=99t write programs that wait=
 for processes to die and need to handle the case where a child is dead, =
waitid() can see it, but SIGCHLD wasn=E2=80=99t sent because =E2=80=9Csec=
urity=E2=80=9D.
>
>>>  If B has
>>> authority to detect a certain action, and A has authority to perform
>>> that action, then refusing to notify B because B is somehow missing
>>> some special authorization to be notified by A is nuts.
>> You are hand-waving the notion of authority. You are assuming
>> that if A can read X and B can read X that A can write B.
> No, read it again please. I=E2=80=99m assuming that if A can *write* X =
and B can read X then A can send information to B.

That is *not* a valid assumption:

	A can write to /dev/null.
	B can read from /dev/null.
	Does not imply B can read what A wrote.
	Does not imply A can send a signal to B.

	A can send a UDP datagram to port 3343
	B can is bound to port 3343
	Does not imply the packet will be delivered


=C2=A0
