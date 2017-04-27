From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
Date: Thu, 27 Apr 2017 16:42:48 -0700
Message-ID: <CAGXu5jJc3LBKWaPCx-PoXa6kzOwp8m6je+Q_kuqN9c9L-D4FOQ@mail.gmail.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
 <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ@mail.gmail.com>
 <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw@mail.gmail.com>
 <CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w@mail.gmail.com>
 <ac79529e-f6b6-690c-e597-5adeb75b0f25@canonical.com> <CAGXu5j+qUOpnDeF4TMH2AXXgHZB_WfHHfxe3TBSShmneisR-Lg@mail.gmail.com>
 <a914076f-efb8-d867-f480-69addca4e628@canonical.com> <CAGXu5j+x-4E8z0TK6je9oLa6yLENzQ30jNH2dXsFkGdzTUaSsQ@mail.gmail.com>
 <0b1a2337-7006-e7cb-f519-dec389ede041@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0b1a2337-7006-e7cb-f519-dec389ede041-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 27, 2017 at 3:17 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> Quick update... I finished the move from the high-water mark
> log_max_action sysctl to the bitmask based actions_logged sysctl.

Awesome!

> Unfortunately, I've just realized that SECCOMP_SET_LOGGING, or any
> process-wide logging configuration mechanism, will not work. It is fine
> for the situation where two unrelated processes set up seccomp filters
> that should be logged differently. However, it fails when two closely
> related processes, such as parent and child, need to set up seccomp
> filters that should be logged differently. Imagine a launcher that sets
> up an application sandbox (including a seccomp filter) and then launches
> an electron app which will have its own seccomp filter for sandboxing
> untrusted code that it runs. Unless the launcher and app completely
> agree on actions that should be logged, the logging won't work as
> intended for both processes.

Oh, you mean the forked process sets up the logging it wants for the
filters it just installed, then after exec a process sets up new
logging requirements?

> I think this needs to be configured at the filter level.

I'm not sure that's even the right way to compose the logging desires.

So, my initial thought was "whatever ran SECCOMP_SET_LOGGING knows
what it's doing" and it should be the actual value.

If the launcher wants logs of everything the application does with its
filters, then a purely-tied-to-filter approach won't work either.

Perhaps log bits can only be enabled? I.e. SECCOMP_SET_LOGGING
performs an OR instead of an assignment?

-Kees

-- 
Kees Cook
Pixel Security
