From: Kees Cook <keescook@chromium.org>
Subject: Re: seccomp: add "seccomp" syscall
Date: Tue, 12 Aug 2014 09:25:43 -0700
Message-ID: <CAGXu5jLxkhaDU7KtHLLXAbseHXc9nEuj93EYM9JvtWvPLzW=ug@mail.gmail.com>
References: <20140806162754.3BCA1660E61@gitolite.kernel.org>
	<CAMuHMdWp1iWm9xLqRN0q3hV72bD8jPRLDW74Cm+Gxp3gB76asQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdWp1iWm9xLqRN0q3hV72bD8jPRLDW74Cm+Gxp3gB76asQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 11, 2014 at 1:07 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Kees,
>
> v3.17 is gonna get a lot of new syscalls...

4 so far! :P

>
> On Wed, Aug 6, 2014 at 6:27 PM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>> Gitweb:     http://git.kernel.org/linus/;a=commit;h=48dc92b9fc3926844257316e75ba11eb5c742b2c
>> Commit:     48dc92b9fc3926844257316e75ba11eb5c742b2c
>> Parent:     3b23dd12846215eff4afb073366b80c0c4d7543e
>> Refname:    refs/heads/master
>> Author:     Kees Cook <keescook@chromium.org>
>> AuthorDate: Wed Jun 25 16:08:24 2014 -0700
>> Committer:  Kees Cook <keescook@chromium.org>
>> CommitDate: Fri Jul 18 12:13:37 2014 -0700
>>
>>     seccomp: add "seccomp" syscall
>>
>>     This adds the new "seccomp" syscall with both an "operation" and "flags"
>>     parameter for future expansion. The third argument is a pointer value,
>>     used with the SECCOMP_SET_MODE_FILTER operation. Currently, flags must
>>     be 0. This is functionally equivalent to prctl(PR_SET_SECCOMP, ...).
>>
>>     In addition to the TSYNC flag later in this patch series, there is a
>>     non-zero chance that this syscall could be used for configuring a fixed
>>     argument area for seccomp-tracer-aware processes to pass syscall arguments
>>     in the future. Hence, the use of "seccomp" not simply "seccomp_add_filter"
>>     for this syscall. Additionally, this syscall uses operation, flags,
>>     and user pointer for arguments because strictly passing arguments via
>>     a user pointer would mean seccomp itself would be unable to trivially
>>     filter the seccomp syscall itself.
>>
>>     Signed-off-by: Kees Cook <keescook@chromium.org>
>>     Reviewed-by: Oleg Nesterov <oleg@redhat.com>
>>     Reviewed-by: Andy Lutomirski <luto@amacapital.net>
>
> Is this something that I should enable?
>
> As it depends on CONFIG_SECCOMP, it only makes sense on architectures that
> already support CONFIG_SECCOMP, right?
> Does it make sense to reserve a syscall slot for it on architectures that
> don't support it yet?

I don't see a good reason to reserve the syscall slot if seccomp
filter is not already implemented. I've CCed linux-api in case there
is something I'm not considering, though.

FWIW, if someone wants to add it for m68k, the steps to support
seccomp are listed in the arch/Kconfig for HAVE_ARCH_SECCOMP_FILTER.

-Kees

-- 
Kees Cook
Chrome OS Security
