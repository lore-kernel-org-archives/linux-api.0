From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Fri, 9 Jan 2015 21:50:42 +0000
Message-ID: <20150109215042.GM22149@ZenIV.linux.org.uk>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-6-git-send-email-drysdale@google.com>
 <54AFF813.7050604@gmail.com>
 <20150109161302.GQ4574@brightrain.aerifal.cx>
 <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
 <20150109204815.GR4574@brightrain.aerifal.cx>
 <20150109205626.GK22149@ZenIV.linux.org.uk>
 <20150109205926.GT4574@brightrain.aerifal.cx>
 <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150109212852.GU4574@brightrain.aerifal.cx>
Sender: linux-arch-owner@vger.kernel.org
To: Rich Felker <dalias@aerifal.cx>
Cc: David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 04:28:52PM -0500, Rich Felker wrote:

> The "magic open-once magic symlink" approach is really the cleanest
> solution I can find. In the case where the interpreter does not open
> the script, nothing terribly bad happens; the magic symlink just
> sticks around until _exit or exec. In the case where the interpreter
> opens it more than once, you get a failure, but as far as I know
> existing interpreters don't do this, and it's arguably bad design. In
> any case it's a caught error.

You know what's cleaner than that?  git revert 27d6ec7ad
It has just been merged; until 3.19 it's fair game for removal.

And yes, I should've NAKed the damn thing loud and clear, rather than
asking questions back then, getting no answers and letting it slip.
Mea culpa.

Back then the procfs-free environments had been pushed as a serious argument
in favour of merging the damn thing.  Now you guys turn around and say that
we not only need procfs mounted, we need a yet-to-be-added kludge in there
to cope with the actual intended uses.
