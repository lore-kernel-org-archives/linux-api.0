From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCH RFC 1/1] Documentation: describe how to add a system call
Date: Tue, 28 Jul 2015 18:13:31 +0100
Message-ID: <CAHse=S-_w+3WR0H0qPGWs5fer-3ncA6LX0is4UeJ48KCtK5Vmg@mail.gmail.com>
References: <1438083663-24814-1-git-send-email-drysdale@google.com>
 <1438083663-24814-2-git-send-email-drysdale@google.com> <CAGXu5j+biSzHgY95TgMOpFzhzysBHr2MPTaU_iNXjhesr=Mafw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+biSzHgY95TgMOpFzhzysBHr2MPTaU_iNXjhesr=Mafw@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Eric B Munson <emunson@akamai.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Milosz Tanski <milosz@adfin.com>, Fam
List-Id: linux-api@vger.kernel.org

On Tue, Jul 28, 2015 at 5:43 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Jul 28, 2015 at 4:41 AM, David Drysdale <drysdale@google.com> wrote:
>> Add a document describing the process of adding a new system call,
>> including the need for a flags argument for future compatibility, and
>> covering 32-bit/64-bit concerns (albeit in an x86-centric way).
>>
>> Signed-off-by: David Drysdale <drysdale@google.com>
>> Reviewed-by: Michael Kerrisk <mtk.manpages@gmail.com>
>
> This is great!
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> I have a few minor suggestions below...

Thanks, I've applied all bar one -- a query below.

>> ---
>>  Documentation/adding-syscalls.txt | 454 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 454 insertions(+)
>>  create mode 100644 Documentation/adding-syscalls.txt
>>
>> diff --git a/Documentation/adding-syscalls.txt b/Documentation/adding-syscalls.txt
>> new file mode 100644
>> index 000000000000..5f52edda8951
>> --- /dev/null
>> +++ b/Documentation/adding-syscalls.txt

[snip]

>> + - If there is an existing capability that governs related functionality, then
>> +   use that.  However, avoid combining lots of only vaguely related functions
>> +   together under the same bit, as this goes against capabilities' purpose of
>> +   splitting the power of root.  In particular, avoid adding new uses of the
>> +   already overly-general CAP_SYS_ADMIN capability.
>> + - If there is no related capability, then consider adding a new capability
>> +   bit -- but bear in mind that the numbering space is limited, and each new
>> +   bit needs to be understood and administered by sysadmins.
>
> Perhaps mention alternative mechanisms for access control when working
> on file descriptors, like avoiding security issues by looking at fd
> _opener_ credentials, rather than current's credentials?

I'm struggling to cope up with text about this that doesn't feel either
too vague or much too detailed / internal, so maybe I'm misunderstanding
what you're after.  Could you clarify or maybe suggest a sentence or two?

Thanks,
David
