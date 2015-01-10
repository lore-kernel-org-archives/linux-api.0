From: Rich Felker <dalias@aerifal.cx>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Date: Sat, 10 Jan 2015 08:31:20 -0500
Message-ID: <20150110133120.GF4574@brightrain.aerifal.cx>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-6-git-send-email-drysdale@google.com>
 <54AFF813.7050604@gmail.com>
 <20150109161302.GQ4574@brightrain.aerifal.cx>
 <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
 <54B0E282.7090203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54B0E282.7090203@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: David Drysdale <drysdale@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Jan 10, 2015 at 09:27:46AM +0100, Michael Kerrisk (man-pages) wrote:
> On 01/09/2015 06:46 PM, David Drysdale wrote:
> > On Fri, Jan 9, 2015 at 4:13 PM, Rich Felker <dalias@aerifal.cx> wrote:
> >> On Fri, Jan 09, 2015 at 04:47:31PM +0100, Michael Kerrisk (man-pages) wrote:
> >>> On 11/24/2014 12:53 PM, David Drysdale wrote:
> >>>> Signed-off-by: David Drysdale <drysdale@google.com>
> >>>> ---
> >>>>  man2/execveat.2 | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>>>  1 file changed, 153 insertions(+)
> >>>>  create mode 100644 man2/execveat.2
> >>>
> >>> David,
> >>>
> >>> Thanks for the very nicely prepared man page. I've done
> >>> a few very light edits, and will release the version below
> >>> with the next man-pages release.
> >>>
> >>> I have one question. In the message accompanying
> >>> commit 51f39a1f0cea1cacf8c787f652f26dfee9611874 you wrote:
> >>>
> >>>   The filename fed to the executed program as argv[0] (or the name of the
> >>>   script fed to a script interpreter) will be of the form "/dev/fd/<fd>"
> >>>   (for an empty filename) or "/dev/fd/<fd>/<filename>", effectively
> >>>   reflecting how the executable was found.  This does however mean that
> >>>   execution of a script in a /proc-less environment won't work; also, script
> >>>   execution via an O_CLOEXEC file descriptor fails (as the file will not be
> >>>   accessible after exec).
> >>>
> >>> How does one produce this situation where the execed program sees
> >>> argv[0] as a /dev/fd path? (i.e., what would the execveat()
> >>> call look like?) I tried to produce this scenario, but could not.
> >>
> >> I think this is wrong. argv[0] is an arbitrary string provided by the
> >> caller and would never be derived from the fd passed.
> > 
> > Yeah, I think I just wrote that wrong, it's only relevant for scripts.
> > As Rich says, for normal binaries argv[0] is just the argv[0] that
> > was passed into the execve[at] call.  For a script, the code in
> > fs/binfmt_script.c will remove the original argv[0] and put the
> > interpreter name and the script filename (e.g. "/bin/sh",
> > "/dev/fd/6/script") in as 2 arguments in its place.
> 
> So, on reflection, I think it's worth saying something about this, and 
> I added the following text to the man page:
> 
>    NOTES
>        When asked to execute a script file, the argv[0] that  is  passed
>        to  the  script  interpreter is a string of the form /dev/fd/N or
>        /dev/fd/N/P, where N is the number of the file descriptor  passed
>        via  the  dirfd argument.  A string of the first form occurs when
>        AT_EMPTY_PATH is employed.  A string of the  second  form  occurs
>        when the script is specified via both dirfd and pathname; in this
>        case, P is the value given in pathname.

While I'm aware that you're simply documenting, it seems unnecessary
to me (and unnecessarily complicating of the cloexec issue) to have
the /dev/fd/N/P form. This could always be resolved by the kernel to a
single temp fd for the new process to use, and in fact it's probably
preferable to always get a "temp fd" in case the fd passed to fexecve
is NOT a throwaway one (e.g. if the original fd was stdin or
something); the program being executed should not have to use ugly and
error-prone heuristics to decide if it should close the exec fd.

On the other hand, this resolution could be done by userspace (open
with O_PATH|O_CLOEXEC prior to making the fexecveat syscall, and
always passing AT_EMPTY_PATH to the kernel) if desirable, so maybe it
doesn't make sense to have the kernel do it. In this sense the whole
"at" part of fexecveat becomes vestigial, though.

Any thoughts?

Rich
