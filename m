From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Fri, 31 Jul 2015 21:56:46 -0700
Message-ID: <55BC518E.4010102@zytor.com>
References: <CAHse=S-Wgv8JKu72FQaivou1PAwyexqjn_sjtMu3n=ezX0x-vg@mail.gmail.com> <CAGXu5j+5KHy68ELU6PmNWaj7mQBXTbRQGXqJFwsXHt9n0LPw8Q@mail.gmail.com> <20150730190434.GD16452@x> <CAGXu5jJwtVgPmmMHiR0M27he3ma7exfSH8OBNdLMFQcbbtzUfg@mail.gmail.com> <20150731010234.GA7265@x> <CAGXu5jLethUkiq1QEZg-uRkOzofa6M8WCT8T7qAByWy5L4xHBw@mail.gmail.com> <20150731205941.GA30362@cloud> <CALCETrUkMXvFRKdTH7ekY7FyGvbKDDJbf7L0shgs5R-Hep6bVA@mail.gmail.com> <20150731220828.GA30890@cloud> <CALCETrXwrf--FG+KdbG-oBixhG+odB7ukW_F7CkBGb0KQ7ZSVA@mail.gmail.com> <20150801043237.GA28660@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150801043237.GA28660@x>
Sender: linux-doc-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, David Drysdale <drysdale@google.com>, Ingo Molnar <mingo@kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>T
List-Id: linux-api@vger.kernel.org

On 07/31/2015 09:32 PM, Josh Triplett wrote:
> 
> Sure, agreed.  But I really hope we don't create new kernel ABIs that
> involve constructs like that.
> 

It's worth noting I have pushed for auto-marshalling in general for a
long time, not the least to get rid of the awful syscall(3) wrapper.  I
even built a prototype but didn't have time to productize it.

	-hpa


