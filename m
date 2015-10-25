From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8] seccomp, ptrace: add support for dumping seccomp
	filters
Date: Sun, 25 Oct 2015 16:39:43 +0100
Message-ID: <20151025153943.GA1912@redhat.com>
References: <1445370612-18843-1-git-send-email-tycho.andersen@canonical.com> <1445370612-18843-2-git-send-email-tycho.andersen@canonical.com> <20151020202024.GA5772@redhat.com> <20151020220814.GA3232@hopstrocity> <20151021185146.GA27176@redhat.com> <20151021191533.GD30729@hopstrocity> <20151021210756.GA641@redhat.com> <20151021213306.GF30729@hopstrocity>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151021213306.GF30729@hopstrocity>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/21, Tycho Andersen wrote:
>
> > And this leads to another question... If we expect that this interface
> > can change later, then perhaps PTRACE_SECCOMP_GET_FILTER should also
> > dump some header before copy_to_user(fprog->filter) ? Say, just
> > "unsigned long version" == 0 for now. So that we can avoid
> > PTRACE_SECCOMP_GET_FILTER_V2 in future.
>
> So this is interesting. Like Kees mentioned, the bulk of the work
> would be done by the bpf syscall. We'd still need some way to get
> access to the fd itself, which we could (ab)use
> PTRACE_SECCOMP_GET_FILTER for, by returning the fd + BPF_MAXINSNS (so
> that it doesn't conflict with length) or something like that. Or add a
> _V2 as you say. If there is some change we can make to have a nicer
> interface than fd + BPF_MAXINSNS to future proof, I'm fine with making
> it.

Can't comment, this is up to you/Kees ;)

So, just in case, let me repeat I am fine with this patch.

Oleg.
