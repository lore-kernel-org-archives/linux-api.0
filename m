From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH RFC 0/1] UAPI,x86: export syscall numbers for all x86 archs
Date: Tue, 28 Jul 2015 08:20:42 -0400
Message-ID: <CAHC9VhRf8b7LRyG1N0t11jQdDbAa_m6-pYjnyb2EHxU0YoJmLg@mail.gmail.com>
References: <1438070731-17764-1-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438070731-17764-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 28, 2015 at 4:05 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> A while ago I was trying to build a seccomp-bpf filter program that would
> survive a change of x86 architecture.  This was complicated for all sorts of
> reasons, but one of the problems was that the different syscall numbers aren't
> all available at the same time -- hence this patch.

Or just use libseccomp and let it take care of all the different ABI
specific warts for you.  The library handles the undefined syscalls
you describe, but also multiplexed syscalls (e.g. socket related
syscalls on x86) and proper invalid arch/ABI filtering (you are
filtering x32 correctly on x86-64 right?).

 * https://github.com/seccomp/libseccomp

-- 
paul moore
www.paul-moore.com
