From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Thu, 7 Jul 2016 18:57:59 -0700
Message-ID: <20160708015758.GA10512@outlook.office365.com>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	<87r3b7pxja.fsf@x220.int.ebiederm.org>
	<CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	<20160706141348.GB20728@mail.hallyn.com>
	<871t36kbvq.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <871t36kbvq.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 06, 2016 at 10:46:33AM -0500, Eric W. Biederman wrote:
> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
> 
> > On Wed, Jul 06, 2016 at 10:41:48AM +0200, Michael Kerrisk (man-pages) wrote:
> >> [Rats! Doing now what I should have down to start with. Looping some
> >> lists and CRIU and other possibly relevant people into this
> >> conversation]
> >> 
> >> Hi Eric,
> >> 
> >> On 5 July 2016 at 23:47, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> >> > "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> >> >
> >> >> Hi Eric,
> >> >>
> >> >> I have a question. Is there any way currently to discover which
> >> >> user namespace a particular nonuser namespace is governed by?
> >> >> Maybe I am missing something, but there does not seem to be a
> >> >> way to do this. Also, can one discover which userns is the
> >> >> parent of a given userns? Again, I can't see a way to do this.
> >> >>
> >> >> The point here is introspecting so that a process might determine
> >> >> what its capabilities are when operating on some resource governed
> >> >> by a (nonuser) namespace.
> >> >
> >> > To the best of my knowledge that there is not an interface to get that
> >> > information.  It would be good to have such an interface for no other
> >> > reason than the CRIU folks are going to need it at some point.  I am a
> >> > bit surprised they have not complained yet.
> >
> > I don't think they need it.  They do in fact have what they need.  Assume
> > you have tasks T1, T2, T1_1 and T2_1;  T1 and T2 are in init_user_ns;  T1
> > spawned T1_1 in a new userns;  T2 spawned T2_1 which setns()d to T1_1's ns.
> > There's some {handwave} uid mapping, does not matter.
> >
> > At restart, it doesn't matter which task originally created the new userns.
> > criu knows T1_1 and T2_1 are in the same userns;  it creates the userns, sets
> > up the mapping, and T1_1 and T2_1 setns() to it.
> 
> Given that the simple cases are so easy it probably doesn't matter in
> that sense.
> 
> However we now have the case where user namespaces own pid namespaces,
> and uts namespaces, and network namespaces, and ipc namespaces, and
> filesystems.  Throw in some mount propagation and use of setns and
> things could get confusing.   It is something that will need to be
> figured out if CRIU is going to properly checkpoint containers
> containing containers containing containers containing containers.

It isn't a joke:). We have a few requests to support CR of containers with
Docker containers inside. And we are going to start this task in a near
future, so we would like to have interface to get dependencies between
namespaces too.

BTW: CRIU already supports nested mount namespaces, because systemd
creates them for services.

> 
> Did I mention I like recursion?
> 
> >> > That said in a normal use scenario I don't think that information is
> >> > needed.
> >> >
> >> > Do you have a particular use case besides checkpoint/restart where this
> >> > is useful?  That might help in coming up with a good userspace interface
> >> > for this information.
> >> 
> >> So, I spend a moderate amount of time working with people to introduce
> >> them to the namespaces infrastructure, and one topic that comes up now
> >> and this introspection/visualization tools. For example,
> >> nowadays--thanks to the (bizarrely misnamed) NStgid and NSpid fields
> >> in /proc/PID--it's possible to (and someone I was working with did)
> >> write tools that introspect the PID namespace hierarchy to show all of
> >> process's and their PIDs in the various namespace instance. It's a
> >> natural enough thing to want to do, when confronted with the
> >> complexity of the namespaces.
> >> 
> >> Someone else then asked me a question that led me to wonder about
> >> generally introspecting on the parental relationships between user
> >> namespaces and the association of other namespaces types with user
> >> namespaces. One use would be visualization, in order to understand the
> >> running system. Another would be to answer the question I already
> >> mentioned: what capability does process X have to perform operations
> >> on a resource governed by namespace Y?
> >
> > I agree they'll probably want it, but if we want for a real need and
> > use case we can do a better job of providing what's needed.
> 
> That two which is why I mentioned CRIU.  But yeah it will probably take
> a little while to get there.
> 
> Eric
> _______________________________________________
> CRIU mailing list
> CRIU-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
> https://lists.openvz.org/mailman/listinfo/criu
