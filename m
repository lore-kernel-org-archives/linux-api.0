From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
	between namespaces
Date: Thu, 21 Jul 2016 14:06:50 -0700
Message-ID: <20160721210650.GA10989@outlook.office365.com>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
	<c9bdaf3d-ec93-d754-81ac-9f524a0d0954@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c9bdaf3d-ec93-d754-81ac-9f524a0d0954-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 21, 2016 at 04:41:12PM +0200, Michael Kerrisk (man-pages) wro=
te:
> Hi Andrey,
>=20
> On 07/14/2016 08:20 PM, Andrey Vagin wrote:

<snip>

>=20
> Could you add here an of the API in detail: what do these FDs refer to,
> and how do you use them to solve the use case? And could you you add
> that info to the commit messages please.

Hi Michael,

A patch for man-pages is attached. It adds the following text to
namespaces(7).

Since  Linux 4.X, the following ioctl(2) calls are supported for names=E2=
=80=90
pace file descriptors.  The correct syntax is:

      fd =3D ioctl(ns_fd, ioctl_type);

where ioctl_type is one of the following:

NS_GET_USERNS
      Returns a file descriptor that refers to an owning  user  names=E2=80=
=90
      pace.

NS_GET_PARENT
      Returns  a  file  descriptor  that refers to a parent namespace.
      This ioctl(2) can be used for pid and user namespaces. For  user
      namespaces,  NS_GET_PARENT and NS_GET_USERNS have the same mean=E2=80=
=90
      ing.

In addition to generic ioctl(2) errors, the following specific ones can
occur:

EINVAL NS_GET_PARENT was called for a nonhierarchical namespace.

EPERM  The  requested  namespace  is  outside  of the current namespace
      scope.

ENOENT ns_fd refers to the init namespace.

Thanks,
Andrew

>=20
> Thanks,
>=20
> Michael
>=20
>=20
> > [1] https://lkml.org/lkml/2016/7/6/158
> > [2] https://lkml.org/lkml/2016/7/9/101
> >=20
> > Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> > Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> > Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
> > Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> > Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> >=20
> > --
> > 2.5.5
> >=20
> >=20
>=20
>=20
> --=20
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: attachment;
	filename="0001-namespace.7-descirbe-NS_GET_USERNS-and-NS_GET-PARENT.patch"

>From 4b9194026f901c2247150bb3038c41658700f6dd Mon Sep 17 00:00:00 2001
From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Date: Thu, 21 Jul 2016 13:58:06 -0700
Subject: [PATCH] namespace.7: descirbe NS_GET_USERNS and NS_GET-PARENT ioctl-s

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 man7/namespaces.7 | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/man7/namespaces.7 b/man7/namespaces.7
index 98ed3e5..207e4a5 100644
--- a/man7/namespaces.7
+++ b/man7/namespaces.7
@@ -149,6 +149,49 @@ even if all processes in the namespace terminate.
 The file descriptor can be passed to
 .BR setns (2).
 
+Since Linux 4.X, the following
+.BR ioctl (2)
+calls are supported for namespace file descriptors.
+The correct syntax is:
+.PP
+.RS
+.nf
+.IB fd " = ioctl(" ns_fd ", " ioctl_type ");"
+.fi
+.RE
+.PP
+where
+.I ioctl_type
+is one of the following:
+.TP
+.B NS_GET_USERNS
+Returns a file descriptor that refers to an owning user namespace.
+.TP
+.B NS_GET_PARENT
+Returns a file descriptor that refers to a parent namespace. This
+.BR ioctl (2)
+can be used for pid and user namespaces. For user namespaces,
+.B NS_GET_PARENT
+and
+.B NS_GET_USERNS
+have the same meaning.
+.PP
+In addition to generic
+.BR ioctl (2)
+errors, the following specific ones can occur:
+.PP
+.TP
+.B EINVAL
+.B NS_GET_PARENT
+was called for a nonhierarchical namespace.
+.TP
+.B EPERM
+The requested namespace is outside of the current namespace scope.
+.TP
+.B ENOENT
+.IB ns_fd
+refers to the init namespace.
+.PP
 In Linux 3.7 and earlier, these files were visible as hard links.
 Since Linux 3.8, they appear as symbolic links.
 If two processes are in the same namespace, then the inode numbers of their
-- 
2.5.5


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--GvXjxJ+pjyke8COw--
