From: Andy Lutomirski <luto@amacapital.net>
Subject: Early comments on kdbus v2 (Re: [PATCH 00/12] Add kdbus implementation)
Date: Wed, 5 Nov 2014 07:56:08 -0800
Message-ID: <CALCETrVJHFzyjOjUhAjzsknm1VVnUcDU2i=Ymhpmy8q1Pef8PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Mack <daniel@zonque.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>, Simon McVittie <simon.mcvittie@collabora.co.uk>, "alban.crequy" <alban.crequy@collabora.co.uk>, Javier Martinez Canillas <javier.martinez@collabora.co.uk>, Tom Gundersen <teg@jklm.no>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 5, 2014 at 6:34 AM, Daniel Mack <daniel@zonque.org> wrote:
> On 10/29/2014 11:19 PM, Andy Lutomirski wrote:
>> I think that each piece of trustable metadata needs to be explicitly
>> opted-in to by the sender at the time of capture.  Otherwise you're
>> asking for lots of information leaks and privilege escalations.  This
>> is especially important given that some of the items in the current
>> list could be rather sensitive.
>
> Alright, the above seems to pretty much sum up that end of our
> discussion. To address this, We've now added the following functionality
> for v2:
>
>  * The attach_flags in kdbus_cmd_hello was split into two parts,
>    attach_flags_send and attach_flags_recv, so each peer may chose what
>    exactly it want to transmit or receive.
>
>  * Metadata will only be attached to the final message in the
>    receiver's pool if both the sender's attach_flags_send and the
>    receiver's attach_flags_recv bit are set.
>
>  * Consequently, the existing KDBUS_ITEM_ATTACH_FLAGS item type is
>    split into KDBUS_ITEM_ATTACH_FLAGS_SEND and
>    KDBUS_ITEM_ATTACH_FLAGS_RECV, so that both connection details can be
>    separately updated through KDBUS_CMD_CONN_UPDATE.
>
>  * To allow for use cases that require certain metadata to be attached
>    on each message, we've added a negotiation mechanism to the HELLO
>    ioctl: An optional metadata mask can be passed during the creation
>    of buses, so bus owners may require certain bits in
>    attach_flags_send to be set. That way, the creator of the bus will
>    specify which metadata is required to fulfill the requirements of
>    the specification of the role of the bus.
>
>

Thanks!

Here are some early thoughts based on reading what I think is the v2
documentation online.

My general impression is that the semantics of and use cases for
passing fds around (including through execve) are not well thought
out.  I think that the kdbus designers need to decide whether kdbus
fds will ever be passed between processes (via execve, SCM_RIGHTS, or
kdbus).  If yes, there are several issues:

The docs for metadata and namespaces suggest that passing fds between
namespaces turns off metadata.  I don't want to reopen this particular
discussion until Eric is back, and I don't think that the code matches
the docs, but to me this suggests that no one has really considered
how this case is supposed to behave.

I think that KDBUS_MESSAGE_SEND needs to specify metadata items to
send.  Otherwise you'll introduce security problems the first time you
ever have a process that accepts a kdbus fd from a process that it
should not fully trust.  (Note that this is not just my overly
paranoid imagination.  I've found real security bugs in netlink and
procfs based on this.  And SCM_CREDENTIALS is broken for similar
reasons.)  Also, the userspace libraries will need to be rather
careful about setting those bits.

I don't see a mechanism to prevent resource exhaustion issues in which
many fds are recursively shoved into kdbus.  (You still may need to
address this to some extent if you disallow the transfer of kdbus fds,
but it's probably easier to handle.)


If no:

KDBUS_MESSAGE_SEND should not send metadata items at all, because they
will never be interesting.



What privilege do you need to create a custom endpoint?  What
privilege do you need to set its policy?  Why do custom endpoints have
names at all?



Metadata:

Please justify each and every metadata with an actual use case or
remove it.  The justification should include an explanation of why the
same thing can't be achieved with policy.

Off the top of my head:

 - KDBUS_ATTACH_TIMESTAMP is fine.

 - KDBUS_ATTACH_CREDS should be just uid and gid

 - I tend to think that pid and tid should be separate.  They're
really their own thing, and, as noted in all the perfectly valid
dislike directed at SO_PEERCRED, they have extremely limited value.

 - starttime should have a justification or be removed.

 - KDBUS_ATTACH_AUXGROUPS: I'm not sure what to think about this.  I
feel like it's only useful for implementing strange types of policies.

 - KDBUS_ATTACH_COMM, KDBUS_ATTACH_CMDLINE, and KDBUS_ATTACH_EXE: Just
remove them.  There is no point whatsoever in having the kernel try to
validate comm and cmdline, and exe is barely better [1].  You realize
that there's this thing called PR_SET_NAME, right?  Removing these may
benefit your arguments about the whole metadata mechanism, too --
these three items are wonderful straw men to poke at, because any
concept of trusting them is absurd even ignoring the framework in
which they're used.  But you can't tell people to shut up and stop
attacking straw men, because you've actually proposed these particular
straw men. :)

 - KDBUS_ATTACH_CGROUP: This sounds legitimately useful.

 - KDBUS_ATTACH_SECLABEL: The docs talk about selinux.  What does this
even mean on a non-selinux system?  I tend to think that this
shouldn't exist as a metadata item and that all selinux integration
should go through the LSM hooks.  Otherwise we'll end up with two
separate selinux policy databases -- the normal one and whatever dbus
tries to do, and the result will be even more unwieldy than the
current state of affairs.  Also, turning off selinux enforcing mode
really ought to continue turning it all the way off, and I don't think
that dbus should be allowed to interfere with that.

 - KDBUS_ATTACH_AUDIT: Please define what an audit label is.  I'm
serious: audit doesn't have a great track record for interface
stability.  Please consider disallowing anyone without
CAP_AUDIT_CONTROL from *receiving* this item.  (Also, the docs here
are full of typos.)

Are caps missing from this list?  I swear they're in the code but not
in either version of the docs...  If they're still in the code, I
really don't like it.  The Linux capability system sucks, and to avoid
having that suckage spread, those bits should IMO not gain any new
powers like this.  One of the great things about polkit and dbus is
that you don't *need* caps to ask system software to do things for
you.  This means that you can, for example, have the ability to ask
for a graceful reboot but not to call reboot(2).  This is a good
thing, and actually using caps as a metadata item risks undoing that.
(Also, keep in mind that actually granting caps to uid != 0 processes
is a royal PITA, and every attempt to fix it gets shot down.
Furthermore, since I fully expect Eric to eventually nak you hard
enough that you get kdbus namespacing to work well, I think you'll
find that namespacing caps will be even less pleasant that the rest of
it.)

[1] I say that exe is barely better than comm because of two factors.
The first is ptrace.  The second is that, if you fix namespacing,
you'll have a high probability of getting mostly-attacker-controlled
garbage out of it.  (It will be 100% garbage, and attackers will have
lots of influence on that garbage.)

--Andy
