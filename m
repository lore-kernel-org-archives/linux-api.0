From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tracefs: Do not allocate and free proxy_ops for lockdown
Date: Fri, 11 Oct 2019 12:24:23 -0700
Message-ID: <CAHk-=wh_JH5-hC3yk8X3Ja8XMTuW68-ozuqZdMw7fcHpcpHuUw@mail.gmail.com>
References: <20191011135458.7399da44@gandalf.local.home> <CAHk-=wj7fGPKUspr579Cii-w_y60PtRaiDgKuxVtBAMK0VNNkA@mail.gmail.com>
 <20191011143610.21bcd9c0@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191011143610.21bcd9c0@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <matthewgarrett@google.com>, James Morris James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 11, 2019 at 11:36 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 11 Oct 2019 11:20:30 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> > Willing to do that instead?
>
> Honestly, what you described was my preferred solution ;-)
>
> I just didn't want to upset the lockdown crowd if a new tracefs file
> was opened without doing this.

Well, since they introduced a bug in your code that killed your
machine with the patch _they_ did, I don't think they get to complain
when you fix it the way you (and me) want to...

Fair is fair.

             Linus
