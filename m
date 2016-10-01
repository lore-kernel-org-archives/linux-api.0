From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/3] proc: Stop reporting eip and esp in /proc/PID/stat
Date: Fri, 30 Sep 2016 21:22:08 -0700
Message-ID: <CA+55aFxZkzC4uCXgL3BEGbbobtm0-n8FoNnswx5s=+8PNsGo2w@mail.gmail.com>
References: <cover.1475257877.git.luto@kernel.org> <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
 <20160930185642.GH14666@pc.thejh.net> <CALCETrUBmsoUK5Shkjwo6n=BGaHFtZhhUZ=2uOcAzWUend-BXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUBmsoUK5Shkjwo6n=BGaHFtZhhUZ=2uOcAzWUend-BXg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 30, 2016 at 7:01 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>
> Peter, how nasty would it be to add some lightish-weight lock that
> lets us pin a task in a non-running state?  Maybe we could take the rq
> lock, do something to the task to make it sleepy (steal it off the
> queue?), unlock the lock, do whatever we're going, then take the lock
> again and put it back.

No. Don't do this. Forcing some sleeping lock in the core task state
/proc stuff is a nightmare. That thing ends up being used very heavily
under some loads. No _way_ is it ok to synchronize with the target
task.

> Or if we had a seqlock-like thing, we could maybe arrange for
> get_wchan to abort if the task get scheduled between when it starts
> and when it finishes.

seq_lock might be ok, but do we even need it? What's the worst that
can happen? An odd symbol name showing up in a race condition? Sounds
like a non-issue to me.

        Linus
