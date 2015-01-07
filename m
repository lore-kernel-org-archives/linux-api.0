From: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Edited seccomp.2 man page for review [v2]
Date: Wed, 07 Jan 2015 13:23:37 +0100
Message-ID: <54AD2549.9040107@redhat.com>
References: <54A29722.1010901@gmail.com>	<CAGXu5j+C0SWQ+CeOb2ADXdsLWorUHahX4UhUg+UGbT6UuWiQFQ@mail.gmail.com>	<54A300D0.7090802@gmail.com> <CAGXu5jKCR8ft=2XNX+SsCOokEqCt9sZizKj4wfAGrXVzf6adcg@mail.gmail.com> <54AD1E37.8020509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54AD1E37.8020509-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/07/2015 12:53 PM, Michael Kerrisk (man-pages) wrote:
...
> Still hoping to hear from Will Drewy regarding this FIXME in the
> page source:
>
> .\" FIXME What is the significance of the line
> .\"           ftest->code = BPF_LDX | BPF_W | BPF_ABS;
> .\"       in kernel/seccomp.c::seccomp_check_filter()?

This came in from our rework via commit bd4cf0ed331a ("net: filter:
rework/optimize internal BPF interpreter's instruction set"), and
is kernel-internal only, and unused in classic BPF. It translates
into A = *(u32 *) (ctx + K) and will basically load an offset from
the populated seccomp_data (= ctx) to A. For the man-page itself
it has therefore no relevance, hope that clarifies it.

Cheers,
Daniel
