From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/7 v2] tracefs: Revert ccbd54ff54e8 ("tracefs: Restrict
 tracefs when the kernel is locked down")
Date: Sat, 12 Oct 2019 15:56:15 -0700
Message-ID: <CAHk-=whE7GjKz9LtEVNw=zEgWr65N1mU7t2rA4MLiia8Zit6DQ@mail.gmail.com>
References: <20191012005747.210722465@goodmis.org> <20191012005920.630331484@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191012005920.630331484@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Garrett <matthewgarrett@google.com>, James Morris James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 11, 2019 at 5:59 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> I bisected this down to the addition of the proxy_ops into tracefs for
> lockdown. It appears that the allocation of the proxy_ops and then freeing
> it in the destroy_inode callback, is causing havoc with the memory system.
> Reading the documentation about destroy_inode and talking with Linus about
> this, this is buggy and wrong.

Can you still add the explanation about the inode memory leak to this message?

Right now it just says "it's buggy and wrong". True. But doesn't
explain _why_ it is buggy and wrong.

          Linus
