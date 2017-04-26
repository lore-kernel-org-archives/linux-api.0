From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
Date: Wed, 26 Apr 2017 11:06:12 +0200
Message-ID: <CAEiveUfVyLVrCgjniA+7eutv=OGQ2LwBCx0V7JLiySeJz3c5ZQ@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-3-git-send-email-tixxdz@gmail.com> <87r30ifmwz.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7591-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <87r30ifmwz.fsf@rustcorp.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@kernel.org>, Zendyani <zendyani@gmail.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

Hi Rusty,

On Mon, Apr 24, 2017 at 6:29 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Djalal Harouni <tixxdz@gmail.com> writes:
>> When value is (1), task must have CAP_SYS_MODULE to be able to trigger a
>> module auto-load operation, or CAP_NET_ADMIN for modules with a
>> 'netdev-%s' alias.
>
> Sorry, the magic 'netdev-' prefix is a crawling horror.  To do this

Yes I agree, that's the not the best part. I added it for backward
compatibility since I did notice that some network daemon retain
CAP_NET_ADMIN for this case. The aim of the patches is to get modules
autoload covered with CAP_SYS_MODULE and make it more like explicit
modules loading.

> properly, you need to hand the capability (if any) from the
> request_module() call.  Probably by adding a new request_module_cap and
> making request_module() call that, then fixing up the callers.

Hmm, sorry Rusty I'm a bit confused, when you refer to "callers", you
mean request_module() callers ?

If so, I'm not sure that the best thing here since it may defeat the
purpose of this feature if we allow to pass capabilities.

Right now we have modules autoload that can be triggered without
privileges, or with CAP_SYS_ADMIN, CAP_NET_ADMIN, CAP_SYS_MODULE...
and some caps may allow to load other modules to resolve symbols etc.

The public exploits did target CAP_NET_ADMIN, if we offer a way to
pass in capabilities it will be used it as it is the case now without
it, not to mention that some capabilities are overloaded, exploits
will continue for these ones.

The goal is to narrow modules autoload only to CAP_SYS_MODULE or
disable it completely for process trees. Later you can give
CAP_SYS_MODULE and you are sure that only /lib/modules/ will be
autoloaded, no arbitrary loads by using seccomp filter on module
syscalls, or separate the process in two one with CAP_SYS_MODULE and
the other with its own capabilities and feature use.

I also don't like that 'netdev-%s' but it is for compatibility for
specific cases, maybe there are others that we may have to add. But I
would prefer if we narrow it down to only CAP_SYS_MODULE.

How about I move all permission checks to security/commoncap.c
helpers, the module logic part will only contain set and read sysctl
"modules_autoload" and "task->modules_autoload" ?

I already added cap_kernel_module_request() which is called by
request_module(), so instead of counting on module to do the
permission check I will open code it inside
security/commoncap.c:cap_kernel_module_request() like other capability
helpers and note that CAP_NET_ADMIN 'netdev-%s' alias is only for
compatibility. This way we prevent that other capabilities get exposed
or targeted for exploitation. Do you think that this will work ?

Thanks!

> Cheers,
> Rusty.

-- 
tixxdz
