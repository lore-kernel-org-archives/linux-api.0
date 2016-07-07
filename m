From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Introspecting userns relationships to other namespaces?
Date: Thu, 7 Jul 2016 20:21:20 +0200
Message-ID: <CAKgNAkg+OiBngdFsdVR0gsSnVhMppuH2DxMBLCNAx8in5C0-zQ@mail.gmail.com>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	<87r3b7pxja.fsf@x220.int.ebiederm.org>
	<CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	<20160706141348.GB20728@mail.hallyn.com>
	<CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
	<20160707133631.GA2994@mail.hallyn.com>
	<1467903712.2347.16.camel@HansenPartnership.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1467903712.2347.16.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 7 July 2016 at 17:01, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Thu, 2016-07-07 at 08:36 -0500, Serge E. Hallyn wrote:
>> Quoting Michael Kerrisk (man-pages) (mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
>> > Hi Serge,
>> >
>> > On 6 July 2016 at 16:13, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
>> > > On Wed, Jul 06, 2016 at 10:41:48AM +0200, Michael Kerrisk (man
>> > > -pages) wrote:
>> > > > [Rats! Doing now what I should have down to start with. Looping
>> > > > some lists and CRIU and other possibly relevant people into
>> > > > this conversation]
>> > > >
>> > > > Hi Eric,
>> > > >
>> > > > On 5 July 2016 at 23:47, Eric W. Biederman <
>> > > > ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> > > > > "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > > > > writes:
>> > > > >
>> > > > > > Hi Eric,
>> > > > > >
>> > > > > > I have a question. Is there any way currently to discover
>> > > > > > which user namespace a particular nonuser namespace is
>> > > > > > governed by? Maybe I am missing something, but there does
>> > > > > > not seem to be a way to do this. Also, can one discover
>> > > > > > which userns is the parent of a given userns? Again, I
>> > > > > > can't see a way to do this.
>> > > > > >
>> > > > > > The point here is introspecting so that a process might
>> > > > > > determine what its capabilities are when operating on some
>> > > > > > resource governed by a (nonuser) namespace.
>> > > > >
>> > > > > To the best of my knowledge that there is not an interface to
>> > > > > get that information.  It would be good to have such an
>> > > > > interface for no other reason than the CRIU folks are going
>> > > > > to need it at some point.  I am a bit surprised they have not
>> > > > > complained yet.
>> > >
>> > > I don't think they need it.  They do in fact have what they need.
>> > >   Assume you have tasks T1, T2, T1_1 and T2_1;  T1 and T2 are in
>> > > init_user_ns;  T1 spawned T1_1 in a new userns;  T2 spawned T2_1
>> > > which setns()d to T1_1's ns. There's some {handwave} uid mapping,
>> > > does not matter.
>> > >
>> > > At restart, it doesn't matter which task originally created the
>> > > new userns. criu knows T1_1 and T2_1 are in the same userns;  it
>> > > creates the userns, sets up the mapping, and T1_1 and T2_1
>> > > setns() to it.
>> >
>> > I'm missing something here. How does the parental relationships
>> > between the user namespaces get reconstructed? Those relationships
>> > will govern what capabilities a process will have in various user
>> > namespaces.
>
> Actually, you get the parent namespace from the process tree by
> tracking the user namespaces of the parent pids.   Currently non-root
> users can't bind the namespace, so the only way to keep a new user_ns
> around if you're not root is to keep the process around, so for
> multiply nested user namespaces you can usually build the user_ns
> hierarchy by looking at the process hierarchy.  Conversely, if the
> process is reparented to init, chances are that the user_ns is also
> parented to init_user_ns.

Yes, but "chances are" == this isn't robust.  PR_SET_CHILD_SUBREAPER
further complicates things.

By the way, is that really what happens? Do child user namespaces get
reparented to the grandparent ns if the parent ns disappears (i.e.,
ceases to have any members and no bind mounts)? I hadn't thought about
that scenario before. It may be worth documenting in
user_namespaces(7).

>> Hm.  Probably best-effort based on the process hierarchy.  So yeah
>> you could probably get a tree into a state that would be wrongly
>> recreated. Create a new netns, bind mount it, exit;  Have another
>> task create a new user_ns, bind mount it, exit;  Third task setns()s
>> first to the new netns then to the new user_ns.  I suspect criu will
>> recreate that wrongly.
>
> This is a bit pathological, and you have to be root to do it: so root
> can set up a nesting hierarchy, bind it and destroy the pids but I know
> of no current orchestration system which does this.
>
> Actually, I have to back pedal a bit: the way I currently set up
> architecture emulation containers does precisely this: I set up the
> namespaces unprivileged with child mount namespaces, but then I ask
> root to bind the userns and kill the process that created it so I have
> a permanent handle to enter the namespace by, so I suspect that when
> our current orchestration systems get more sophisticated, they might
> eventually want to do something like this as well.
>
> In theory, we could get nsfs to show this information as an option
> (just add a show_options entry to the superblock ops), but the problem
> is that although each namespace has a parent user_ns, there's no way to
> get it without digging in the namespace specific structure.  Probably
> we should restructure to move it into ns_common, then we could display
> it (and enforce all namespaces having owning user_ns) but it would be a

I'm missing something here. Is it not already the case that all
namespaces have an owning user_ns?

Cheers,

Michael

> reasonably large (but mechanical) change.
>
> James
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
