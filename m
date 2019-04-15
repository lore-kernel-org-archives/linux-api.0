From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add
 CLONE_PIDFD]
Date: Mon, 15 Apr 2019 12:08:09 +0200
Message-ID: <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
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

Hi folks,

> This patchset makes it possible to retrieve pid file descriptors at
> process creation time by introducing the new flag CLONE_PIDFD to the
> clone() system call as previously discussed.

Sorry, for highjacking this thread, but I'm curious on what things to
consider when introducing new CLONE_* flags.

The reason I'm asking is:

I'm working on implementing plan9-like fs namespaces, where unprivileged
processes can change their own namespace at will. For that, certain
traditional unix'ish things have to be disabled, most notably suid.
As forbidding suid can be helpful in other scenarios, too, I thought
about making this its own feature. Doing that switch on clone() seems
a nice place for that, IMHO.

As there might be potentially even more CLONE_* flags in the future,
and the bitmask size is limited, this raises the question on how to
proceed with those flag additions in the future.

What's your thoughts on that ?


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
