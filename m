From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracefs: Do not allocate and free proxy_ops for
 lockdown
Date: Fri, 11 Oct 2019 17:11:52 -0400
Message-ID: <20191011171152.0e6f4615@gandalf.local.home>
References: <20191011135458.7399da44@gandalf.local.home>
        <CAHk-=wj7fGPKUspr579Cii-w_y60PtRaiDgKuxVtBAMK0VNNkA@mail.gmail.com>
        <20191011162518.2f8c99ca@gandalf.local.home>
        <20191011165455.32666d53@gandalf.local.home>
        <CAHk-=wiGtEDhwJab7+tQzmjDssynBruRvgj9NJY2bzNrVzw+0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wiGtEDhwJab7+tQzmjDssynBruRvgj9NJY2bzNrVzw+0Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <matthewgarrett@google.com>, James Morris James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, 11 Oct 2019 14:00:50 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Oct 11, 2019 at 1:55 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > I guess I can keep it this way. Thoughts?  
> 
> That looks fine to me. I'm still not sure you actually need to do all
> this, but it doesn't look _wrong_.

Yep, I sent this before seeing your other email.

> 
> That said, I still do think that if things are locked down from the
> very get-go, tracefs_create_file() shouldn't even create the files.

Agreed. I forgot to add in my last email:

4) Add the lockdown check to create_file()

> 
> That's mostly an independent thing from the "what about if they exists
> and things got locked down afterwards", though.

Well, I'll be combining it with the tracing_disabled code, which was
there originally to prevent corrupted buffers from causing harm by
being read.

> 
> I do wonder about the whole "well, if you started tracing before
> locking things down, don't you want to see the end results"?
> 

I don't think it hurts to disable it. Although, I don't think reading
the trace event formats will be a issue. I'm not aware of any of them
from giving too much info to the system. And if you really do care
about that, do it at boot up, and with the create_file part, it wont
have any files to read.

-- Steve
