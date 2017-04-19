From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
Date: Wed, 19 Apr 2017 16:43:18 -0700
Message-ID: <CAGXu5jJ5dm8yJJ34tEyOP78OxUr2awXmNhm6RaVP8jE4q+L5Ng@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-3-git-send-email-tixxdz@gmail.com> <CALCETrXFp-apnfRPg9qx6E7g3KDU8DanBW1pMUnA1zShrB5xKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALCETrXFp-apnfRPg9qx6E7g3KDU8DanBW1pMUnA1zShrB5xKg@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro
List-Id: linux-api@vger.kernel.org

On Wed, Apr 19, 2017 at 4:15 PM, Andy Lutomirski <luto@kernel.org> wrote:
> On Wed, Apr 19, 2017 at 3:20 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> +/* Sets task's modules_autoload */
>> +static inline int task_set_modules_autoload(struct task_struct *task,
>> +                                           unsigned long value)
>> +{
>> +       if (value > MODULES_AUTOLOAD_DISABLED)
>> +               return -EINVAL;
>> +       else if (task->modules_autoload > value)
>> +               return -EPERM;
>> +       else if (task->modules_autoload < value)
>> +               task->modules_autoload = value;
>> +
>> +       return 0;
>> +}
>
> This needs to be more locked down.  Otherwise someone could set this
> and then run a setuid program.  Admittedly, it would be quite odd if
> this particular thing causes a problem, but the issue exists
> nonetheless.

Eeeh, I don't agree this needs to be changed. APIs provided by modules
are different than the existing privilege-manipulation syscalls this
concern stems from. Applications are already forced to deal with
things being missing like this in the face of it simply not being
built into the kernel.

Having to hide this behind nnp seems like it'd reduce its utility...

-Kees

-- 
Kees Cook
Pixel Security
