From: James Bottomley <James.Bottomley-RxcU5blhW6jCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Fri, 08 Jul 2016 15:19:26 -0700
Message-ID: <b1cc7d60-55b1-42c5-8262-70e0910a4f50@email.android.com>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com> <87r3b7pxja.fsf@x220.int.ebiederm.org> <CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com> <20160706141348.GB20728@mail.hallyn.com> <871t36kbvq.fsf@x220.int.ebiederm.org> <20160708015758.GA10512@outlook.office365.com> <87vb0gy3nr.fsf@x220.int.ebiederm.org> <1467988533.2322.118.camel@HansenPartnership.com> <20160708203818.GA2602@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160708203818.GA2602-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On July 8, 2016 1:38:19 PM PDT, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wro=
te:
>On Fri, Jul 08, 2016 at 07:35:33AM -0700, James Bottomley wrote:
>> On Fri, 2016-07-08 at 02:44 -0500, Eric W. Biederman wrote:
>> > Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:
>> >=20
>> > > On Wed, Jul 06, 2016 at 10:46:33AM -0500, Eric W. Biederman
>wrote:
>> > > > "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
>> > > >=20
>> > > > > On Wed, Jul 06, 2016 at 10:41:48AM +0200, Michael Kerrisk
>(man
>> > > > > -pages) wrote:
>> > > > > > [Rats! Doing now what I should have down to start with.
>> > > > > > Looping some
>> > > > > > lists and CRIU and other possibly relevant people into thi=
s
>> > > > > > conversation]
>> > > > > >=20
>> > > > > > Hi Eric,
>> > > > > >=20
>> > > > > > On 5 July 2016 at 23:47, Eric W. Biederman <
>> > > > > > ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> > > > > > > "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > > > > > > writes:
>> > > > > > >=20
>> > > > > > > > Hi Eric,
>> > > > > > > >=20
>> > > > > > > > I have a question. Is there any way currently to
>discover=20
>> > > > > > > > which user namespace a particular nonuser namespace is=
=20
>> > > > > > > > governed by? Maybe I am missing something, but there
>does=20
>> > > > > > > > not seem to be a way to do this. Also, can one discove=
r
>
>> > > > > > > > which userns is the parent of a given userns? Again, I=
=20
>> > > > > > > > can't see a way to do this.
>> > > > > > > >=20
>> > > > > > > > The point here is introspecting so that a process migh=
t
>
>> > > > > > > > determine what its capabilities are when operating on=20
>> > > > > > > > some resource governed by a (nonuser) namespace.
>> > > > > > >=20
>> > > > > > > To the best of my knowledge that there is not an
>interface=20
>> > > > > > > to get that information.  It would be good to have such
>an=20
>> > > > > > > interface for no other reason than the CRIU folks are
>going=20
>> > > > > > > to need it at some point.  I am a bit surprised they hav=
e
>> > > > > > > not complained yet.
>> > > > >=20
>> > > > > I don't think they need it.  They do in fact have what they=20
>> > > > > need.  Assume you have tasks T1, T2, T1_1 and T2_1;  T1 and
>T2=20
>> > > > > are in init_user_ns;  T1 spawned T1_1 in a new userns;  T2=20
>> > > > > spawned T2_1 which setns()d to T1_1's ns. There's some
>> > > > > {handwave} uid mapping, does not matter.
>> > > > >=20
>> > > > > At restart, it doesn't matter which task originally created
>the=20
>> > > > > new userns. criu knows T1_1 and T2_1 are in the same userns;=
=20
>> > > > >  it creates the userns, sets up the mapping, and T1_1 and
>T2_1
>> > > > > setns() to it.
>> > > >=20
>> > > > Given that the simple cases are so easy it probably doesn't=20
>> > > > matter in that sense.
>> > > >=20
>> > > > However we now have the case where user namespaces own pid=20
>> > > > namespaces, and uts namespaces, and network namespaces, and ip=
c
>
>> > > > namespaces, and filesystems.  Throw in some mount propagation
>and=20
>> > > > use of setns and things could get confusing.   It is something=
=20
>> > > > that will need to be figured out if CRIU is going to properly=20
>> > > > checkpoint containers containing containers containing
>containers=20
>> > > > containing containers.
>> > >=20
>> > > It isn't a joke:). We have a few requests to support CR of=20
>> > > containers with Docker containers inside. And we are going to
>start=20
>> > > this task in a near future, so we would like to have interface t=
o
>
>> > > get dependencies between namespaces too.
>> > >=20
>> > > BTW: CRIU already supports nested mount namespaces, because
>systemd
>> > > creates them for services.
>> >=20
>> > The tricky part about this and what messes up James proposed plan
>is
>> > that the interface needs to be something that returns a namespace=20
>> > file descriptor.  So we can't print something out in a simple text
>> > file.
>>=20
>> I actually described two problems: the first was how we get the
>> information in the first place.  Currently the owning or parent
>user_ns
>> is tucked inside an opaque structure.  I think we need to move that
>to
>> ns_common where it would be the owning userns for all non-user
>> namespaces and the parent for the userns.
>
>I'm agree with this.
>
>>=20
>> Once we actually have the information, we can also add a set of proc
>> links, say either
>>=20
>> /proc/<pid>/ns/X-userns
>>=20
>> Which might be a bit messy since it doubles the number of files, or
>> perhaps in a simple directory.
>
>In this case we will need to enter into each namespace to build a full
>chain of dependencies.
>
>It's tricky, because if we enter into a child userns, we can't to ente=
r
>into a parent userns from the same process, so to get the next branch,
>we will need to create a new process.
>
>				    process A
>					|
>init_user_ns->child_user_ns_1->child_userns_2
>
>fork() -> B
>  B: setns(/proc/A/ns/userns-parent)
>readlink(/proc/B/ns/userns)
>
>fork() -> C
>  C: setns(/proc/B/ns/userns-parent)
>readlink(/proc/C/ns/userns)
>
>
>>=20
>> > Well I suppose we could print an device number and inode number
>pair.
>> > But then someone would still have to scour processes looking for a=
=20
>> > user namespace so that is likely less than ideal.
>>=20
>> There's no reason any of the proposed methods so far have to be
>> exclusive: nsfs.c has a lot of flexibility.
>
>
>What do you think about the idea to mount nsfs and be able to look up
>any alive namespace by inum:

