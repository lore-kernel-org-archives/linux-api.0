From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH bpf-next v10 10/10] landlock: Add user and kernel
 documentation for Landlock
Date: Thu, 1 Aug 2019 10:49:05 -0700
Message-ID: <08c94f99-68e0-4866-3eba-28fa71347fca@infradead.org>
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-11-mic@digikod.net>
 <88e90c22-1b78-c2f2-8823-fa776265361c@infradead.org>
 <2ced8fc8-79a6-b0fb-70fe-6716fae92aa7@ssi.gouv.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <2ced8fc8-79a6-b0fb-70fe-6716fae92aa7@ssi.gouv.fr>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>Shuah Khan <s>
List-Id: linux-api@vger.kernel.org

On 8/1/19 10:03 AM, Mickaël Salaün wrote:
>>> +Ptrace restrictions
>>> +-------------------
>>> +
>>> +A landlocked process has less privileges than a non-landlocked process and must
>>> +then be subject to additional restrictions when manipulating another process.
>>> +To be allowed to use :manpage:`ptrace(2)` and related syscalls on a target
>>> +process, a landlocked process must have a subset of the target process programs.
>>             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> Maybe that last statement is correct, but it seems to me that it is missing something.
> What about this:
> 
> To be allowed to trace a process (using :manpage:`ptrace(2)`), a
> landlocked tracer process must only be constrained by a subset (possibly
> empty) of the Landlock programs which are also applied to the tracee.
> This ensure that the tracer has less or the same constraints than the

       ensures

> tracee, hence protecting against privilege escalation.

Yes, better.  Thanks.


-- 
~Randy
