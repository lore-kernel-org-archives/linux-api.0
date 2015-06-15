From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v5] seccomp: add ptrace options for suspend/resume
Date: Mon, 15 Jun 2015 13:19:35 -0700
Message-ID: <CAGXu5jJt93GKadDonjgYkrjh2Z44QyyzxmJwNOt1MVNM9gekJQ@mail.gmail.com>
References: <1434207768-16729-1-git-send-email-tycho.andersen@canonical.com>
	<20150613235250.GA25252@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150613235250.GA25252-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 13, 2015 at 4:52 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 06/13, Tycho Andersen wrote:
>>
>> This patch is the first step in enabling checkpoint/restore of processes
>> with seccomp enabled.
>
> So just in case, I am fine with this version.

Should I add your Ack? Though I really like the idea of a
"Fine-with-this:" tag. ;)

Andy, if you're okay with this too, I'll add it to my seccomp tree.

Thanks again Tycho!

-Kees

-- 
Kees Cook
Chrome OS Security