I think I like it.  It will give us a way to enter any extant namespace=
=2E  It will work for Eric's fs namespaces as well.  Perhaps a /process=
/ns/<inum>
 Directory?

James

>  $ tree .
>  .
>  =E2=94=9C=E2=94=80=E2=94=80 mnt{inum}
>  =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 user -> ../user{inum}
>  =E2=94=9C=E2=94=80=E2=94=80 pid{inum}
>  =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 pid{inum}
>  =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 user -> ../../us=
er{inum}/user{inum}
>  =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 user -> ../user{inum}
>  =E2=94=94=E2=94=80=E2=94=80 user{inum}
>      =E2=94=94=E2=94=80=E2=94=80 user{inum}
>
>https://lkml.org/lkml/2016/7/8/59
>
>I think it solves all requirements which were mentioned in this thread=
=2E
>
>>=20
>> > Starting with 4.8 we are also going to need to be able to retrieve=
=20
>> > the user namespace owner of filesystems.  That will be an
>interesting
>> > mix.
>>=20
>> This is per mount point, isn't it? so it can't be in /proc/fs/ and i=
t
>> would have to be per local mount tree.  Yes, that is a bit nasty.=20
>>  Sounds like we might need to unfold mount or mountinfo into
>something
>> that has one directory per entry?
>
>If we will be able to look up namespaces in nsfs by inum, we can print
>an userns inum in mountinfo.
>
>>=20
>> James
>>=20
>> > Eric
>> >=20
>> > _______________________________________________
>> > Containers mailing list
>> > Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>> > https://lists.linuxfoundation.org/mailman/listinfo/containers
>> >=20
>>=20
>_______________________________________________
>Containers mailing list
>Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>https://lists.linuxfoundation.org/mailman/listinfo/containers


--=20
Sent from my Android device with K-9 Mail. Please excuse my brevity.
