From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers per syscall
Date: Mon, 29 Aug 2016 16:55:27 -0700
Message-ID: <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472463007-6469-1-git-send-email-marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mips-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Aug 29, 2016 11:30 AM, "Marcin Nowakowski"
<marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org> wrote:
>
> Syscall metadata makes an assumption that only a single syscall number
> corresponds to a given method. This is true for most archs, but
> can break tracing otherwise.
>
> For MIPS platforms, depending on the choice of supported ABIs, up to 3
> system call numbers can correspond to the same call - depending on which
> ABI the userspace app uses.

MIPS isn't special here.  x86 does the same thing.  Why isn't this a
problem on x86?

Also, you seem to be partially reinventing AUDIT_ARCH here.  Can you
use that and integrate with syscall_get_arch()?

--Andy
