From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2] seccomp: add ptrace options for suspend/resume
Date: Thu, 4 Jun 2015 11:12:07 -0700
Message-ID: <CAGXu5jKNpty2cTJNTzYALtF3hZWwwh4+tZespPcYQAcJrYo8JQ@mail.gmail.com>
References: <1433369396-13360-1-git-send-email-tycho.andersen@canonical.com>
	<CAGXu5jLBm6ZBptsDTrNV6OrFSwoZ__k3867-Ji+6oYuTQ8ncWQ@mail.gmail.com>
	<20150604171501.GI3160@smitten>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150604171501.GI3160@smitten>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 4, 2015 at 10:15 AM, Tycho Andersen
<tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> On Thu, Jun 04, 2015 at 09:44:36AM -0700, Kees Cook wrote:
>> On Wed, Jun 3, 2015 at 3:09 PM, Tycho Andersen
>> <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
>> > This patch is the first step in enabling checkpoint/restore of processes
>> > with seccomp enabled.
>> >
>> > One of the things CRIU does while dumping tasks is inject code into them
>> > via ptrace to collect information that is only available to the process
>> > itself. However, if we are in a seccomp mode where these processes are
>> > prohibited from making these syscalls, then what CRIU does kills the task.
>> >
>> > This patch adds a new ptrace option, PTRACE_O_SUSPEND_SECCOMP, that enables
>> > a task from the init user namespace which has CAP_SYS_ADMIN and no seccomp
>> > filters to disable (and re-enable) seccomp filters for another task so that
>> > they can be successfully dumped (and restored). We restrict the set of
>> > processes that can disable seccomp through ptrace because although today
>> > ptrace can be used to bypass seccomp, there is some discussion of closing
>> > this loophole in the future and we would like this patch to not depend on
>> > that behavior and be future proofed for when it is removed.
>> >
>> > Note that seccomp can be suspended before any filters are actually
>> > installed; this behavior is useful on criu restore, so that we can suspend
>> > seccomp, restore the filters, unmap our restore code from the restored
>> > process' address space, and then resume the task by detaching and have the
>> > filters resumed as well.
>> >
>> > v2 changes:
>> >
>> > * require that the tracer have no seccomp filters installed
>> > * drop TIF_NOTSC manipulation from the patch
>> > * change from ptrace command to a ptrace option and use this ptrace option
>> >   as the flag to check. This means that as soon as the tracer
>> >   detaches/dies, seccomp is re-enabled and as a corrollary that one can not
>> >   disable seccomp across PTRACE_ATTACHs.
>>
>> This feature gives me the creeps, but I think it's okay.
>
> :D
>
>> Could it be
>> further restricted so that the process doing the suspension is already
>> ptracing the target?
>
> As far as I understand it you do have to PTRACE_{ATTACH,SEIZE} to the
> target before setting options in general. Is that not what you mean
> here?

Ah, true, yes. Okay, ignore me. I was thinking about the mechanism for
setting the flag wrong. :)

-Kees

>
> The rest of the changes sound good, I'll make those and resend.
>
>>
>> Thanks for working on this!
>
> Thanks for the review.
>
> Tycho



-- 
Kees Cook
Chrome OS Security
