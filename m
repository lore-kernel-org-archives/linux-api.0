From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
Date: Mon, 12 Jan 2015 14:18:18 +0000
Message-ID: <CAHse=S9qP19WrNRefOzJ1yKiT9qWof67-y5wHBcxAfR-r4HzmQ@mail.gmail.com>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-6-git-send-email-drysdale@google.com> <54AFF813.7050604@gmail.com>
 <20150109161302.GQ4574@brightrain.aerifal.cx> <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
 <20150109204815.GR4574@brightrain.aerifal.cx> <20150109205626.GK22149@ZenIV.linux.org.uk>
 <20150109205926.GT4574@brightrain.aerifal.cx> <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx> <20150109215042.GM22149@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150109215042.GM22149@ZenIV.linux.org.uk>
Sender: linux-arch-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rich Felker <dalias@aerifal.cx>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 9, 2015 at 9:50 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Jan 09, 2015 at 04:28:52PM -0500, Rich Felker wrote:
>
>> The "magic open-once magic symlink" approach is really the cleanest
>> solution I can find. In the case where the interpreter does not open
>> the script, nothing terribly bad happens; the magic symlink just
>> sticks around until _exit or exec. In the case where the interpreter
>> opens it more than once, you get a failure, but as far as I know
>> existing interpreters don't do this, and it's arguably bad design. In
>> any case it's a caught error.
>
> You know what's cleaner than that?  git revert 27d6ec7ad
> It has just been merged; until 3.19 it's fair game for removal.
>
> And yes, I should've NAKed the damn thing loud and clear, rather than
> asking questions back then, getting no answers and letting it slip.
> Mea culpa.

Al, I'm sorry if I missed a question or concern of yours back in
October -- I certainly didn't intend to (that would be foolish indeed!).

[I thought the main open question was whether a dupfs
implementation would help with /dev/fd/ and /proc/ semantics, but I
had the (possibly incorrect) understanding that that was somewhat
orthogonal to the execveat implementation.]

Are there any changes/fixes/refactorings that I could do (especially
within the 3.19 timeframe) that would help mollify at all?

> Back then the procfs-free environments had been pushed as a serious argument
> in favour of merging the damn thing.  Now you guys turn around and say that
> we not only need procfs mounted, we need a yet-to-be-added kludge in there
> to cope with the actual intended uses.

Not me!
