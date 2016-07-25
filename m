From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
 between namespaces
Date: Mon, 25 Jul 2016 09:54:45 -0500
Message-ID: <20160725145445.GA19879@mail.hallyn.com>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
 <c9bdaf3d-ec93-d754-81ac-9f524a0d0954@gmail.com>
 <20160721210650.GA10989@outlook.office365.com>
 <1515f5f2-5a49-fcab-61f4-8b627d3ba3e2@gmail.com>
 <CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
 <e2811bf1-4b86-e115-bcdb-301d6f2546eb@gmail.com>
 <87lh0pg8jx.fsf@x220.int.ebiederm.org>
 <44ca0e41-dc92-45b1-2a6c-c41a048a072d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <44ca0e41-dc92-45b1-2a6c-c41a048a072d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Michael Kerrisk (man-pages) (mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
> Hi Eric,
>=20
> On 07/25/2016 03:18 PM, Eric W. Biederman wrote:
> >"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> >
> >>Hi Andrey,
> >>
> >>On 07/22/2016 08:25 PM, Andrey Vagin wrote:
> >>>On Thu, Jul 21, 2016 at 11:48 PM, Michael Kerrisk (man-pages)
> >>><mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>>>Hi Andrey,
> >>>>
> >>>>
> >>>>On 07/21/2016 11:06 PM, Andrew Vagin wrote:
> >>>>>
> >>>>>On Thu, Jul 21, 2016 at 04:41:12PM +0200, Michael Kerrisk (man-p=
ages)
> >>>>>wrote:
> >>>>>>
> >>>>>>Hi Andrey,
> >>>>>>
> >>>>>>On 07/14/2016 08:20 PM, Andrey Vagin wrote:
> >>>>>
> >>>>>
> >>>>><snip>
> >>>>>
> >>>>>>
> >>>>>>Could you add here an of the API in detail: what do these FDs r=
efer to,
> >>>>>>and how do you use them to solve the use case? And could you yo=
u add
> >>>>>>that info to the commit messages please.
> >>>>>
> >>>>>
> >>>>>Hi Michael,
> >>>>>
> >>>>>A patch for man-pages is attached. It adds the following text to
> >>>>>namespaces(7).
> >>>>>
> >>>>>Since  Linux 4.X, the following ioctl(2) calls are supported for=
 names=E2=80=90
> >>>>>pace file descriptors.  The correct syntax is:
> >>>>>
> >>>>>      fd =3D ioctl(ns_fd, ioctl_type);
> >>>>>
> >>>>>where ioctl_type is one of the following:
> >>>>>
> >>>>>NS_GET_USERNS
> >>>>>      Returns a file descriptor that refers to an owning  user  =
names=E2=80=90
> >>>>>      pace.
> >>>>>
> >>>>>NS_GET_PARENT
> >>>>>      Returns  a  file  descriptor  that refers to a parent name=
space.
> >>>>>      This ioctl(2) can be used for pid and user namespaces. For=
  user
> >>>>>      namespaces,  NS_GET_PARENT and NS_GET_USERNS have the same=
 mean=E2=80=90
> >>>>>      ing.
> >>
> >>For each of the above, I think it is worth mentioning that the
> >>close-on-exec flag is set for the returned file descriptor.
> >
> >Hmm.  That is an odd default.
>=20
> Why do you say that? It's pretty common as the default for various
> APIs that create new FDs these days. (There's of course a strong argu=
ment
> that the original UNIX default was a design blunder...)
>=20
> >>>>>
> >>>>>In addition to generic ioctl(2) errors, the following specific o=
nes can
> >>>>>occur:
> >>>>>
> >>>>>EINVAL NS_GET_PARENT was called for a nonhierarchical namespace.
> >>>>>
> >>>>>EPERM  The  requested  namespace  is  outside  of the current na=
mespace
> >>>>>      scope.
> >>
> >>Perhaps add "and the caller does not have CAP_SYS_ADMIN" in the ini=
tial
> >>user namespace"?
> >
> >Having looked at that bit of code I don't think capabilities really
> >have a role to play.
>=20
> Yes, I caught up with that now. I await to see how this plays out
> in the next patch version.

Thanks - that had caught my eye but I hadn't had time to look into the
justification for this.  Hiding this kind of thing indeed seems wrong t=
o
me, unless there is a really good justification for it, i.e. a way
to use that info in an exploit.
