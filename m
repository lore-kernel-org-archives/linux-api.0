From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC][PATCH 0/8] Mount, FS, Block and Keyrings notifications [ver #2]
Date: Wed, 5 Jun 2019 10:47:43 -0700
Message-ID: <15CBE0B8-2797-433B-B9D7-B059FD1B9266@amacapital.net>
References: <50c2ea19-6ae8-1f42-97ef-ba5c95e40475@schaufler-ca.com> <155966609977.17449.5624614375035334363.stgit@warthog.procyon.org.uk> <CALCETrWzDR=Ap8NQ5-YrVhXCEBgr+hwpjw9fBn0m2NkZzZ7XLQ@mail.gmail.com> <20192.1559724094@warthog.procyon.org.uk> <e4c19d1b-9827-5949-ecb8-6c3cb4648f58@schaufler-ca.com> <CALCETrVSBwHEm-1pgBXxth07PZ0XF6FD+7E25=WbiS7jxUe83A@mail.gmail.com> <9a9406ba-eda4-e3ec-2100-9f7cf1d5c130@schaufler-ca.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9a9406ba-eda4-e3ec-2100-9f7cf1d5c130@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


> On Jun 5, 2019, at 10:01 AM, Casey Schaufler <casey@schaufler-ca.com> wrot=
e:
>=20
>> On 6/5/2019 9:04 AM, Andy Lutomirski wrote:
>>> On Wed, Jun 5, 2019 at 7:51 AM Casey Schaufler <casey@schaufler-ca.com> w=
rote:
>>>> On 6/5/2019 1:41 AM, David Howells wrote:
>>>> Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>=20
>>>>> I will try to explain the problem once again. If process A
>>>>> sends a signal (writes information) to process B the kernel
>>>>> checks that either process A has the same UID as process B
>>>>> or that process A has privilege to override that policy.
>>>>> Process B is passive in this access control decision, while
>>>>> process A is active. In the event delivery case, process A
>>>>> does something (e.g. modifies a keyring) that generates an
>>>>> event, which is then sent to process B's event buffer.
>>>> I think this might be the core sticking point here.  It looks like two
>>>> different situations:
>>>>=20
>>>> (1) A explicitly sends event to B (eg. signalling, sendmsg, etc.)
>>>>=20
>>>> (2) A implicitly and unknowingly sends event to B as a side effect of s=
ome
>>>>     other action (eg. B has a watch for the event A did).
>>>>=20
>>>> The LSM treats them as the same: that is B must have MAC authorisation t=
o send
>>>> a message to A.
>>> YES!
>>>=20
>>> Threat is about what you can do, not what you intend to do.
>>>=20
>>> And it would be really great if you put some thought into what
>>> a rational model would be for UID based controls, too.
>>>=20
>>>> But there are problems with not sending the event:
>>>>=20
>>>> (1) B's internal state is then corrupt (or, at least, unknowingly inval=
id).
>>> Then B is a badly written program.
>> Either I'm misunderstanding you or I strongly disagree.
>=20
> A program needs to be aware of the conditions under
> which it gets event, *including the possibility that
> it may not get an event that it's not allowed*. Do you
> regularly write programs that go into corrupt states
> if an open() fails? Or where read() returns less than
> the amount of data you ask for?

I do not regularly write programs that handle read() omitting data in the mi=
ddle of a TCP stream.  I also don=E2=80=99t write programs that wait for pro=
cesses to die and need to handle the case where a child is dead, waitid() ca=
n see it, but SIGCHLD wasn=E2=80=99t sent because =E2=80=9Csecurity=E2=80=9D=
.

>=20
>>  If B has
>> authority to detect a certain action, and A has authority to perform
>> that action, then refusing to notify B because B is somehow missing
>> some special authorization to be notified by A is nuts.
>=20
> You are hand-waving the notion of authority. You are assuming
> that if A can read X and B can read X that A can write B.

No, read it again please. I=E2=80=99m assuming that if A can *write* X and B=
 can read X then A can send information to B.
