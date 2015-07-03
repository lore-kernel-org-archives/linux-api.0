From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC 0/8] Additional kmsg devices
Date: Fri, 3 Jul 2015 09:57:52 -0700
Message-ID: <CALCETrW2RbX928+TA6YWENNKAx+KY0bjTPHdk72QmPiwphJ1BQ@mail.gmail.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
 <CAFLxGvxvaePEyCpLrB1cjNn4bvnCwt-_HE3zcT-6diMYNOraBw@mail.gmail.com> <5596A58F.7090208@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5596A58F.7090208-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 3, 2015 at 8:09 AM, Marcin Niesluchowski
<m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
>
> * Message credibility: Lets imagine simple service which collects logs via
> unix sockets. There is no reliable way of identifying logging process.
> getsockopt() with SO_PEERCRED option would give pid form cred structure, but
> according to manual it may not be of actual logging process:
>   "The returned credentials are those that were in effect at the time of the
> call to connect(2) or socketpair(2)."
>       - select(7)

There's SCM_CREDENTIALS, which is dangerous, but it's dangerous in
exactly the same way that your patches are dangerous.  You're
collecting PID/TID when write(2) is called, and it's very easy to get
another process to call write(2) on your behalf, because write(2)
isn't supposed to collect credentials.

--Andy
