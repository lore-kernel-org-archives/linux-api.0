From: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Date: Fri, 26 Sep 2014 10:45:30 +0800
Message-ID: <CAPTn0cBvQXTy2755sBUQKx5GrMP2ehHkv8hdh2ZqNdvoLNMD_A@mail.gmail.com>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-5-git-send-email-lixi@ddn.com>
	<20140924162507.GC27000@quack.suse.cz>
	<20140924162634.GA16886@infradead.org>
	<20140924170105.GE27000@quack.suse.cz>
	<20140925075912.GG4758@dastard>
	<C31A739F-4502-4B40-9AE3-F2FE49291657@gmail.com>
	<20140926001049.GK4945@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140926001049.GK4945@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 26, 2014 at 8:10 AM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wro=
te:
> On Thu, Sep 25, 2014 at 07:34:38PM +0800, lixi wrote:
>> Hi Dave,
>>
>> I was mostly working on the semantics of inherit flag on these patch=
es. And
>> I didn=E2=80=99t realized that the interface differences would bothe=
r you so much. Sorry
>> for that.
>
> It's not the differences that bother me - it's the fact that I was
> repeatedly ignored until someone else raised the same issue....
Sorry about that. Since we are implementing a feature which exsits in X=
=46S
for years, your opions are surely very important. They are not ignored.
But I think more discussion is necessary before an common agreement is
reached. And I am willing to change the interfaces to whatever all peop=
le
agree on.
>
>> I agree that we should choose a good interface. It would be good tha=
t it is
>> general so that it works well for all file systems. I agree that add=
ing an
>> ext4 specific ioctl() is far from the best choice. I am willing to c=
hange it to
>> any general interface. A general ioctl() sounds good to me. Extend s=
etattr()
>> and getattr() for project ID sounds even better, since project ID lo=
oks like
>> UID/GID.
>
> Ah, no, project ID is not a uid/gid. It's a completely independent
> construct.
>
> [ Which brings me to, once again, the issue of being ignored during
> reviews: project IDs should not be mapped by user namespaces, nor be
> accessible from anything other than the init namespace.
>
> In XFS we've turned off access to project IDs within namespace
> containers because they are used for container space management
> (i.e. by the init namespace) to manage the amount of filesystem
> space a container or set of containers can use. We do not want
> project IDs to be manipulated from within such containers, and
> therefore have to prevent access to them from within user
> namespaces. ]
OK. That is another semantics which needs further discussion whether
we need to implement for Ext4. Container space management is one
of the project quota use case. I am not sure how widely used it is,
but I like features with less limits.
>
>> And general xattr name is another choice. But it is might be a littl=
e
>> bit confusing if we use xattr actually, since we are not saving proj=
ect ID as
>> extended attribute on Ext4. Any choice is fine with me, as long as t=
he
>> implementation won't introduce nasty codes or inconsistent design.
>
> We can easily create another ioctl name if we have to. It just needs
> sto be defined to the same value as the XFS ioctl names currently
> are. We've done this before when making ioctls that originated in
> XFS generic (e.g. with freeze/thaw ioctls)....
OK. I am fine with general ioctl to set/get project ID.
>
>> However, the problem is, I do not quite understand why we should kee=
p
>> the interface exactly the same with XFS. It would be good if we can.=
 But
