From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tracefs: Do not allocate and free proxy_ops for lockdown
Date: Fri, 11 Oct 2019 13:46:11 -0700
Message-ID: <CAHk-=whC6Ji=fWnjh2+eS4b15TnbsS4VPVtvBOwCy1jjEG_JHQ@mail.gmail.com>
References: <20191011135458.7399da44@gandalf.local.home> <CAHk-=wj7fGPKUspr579Cii-w_y60PtRaiDgKuxVtBAMK0VNNkA@mail.gmail.com>
 <20191011162518.2f8c99ca@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191011162518.2f8c99ca@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <matthewgarrett@google.com>, James Morris James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 11, 2019 at 1:25 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> OK, so I tried this approach, and there's a bit more than just a "few"
> extra cases that use tracing_open_generic().

Yeah, that's more than I would have expected.

That said, you also did what I consider a somewhat over-done conversion.

Just do

   static inline bool tracefs_lockdown_or_disabled(void)
   { return tracing_disabled || security_locked_down(LOCKDOWN_TRACEFS); }

and ignore the pointless return value (we know it's EPERM, and we
really don't care).

And then several of those conversions just turn into oneliner

-       if (tracing_disabled)
+       if (tracefs_lockdown_or_disabled())
                 return -ENODEV;

patches instead.

I'm also not sure why you bothered with a lot of the files that don't
currently even have that "tracing_disabled" logic at all. Yeah, they
show pre-existing tracing info, but even if you locked down _after_
starting some tracing, that's probably what you want. You just don't
want people to be able to add new trace events.

For example, maybe you want to have lockdown after you've booted, but
still show boot time traces?

I dunno. I feel like you re-did the original patch, and the original
patch was designed for "least line impact" rather than for anything
else.

I also suspect that if you *actually* do lockdown at early boot (which
is presumably one common case), then all you need is to do

    --- a/fs/tracefs/inode.c
    +++ b/fs/tracefs/inode.c
    @@ -418,6 +418,9 @@ struct dentry *tracefs_create_file(
        struct dentry *dentry;
        struct inode *inode;

    +   if (security_locked_down(LOCKDOWN_TRACEFS))
    +           return NULL;
    +
        if (!(mode & S_IFMT))
                mode |= S_IFREG;
        BUG_ON(!S_ISREG(mode));

and the "open-time check" is purely for "we did lockdown _after_ boot,
but then you might well want to be able to read the existing trace
information that you did before you locked down.

Again - I think trying to emulate exactly what that broken lockdown
patch did is not really what you should aim for.

That patch was not only buggy, it really wasn't about what people
really necessarily _want_, as about "we don't want to deal with
tracing, so here's a minimal patch that doesn't even work".

          Linus
