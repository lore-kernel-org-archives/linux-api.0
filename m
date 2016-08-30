From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers
 per syscall
Date: Tue, 30 Aug 2016 16:58:30 -0400
Message-ID: <20160830165830.5e494c43@gandalf.local.home>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
        <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com>
        <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com>
        <CALCETrWy5cUDJmTVrjSSqWHc4KyxTPjoD7yU7iqTSHfkK4UwvA@mail.gmail.com>
        <20160830152955.17633511@gandalf.local.home>
        <CALCETrXA0XbYuqYzWMJA+KjFS31YL0cTVtrvCnmRY_GMK6oNpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXA0XbYuqYzWMJA+KjFS31YL0cTVtrvCnmRY_GMK6oNpw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Marcin Nowakowski <marcin.nowakowski@imgtec.com>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, open list <linux-kernel@vger.kernel.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>
List-Id: linux-api@vger.kernel.org

On Tue, 30 Aug 2016 12:53:53 -0700
Andy Lutomirski <luto@amacapital.net> wrote:


> Egads!  OK, I see why this is a mess.

:-)

> 
> I guess we should be creating the metadata from the syscall tables
> instead of from the syscall definitions, but I guess that's currently
> a nasty per-arch mess.

Yep.

> 
> Could we at least have an array of (arch, nr) instead of just an array
> of nrs in the metadata?

I guess I'm not following you on what would be used for "arch".

-- Steve
