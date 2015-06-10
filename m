From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] seccomp: add ptrace options for suspend/resume
Date: Wed, 10 Jun 2015 21:20:10 +0200
Message-ID: <20150610192010.GA12697@redhat.com>
References: <1433897388-9567-1-git-send-email-tycho.andersen@canonical.com> <CALCETrVuNzZRAw40reo_2ne9saO5KbbG-omFUQXDo=+XFhpuWA@mail.gmail.com> <20150610163149.GA5092@redhat.com> <CALCETrX_GXgjPRXXT4jMZtjR6vMQrmYbk_OwrAoxaJWFT0+0Fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrX_GXgjPRXXT4jMZtjR6vMQrmYbk_OwrAoxaJWFT0+0Fw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/10, Andy Lutomirski wrote:
>
> On Wed, Jun 10, 2015 at 9:31 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Andy, I simply can't understand why do we need any security check at all.
...
> I think we
> should take the more paranoid approach to start and relax it later as
> needed.

OK. I didn't really tried to argue. I actually replied to other part
of you email, and simply could not resist ;)

Oleg.
