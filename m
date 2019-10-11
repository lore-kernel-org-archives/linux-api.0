From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tracefs: Do not allocate and free proxy_ops for lockdown
Date: Fri, 11 Oct 2019 14:00:50 -0700
Message-ID: <CAHk-=wiGtEDhwJab7+tQzmjDssynBruRvgj9NJY2bzNrVzw+0Q@mail.gmail.com>
References: <20191011135458.7399da44@gandalf.local.home> <CAHk-=wj7fGPKUspr579Cii-w_y60PtRaiDgKuxVtBAMK0VNNkA@mail.gmail.com>
 <20191011162518.2f8c99ca@gandalf.local.home> <20191011165455.32666d53@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191011165455.32666d53@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <matthewgarrett@google.com>, James Morris James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 11, 2019 at 1:55 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I guess I can keep it this way. Thoughts?

That looks fine to me. I'm still not sure you actually need to do all
this, but it doesn't look _wrong_.

That said, I still do think that if things are locked down from the
very get-go, tracefs_create_file() shouldn't even create the files.

That's mostly an independent thing from the "what about if they exists
and things got locked down afterwards", though.

I do wonder about the whole "well, if you started tracing before
locking things down, don't you want to see the end results"?

             Linus
