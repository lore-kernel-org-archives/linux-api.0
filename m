From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add
 CLONE_PIDFD]
Date: Wed, 17 Apr 2019 14:03:16 +0200
Message-ID: <e58d1694-c143-3465-512d-43301422bd8b@metux.net>
References: <20190414201436.19502-1-christian@brauner.io>
 <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415195911.z7b7miwsj67ha54y@yavin>
 <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
 <c783a83a-01a1-9813-e2f7-0516cf7a1c16@metux.net>
 <CALCETrWWoEvnzx6oLTEajBmiArScX5sSt74o2VO+aTiwEi_9mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWWoEvnzx6oLTEajBmiArScX5sSt74o2VO+aTiwEi_9mQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian@brauner.io>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>
List-Id: linux-api@vger.kernel.org

On 16.04.19 23:31, Andy Lutomirski wrote:

>> How exactly would the pidfd improve this scenario ?
>> IMHO, would just need to pass the inherited fd's to that daemon (eg.
>> via unix socket) which then sets them up in the new child process.
> 
> It makes it easier to wait until the privileged program exits.
> Without pidfd, you can't just wait(2) because the program that gets
> spawned isn't a child.  

Ah, that is a cool thing !
I suppose that also works across namespaces ?

What other things can be done via pidfd ?

>> But: how can we handle things like cgroups ?
> 
> Find a secure way to tell the daemon what cgroups to use?

hmm, do we have some fd-handle to cgroups ?
In that case a process could send a handle of his cgroup to some
other process (eg. some "login" deamon) allowing him to join in.

We could look at cgroups more as kind of capabilities instead of
limitations (eg. things like: members of cgroup "net-foo1" are
granted n% of network bandwith, etc). That would open up completely
new approaches to security and resource control :)

It could go even further: anybody can create new cgroups within his
own, narrow down some limits and pass this to some other agent that
acts on behalf of him and is allowed to use his share of the system
resources for that.


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
