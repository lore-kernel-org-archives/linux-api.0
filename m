From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH RFC v2 4/6] proc: support mounting private procfs
 instances inside same pid namespace
Date: Tue, 2 May 2017 16:29:57 +0200
Message-ID: <CAEiveUf22RQ6awvCKJ4p5OxZCPAyhOfpLBQXFLJ=tev3zDfL+g@mail.gmail.com>
References: <1493123038-30590-1-git-send-email-tixxdz@gmail.com>
 <1493123038-30590-5-git-send-email-tixxdz@gmail.com> <CALCETrWOjLnfCgpAJs6tTjLXeNHjqPQa5qSZpztcnbR2kN5A2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWOjLnfCgpAJs6tTjLXeNHjqPQa5qSZpztcnbR2kN5A2w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg
List-Id: linux-api@vger.kernel.org

On Thu, Apr 27, 2017 at 12:13 AM, Andy Lutomirski <luto@kernel.org> wrote:
> On Tue, Apr 25, 2017 at 5:23 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
[...]
>> We have to align procfs and modernize it to have a per mount context
>> where at least the mount option do not propagate to all other mounts,
>> then maybe we can continue to implement new features. One example is to
>> require CAP_SYS_ADMIN in the init user namespace on some /proc/* which are
>> not pids and which are are not virtualized by design, or CAP_NET_ADMIN
>> inside userns on the net bits that are virtualized, etc.
>> These mount options won't propagate to previous mounts, and the system
>> will continue to be usable.
>>
>> Ths patch introduces the new 'limit_pids' mount option as it was also
>> suggesed by Andy Lutomirski [1]. When this option is passed we
>> automatically create a private procfs instance. This is not the default
>> behaviour since we do not want to break userspace and we do not want to
>> provide different devices IDs by default, please see [1] for why.
>
> I think that calling the option to make a separate instance
> "limit_pids" is extremely counterintuitive.

Ok.

> My strong preference would be to make proc *always* make a separate
> instance (unless it's a bind mount) and to make it work.  If that
> means fudging stat() output, so be it.

I also agree, but as said if we change stat(), userspace won't be able
to notice if these two proc instances are really separated, the device
ID is the only indication here.

So,

> Failing that, let's come up with some coherent way to make this work.
> "new_instance" or similar would do.  Then make limit_pid cause an
> error unless new_instance is also set.

This is reasonable and it follows devpts filesystem, when
'new_instance' was introduced to gradually switch to private
instances, then it was made default behaviour. We can do the same and
improve the situation bit by bit without breaking anything.

I will prepare a new clean version with "newinstance" and
"pids=ptraceable" requiring it, this way we don't change anything that
is related to current 'hidepid' behaviour. Let me know please if you
don't agree.

Thank you for the feedback!

-- 
tixxdz