>> as far as I can see, it seems hard. XFS uses a lot interfaces which =
are
>> not so standard and used by other file systems. For example, struct
>> fsxattr is not used by other file systems at all except XFS.
>
> Moving a existing structure definitions to a different header file
> is too hard?
I don't think difficulty is a big problem. I'm wondering whether it is
necessary.
>
>> I am not sure why we should introduce this into Ext4 if there are
>> a lot of other better ways. I would be happy to change to XFS
>> interfaces, if it is general.  However, I don=E2=80=99t think it is
>> general enough.
>
> How is it not general enough? Examples, please, not handwaving:
> which bit of the quota interface can't ext4 use because it's XFS
> specific?
Well, I am not so familar with XFS, so I might be all wrong about
XFS. But honestly, a lot of quota interfaces of XFS seems not
so standard. For example, all the Q_X* flags used in do_quotactl().
Maybe there are really good reasons why they are there. I don't
know. And XFS does not use general codes under fs/quota. That
is a big difference with Ext4.
>
> We already have a perfectly functional interface and a large body of
> code that implements and tests it. You're saying "oh, it's too much
> work for me to implement an existing interface" and ignoring the
> fact that not implementing the existing interface forces a huge
> amount of downstream work. e.g.
>
>         - we need completely new test infrastructure to replicate
>           existing tests.
>         - we need new tests to ensure the different APIs and
>           utilities provide the same functionality, and that the
>           work identically.
>         - administrators are going to have to learn how ext4 is
>           different to what they already know and understand.
>         - administrators that has tools written to manage project
>           quotas is going to have to rewrite them to support ext4.
>
> It's an entirely selfish argument that ignores what already existing
> out in userspace. i.e. you're saying that existing downstream users o=
f
> project quotas simple don't matter to you...
>
>> I know xfstest is using the existing project quota interfaces of XFS=
=2E And
>> maybe there are some applications which are using them too. But
>> keeping the interfaces exactly the same with XFS would cost so much
>> effort that I=E2=80=99d like to get enough reasons before start work=
ing on it. Is it
>> really necessary? I am not so sure.
>
> You have to have a stronger argument than that to justify creating a
> new incompatible user interface. The XFS interfaces have been
> available for more than 10 years and support all the functionality
> ext4 requires. If it was any other userspace interface (e.g.
> syscalls) or any filesystem other than ext4 there would be people
> from all over telling you "use the existing interfaces!" and you'd
> need very strong reasons for creating a new one.
>
> i.e. you need to demonstrate that the existing interfaces are
> inadequate for the intended purpose of the new functionality. That's
> clearly not the case here so why should we allow you to create an
> incompatible userspace API rather than use the existing, fully
> functional API?
>
>> It is so easy to change user space applications comparing to
>> changing a weird interfaces.
>
> The existing generic quota tools (i.e quotactl, repquota, etc)
> already implement the XFS quota API to be able to query XFS
> filesystems.  There's no "changing to wierd interfaces" necessary
> for userspace; it's already all there. Hence any work you do to add
> project quota awareness to those generic userspace tools will need to
> add the support to the XFS queries anyway.
>
> IOWs, you're not making it any easier for yourself in userspace by
> creating a new API for ext4 - it just doubles the amount of work you
> have to in userspace to make existing tools project quota aware.
I am afraid I have to make existing tools project quota aware. And
actually I've done most of the work. I've updated e2fsprogs and
quota-tools to support project quota. Unfortunately these updates are
inevitable anyway. As Jan Kara said, we can't force system admins
to change from quota-tool command to xfs quota tools. Thus, I add
'-P $PROJECT' arguments to all the commands. And based on
those tools, I made a script which is less than 1K lines for
regression test. It is working pretty well. I don't see a good reason
why it is necessary to change everything to XFS way.
>
>> For
>> example, I think it won=E2=80=99t cost even more than a day to add x=
fstest
>> support for new Ext4 project quota.
>
> A day of whose time?
I am always willing to help if you agree. :)
>
> Ever thought about how much time it will take reviewers to look at
> your tests and iterate over them to get it all right? If you're
> introducing new userspace infrastructure that xfstests will need to
> depend on and test for, then it's a lot more than just writing new
> tests.
>
> Indeed, I'm likely to want new project quota tests to be generic
> (i.e. works and passes on any filesystem that supports project
> quotas) with the introduction of ext4 project quota support. It's
> the same functionality and so it should work the same just like user
> and group quotas do across all filesystems.
>
>> And since project quota is far from
>> a widely used feature,
>
> I don't think you realise quite how widespread it's use is on XFS.
>
>> I don=E2=80=99t think there is much compatibility problems
>> for existing applications.  And If the new project interface are gen=
eral
>> enough, there won=E2=80=99t be any compatibility problems for new ap=
plications
>> at all.
>
> Again, you are ignoring the compatibility problems with existing
> applications that are project quota aware. For them you are
> *creating new compatibility problems* by implementing a new
> interface. i.e. Existing applications will not work on ext4, and
> new applications written to work on ext4 won't work on XFS.
>
> That's the crux of the issue - we have existing applications using
> the existing interface and so introducing a new interface introduces
> compatibility problems.  You can't just wave this problem away
> because you don't think the existing interface matters.
>
> "It's easier for me to create a new interface" is not a valid reason
> for creating a new interface....
Sorry about my ignorance about the existing usage of XFS
project quota. I hope it is widely used. But does it really matters
for XFS that what kind of Ext4 interfaces is going to use?
Existing appplications would run happily on XFS any way
using the exisitng XFS interfaces. And if you are concerning
about the compatibility between Ext4 and XFS, I am afraid
those applications have to be changed any way when been ported
to Ext4. Since those applications are using XFS specific feature,
i.e. project quota, it is likely they are using other kind of XFS
speicific features which probably will never be implemented on
Ext4. I don't think there is any easy way to port them from
XFS to Ext4 any way. And I really don't think therea are many
such kind of applications. So, since we are not implementing
interfaces for XFS2 or XFS3, I don't think compatibility problem
is so critical.

Regards,
                                             - Li Xi
