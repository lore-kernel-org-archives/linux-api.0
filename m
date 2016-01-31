From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Sun, 31 Jan 2016 09:00:59 -0800
Message-ID: <CALCETrU1sB4FDkyrGcxY0CrCRr7qyGW0tzmpyaQDwM0UTjCRMw@mail.gmail.com>
References: <56AE3369.2090709@list.ru> <56AE3626.7080706@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56AE3626.7080706-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Cc: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jan 31, 2016 at 8:28 AM, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>
> linux implements the sigaltstack() in a way that makes it impossible to
> use with swapcontext(). Per the man page, sigaltstack is allowed to return
> EPERM if the process is altering its sigaltstack while running on
> sigaltstack.
> This is likely needed to consistently return oss->ss_flags, that indicates
> whether the process is being on sigaltstack or not.
> Unfortunately, linux takes that permission to return EPERM too literally:
> it returns EPERM even if you don't want to change to another sigaltstack,
> but only want to temporarily disable sigaltstack with SS_DISABLE.
> You can't use swapcontext() without disabling sigaltstack first, or the
> stack will be re-used and overwritten by a subsequent signal.
>
> With this patch, disabling sigaltstack inside a signal handler became
> possible, and the swapcontext() can then be used safely. After switching
> back to the sighandler, the app can re-enable the sigatlstack.
> The oss->ss_flags will correctly indicate the current use of sigaltstack,
> even if it is temporarily disabled. Any attempt to modify the sigaltstack
> (rather than to disable or re-enable it) within the sighandler, will still
> be punished with EPERM as suggested by POSIX.

This seems considerably more complicated than my previous proposal to
add an SS_FORCE flag to say "I know what I'm doing.  Ignore POSIX and
let me change the sigaltstack configuration even if it's in use".
What's the advantage?

--Andy
