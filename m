From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
	between namespaces
Date: Mon, 1 Aug 2016 16:32:49 -0700
Message-ID: <20160801233248.GB32309@outlook.office365.com>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
	<CAMXgnP6j+rTeb5XJgoPV20y8puGyVm=9O9gdg9Sah4DuF5qm9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMXgnP6j+rTeb5XJgoPV20y8puGyVm=9O9gdg9Sah4DuF5qm9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, iago-lYLaGTFnO9sWenYVfaLwtA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alban Crequy <alban-lYLaGTFnO9sWenYVfaLwtA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk
	(man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 01, 2016 at 08:20:27PM +0200, Alban Crequy wrote:
> Hi,
> 
> On 14 July 2016 at 20:20, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> > Each namespace has an owning user namespace and now there is not way
> > to discover these relationships.
> >
> > Pid and user namepaces are hierarchical. There is no way to discover
> > parent-child relationships too.
> >
> > Why we may want to know relationships between namespaces?
> >
> > One use would be visualization, in order to understand the running system.
> 
> This looks interesting to me because I am interested in representing
> in a graphical way the relationship between different mounts in
> different mount namespaces (showing the ID, the parent-children
> relationships, mount peer groups, the master-slave relationships etc),
> specially for containers. The first idea was to take both
> /proc/1/mountinfo and /proc/$OTHER_PID/mountinfo and I can correlate
> the "shared:" and "master:" fields in the mountinfo files.
> 
> But I cannot read the /proc/$pid/mountinfo of mount namespaces when
> there are no processes in those mount namespaces. For example, if
> those mount namespaces stay alive only because they contain
> "shared&slave" mounts between master mounts and slave mounts that I
> can see in /proc/$pid/mountinfo. Fictional example:
> 
> # mntns 1, mountinfo 1 (visible via /proc/1/mountinfo)
> 61 0 253:1 / / rw shared:1
> 
> # mntns 2, mountinfo 2 (not visible via any /proc/$pid/mountinfo)
> 731 569 0:75 / / rw master:1 shared:42
> 
> # mntns 3, mountinfo 3 (not visible via any /proc/${container_pid}/mountinfo)
> 762 597 0:82 / / rw master:42 shared:76
> 
> As far as I understand, I cannot get a reference to the mntns2 fd
> because mnt namespaces are not hierarchical, and I cannot get its
> /proc/???/mountinfo because no processes live inside.

Hi Alban,

A mount namespace is alive only if someone lives in it or if it is
bind-mounted somewhere.

In your case, the kernel destroys mntns2 and adjusts groups for mounts:

[root@fc24 zzz]# nsenter --mount=mnt2 -- cat /proc/self/mountinfo | grep zzz
184 183 0:43 / /tmp/zzz/a rw,relatime shared:72 master:70 - tmpfs a rw
[root@fc24 zzz]# nsenter --mount=mnt3 -- cat /proc/self/mountinfo | grep zzz
162 161 0:43 / /tmp/zzz/a rw,relatime master:72 - tmpfs a rw

[root@fc24 zzz]# umount mnt2
[root@fc24 zzz]# nsenter --mount=mnt3 -- cat /proc/self/mountinfo | grep zzz
162 161 0:43 / /tmp/zzz/a rw,relatime master:70 - tmpfs a rw

Thanks,
Andrew

> 
> Is there a way around it? Should this use case be handled together?
> 
> Thanks!
> Alban
> 
> > Another would be to answer the question: what capability does process X have to
> > perform operations on a resource governed by namespace Y?
> >
> > One more use-case (which usually called abnormal) is checkpoint/restart.
> > In CRIU we age going to dump and restore nested namespaces.
> >
> > There [1] was a discussion about which interface to choose to determing
> > relationships between namespaces.
> >
> > Eric suggested to add two ioctl-s [2]:
> >> Grumble, Grumble.  I think this may actually a case for creating ioctls
> >> for these two cases.  Now that random nsfs file descriptors are bind
> >> mountable the original reason for using proc files is not as pressing.
> >>
> >> One ioctl for the user namespace that owns a file descriptor.
> >> One ioctl for the parent namespace of a namespace file descriptor.
> >
> > Here is an implementaions of these ioctl-s.
> >
> > [1] https://lkml.org/lkml/2016/7/6/158
> > [2] https://lkml.org/lkml/2016/7/9/101
> >
> > Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> > Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> > Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
> > Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> > Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> >
> > --
> > 2.5.5
> >
> > _______________________________________________
> > Containers mailing list
> > Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> > https://lists.linuxfoundation.org/mailman/listinfo/containers
