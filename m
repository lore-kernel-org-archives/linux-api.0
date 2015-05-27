From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2 0/7] Smack namespace
Date: Wed, 27 May 2015 10:12:33 -0500
Message-ID: <87vbfeqcke.fsf@x220.int.ebiederm.org>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
	<1432557162-19123-1-git-send-email-l.pawelczyk@samsung.com>
	<87h9qyww4h.fsf@x220.int.ebiederm.org>
	<1432721610.1784.27.camel@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1432721610.1784.27.camel@samsung.com> (Lukasz Pawelczyk's
	message of "Wed, 27 May 2015 12:13:30 +0200")
Sender: linux-doc-owner@vger.kernel.org
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, "David S. Miller" <davem@davemloft.net>, "Kirill A. Shutemov" <kirill@shutemov.name>, "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, David Howells <dhowells@redhat.com>, Fabian Frederick <fabf@skynet.be>, Greg KH <gregkh@linuxfoundation.org>, James Morris <james.l.morris@oracle.com>, Jeff Layton <jlayton@primarydata.com>, Jingoo Han <jg1.han@samsung.com>, Joe Perches <joe@perches.com>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Miklos Szeredi <miklos@szeredi.hu>, Oleg Nesterov <oleg@redhat.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa>
List-Id: linux-api@vger.kernel.org

Lukasz Pawelczyk <l.pawelczyk@samsung.com> writes:

> On wto, 2015-05-26 at 22:13 -0500, Eric W. Biederman wrote:
>> Lukasz Pawelczyk <l.pawelczyk@samsung.com> writes:
>> 
>> > Hello,
>> >
>> > Some time ago I sent a Smack namespace documentation and a preliminary
>> > LSM namespace for RFC. I've been suggested that there shouldn't be a
>> > separate LSM namespace and that it should live within user namespace.
>> > And this version does. This is a complete set of patches required for
>> > Smack namespace.
>> >
>> > This was designed with a collaboration of Smack maintainer Casey
>> > Schaufler.
>> >
>> > Smack namespace have been implemented using user namespace hooks added
>> > by one of the patches. To put some context to it I paste here a
>> > documentation on what Smack namespace wants to achieve.
>> >
>> > LSM hooks themselves are documented in the security.h file inside the
>> > patch.
>> >
>> > The patches are based on:
>> > https://github.com/cschaufler/smack-next/tree/smack-for-4.2-stacked
>> >
>> > The tree with them is avaiable here:
>> > https://github.com/Havner/smack-namespace/tree/smack-namespace-for-4.2-stacked-v2
>> >
>> > Changes from v1:
>> >  - "kernel/exit.c: make sure current's nsproxy != NULL while checking
>> >    caps" patch has been dropped
>> >  - fixed the title of the user_ns operations patch
>> 
>> A have not completed a review I don't understand smack well enough to
>> answer some questions but I don't think I like the approach this patch
>> takes to get things done.
>> 
>> I am flattered that you are using a mapping as I did with uid map and
>> gid map.  Unfortunately I do not believe your mapping achieves what my
>> mapping of uids and gids achieved.
>> 
>> A technical goal is to give people the tools so that a sysadmin can set
>> up a system, can grant people subids and subgids, and then the user can
>> proceed to do what they need to do. 
>
> This is exactly the case with Smack namespace.
>
>
>> In particular there should be
>> little to no need to keep pestering the system administrator for more
>> identifiers.
>
> This all depends on the use case. When you create a new namespace for a
> particular purpose you could know what labels will be required there and
> map them upfront. Adding new mappings is for a use case that a container
> might have new software installed that requires new labels for it. You
> don't create/import new labels on a normal basis all the time.

Good.

>> The flip side of that was that the mapping would ensure all of the
>> existing permissions checks would work as expected, and the checks in
>> the kernel could be converted without much trouble.
>
> Again, this is exactly the case with Smack namespace. There are
> additional checks in place of course, but the rules are clear about
> how that works.
>
>
>> Ranges of ids were choosen because they allow for a lot of possible ways
>> of using uids and gids in containers, are comparitively easy to
>> administer, are very fast to use, and don't need large data structures.
>
> This is Smack specific. The same way we could compare Smack with DAC
> (even without talking about namespaces). Every new UID is just it, a
> number. Every new label requires allocation and adds to the list.
>
> I had an idea about mapping ranges of labels for a container by using
> prefixes but this was dropped by Casey. Labels (with an exception of the
> built-in ones) should not have any special meaning. This is Smack
> design.

Maybe.  All I care about is the resources for user namespaces remain
something that the administrator can set up (before any containers
exist) a set of resources (uid, gids, labels?) that an individual user
can use and then that user can set up containers as they desire.

