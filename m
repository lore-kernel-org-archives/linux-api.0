From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
Date: Fri, 2 Jun 2017 13:18:22 -0500
Message-ID: <20170602181822.GA5125@mail.hallyn.com>
References: <20170531005633.484a2e14@alans-desktop>
 <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
 <20170601140812.583cf0a5@alans-desktop>
 <CAGXu5jLefv=T3mCYryqh2pYjYonFsTQZSLsHqLK75CKvSmgb-w@mail.gmail.com>
 <20170601222432.6f593538@lxorguk.ukuu.org.uk>
 <2d0ad49c-886e-1caf-771a-d251957f614c@nmatt.com>
 <20170602153647.GA2688@mail.hallyn.com>
 <a3c1b792-a426-90e1-e37b-9f9a8d4d192a@nmatt.com>
 <20170602165732.GA3614@mail.hallyn.com>
 <3027e4fa-5dc2-a52f-8699-9974cb4d4b6b@nmatt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3027e4fa-5dc2-a52f-8699-9974cb4d4b6b-YiBOUZGZpYMAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Brown <matt-YiBOUZGZpYMAvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Boris Lukashev <blukashev-JNja4Z15B3SvB/ACxS1yDA@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Matt Brown (matt-YiBOUZGZpYMAvxtiuMwx3w@public.gmane.org):
> On 6/2/17 12:57 PM, Serge E. Hallyn wrote:
> > I'm not quite sure what you're asking for here.  Let me offer a precise
> > strawman design.  I'm sure there are problems with it, it's just a starting
> > point.
> > 
> > system-wide whitelist (for now 'may_push_chars') is full by default.
> > 
> 
> So is may_push_chars just an alias for TIOCSTI? Or are there some
> potential whitelist members that would map to multiple ioctls?

<shrug>  I'm seeing it as only TIOCSTI right now.

> > By default, nothing changes - you can use those on your own tty, need
> > CAP_SYS_ADMIN against init_user_ns otherwise.
> > 
> > Introduce a new CAP_TTY_PRIVILEGED.
> > 
> 
> I'm fine with this.
> 
> > When may_push_chars is removed from the whitelist, you lose the ability
> > to use TIOCSTI on a tty - even your own - if you do not have CAP_TTY_PRIVILEGED
> > against the tty's user_ns.
> > 
> 
> How do you propose storing/updating the whitelist? sysctl?
> 
> If it is a sysctl, would each whitelist member have a sysctl?
> e.g.: kernel.ioctlwhitelist.may_push_chars = 1
> 
> Overall, I'm fine with this idea.

That sounds reasonable.  Or a securityfs file - I guess not everyone
has securityfs, but if it were to become part of YAMA then that would
work.

-serge
