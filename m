From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Formal description of system call interface
Date: Mon, 21 Nov 2016 10:37:52 -0500
Message-ID: <20161121103752.70ad1418@gandalf.local.home>
References: <CACT4Y+YYgs43nJnyg3B9cHWOue62iMW3ZgXQKiKG12A1NVMgtg@mail.gmail.com>
        <20161107103819.GA11374@rei.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161107103819.GA11374@rei.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Cyril Hrubis <chrubis@suse.cz>
Cc: Dmitry Vyukov <dvyukov@google.com>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com, Thomas Gleixner <tglx@linutronix.de>, Sasha Levin <levinsasha928@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, scientist@fb.com, Arnd Bergmann <arnd@arndb.de>, carlos@redhat.com, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Mike Frysinger <vapier@google.com>, Dave Jones <davej@codemonkey.org.uk>, Tavis Ormandy <taviso@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, 7 Nov 2016 11:38:20 +0100
Cyril Hrubis <chrubis@suse.cz> wrote:


> I'm not sure if something like this is really doable or in the scope of
> this project, but it may be worth a try.
> 

Looking ahead into the future, I was also thinking that if this becomes
robust, we could also start an integration specification, that could
describe how different system calls interact with each other. Like
open() to read(), write() and close().

But this is just an idea that popped in my head while reading this
thread. We want to start small first, but still could keep this in the
back of our minds for future enhancements.

-- Steve
