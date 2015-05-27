From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: Re: [PATCH v2 0/7] Smack namespace
Date: Wed, 27 May 2015 19:15:15 +0200
Message-ID: <1432746915.1784.81.camel@samsung.com>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
 <1432557162-19123-1-git-send-email-l.pawelczyk@samsung.com>
 <87h9qyww4h.fsf@x220.int.ebiederm.org> <1432721610.1784.27.camel@samsung.com>
 <87vbfeqcke.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <87vbfeqcke.fsf@x220.int.ebiederm.org>
Sender: linux-doc-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, "David S. Miller" <davem@davemloft.net>, "Kirill A. Shutemov" <kirill@shutemov.name>, "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, David Howells <dhowells@redhat.com>, Fabian Frederick <fabf@skynet.be>, Greg KH <gregkh@linuxfoundation.org>, James Morris <james.l.morris@oracle.com>, Jeff Layton <jlayton@primarydata.com>, Jingoo Han <jg1.han@samsung.com>, Joe Perches <joe@perches.com>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Miklos Szeredi <miklos@szeredi.hu>, Oleg Nesterov <oleg@redhat.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa>
List-Id: linux-api@vger.kernel.org

On =C5=9Bro, 2015-05-27 at 10:12 -0500, Eric W. Biederman wrote:
> Lukasz Pawelczyk <l.pawelczyk@samsung.com> writes:
> > On wto, 2015-05-26 at 22:13 -0500, Eric W. Biederman wrote:
> >> In particular there should be
> >> little to no need to keep pestering the system administrator for m=
ore
> >> identifiers.
> >
> > This all depends on the use case. When you create a new namespace f=
or a
> > particular purpose you could know what labels will be required ther=
e and
> > map them upfront. Adding new mappings is for a use case that a cont=
ainer
> > might have new software installed that requires new labels for it. =
You
> > don't create/import new labels on a normal basis all the time.
>=20
> Good.
>=20
> >> The flip side of that was that the mapping would ensure all of the
> >> existing permissions checks would work as expected, and the checks=
 in
> >> the kernel could be converted without much trouble.
> >
> > Again, this is exactly the case with Smack namespace. There are
> > additional checks in place of course, but the rules are clear about
> > how that works.
> >
> >
> >> Ranges of ids were choosen because they allow for a lot of possibl=
e ways
> >> of using uids and gids in containers, are comparitively easy to
> >> administer, are very fast to use, and don't need large data struct=
ures.
> >
> > This is Smack specific. The same way we could compare Smack with DA=
C
> > (even without talking about namespaces). Every new UID is just it, =
a
> > number. Every new label requires allocation and adds to the list.
> >
> > I had an idea about mapping ranges of labels for a container by usi=
ng
> > prefixes but this was dropped by Casey. Labels (with an exception o=
f the
> > built-in ones) should not have any special meaning. This is Smack
> > design.
>=20
> Maybe.  All I care about is the resources for user namespaces remain
> something that the administrator can set up (before any containers
> exist) a set of resources (uid, gids, labels?) that an individual use=
r
> can use and then that user can set up containers as they desire.
>=20
> That is the property that the administration of the container is full=
y
> delegated to the whoever creates the container.

You can do that the same way as in user namespace.

You are allowed to add mappings later, but e.g. if you have a hermetic
container you don't have to. This is not required for a Smack namespace
to work. It's purely optional. You can map a set of labels and forget
about it. The namespace will not be able to import/create a new ones bu=
t
it will work just fine.


> > About performance, as it was originally with Smack. The list of lab=
els
> > was a simple list. When the performance was not enough hashing was
> > added. I'd take the same approach here. If some use cases will requ=
ire
> > so many mappings that this becomes a problem we will deal with it. =
I
> > don't want to complicate the patches now and I this was Casey's opi=
nion
> > as well.
>=20
> Occassionally performance implications are sufficiently profound that
> it impacts your userspace API, and thus all future maintenance.  How
> labels are managed and mapped into a container appears to be one such
> issue.  So unfortunately it does not appear to shove performance
> questions off until later.

In this case the only "public" kernel API are user_ns hooks that are
orthogonal to the Smack internals, so I don't really see how is that a
case.

I was also asked by Stephen Smalley to make the label map a generic fil=
e
in /proc/$PID/attr/ so it will also be up to the LSM to decide how this
file is treated. It will be abstracted by getprocattr/setprocattr hooks
or something similar.


> And actually it is much more about managability rather than raw
> performance.
>=20
> What I know is that the human factors of how these identifiers are
> assigned and managed is important.  Especially as they are persistent=
 on
> disk and likely need to be kept consistent between multiple different
> machines.
>=20
> A range of uids, a prefix on a label, those kinds of things are simpl=
e
> and easy to understand and make sense of.  The rule is simple enough =
I
> can track it in my head and I don't need to keep going back and looki=
ng
> at configuration files.   Discrete unrelated assignment of values
> (unless the set of values is very small) does not work that way and
> makes things less managable.

Like I said, this is Smack design (fortunately or not). I don't really
see how that could be different here. We might argue why Smack uses
strings instead of numbers. But by design those strings should bear no
special meaning and Casey stressed this on several occasions.

Nobody prevents you from doing prefixes yourself though:
C1_label1 -> label1
C1_label2 -> label2
etc..


> Which leads to my observation that if the mapping rule is simple enou=
gh
> I can keep track of it in my head I can put a small array in struct
> user_namespace to implement that rule.

Even though you can only have 5 mappings in user_ns you could in
principle map the UIDs in a way that would be confusing. The 5 mappings
mitigate that significantly of course, but numbers are easier to deal
with than strings. It's just the way it is.


