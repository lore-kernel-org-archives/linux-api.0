From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Thu, 22 Oct 2015 16:44:49 -0500
Message-ID: <874mhi4lym.fsf@x220.int.ebiederm.org>
References: <5622700C.9090107@miglix.eu>
	<20151017215501.GA22900@mail.hallyn.com> <5623FD82.4030902@miglix.eu>
	<87twpi63ai.fsf@x220.int.ebiederm.org>
	<CALCETrWKN+Uzw_TYqVTGatNZ3LT5RbSM1WuYPoXeKQs9Yw_qjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWKN+Uzw_TYqVTGatNZ3LT5RbSM1WuYPoXeKQs9Yw_qjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Thu, 22 Oct 2015 14:02:09 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yves-Alexis Perez <corsac-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> At the risk of pointing out a can of worms, the attack surface also
> includes things like the iptables configuration APIs, parsers, and
> filter/conntrack/action modules.

It is worth noting that module auto-load does not happen if the
triggering code does not have the proper permissions in the initial user
namespace.

I agree that is another piece of code that should be counted.  How that
compares to the other 130,000 or so lines of code in the network stack
an unprivileged user can caused to be exercised already I don't know.
In my back of the napkin swag I had totally forgotten to count anything
in the network stack.

A lot of the netfilter code that I have read and looked at is
compartively simple and clean so I don't expect there is much risk
except from sheer volume of code there.

It is also tricky to count because the entire network side of the
networking stack is exposed to hostile users on the internet so anything
except the configuration is already exposed to hostile users.  The
average check entry is 15-20 lines long.  There appear to be 117 unique
check entry functions in the kernel so there may be another 2.5k lines of
code there.

Hmm.  And we have not had any design issues with the network stack.

Absent of design issues where the code even when implemented correctly
has the wrong semantics, we are left with the probability of exploitable
buggy code.  I suspect we have enough code even without user namespaces
enabled that the probability of exploitable buggy code someone in the
code that unprivilged users can cause to be exercised run is > 50%.

I wonder if there are any good statistical models that give realistic
estimates of those things.

Eric
