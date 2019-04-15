From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: [PATCH 0/4] clone: add CLONE_PIDFD
Date: Mon, 15 Apr 2019 12:16:59 +0200
Message-ID: <81fa3d00-70be-0d41-e145-60285e23687d@metux.net>
References: <20190414201436.19502-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190414201436.19502-1-christian@brauner.io>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On 14.04.19 22:14, Christian Brauner wrote:

Hi,

> When clone is called with CLONE_PIDFD a pidfd instead of a pid will be
> returned. 

Uh, changing the return type by some flags produces a very strange
feeling in my stomach. Isn't there any other way for fetching a pidfs
for some pid ?

> To make it possible for users of CLONE_PIDFD to apply standard
> error checking that is common all across userspace, file descriptor
> numbering for pidfds starts at 1 and not 0. 

Feels even more strange. I'm used to the kernel always picking the
lowest available pid. In some cases, one really wants to have fd 0.
Even though the actual usecases for doing that w/ a pidfd might be
pretty limited, I don't feel good w/ breaking this old habit.


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
