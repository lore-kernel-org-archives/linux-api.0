From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Sat, 09 Jul 2016 13:15:19 -0500
Message-ID: <87eg72llu0.fsf@x220.int.ebiederm.org>
References: <20160706141348.GB20728@mail.hallyn.com>
	<871t36kbvq.fsf@x220.int.ebiederm.org>
	<20160708015758.GA10512@outlook.office365.com>
	<87vb0gy3nr.fsf@x220.int.ebiederm.org>
	<1467988533.2322.118.camel@HansenPartnership.com>
	<20160708203818.GA2602@outlook.office365.com>
	<5e4cc802-f0e0-4f4c-a2f7-585aaaa8feec@email.android.com>
	<87wpkvpu1i.fsf@x220.int.ebiederm.org>
	<1468023332.2390.10.camel@HansenPartnership.com>
	<87bn27o6j5.fsf@x220.int.ebiederm.org>
	<20160709072627.GA7480@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160709072627.GA7480-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org> (Andrew Vagin's
	message of "Sat, 9 Jul 2016 00:26:28 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:

> All these thoughts about security make me thinking that kcmp is what we
> should use here. It's maybe something like this:
>
> kcmp(pid1, pid2, KCMP_NS_USERNS, fd1, fd2)
>
> - to check if userns of the fd1 namepsace is equal to the fd2 userns
>
> kcmp(pid1, pid2, KCMP_NS_PARENT, fd1, fd2)
>
> - to check if a parent namespace of the fd1 pidns is equal to fd pidns.
>
> fd1 and fd2 is file descriptors to namespace files.
>
> So if we want to build a hierarchy, we need to collect all namespaces
> and then enumerate them to check dependencies with help of kcmp.

That is certainly one way to go.

There is a funny case where we would want to compare a user namespace
file descriptor to a parent user namespace file descriptor.


Grumble, Grumble.  I think this may actually a case for creating ioctls
for these two cases.  Now that random nsfs file descriptors are bind
mountable the original reason for using proc files is not as pressing.

One ioctl for the user namespace that owns a file descriptor.
One ioctl for the parent namespace of a namespace file descriptor.

We also need some way to get a command file descriptor for a file system
super block.  Al Viro has a pet project for cleaning up the mount API
and this might be the idea excuse to start looking at that.

(In principle we might be able to run commands through the namespace
 file descriptor and using an ioctl feels dirty.  But an ioctl that
 only uses the fd and request argument does not suffer from the same
 problems that ioctls that have to pass additional arguments suffer
 from.)

Eric
