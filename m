From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Review of ptrace Yama ptrace_scope description
Date: Sat, 25 Jun 2016 09:30:43 +0200
Message-ID: <a80772d7-f52a-0943-de24-a0cf8d6b2f7c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Kees,

So, last year, I added some documentation to ptrace(2) to describe
the Yama ptrace_scope file. I don't think I asked you for review
at the time, but in the light of other changes to the ptrace(2)
page, it occurred to me that it might be a good idea to ask you
to check the text below to see if anything is missing or could be
improved. Might you have a moment for that?

    /proc/sys/kernel/yama/ptrace_scope
        On systems with the Yama Linux Security Module (LSM)  installed
        (i.e.,  the  kernel  was configured with CONFIG_SECURITY_YAMA),
        the /proc/sys/kernel/yama/ptrace_scope  file  (available  since
        Linux  3.4)  can  be  used  to  restrict the ability to trace a
        process with ptrace(2) (and thus also the ability to use  tools
        such  as  strace(1) and gdb(1)).  The goal of such restrictions
        is to prevent attack escalation whereby a  compromised  process
        can  ptrace-attach  to  other  sensitive processes (e.g., a GPG
        agent or an SSH session) owned by the user  in  order  to  gain
        additional credentials and thus expand the scope of the attack.

        More precisely, the Yama LSM limits two types of operations:

        *  Any   operation   that   performs   a   ptrace  access  mode
           PTRACE_MODE_ATTACH     check=E2=80=94for      example,      =
ptrace()
           PTRACE_ATTACH.   (See the "Ptrace access mode checking" dis=E2=
=80=90
           cussion above.)

        *  ptrace() PTRACE_TRACEME.

        A process that has the CAP_SYS_PTRACE capability can update the
        /proc/sys/kernel/yama/ptrace_scope file with one of the follow=E2=
=80=90
        ing values:

        0 ("classic ptrace permissions")
               No additional restrictions on  operations  that  perform
               PTRACE_MODE_ATTACH  checks  (beyond those imposed by the
               commoncap and other LSMs).

               The use of PTRACE_TRACEME is unchanged.

        1 ("restricted ptrace") [default value]
               When   performing   an   operation   that   requires   a
               PTRACE_MODE_ATTACH  check, the calling process must have
               a predefined relationship with the target  process.   By
               default,  the predefined relationship is that the target
               process must be a child of the caller.

               A target process can employ the prctl(2)  PR_SET_PTRACER
               operation  to declare a different PID that is allowed to
               perform PTRACE_MODE_ATTACH  operations  on  the  target.
               See   the   kernel   source   file   Documentation/secu=E2=
=80=90
               rity/Yama.txt for further details.

               The use of PTRACE_TRACEME is unchanged.

        2 ("admin-only attach")
               Only processes with the  CAP_SYS_PTRACE  capability  may
               perform  PTRACE_MODE_ATTACH operations or trace children
               that employ PTRACE_TRACEME.

        3 ("no attach")
               No process may perform PTRACE_MODE_ATTACH operations  or
               trace children that employ PTRACE_TRACEME.

               Once  this value has been written to the file, it cannot
               be changed.

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
