From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
Date: Fri, 9 Jan 2015 17:46:28 +0000
Message-ID: <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-6-git-send-email-drysdale@google.com> <54AFF813.7050604@gmail.com>
 <20150109161302.GQ4574@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150109161302.GQ4574-C3MtFaGISjmo6RMmaWD+6Sb1p8zYI1N1@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 9, 2015 at 4:13 PM, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org> wrote:
> On Fri, Jan 09, 2015 at 04:47:31PM +0100, Michael Kerrisk (man-pages) wrote:
>> On 11/24/2014 12:53 PM, David Drysdale wrote:
>> > Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> > ---
>> >  man2/execveat.2 | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 153 insertions(+)
>> >  create mode 100644 man2/execveat.2
>>
>> David,
>>
>> Thanks for the very nicely prepared man page. I've done
>> a few very light edits, and will release the version below
>> with the next man-pages release.
>>
>> I have one question. In the message accompanying
>> commit 51f39a1f0cea1cacf8c787f652f26dfee9611874 you wrote:
>>
>>   The filename fed to the executed program as argv[0] (or the name of the
>>   script fed to a script interpreter) will be of the form "/dev/fd/<fd>"
>>   (for an empty filename) or "/dev/fd/<fd>/<filename>", effectively
>>   reflecting how the executable was found.  This does however mean that
>>   execution of a script in a /proc-less environment won't work; also, script
>>   execution via an O_CLOEXEC file descriptor fails (as the file will not be
>>   accessible after exec).
>>
>> How does one produce this situation where the execed program sees
>> argv[0] as a /dev/fd path? (i.e., what would the execveat()
>> call look like?) I tried to produce this scenario, but could not.
>
> I think this is wrong. argv[0] is an arbitrary string provided by the
> caller and would never be derived from the fd passed.

Yeah, I think I just wrote that wrong, it's only relevant for scripts.
As Rich says, for normal binaries argv[0] is just the argv[0] that
was passed into the execve[at] call.  For a script, the code in
fs/binfmt_script.c will remove the original argv[0] and put the
interpreter name and the script filename (e.g. "/bin/sh",
"/dev/fd/6/script") in as 2 arguments in its place.

[As an aside, IIRC the filename does get put into the new
process's memory, up above the environment strings -- but
that copy isn't visible via argv nor envp.]

> It's AT_EXECFN,
> /proc/self/exe, and filenames shown elsewhere in /proc that may be
> derived in odd ways.
>
> I would also move the text about O_CLOEXEC to a BUGS or NOTES section
> rather than the main description. The long-term intent should be that
> script execution this way should work. IIRC this was discussed earlier
> in the thread.

I may be misremembering, but I thought we hoped to be able to fix
execveat of a script without /proc in future, but didn't expect to fix
execveat of a script via an O_CLOEXEC fd (because in the latter
case the fd gets closed before the script interpreter runs, so even
if the interpreter (or a special filesystem) does clever things for names
starting with "/dev/fd/..." the file descriptor is already gone).
