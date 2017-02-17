From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC 1/2] fs,eventpoll: Add ability to install target file by its number
Date: Fri, 17 Feb 2017 08:52:59 -0800
Message-ID: <CALCETrUOaNaS6yAhLM9jLb8PD2eg2ZwXfu4v327aAOy82SbLwg@mail.gmail.com>
References: <20170217083324.627615532@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170217083324.627615532-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kirill Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 17, 2017 at 12:30 AM, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> When we checkpoint a process we look into /proc/<pid>/fdinfo/<fd> of eventpoll
> file and parse target files list from there. In most situations this is fine
> because target file is present in the /proc/<pid>/fd/ list. But in case if file
> descriptor was dup'ed or transferred via unix socket and closed after,
> it might not be in the list and we can't figure out which file descriptor
> to pass into epoll_ctl call.
>
> To resolve this tie lets add EPOLL_CTL_DUP operation which simply takes
> target file descriptor number and installs it into a caller's file table,
> thus we can use kcmp() syscall and figure out which exactly file to be
> added into eventpoll on restore procedure.

This is a scary thing to let an unprivileged process do.

I'm wondering if there might be a nicer way to address this using a
better interface in /proc.
