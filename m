From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 0/8] Mount, FS, Block and Keyrings notifications [ver
 #2]
Date: Tue, 4 Jun 2019 15:03:12 -0700
Message-ID: <7645e662-8053-aeb4-ec79-57aa0bab4932@schaufler-ca.com>
References: <155966609977.17449.5624614375035334363.stgit@warthog.procyon.org.uk>
 <CALCETrWzDR=Ap8NQ5-YrVhXCEBgr+hwpjw9fBn0m2NkZzZ7XLQ@mail.gmail.com>
 <50c2ea19-6ae8-1f42-97ef-ba5c95e40475@schaufler-ca.com>
 <CALCETrWFBA8H0RiZPikLtEi8xg-cqJLtQgnU2CGTuwByrHN7Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWFBA8H0RiZPikLtEi8xg-cqJLtQgnU2CGTuwByrHN7Dw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 6/4/2019 2:05 PM, Andy Lutomirski wrote:
> On Tue, Jun 4, 2019 at 1:31 PM Casey Schaufler <casey@schaufler-ca.com>=
 wrote:
>> n 6/4/2019 10:43 AM, Andy Lutomirski wrote:
>>> On Tue, Jun 4, 2019 at 9:35 AM David Howells <dhowells@redhat.com> wr=
ote:
>>>> Hi Al,
>>>>
>>>> Here's a set of patches to add a general variable-length notificatio=
n queue
>>>> concept and to add sources of events for:
>>> I asked before and didn't see a response, so I'll ask again.  Why are=

>>> you paying any attention at all to the creds that generate an event?
>>> It seems like the resulting security model will be vary hard to
>>> understand and probably buggy.  Can't you define a sensible model in
>>> which only the listener creds matter?
>> We've spent the last 18 months reeling from the implications
>> of what can happen when one process has the ability to snoop
>> on another. Introducing yet another mechanism that is trivial
>> to exploit is a very bad idea.
> If you're talking about Spectre, etc, this is IMO entirely irrelevant.

We're seeing significant interest in using obscure mechanisms
in system exploits. Mechanisms will be exploited.

> Among other things, setting these watches can and should require some
> degree of privilege.

Requiring privilege would address the concerns for most
situations, although I don't see that it would help for
SELinux. SELinux does not generally put much credence in
what others consider "privilege".

Extreme care would probably be required for namespaces, too.

>
>> I will try to explain the problem once again. If process A
>> sends a signal (writes information) to process B the kernel
>> checks that either process A has the same UID as process B
>> or that process A has privilege to override that policy.
>> Process B is passive in this access control decision, while
>> process A is active.
> Are you stating what you see to be a requirement?

Basic subject/object access control is the core of
the Linux security model. Yes, there are exceptions,
but mostly they're historical in origin.


>> Process A must have write access
>> (defined by some policy) to process B's event buffer.
> No, stop right here.

Listening ...

>   Process B is monitoring some aspect of the
> system.

Process B is not "monitoring". At some point in the past it
has registered a request for information should an event occur.
It is currently passive.

> Process A is doing something.

Yes. It is active.'

> Process B should need
> permission to monitor whatever it's monitoring,

OK, I'm good with that. But the only time you
can tell that is when the event is registered,
and at that time you can't tell who might be causing
the event. (Or can you?)

> and process A should
> have permission to do whatever it's doing.

So there needs to be some connection between what B
can request events for and what events A can cause.
Then you can deny B's requests because of A.

>   I don't think it makes
> sense to try to ascribe an identity to the actor doing some action to
> decide to omit it from the watch -- this has all kinds of correctness
> issues.

It works for signals and UDP, but in general I get the concern.

> If you're writing a policy and you don't like letting process B spy on
> processes doing various things, then disallow that type of spying.

That gets you into a situation where you can't do the legitimate
monitoring you want to do just because there's the off chance you
might see something you shouldn't. "I hate security! It's confusing,
and always gets in the way!"

>> To
>> implement such a policy requires A's credential,
> You may not design a new mechanism that looks at the credential in a
> context where looking at a credential is invalid unless you have some
> very strong justification for why all of the known reasons that it's a
> bad idea don't apply to what you're doing.

Point. But you also don't get to ignore basic security policy
just because someone's spiffy lazy memory free cache hashing
tree (or similar mechanism) throws away references to important
information while it's still needed.

> So, without a much stronger justification, NAK.

I try to be reasonable. Really. All I want is something
with a security model that can be explained coherently=20
within the context of the basic Linux security model.
There are enough variations as it is.
