From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 4/5] pidfd: add CLONE_WAIT_PID
Date: Thu, 25 Jul 2019 14:26:51 +0200
Message-ID: <20190725122650.4i3arct5rpchqmyt@brauner.io>
References: <20190724144651.28272-1-christian@brauner.io>
 <20190724144651.28272-5-christian@brauner.io>
 <20190725103543.GF4707@redhat.com>
 <20190725104006.7myahvjtnbcgu3in@brauner.io>
 <20190725112503.GG4707@redhat.com>
 <20190725114359.GH4707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190725114359.GH4707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, joel@joelfernandes.org, tglx@linutronix.de, tj@kernel.org, dhowells@redhat.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, cyphar@cyphar.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, kernel-team@android.com, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 25, 2019 at 01:43:59PM +0200, Oleg Nesterov wrote:
> Or. We can change wait_consider_task() to not clear ->notask_error if
> WXXX and the child is PF_WAIT_PID.
> 
> This way you can "safely" use wait() without WNOHANG, it won't block if
> all the children which can report an even are PF_WAIT_PID.
> 
> But I do not understand your use-cases, I have no idea if this can help

One usecase (among others listed in the commit message) are shared
libraries. P_ALL is usually something you can't really use in a shared
library because you have no idea what else might be fork()ed off. Only
the main program can use this but none of the auxiliary libraries that
it uses.
The other way around you want to be able fork() off something without
affecting P_ALL in the main program.
The key is that you want to be able to create child processes in a
shared library without the main programing having to know about this so
that it can use P_ALL and never get stuff from the library.

Assume you have a project with a main loop with a million things
happening in that mainloop like some gui app running an avi video. For
example, gtk uses gstreamer which forks off all codecs in child
processes which are sandboxed for security. So gstreamer is using helper
processes in the background which are my children now. Now I'm creating
four more additional helper processes as well. Now, in my (glib, qt
whatever) mainloop on SIGCHLD some part of the app is checking with
WNHOANG and finds a process has exited. It's cleaning this thing up now
but it's not a process it wanted to clean up. The other part of the app
is now doing waitid(P_PID, pid) but will find the process already gone
it wanted to reap.

I hope I'm expressing this well enough.
