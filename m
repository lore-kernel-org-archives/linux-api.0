From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH RFC 0/1] UAPI,x86: export syscall numbers for all x86 archs
Date: Tue, 28 Jul 2015 11:52:51 -0400
Message-ID: <CAHC9VhQJa+uiPNPA3MvxjYc_U0eoin2oVBEPikPVsQMe8kkh7w@mail.gmail.com>
References: <1438070731-17764-1-git-send-email-drysdale@google.com>
	<CAHC9VhRf8b7LRyG1N0t11jQdDbAa_m6-pYjnyb2EHxU0YoJmLg@mail.gmail.com>
	<CAHse=S8dN+e6nhSrf=hVLsfGyrR191mrxj_wc_OauqNtUXxSCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHse=S8dN+e6nhSrf=hVLsfGyrR191mrxj_wc_OauqNtUXxSCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 28, 2015 at 11:32 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Jul 28, 2015 at 1:20 PM, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
>> On Tue, Jul 28, 2015 at 4:05 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>> A while ago I was trying to build a seccomp-bpf filter program that would
>>> survive a change of x86 architecture.  This was complicated for all sorts of
>>> reasons, but one of the problems was that the different syscall numbers aren't
>>> all available at the same time -- hence this patch.
>>
>> Or just use libseccomp and let it take care of all the different ABI
>> specific warts for you.  The library handles the undefined syscalls
>> you describe, but also multiplexed syscalls (e.g. socket related
>> syscalls on x86) and proper invalid arch/ABI filtering
>
> Ah, I hadn't realized that libseccomp handled cross-architecture
> stuff and the socketcall multiplexing -- very neat.  I'll look into whether
> I can convert my stuff to use it.

[Ooops, forgot to hit reply-all]

It should be pretty easy; if you've been writing BPF assembly, simply
making a few function calls should be a no-brainer.

We've got man pages for each of the libseccomp APIs that should cover
most of your questions, but there is also a collection of tests (see
the "tests/" directory) which serve as reasonable examples too.  If
all else fails, you can always ask for help on our mailing list:

 * https://groups.google.com/d/forum/libseccomp

> I still think exporting all the sub-arch syscall numbers is a good idea
> though (even if my need for it is potentially reduced by libseccomp)...

No real argument against it from me.  I just worry that some
developers accidently get the seccomp-bpf filters wrong when they do
it by hand, e.g. ABI specific filters and not properly handling x32 on
x86-64.

>> (you are filtering x32 correctly on x86-64 right?).
>
> Yep, I think so, but it's fiddly.  If I can leave the fiddliness
> to libseccomp, so much the better...

Annoyingly fiddly.  If we could do it over I would much prefer to see
x32 get its own 32-bit ABI token value; sharing a value with x86-64
makes things harder than they need to be, but sadly it is too late to
change it now.

> Thanks for the pointer,
> David
>
>>  * https://github.com/seccomp/libseccomp

No problem, let me know if you run into any problems.

Good luck!

-- 
paul moore
www.paul-moore.com
