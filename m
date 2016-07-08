From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Fri, 08 Jul 2016 07:35:33 -0700
Message-ID: <1467988533.2322.118.camel@HansenPartnership.com>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	<87r3b7pxja.fsf@x220.int.ebiederm.org>
	<CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	<20160706141348.GB20728@mail.hallyn.com>
	<871t36kbvq.fsf@x220.int.ebiederm.org>
	<20160708015758.GA10512@outlook.office365.com>
	<87vb0gy3nr.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87vb0gy3nr.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael Kerrisk
	(man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2016-07-08 at 02:44 -0500, Eric W. Biederman wrote:
> Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:
> 
> > On Wed, Jul 06, 2016 at 10:46:33AM -0500, Eric W. Biederman wrote:
> > > "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
> > > 
> > > > On Wed, Jul 06, 2016 at 10:41:48AM +0200, Michael Kerrisk (man
> > > > -pages) wrote:
> > > > > [Rats! Doing now what I should have down to start with.
> > > > > Looping some
> > > > > lists and CRIU and other possibly relevant people into this
> > > > > conversation]
> > > > > 
> > > > > Hi Eric,
> > > > > 
> > > > > On 5 July 2016 at 23:47, Eric W. Biederman <
> > > > > ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> > > > > > "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > > > > writes:
> > > > > > 
> > > > > > > Hi Eric,
> > > > > > > 
> > > > > > > I have a question. Is there any way currently to discover 
> > > > > > > which user namespace a particular nonuser namespace is 
> > > > > > > governed by? Maybe I am missing something, but there does 
> > > > > > > not seem to be a way to do this. Also, can one discover 
> > > > > > > which userns is the parent of a given userns? Again, I 
> > > > > > > can't see a way to do this.
> > > > > > > 
> > > > > > > The point here is introspecting so that a process might 
> > > > > > > determine what its capabilities are when operating on 
> > > > > > > some resource governed by a (nonuser) namespace.
> > > > > > 
> > > > > > To the best of my knowledge that there is not an interface 
> > > > > > to get that information.  It would be good to have such an 
> > > > > > interface for no other reason than the CRIU folks are going 
> > > > > > to need it at some point.  I am a bit surprised they have
> > > > > > not complained yet.
> > > > 
> > > > I don't think they need it.  They do in fact have what they 
> > > > need.  Assume you have tasks T1, T2, T1_1 and T2_1;  T1 and T2 
> > > > are in init_user_ns;  T1 spawned T1_1 in a new userns;  T2 
> > > > spawned T2_1 which setns()d to T1_1's ns. There's some
> > > > {handwave} uid mapping, does not matter.
> > > > 
> > > > At restart, it doesn't matter which task originally created the 
> > > > new userns. criu knows T1_1 and T2_1 are in the same userns; 
> > > >  it creates the userns, sets up the mapping, and T1_1 and T2_1
> > > > setns() to it.
> > > 
> > > Given that the simple cases are so easy it probably doesn't 
> > > matter in that sense.
> > > 
> > > However we now have the case where user namespaces own pid 
> > > namespaces, and uts namespaces, and network namespaces, and ipc 
> > > namespaces, and filesystems.  Throw in some mount propagation and 
> > > use of setns and things could get confusing.   It is something 
> > > that will need to be figured out if CRIU is going to properly 
> > > checkpoint containers containing containers containing containers 
> > > containing containers.
> > 
> > It isn't a joke:). We have a few requests to support CR of 
> > containers with Docker containers inside. And we are going to start 
> > this task in a near future, so we would like to have interface to 
> > get dependencies between namespaces too.
> > 
> > BTW: CRIU already supports nested mount namespaces, because systemd
> > creates them for services.
> 
> The tricky part about this and what messes up James proposed plan is
> that the interface needs to be something that returns a namespace 
> file descriptor.  So we can't print something out in a simple text
> file.

I actually described two problems: the first was how we get the
information in the first place.  Currently the owning or parent user_ns
is tucked inside an opaque structure.  I think we need to move that to
ns_common where it would be the owning userns for all non-user
namespaces and the parent for the userns.

Once we actually have the information, we can also add a set of proc
links, say either

/proc/<pid>/ns/X-userns

Which might be a bit messy since it doubles the number of files, or
perhaps in a simple directory.

> Well I suppose we could print an device number and inode number pair.
> But then someone would still have to scour processes looking for a 
> user namespace so that is likely less than ideal.

There's no reason any of the proposed methods so far have to be
exclusive: nsfs.c has a lot of flexibility.

> Starting with 4.8 we are also going to need to be able to retrieve 
> the user namespace owner of filesystems.  That will be an interesting
> mix.

This is per mount point, isn't it? so it can't be in /proc/fs/ and it
would have to be per local mount tree.  Yes, that is a bit nasty. 
 Sounds like we might need to unfold mount or mountinfo into something
that has one directory per entry?

James

> Eric
> 
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
> 