> >> With a discreet mapping of labels I have the premonition that we n=
ow
> >> have a large data structure that, is not as flexible in to use,
> >> is comparatively slow and appears to require an interaction with t=
he
> >> system administrator for every label you use in a container.
> >
> > Again, DAC vs Smack philosophy. The same way a new label appears in=
 init
> > namespace (e.g. with a file/inode). Without a new rule you won't ha=
ve an
> > access to it. This requires administrator intervention as well. Thi=
s is
> > MAC after all.
>=20
> If it does not work with how user namespaces are designed to be used
> this approach gets my nack.  I will not accept an approach that requi=
res
> asking a system administrator permission for every little change.  Th=
at
> fundamentally is what the user namespace gets away from.
>
> If on the other hand the sysadmin interaction becomes here are N labe=
ls
> do what you need to with them.  Where N is sufficiently large that mo=
st
> users can be given those N labels and then users don't have to ask ab=
out
> it I can live with that.

This works here as I described earlier in this email.


> >> As part of that there is added a void *security pointer in the use=
r
> >> namespace to apparently hang off anything anyone would like to use=
=2E
> >> Connected to that are hooks that have failure codes (presumably me=
mory
> >> allocation failures), but the semantics are not clear.  My gut fee=
l is
> >> that I would rather extend struct user_namespace to hold the smack=
 label
> >> mapping table and remove all of the error codes because they would=
 then
> >> be unnecessary.
> >
> > How is this different then filling a void *security pointer for oth=
er
> > kernel objects (tasks, indodes, ipc, etc). The allocations can fail=
 as
> > well. I don't see how the semantics are different here.
> >
> > So you would have me a Smack generic pointer in user_namespace with=
out
> > any LSM abstraction? How does that cope with LSM philosophy and rec=
ently
> > introduced (initial) LSM stacking?
>=20
> I would have an smack specific array of mapped labels (probably in a
> union).
>=20
> I am not an LSM guy and to me tell the only important LSM philosophy =
is
> provide a way for the various people who want to odd things with
> security to each have a place at the table so they don't fight.
>=20
> What you are proposing is something different from core LSM activitie=
s.

I think this actually is very much in line with LSM activities. Every
object with a security context gets an opaque pointer that LSM
interprets as it wants. And does whatever it wants with it to make
security decisions.


> I have a hard time working with ``security'' code in the kernel as
> almost invariably it is some of the worst code in the core kernel.
> There are likely a lot of reasons for that but one reason that stands
> out to me is the LSM interface seems to relegate the ``security'' cod=
e
> to second class status.
>=20
> We have merged the security modules now and we no longer support
> loadable modules so I think some of the original design assumptions c=
an
> be reexamined.=20

This is new to me and recently I have heard quite the opposite in regar=
d
to the newly introduced LSM stacking code. I'm not aware that
out-of-tree modules should not be supported.

People do have and use out-of-tree LSM modules. Not having an opaque
pointer blocks them from using those LSM hooks.

And recent stacking changes try to make this infrastructure even more
generic, by proving stacked security pointers (hooks should already be
stacked in 4.2 afaik):

http://www.spinics.net/linux/fedora/linux-security-module/msg21608.html


>  If we will change anything upon reexamination I don't
> know and I am not looking for any great whole sale change.  But I do
> intend to look at LSM related changes to the code I maintain under th=
e
> same spot light and under the same criteria as I look at any other
> changes.
>=20
> i.e. I can't ignore what the LSMs do during code maintenance so I won=
't
> ignore what the LSMs do or want to do when adding LSM hooks.
>=20
> >> I am also concerned that several of the operations assume that set=
ns
> >> and the like are normally privileged operations and so require the
> >> ability to perform other privileged operations.  Given that in the=
 right
> >> circumstances setns is not privileged that seems like a semantics
> >> mismatch.
> >
> > Sorry, I don't exactly know what you mean. setns remains unprivileg=
ed
> > operation here. The only limit is to refuse setns when adding a pro=
cess
> > to a container would break Smack namespace rules. In theory this
> > limitation could be removed (I think), because a process with an
> > unmapped label would not be able to do anything in the namespace. T=
his
> > is mostly for convenience.
>=20
> The rule may make sense but because of it it sounds like in practice =
you
> may actually have to be root to enter a container. =20

In this particular case UID is irrelevant. You'll either be allowed or
not. Depending on Smack rules.

If the check would be removed UID would still be irrelevant. You'd
always be allowed (as far as Smack is concerned of course) but dependin=
g
on Smack rules the process would be usable or not (not able to access
anything, even itself).

I think you can't try to compare apples and oranges. Smack security
model, or any MAC for that matter will not be analogous to DAC. Being
root can be completely irrelevant for an LSM module. And it's completel=
y
its own decision.

If a hook is added for some syscall a module might have its arbitrary
rules for allowing it or not. I don't see anything awkward here. And
honestly I think that having a hook for setns where it might be
allowed/refused could be beneficial to other LSM modules.

The hook itself doesn't define any decision/model. A module does.


As a side note: I do realize that having security context in user
namespace makes it kinda more of a security namespace (DAC, MAC, CAPS,
etc).

Initially I made a whole separate namespace for LSM. You told me this
was a strange decision and I agree now.

This extends user namespace a little and I don't feel this is bad. Even
now user_ns is not a part of nsproxy, but cred. It's created first and
referenced from all the other namespaces. It doesn't only map UIDs. It
also gives capabilities a context. So in the same way it could hold MAC
security context for MAC related decisions that don't necessarily align
with DAC (that's what MAC is for after all).



--=20
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



