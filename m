From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] fs/proc: report eip/esp in /prod/PID/stat for coredumping
Date: Fri, 15 Sep 2017 12:08:09 -0700
Message-ID: <CA+55aFxgEySMkG=0iO_v9aje7nik6XR3mZYc=4jpNzr9oDqtKA@mail.gmail.com>
References: <87poatfwg6.fsf@linutronix.de> <alpine.DEB.2.20.1709141735420.1916@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1709141735420.1916@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: John Ogness <john.ogness-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Ingo, I'm assuming I'll get this from the -tip tree, which is where I
got the original commit that this fixes.

Thanks,
                   Linus

On Thu, Sep 14, 2017 at 8:37 AM, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> On Thu, 14 Sep 2017, John Ogness wrote:
>
>> Commit 0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in
>> /proc/PID/stat") stopped reporting eip/esp because it is
>> racey and dangerous for executing tasks. The comment adds:
...
>> Partially revert the change and make the readout possible for
>> tasks with the proper permissions and only if the target task
>> has the PF_DUMPCORE flag set.
>
> Duh, I completely forgot about mini core dumper when I acked that commit.
>
> Reviewed-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
