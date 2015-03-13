From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit
 notification via fd
Date: Fri, 13 Mar 2015 15:38:58 -0700
Message-ID: <CALCETrXs8Ne8hMSzQidOr0RvHhPi5PMncK93DAoT098nZYbSXQ@mail.gmail.com>
References: <cover.1426180120.git.josh@joshtriplett.org> <9c39c576e1d9a9912b4aec54d833a73a84d2f592.1426180120.git.josh@joshtriplett.org>
 <20150313162113.GA25966@redhat.com> <20150313195707.GA10487@cloud>
 <CALCETrVkZVa6zsd6gpW_AnQSO2cC___U8M3Dc7c6=PJdEiT9Pg@mail.gmail.com>
 <20150313222052.GC10954@cloud> <CALCETrVRqgsbpi9pPRwy42cuXiDzyPgWRJmfSRSQM7eGFfsZYA@mail.gmail.com>
 <20150313223409.GE10954@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150313223409.GE10954@cloud>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Thiago Macieira <thiago.macieira@intel.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 3:34 PM,  <josh@joshtriplett.org> wrote:
> On Fri, Mar 13, 2015 at 03:28:26PM -0700, Andy Lutomirski wrote:
>> On Fri, Mar 13, 2015 at 3:20 PM,  <josh@joshtriplett.org> wrote:
>> > On Fri, Mar 13, 2015 at 02:34:58PM -0700, Andy Lutomirski wrote:
>> >> On Fri, Mar 13, 2015 at 12:57 PM,  <josh@joshtriplett.org> wrote:
>> >> > A process launching a new process with CLONE_FD is explicitly requesting
>> >> > that the process be automatically reaped without any other process
>> >> > having to wait on it.  The task needs to not become a zombie, because
>> >> > otherwise, it'll show up in waitpid(-1, ...) calls in the parent
>> >> > process, which would break the ability to use this to completely
>> >> > encapsulate process management within a library and not interfere with
>> >> > the parent's process handling via SIGCHLD and wait{pid,3,4}.
>> >>
>> >> Wouldn't the correct behavior be to keep it alive as a zombie but
>> >> *not* show it in waitpid, etc?
>> >
>> > That's a significant change to the semantics of waitpid.  And then
>> > someone would still need to wait on the process, which we'd like to
>> > avoid.  (We don't want to have magic "reap on read(2)" semantics,
>> > because among other things, what if we add a means in the future to get
>> > an additional file descriptor corresponding to an existing process?)
>>
>> Do we not already have a state "dead, successfully waited on by
>> parent, but still around because ptraced"?  If not, shouldn't we?
>> Isn't that what PTRACE_SEIZE does?  Or am I just confused?
>
> I don't think that affects the task's exit_state though.
>

That's a question for Oleg.  I have no idea how ptrace is actually implemented.

--Andy

> - Josh Triplett



-- 
Andy Lutomirski
AMA Capital Management, LLC
