From: Elvira Khabirova <lineprinter-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH RESEND v3 1/3] ptrace: pass type of a syscall-stop in
 ptrace_message
Date: Tue, 27 Nov 2018 03:53:57 +0100
Message-ID: <20181127035357.0b381323@akathisia>
References: <20181125022150.46258a20@akathisia>
 <20181125022227.55e8caf7@akathisia>
 <20181126145643.GD1660@redhat.com>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181126145643.GD1660-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 26 Nov 2018 15:56:43 +0100
Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On 11/25, Elvira Khabirova wrote:
> >
> > + * These values are stored in task->ptrace_message by tracehook_report_syscall_*
> > + * to describe current syscall-stop.
> > + *
> > + * Values for these constants are chosen so that they do not appear
> > + * in task->ptrace_message by other means.
> > + */
> > +#define PTRACE_EVENTMSG_SYSCALL_ENTRY	0x80000000U
> > +#define PTRACE_EVENTMSG_SYSCALL_EXIT	0x90000000U  
> 
> Stupid question, why not
> 
> 	#define PTRACE_EVENT_SYSCALL_ENTRY	8
> 	#define PTRACE_EVENT_SYSCALL_EXIT	9
> 
> right after other PTRACE_EVENT_* constants?

I thought about adding new events for syscall {entry,exit}.
For tracers, using new events means setting new options and checking
for new values after waitpid(). They will also have to switch from using
PTRACE_SYSCALL to PTRACE_CONT.
Right now (with this version of the patch) tracers can use
PTRACE_GETEVENTMSG without doing any additional configuration.
More importantly, adding these events would require much more complex
modifications of kernel code than this patch does.
The only benefit I see from adding these events instead of letting
syscall-stops put a value in ptrace_message is an ability to subscribe
to syscall entries, but not to exits, and vice-versa, and I don't think
it is worth it.
-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel
