From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 1/2] modules:capabilities: automatic module loading restriction
Date: Wed, 19 Apr 2017 16:16:22 -0700
Message-ID: <CALCETrWzjCWGJ2-ghQBie1AXLgFqGe-B9DALUASm43gDO5RRcw@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com> <1492640420-27345-2-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1492640420-27345-2-git-send-email-tixxdz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 19, 2017 at 3:20 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
> Currently, an explicit call to load or unload kernel modules require
> CAP_SYS_MODULE capability. However unprivileged users have always been
> able to load some modules using the implicit auto-load operation. An
> automatic module loading happens when programs request a kernel feature
> from a module that is not loaded. In order to satisfy userspace, the
> kernel then automatically load all these required modules.

I like this feature.

--Andy
