From: Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 12:28:56 +0000
Message-ID: <54522F08.7080005@collabora.co.uk>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz> <20141029231106.GB16548@kroah.com> <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz> <20141029234001.GB16520@kroah.com> <CALCETrXY90YAXA9-GLc0EowmRCtWZzh8br8seiqrzOkmNn8_Hw@mail.gmail.com> <CAG-2HqX9RUQHiF1U_CXiDVVLS-7aUOQdYn7EVNSMZNdbe38cTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG-2HqX9RUQHiF1U_CXiDVVLS-7aUOQdYn7EVNSMZNdbe38cTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 30/10/14 11:52, Tom Gundersen wrote:
> For example, if you want to get the audit identity
> bits, you can now get this attached securely by the kernel, at the
> time the message is sent, rather than having to firest get the peer's
> $PID from SCM_CREDENTIALS and then read the audit identity bits racily
> from /proc/$PID/loginuid and /proc/$PID/sessionid

... which dbus-daemon (traditional D-Bus) deliberately doesn't offer as
a feature, because we are not aware of any way to do that over Unix
sockets without a race condition; and if we can't have it securely, we
don't want to have it at all.
<https://bugs.freedesktop.org/show_bug.cgi?id=83499>
It would be great if kdbus can fix that omission.

Capabilities are in the same boat, and as a result, systemd can't
currently have D-Bus methods that can only be called with CAP_WHATEVER.

> * fewer userspace context switches
[...]
> * fewer message copies in userspace

Readers are probably already aware of this, but note that D-Bus is
designed to be usable between mutually distrusting processes, which is
why we use Unix sockets and a lot of copies, rather than mmap or something.

    S
