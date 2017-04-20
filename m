From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v3 1/2] modules:capabilities:
 automatic module loading restriction
Date: Thu, 20 Apr 2017 14:44:53 +0200
Message-ID: <CAEiveUdS=GbyxDVeNFrjTmhvQB-a6UgrJXcGY=BYJLu+3z0x_Q@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-2-git-send-email-tixxdz@gmail.com> <1492654942.31767.21.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1492654942.31767.21.camel@decadent.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mcheh>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 20, 2017 at 4:22 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Thu, 2017-04-20 at 00:20 +0200, Djalal Harouni wrote:
> [...]
>> +modules_autoload:
>> +
>> +A sysctl to control if modules auto-load feature is allowed or not.
>> +This sysctl complements "modules_disabled" which is for all module
>> +operations where this flag applies only to automatic module loading.
>> +Automatic module loading happens when programs request a kernel feature
>> +that is implemented by an unloaded module, the kernel automatically
>> +runs the program pointed by "modprobe" sysctl in order to load the
>> +corresponding module.
>> +
>> +When modules_autoload is set to (0), the default, there are no
>> +restrictions.
>> +
>> +When modules_autoload is set to (1), processes must have CAP_SYS_MODULE
>> +to be able to trigger a module auto-load operation, or CAP_NET_ADMIN
>> +for modules with a 'netdev-%s' alias.
>> +
>> +When modules_autoload is set to (2), automatic module loading is
>> +disabled for all. Once set, this value can not be changed.
>
> I would expect a parameter 'modules_autoload' to be a boolean, so this
> behaviour would be surprising.
>
> What is the point of mode 2?  Why would someone want to set
> modules_disabled=0 and modules_autoload=2?

modules_disabled is too restrictive and once set it can't be changed,
maybe that's why not all users use it.

With modules_disabled=0 and modules_autoload=2

* The functionality of the system can still be made available.
* You only disable automatic module loading
* Explicit module load/unload can still happen. Administrators or
privileged programs can still explicitly load modules provide a
feature without rebooting.
* You are able to restrict some applications from inserting new
modules at all by also applying a seccomp filter and removing their
CAP_SYS_MODULE, where explicit load/unload is still available to
others.
* You are able to unload an old bad version of the module without
rebooting, and maybe load the new version.


> [...]
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
> [...]
>> +static int modules_autoload_privileged_access(const char *name)
>> +{
>> +     if (capable(CAP_SYS_MODULE))
>> +             return 0;
>> +     else if (name && strstr(name, "netdev-") && capable(CAP_NET_ADMIN))
> [...]
>
> We want a prefix match, so use strncmp() not strstr().

Indeed, will fix it.

Thanks!


> Ben.
>
> --
> Ben Hutchings
> It is easier to change the specification to fit the program than vice
> versa.
>



-- 
tixxdz
