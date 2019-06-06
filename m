From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 00/10] Mount, FS, Block and Keyrings notifications
 [ver #3]
Date: Thu, 6 Jun 2019 11:56:07 -0700
Message-ID: <07e92045-2d80-8573-4d36-643deeaff9ec@schaufler-ca.com>
References: <b91710d8-cd2d-6b93-8619-130b9d15983d@tycho.nsa.gov>
 <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk>
 <3813.1559827003@warthog.procyon.org.uk>
 <8382af23-548c-f162-0e82-11e308049735@tycho.nsa.gov>
 <0eb007c5-b4a0-9384-d915-37b0e5a158bf@schaufler-ca.com>
 <c82052e5-ca11-67b5-965e-8f828081f31c@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c82052e5-ca11-67b5-965e-8f828081f31c@tycho.nsa.gov>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>, David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Moore <paul@paul-moore.com>, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 6/6/2019 10:16 AM, Stephen Smalley wrote:
> On 6/6/19 12:43 PM, Casey Schaufler wrote:
>> ...
>> I don't agree. That is, I don't believe it is sufficient.
>> There is no guarantee that being able to set a watch on an
>> object implies that every process that can trigger the event
>> can send it to you.
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0Watcher has Smack label W
>> =C2=A0=C2=A0=C2=A0=C2=A0Triggerer has Smack label T
>> =C2=A0=C2=A0=C2=A0=C2=A0Watched object has Smack label O
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0Relevant Smack rules are
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0W O rw
>> =C2=A0=C2=A0=C2=A0=C2=A0T O rw
>>
>> The watcher will be able to set the watch,
>> the triggerer will be able to trigger the event,
>> but there is nothing that would allow the watcher
>> to receive the event. This is not a case of watcher
>> reading the watched object, as the event is delivered
>> without any action by watcher.
>
> You are allowing arbitrary information flow between T and W above.=C2=A0=
 Who cares about notifications?

I do. If Watched object is /dev/null no data flow is possible.
There are many objects on a modern Linux system for which this
is true. Even if it's "just a file" the existence of one path
for data to flow does not justify ignoring the rules for other
data paths.

>
> How is it different from W and T mapping the same file as a shared mapp=
ing and communicating by reading and writing the shared memory?=C2=A0 You=
 aren't performing a permission check directly between W and T there.

In this case there is one object O, two subjects, W and T and two accesse=
s.

	W open O
	T open O

They fiddle about with the data in O.

In the event case, there are two objects, O and W, two subjects W and T, =
and
three accesses.

	W watch O
	T trigger O
	T write-event W

You can't wave away the flow of data. Different objects are involved.

An analogy is that two processes with different UIDs can open a file,
but still can't signal each other. Different mechanisms have different
policies. I'm not saying that's good, but it's the context we're in.
