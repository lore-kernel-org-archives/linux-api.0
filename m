From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
	between namespaces
Date: Tue, 26 Jul 2016 13:39:56 -0700
Message-ID: <20160726203955.GA9415@outlook.office365.com>
References: <1515f5f2-5a49-fcab-61f4-8b627d3ba3e2@gmail.com>
	<CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
	<e2811bf1-4b86-e115-bcdb-301d6f2546eb@gmail.com>
	<87lh0pg8jx.fsf@x220.int.ebiederm.org>
	<44ca0e41-dc92-45b1-2a6c-c41a048a072d@gmail.com>
	<87r3ahepb4.fsf@x220.int.ebiederm.org>
	<20160726025455.GC26206@outlook.office365.com>
	<3390535b-0660-757f-aeba-c03d936b3485@gmail.com>
	<20160726182524.GA328@outlook.office365.com>
	<CAKgNAkjmOu+vfiMDyeYQkkf7wQBH9PVmJ4nH2CTg43GrN-k7eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkjmOu+vfiMDyeYQkkf7wQBH9PVmJ4nH2CTg43GrN-k7eA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 26, 2016 at 09:17:31PM +0200, Michael Kerrisk (man-pages) wrote:
> Hello Andrew,
> 
> On 26 July 2016 at 20:25, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> > On Tue, Jul 26, 2016 at 10:03:25AM +0200, Michael Kerrisk (man-pages) wrote:
> >> On 07/26/2016 04:54 AM, Andrew Vagin wrote:
> >> > On Mon, Jul 25, 2016 at 09:59:43AM -0500, Eric W. Biederman wrote:
> >> > > "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> >> >
> >> > [snip]
> >> >
> >> > > [snip]
> >> > > > > > So, from my point of view, the important piece that was missing from
> >> > > > > > your commit message was the note to use readlink("/proc/self/fd/%d")
> >> > > > > > on the returned FDs. I think that detail needs to be part of the
> >> > > > > > commit message (and also the man page text). I think it even be
> >> > > > > > helpful to include the above program as part of the commit message:
> >> > > > > > it helps people more quickly grasp the API.
> >> > > > >
> >> > > > > Please, please make the standard way to compare these things fstat.
> >> > > > > That is much less magic than a symlink, and a little more future proof.
> >> > > > > Possibly even kcmp.
> >> >
> >> > I like the idea to use kcmp to compare namespaces. I am going to add this
> >> > functionality to kcmp and describe all these in the man page.
> >>
> >> Hi Andrey,
> >>
> >> Can you briefly sketch out the proposed API and how it would be used?
> >> I'd find it useful to see that even before the implementation.
> >
> > Sure. If a process wants to compare two namespaces, it needs to get file
> > descriptors for them (open /proc/PID/ns/XXX, use new ioctl-s, find a
> > process which has them),
> > and then it calls kcmp(pid1, pid2, KCMP_NSFD, ns_fd1, ns_fd2)
> >
> > For example, if we want to compare pid namespaces for 1 and 2 processes:
> >
> 
> What's the purpose of the following line, and the use of 'pid' in the
> kcmp() call?:

It's the existing interface of kcmp. It's used to check whether the
two processes identified  by pid1  and  pid2 share a kernel resource
such as virtual memory, file descriptors, and so on.

If we want to compare two file descriptors of the current process,
it is one of cases for which kcmp can be used. We can call kcmp to
compare two namespaces which are opened in other processes.

Thanks,
Andrew

> 
> > pid = getpid();
> > ns_fd1 = open("/proc/1/ns/pid")
> > ns_fd2 = open("/proc/2/ns/pid")
> >
> > if (!kcmp(pid, pid, KCMP_NSFD, ns_fd1, ns_fd2))
> >         printf("Both processes live in the same pid namespace\n");
> 
> Thanks,
> 
> Michael
