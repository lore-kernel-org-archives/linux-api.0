From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v4] seccomp: add ptrace options for suspend/resume
Date: Wed, 10 Jun 2015 14:57:07 -0600
Message-ID: <20150610205707.GO3160@smitten>
References: <1433897388-9567-1-git-send-email-tycho.andersen@canonical.com>
 <CAGXu5jKuf6PoBDDkr21ZHOMnWpRAZ-G=NA7rVMx_1qiHZ-8DzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKuf6PoBDDkr21ZHOMnWpRAZ-G=NA7rVMx_1qiHZ-8DzA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 10, 2015 at 01:33:21PM -0700, Kees Cook wrote:
>
> And if I've convinced Andy to be okay with this patch, consider v4:
> 
> Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Thanks, I'm happy to send a v5 with checking seccomp (and
->ptrace & PT_SUSPEND_SECCOMP) if you'd feel better with that, Andy.

Tycho
