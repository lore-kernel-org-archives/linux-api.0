From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v8] seccomp, ptrace: add support for dumping seccomp filters
Date: Mon, 26 Oct 2015 16:07:01 +0900
Message-ID: <CAGXu5jKj22-obrjhULdYx5+rEzNESHxLh6VZAbWugKr_LzA7kg@mail.gmail.com>
References: <1445370612-18843-1-git-send-email-tycho.andersen@canonical.com>
	<1445370612-18843-2-git-send-email-tycho.andersen@canonical.com>
	<20151020202024.GA5772@redhat.com>
	<20151020220814.GA3232@hopstrocity>
	<20151021185146.GA27176@redhat.com>
	<20151021191533.GD30729@hopstrocity>
	<20151021210756.GA641@redhat.com>
	<20151021213306.GF30729@hopstrocity>
	<20151025153943.GA1912@redhat.com>
	<CAGXu5jLH++bDe-yf=jVxSxqO0FFLtpGnme9TFp2s-uPSZ4jbSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jLH++bDe-yf=jVxSxqO0FFLtpGnme9TFp2s-uPSZ4jbSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 26, 2015 at 3:46 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Mon, Oct 26, 2015 at 12:39 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On 10/21, Tycho Andersen wrote:
>>>
>>> > And this leads to another question... If we expect that this interface
>>> > can change later, then perhaps PTRACE_SECCOMP_GET_FILTER should also
>>> > dump some header before copy_to_user(fprog->filter) ? Say, just
>>> > "unsigned long version" == 0 for now. So that we can avoid
>>> > PTRACE_SECCOMP_GET_FILTER_V2 in future.
>>>
>>> So this is interesting. Like Kees mentioned, the bulk of the work
>>> would be done by the bpf syscall. We'd still need some way to get
>>> access to the fd itself, which we could (ab)use
>>> PTRACE_SECCOMP_GET_FILTER for, by returning the fd + BPF_MAXINSNS (so
>>> that it doesn't conflict with length) or something like that. Or add a
>>> _V2 as you say. If there is some change we can make to have a nicer
>>> interface than fd + BPF_MAXINSNS to future proof, I'm fine with making
>>> it.
>>
>> Can't comment, this is up to you/Kees ;)
>>
>> So, just in case, let me repeat I am fine with this patch.
>
> Cool, thanks. I'll get this into my tree after kernel summit. Thanks
> for suffering through all this Tycho!

Actually, since this depends on changes in net, could this get pulled
in from that direction?

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-Kees

-- 
Kees Cook
Chrome OS Security