That is the property that the administration of the container is fully
delegated to the whoever creates the container.

> About performance, as it was originally with Smack. The list of labels
> was a simple list. When the performance was not enough hashing was
> added. I'd take the same approach here. If some use cases will require
> so many mappings that this becomes a problem we will deal with it. I
> don't want to complicate the patches now and I this was Casey's opinion
> as well.

Occassionally performance implications are sufficiently profound that
it impacts your userspace API, and thus all future maintenance.  How
labels are managed and mapped into a container appears to be one such
issue.  So unfortunately it does not appear to shove performance
questions off until later.

And actually it is much more about managability rather than raw
performance.

What I know is that the human factors of how these identifiers are
assigned and managed is important.  Especially as they are persistent on
disk and likely need to be kept consistent between multiple different
machines.

A range of uids, a prefix on a label, those kinds of things are simple
and easy to understand and make sense of.  The rule is simple enough I
can track it in my head and I don't need to keep going back and looking
at configuration files.   Discrete unrelated assignment of values
(unless the set of values is very small) does not work that way and
makes things less managable.

Which leads to my observation that if the mapping rule is simple enough
I can keep track of it in my head I can put a small array in struct
user_namespace to implement that rule.

>> With a discreet mapping of labels I have the premonition that we now
>> have a large data structure that, is not as flexible in to use,
>> is comparatively slow and appears to require an interaction with the
>> system administrator for every label you use in a container.
>
> Again, DAC vs Smack philosophy. The same way a new label appears in init
> namespace (e.g. with a file/inode). Without a new rule you won't have an
> access to it. This requires administrator intervention as well. This is
> MAC after all.

If it does not work with how user namespaces are designed to be used
this approach gets my nack.  I will not accept an approach that requires
asking a system administrator permission for every little change.  That
fundamentally is what the user namespace gets away from.

If on the other hand the sysadmin interaction becomes here are N labels
do what you need to with them.  Where N is sufficiently large that most
users can be given those N labels and then users don't have to ask about
it I can live with that.

>> As part of that there is added a void *security pointer in the user
>> namespace to apparently hang off anything anyone would like to use.
>> Connected to that are hooks that have failure codes (presumably memory
>> allocation failures), but the semantics are not clear.  My gut feel is
>> that I would rather extend struct user_namespace to hold the smack label
>> mapping table and remove all of the error codes because they would then
>> be unnecessary.
>
> How is this different then filling a void *security pointer for other
> kernel objects (tasks, indodes, ipc, etc). The allocations can fail as
> well. I don't see how the semantics are different here.
>
> So you would have me a Smack generic pointer in user_namespace without
> any LSM abstraction? How does that cope with LSM philosophy and recently
> introduced (initial) LSM stacking?

I would have an smack specific array of mapped labels (probably in a
union).

I am not an LSM guy and to me tell the only important LSM philosophy is
provide a way for the various people who want to odd things with
security to each have a place at the table so they don't fight.

What you are proposing is something different from core LSM activities.

I have a hard time working with ``security'' code in the kernel as
almost invariably it is some of the worst code in the core kernel.
There are likely a lot of reasons for that but one reason that stands
out to me is the LSM interface seems to relegate the ``security'' code
to second class status.

We have merged the security modules now and we no longer support
loadable modules so I think some of the original design assumptions can
be reexamined.  If we will change anything upon reexamination I don't
know and I am not looking for any great whole sale change.  But I do
intend to look at LSM related changes to the code I maintain under the
same spot light and under the same criteria as I look at any other
changes.

i.e. I can't ignore what the LSMs do during code maintenance so I won't
ignore what the LSMs do or want to do when adding LSM hooks.

>> I am also concerned that several of the operations assume that setns
>> and the like are normally privileged operations and so require the
>> ability to perform other privileged operations.  Given that in the right
>> circumstances setns is not privileged that seems like a semantics
>> mismatch.
>
> Sorry, I don't exactly know what you mean. setns remains unprivileged
> operation here. The only limit is to refuse setns when adding a process
> to a container would break Smack namespace rules. In theory this
> limitation could be removed (I think), because a process with an
> unmapped label would not be able to do anything in the namespace. This
> is mostly for convenience.

The rule may make sense but because of it it sounds like in practice you
may actually have to be root to enter a container.  

>> Or in short my gut feel says the semantics of this change are close to
>> something that would be very useful, but the details make this patchset
>> far less useful, usable and comprehensible than it should be.
>
> This isn't much to go on for me unfortunately.
> Anyway, thank you for your insight, and taking the time.

Eric
