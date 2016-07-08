From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Fri, 08 Jul 2016 02:44:56 -0500
Message-ID: <87vb0gy3nr.fsf@x220.int.ebiederm.org>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	<87r3b7pxja.fsf@x220.int.ebiederm.org>
	<CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	<20160706141348.GB20728@mail.hallyn.com>
	<871t36kbvq.fsf@x220.int.ebiederm.org>
	<20160708015758.GA10512@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160708015758.GA10512-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org> (Andrew Vagin's
	message of "Thu, 7 Jul 2016 18:57:59 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:

> On Wed, Jul 06, 2016 at 10:46:33AM -0500, Eric W. Biederman wrote:
>> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
>> 
>> > On Wed, Jul 06, 2016 at 10:41:48AM +0200, Michael Kerrisk (man-pages) wrote:
>> >> [Rats! Doing now what I should have down to start with. Looping some
>> >> lists and CRIU and other possibly relevant people into this
>> >> conversation]
>> >> 
>> >> Hi Eric,
>> >> 
>> >> On 5 July 2016 at 23:47, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> >> > "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>> >> >
>> >> >> Hi Eric,
>> >> >>
>> >> >> I have a question. Is there any way currently to discover which
>> >> >> user namespace a particular nonuser namespace is governed by?
>> >> >> Maybe I am missing something, but there does not seem to be a
>> >> >> way to do this. Also, can one discover which userns is the
>> >> >> parent of a given userns? Again, I can't see a way to do this.
>> >> >>
>> >> >> The point here is introspecting so that a process might determine
>> >> >> what its capabilities are when operating on some resource governed
>> >> >> by a (nonuser) namespace.
>> >> >
>> >> > To the best of my knowledge that there is not an interface to get that
>> >> > information.  It would be good to have such an interface for no other
>> >> > reason than the CRIU folks are going to need it at some point.  I am a
>> >> > bit surprised they have not complained yet.
>> >
>> > I don't think they need it.  They do in fact have what they need.  Assume
>> > you have tasks T1, T2, T1_1 and T2_1;  T1 and T2 are in init_user_ns;  T1
>> > spawned T1_1 in a new userns;  T2 spawned T2_1 which setns()d to T1_1's ns.
>> > There's some {handwave} uid mapping, does not matter.
>> >
>> > At restart, it doesn't matter which task originally created the new userns.
>> > criu knows T1_1 and T2_1 are in the same userns;  it creates the userns, sets
>> > up the mapping, and T1_1 and T2_1 setns() to it.
>> 
>> Given that the simple cases are so easy it probably doesn't matter in
>> that sense.
>> 
>> However we now have the case where user namespaces own pid namespaces,
>> and uts namespaces, and network namespaces, and ipc namespaces, and
>> filesystems.  Throw in some mount propagation and use of setns and
>> things could get confusing.   It is something that will need to be
>> figured out if CRIU is going to properly checkpoint containers
>> containing containers containing containers containing containers.
>
> It isn't a joke:). We have a few requests to support CR of containers with
> Docker containers inside. And we are going to start this task in a near
> future, so we would like to have interface to get dependencies between
> namespaces too.
>
> BTW: CRIU already supports nested mount namespaces, because systemd
> creates them for services.

The tricky part about this and what messes up James proposed plan is
that the interface needs to be something that returns a namespace file
descriptor.  So we can't print something out in a simple text file.
Well I suppose we could print an device number and inode number pair.
But then someone would still have to scour processes looking for a user
namespace so that is likely less than ideal.

Starting with 4.8 we are also going to need to be able to retrieve the
user namespace owner of filesystems.  That will be an interesting mix.

Eric
