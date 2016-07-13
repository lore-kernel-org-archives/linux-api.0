From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Tue, 12 Jul 2016 17:08:43 -0700
Message-ID: <20160713000842.GC5818@outlook.office365.com>
References: <87vb0gy3nr.fsf@x220.int.ebiederm.org>
	<1467988533.2322.118.camel@HansenPartnership.com>
	<20160708203818.GA2602@outlook.office365.com>
	<5e4cc802-f0e0-4f4c-a2f7-585aaaa8feec@email.android.com>
	<87wpkvpu1i.fsf@x220.int.ebiederm.org>
	<1468023332.2390.10.camel@HansenPartnership.com>
	<87bn27o6j5.fsf@x220.int.ebiederm.org>
	<20160709072627.GA7480@outlook.office365.com>
	<87eg72llu0.fsf@x220.int.ebiederm.org>
	<871t32ll6n.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <871t32ll6n.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jul 09, 2016 at 01:29:20PM -0500, Eric W. Biederman wrote:
> ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:
> 
> > Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:
> >
> >> All these thoughts about security make me thinking that kcmp is what we
> >> should use here. It's maybe something like this:
> >>
> >> kcmp(pid1, pid2, KCMP_NS_USERNS, fd1, fd2)
> >>
> >> - to check if userns of the fd1 namepsace is equal to the fd2 userns
> >>
> >> kcmp(pid1, pid2, KCMP_NS_PARENT, fd1, fd2)
> >>
> >> - to check if a parent namespace of the fd1 pidns is equal to fd pidns.
> >>
> >> fd1 and fd2 is file descriptors to namespace files.
> >>
> >> So if we want to build a hierarchy, we need to collect all namespaces
> >> and then enumerate them to check dependencies with help of kcmp.
> >
> > That is certainly one way to go.
> >
> > There is a funny case where we would want to compare a user namespace
> > file descriptor to a parent user namespace file descriptor.
> >
> >
> > Grumble, Grumble.  I think this may actually a case for creating ioctls
> > for these two cases.  Now that random nsfs file descriptors are bind
> > mountable the original reason for using proc files is not as pressing.
> >
> > One ioctl for the user namespace that owns a file descriptor.
> > One ioctl for the parent namespace of a namespace file descriptor.
> >
> > We also need some way to get a command file descriptor for a file system
> > super block.  Al Viro has a pet project for cleaning up the mount API
> > and this might be the idea excuse to start looking at that.
> >
> > (In principle we might be able to run commands through the namespace
> >  file descriptor and using an ioctl feels dirty.  But an ioctl that
> >  only uses the fd and request argument does not suffer from the same
> >  problems that ioctls that have to pass additional arguments suffer
> >  from.)
> 
> Of course it should be an error perhaps -EINVAL to get a user
> namespace owner or parent namespace that is outside of a processes
> current user namespace or pid namespace.  That way thing stay bounded
> within the current namespaces the process is in.  Which prevents any
> leak possibilities, and keeps CRIU working.

I prepared patches with ioctl-s to understand how it looks like.

Here is a whole series:
https://github.com/avagin/linux-task-diag/commits/namespaces

Here is a patch to get an owning user namespace:
https://github.com/avagin/linux-task-diag/commit/7fad8ff3fc4110bebf0920cec2388390b3bd2238
https://github.com/avagin/linux-task-diag/commit/2663bc803d324785e328261f3c07a0fef37d2088

Here is an example how it looks from user-space:
https://github.com/avagin/linux-task-diag/blob/namespaces/tools/testing/selftests/nsfs/owner.c#L49

I like the idea with ioctl-s. James, Michael, Trevor, what is your
opinion about this?

> 
> Eric
