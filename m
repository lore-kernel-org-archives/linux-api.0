From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC][PATCH 00/10] Mount, FS, Block and Keyrings notifications [ver #3]
Date: Thu, 6 Jun 2019 11:51:01 -0700
Message-ID: <E7472FA4-886E-4325-87EA-9812D08CC2D3@amacapital.net>
References: <b91710d8-cd2d-6b93-8619-130b9d15983d@tycho.nsa.gov> <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk> <3813.1559827003@warthog.procyon.org.uk> <8382af23-548c-f162-0e82-11e308049735@tycho.nsa.gov> <0eb007c5-b4a0-9384-d915-37b0e5a158bf@schaufler-ca.com> <CALCETrWn_C8oReKXGMXiJDOGoYWMs+jg2DWa5ZipKAceyXkx5w@mail.gmail.com> <7afe1a85-bf19-b5b4-fdf3-69d9be475dab@schaufler-ca.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7afe1a85-bf19-b5b4-fdf3-69d9be475dab@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andy Lutomirski <luto@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Paul Moore <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org



> On Jun 6, 2019, at 11:33 AM, Casey Schaufler <casey@schaufler-ca.com> wrot=
e:
>=20
>> On 6/6/2019 10:11 AM, Andy Lutomirski wrote:
>>> On Thu, Jun 6, 2019 at 9:43 AM Casey Schaufler <casey@schaufler-ca.com> w=
rote:
>>> ...
>>> I don't agree. That is, I don't believe it is sufficient.
>>> There is no guarantee that being able to set a watch on an
>>> object implies that every process that can trigger the event
>>> can send it to you.
>>>=20
>>>        Watcher has Smack label W
>>>        Triggerer has Smack label T
>>>        Watched object has Smack label O
>>>=20
>>>        Relevant Smack rules are
>>>=20
>>>        W O rw
>>>        T O rw
>>>=20
>>> The watcher will be able to set the watch,
>>> the triggerer will be able to trigger the event,
>>> but there is nothing that would allow the watcher
>>> to receive the event. This is not a case of watcher
>>> reading the watched object, as the event is delivered
>>> without any action by watcher.
>> I think this is an example of a bogus policy that should not be
>> supported by the kernel.
>=20
> At this point it's pretty hard for me to care much what
> you think. You don't seem to have any insight into the
> implications of the features you're advocating, or their
> potential consequences.
>=20
>=20

Can you try to spell it out, then?  A mostly or fully worked out example mig=
ht help.

As Stephen said, it looks like you are considering cases where there is alre=
ady a full communication channel between two processes, and you=E2=80=99re c=
oncerned that this new mechanism might add a side channel too.  If this is w=
rong, can you explain how?=
