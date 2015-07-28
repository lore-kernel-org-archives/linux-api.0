From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCH RFC 0/1] UAPI,x86: export syscall numbers for all x86 archs
Date: Tue, 28 Jul 2015 16:32:14 +0100
Message-ID: <CAHse=S8dN+e6nhSrf=hVLsfGyrR191mrxj_wc_OauqNtUXxSCg@mail.gmail.com>
References: <1438070731-17764-1-git-send-email-drysdale@google.com> <CAHC9VhRf8b7LRyG1N0t11jQdDbAa_m6-pYjnyb2EHxU0YoJmLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhRf8b7LRyG1N0t11jQdDbAa_m6-pYjnyb2EHxU0YoJmLg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Eric Paris <eparis@redhat.com>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 28, 2015 at 1:20 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Tue, Jul 28, 2015 at 4:05 AM, David Drysdale <drysdale@google.com> wrote:
>> A while ago I was trying to build a seccomp-bpf filter program that would
>> survive a change of x86 architecture.  This was complicated for all sorts of
>> reasons, but one of the problems was that the different syscall numbers aren't
>> all available at the same time -- hence this patch.
>
> Or just use libseccomp and let it take care of all the different ABI
> specific warts for you.  The library handles the undefined syscalls
> you describe, but also multiplexed syscalls (e.g. socket related
> syscalls on x86) and proper invalid arch/ABI filtering

Ah, I hadn't realized that libseccomp handled cross-architecture
stuff and the socketcall multiplexing -- very neat.  I'll look into whether
I can convert my stuff to use it.

I still think exporting all the sub-arch syscall numbers is a good idea
though (even if my need for it is potentially reduced by libseccomp)...

> (you are
> filtering x32 correctly on x86-64 right?).

Yep, I think so, but it's fiddly.  If I can leave the fiddliness
to libseccomp, so much the better...

Thanks for the pointer,
David

>  * https://github.com/seccomp/libseccomp
>
> --
> paul moore
> www.paul-moore.com
