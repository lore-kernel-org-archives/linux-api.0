From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH] tracefs: Do not allocate and free proxy_ops for lockdown
Date: Fri, 11 Oct 2019 23:46:20 +0200
Message-ID: <87tv8f9cr7.fsf@mid.deneb.enyo.de>
References: <20191011135458.7399da44@gandalf.local.home>
        <CAHk-=wj7fGPKUspr579Cii-w_y60PtRaiDgKuxVtBAMK0VNNkA@mail.gmail.com>
        <20191011143610.21bcd9c0@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191011143610.21bcd9c0@gandalf.local.home> (Steven Rostedt's
        message of "Fri, 11 Oct 2019 14:36:10 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <matthewgarrett@google.com>, James Morris James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

* Steven Rostedt:

> Once locked down is set, can it ever be undone without rebooting?

I think this is the original intent with such patches, yes.  But then
reality interferes and people add some escape hatch, so that it's
possible again to load arbitrary kernel modules.  And for servers, you
can't have a meaningful physical presence check, so you end up with a
lot of complexity for something that offers absolutely zero gains in
security.

The other practical issue is that general-purpose Linux distributions
cannot prevent kernel downgrades, so even if there's a
cryptographically signed chain from the firmware to the kernel, you
can boot last year's kernel, use a root-to-ring-0 exploit to disable
its particular implementation of lockdown, and then kexec the real
kernel with lockdown disabled.

I'm sure that kernel lockdown has applications somewhere, but for
general-purpose distributions (who usually want to support third-party
kernel modules), it's an endless source of problems that wouldn't
exist without it.
