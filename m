From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] epoll: add exclusive wakeups flag
Date: Thu, 10 Mar 2016 20:47:01 +0100
Message-ID: <56E1CF35.2070005@gmail.com>
References: <cover.1449523436.git.jbaron@akamai.com>
 <56A9C03B.7020104@gmail.com> <56AA56A2.3000700@akamai.com>
 <56AB1F6C.7000609@gmail.com> <56E1C2B5.2040905@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E1C2B5.2040905-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, m@silodev.com, corbet-T1hC0tSOHrs@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hagen-GvnIQ6b/HdU@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Jason,

> Ok, here's some updated text:
>=20
> EPOLLEXCLUSIVE
>=20
> Sets an exclusive wakeup mode for the epfd file descriptor that is be=
ing
> attached to the target file descriptor, fd. When a wakeup event occur=
s
> and multiple epfd file descriptors are attached to the same target fi=
le
> using EPOLLEXCLUSIVE, one or more epfds will receive an event with
> epoll_wait(2). The default in this scenario (when EPOLLEXCLUSIVE is n=
ot
> set) is for all epfds to receive an event.
>=20
> The events supported by EPOLLEXCLUSIVE are: EPOLLIN, EPOLLOUT, EPOLLE=
RR,
> EPOLLHUP, EPOLLWAKEUP, and EPOLLET. epoll_wait(2) will always wait fo=
r
> EPOLLERR and EPOLLHUP; it is not necessary to set it in events. If
> EPOLLEXCLUSIVE is set using epoll_ctl(2), then a subsequent
> EPOLL_CTL_MOD on the same epfd, fd pair will retrun -EINVAL. An
> epoll_ctl(2) that specifies EPOLLEXCLUSIVE in events and specifies th=
e
> target file descriptor fd as an epoll instance will return -EINVAL
> as well.

So, I worked that up into the following text:

       EPOLLEXCLUSIVE (since Linux 4.5)
              Sets  an  exclusive  wakeup  mode  for  the  epoll  file
              descriptor  that  is  being  attached to the target file
              descriptor, fd.  When a wakeup event occurs and multiple
              epoll  file  descriptors are attached to the same target
              file using EPOLLEXCLUSIVE, one or more of the epoll file
              descriptors  will  receive  an event with epoll_wait(2).
              The default in this scenario (when EPOLLEXCLUSIVE is not
              set)  is  for  all  epoll file descriptors to receive an
              event.  EPOLLEXCLUSIVE is thus useful for avoiding thun=E2=
=80=90
              dering herd problems in certain scenarios.

              If  the  same  file  descriptor  is  in  multiple  epoll
              instances, some with the EPOLLEXCLUSIVE flag, and others
              without,   then   events  will  provided  to  all  epoll
              instances that did not specify  EPOLLEXCLUSIVE,  and  at
              least  one  of  the  epoll  instances  that  did specify
              EPOLLEXCLUSIVE.

              The following values may  be  specified  in  conjunction
              with EPOLLEXCLUSIVE: EPOLLIN, EPOLLOUT, EPOLLWAKEUP, and
              EPOLLET.  EPOLLHUP and EPOLLERR can also  be  specified,
              but  are  ignored (as usual).  Attempts to specify other
              values in events yield an error.  EPOLLEXCLUSIVE may  be
              used  only  in  an  EPOLL_CTL_ADD operation; attempts to
              employ  it  with  EPOLL_CTL_MOD  yield  an  error.    If
              EPOLLEXCLUSIVE has set using epoll_ctl(2), then a subse=E2=
=80=90
              quent EPOLL_CTL_MOD on the same epfd, fd pair yields  an
              error.  An epoll_ctl(2) that specifies EPOLLEXCLUSIVE in
              events and specifies the target file descriptor fd as an
              epoll  instance will likewise fail.  The error in all of
              these cases is EINVAL.

   ERRORS
       EINVAL An invalid event type was specified along with  EPOLLEX=E2=
=80=90
              CLUSIVE in events.

       EINVAL op was EPOLL_CTL_MOD and events included EPOLLEXCLUSIVE.

       EINVAL op  was  EPOLL_CTL_MOD  and  the EPOLLEXCLUSIVE flag has
              previously been applied to this epfd, fd pair.

       EINVAL EPOLLEXCLUSIVE was specified in event and fd  is  refers
              to an epoll instance.

Is there anything that needs to be fixed in the above text?

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
