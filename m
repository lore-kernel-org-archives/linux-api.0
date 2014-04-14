From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Documenting prctl() PR_SET_THP_DISABLE and PR_GET_THP_DISABLE
Date: Mon, 14 Apr 2014 12:15:01 +0200
Message-ID: <CAHO5Pa0VCzR7oqNXkwELuAsNQnnvF8Xoo=CuCaM64-GzjDuoFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gerald Schaefer <gerald.schaefer-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Alex,

Your commit a0715cc22601e8830ace98366c0c2bd8da52af52 added the prctl()
PR_SET_THP_DISABLE and PR_GET_THP_DISABLE flags.

The text below attempts to document these flags for the prctl(3).
Could you (and anyone else who is willing) please review the text
below (one or two p[ieces of which are drawn from your commit message)
to verify that it accurately reflects reality and your intent, and
that I have not missed any significant details.

    DESCRIPTION
    ...
       PR_SET_THP_DISABLE (since Linux 3.15)
              Set the state of the "THP disable" flag for the  calling
              thread.   If  arg2 has a nonzero value, the flag is set,
              otherwise it is cleared.  Setting this flag  provides  a
              method  for disabling  transparent  huge  pages for jobs
              where the code cannot be modified, and  using  a  malloc
              hook  with madvise(2) is not an option (i.e., statically
              allocated data).  The setting of the "THP disable"  flag
              is  inherited by a child created via fork(2) and is pre=E2=
=80=90
              served across execve(2).

       PR_GET_THP_DISABLE (since Linux 3.15)
              Return (via the function result) the current setting  of
              the "THP disable" flag for the calling thread: either 1,
              if the flag is set, or 0, if it is not.
    ...
    RETURN VALUE
       On       success,       PR_GET_DUMPABLE,       PR_GET_KEEPCAPS,
       PR_GET_NO_NEW_PRIVS,    PR_GET_THP_DISABLE,    PR_CAPBSET_READ,
       PR_GET_TIMING,       PR_GET_TIMERSLACK,      PR_GET_SECUREBITS,
       PR_MCE_KILL_GET, and (if it returns) PR_GET_SECCOMP return  the
       nonnegative  values  described  above.  All other option values
       return 0 on success.  On error, -1 is returned,  and  errno  is
       set appropriately.
    ...
    ERRORS
       EINVAL option is PR_SET_THP_DISABLE and arg3, arg4, or arg5  is
              nonzero.

       EINVAL option  is  PR_GET_THP_DISABLE  and arg2, arg3, arg4, or
              arg5 is nonzero.

Thanks,

Michael



--=20
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
