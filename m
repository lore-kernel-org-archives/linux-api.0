From: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
Date: Thu, 26 Feb 2009 16:03:52 -0800 (PST)
Message-ID: <20090227000352.7D32BFC339@magilla.sf.frob.com>
References: <20090226133339.875832967@linutronix.de>
	<cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Michael Kerrisk's message of  Friday, 27 February 2009 10:19:08 +1300 <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

I don't see any rationale for rt_tgsigqueueinfo and rt_sigqueueinfo to
differ in their treatment of si_pid/si_uid (whatever that is).  It just
seems like common sense that they would match.

Oleg and/or Sukadev have some patches floating around (maybe all in -mm?)
that relate to setting those.

I notice that POSIX says that si_pid and si_uid have reliable values
whenever si_code <= 0 (what we call SI_FROMUSER() in asm/siginfo.h).
(POSIX only has sigqueue() and kill() et al to send these, so a POSIX
application never explicitly supplies the values.  libc/libpthread do.
The {t,tg,}kill syscalls all set si_pid to tgid already.)
This means a POSIX-conformant application might check si_pid and si_uid and
rely on them not being forged by some other process/user.  Firstly this
means that si_pid must be the POSIX PID, i.e. tgid, not the Linux TID
(which is not a useful value in POSIX interfaces).  Secondly it means the
kernel should guarantee the correctness of these values (at least when
crossing processes, might as well do always).

I don't recall if the pending changes already use tgid, I think they do.

I think what both calls should do is set si_pid to tgid and si_uid to uid
whenever SI_FROMUSER().  This satisfies the POSIX and security trust
concern, and makes them uniform.  (In Sukadev's version, what si_pid value
they fill in here depends on pid_ns details of sender and recipient.)

Vis a vis Sukadev's changes, I also notice that si_uid ought to be
translated for the recipient user_ns.


Thanks,
Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
