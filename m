From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v5 7/7] proc: add option to mount only a pids subset
Date: Mon, 14 May 2018 08:13:50 -0500
Message-ID: <874ljamlbl.fsf@xmission.com>
References: <20180511093707.GA1403@comp-core-i7-2640m-0182e6>
        <CAG48ez0bXvp1iF=HqyhEP1p5B6PRR07_j0qRoypJqs8x3Z+=mw@mail.gmail.com>
        <20180514090117.GC28179@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180514090117.GC28179@comp-core-i7-2640m-0182e6> (Alexey
        Gladkov's message of "Mon, 14 May 2018 11:01:17 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, aniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lw>
List-Id: linux-api@vger.kernel.org

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> On Fri, May 11, 2018 at 03:58:39PM +0200, Jann Horn wrote:
>> On Fri, May 11, 2018 at 11:37 AM, Alexey Gladkov
>> <gladkov.alexey@gmail.com> wrote:
>> > This allows to hide all files and directories in the procfs that are not
>> > related to tasks.
>> 
>> /proc/$pid/net and /proc/$pid/task/$tid/net aren't in scope for this
>> protection, even though they contain information about the whole
>> network namespace of the task, right?
>
> Yes. The pidonly makes visible only pids subset. You can still access the
> process namespaces via /proc/$pid/ns.
>
> We can think of additional constraints since the parameters are not
> stored in the pid namespace anymore.

pidonly is fine.

You have to be very careful with this.  The existing hidepid option
needs to live in the pid namespace.  The issue is if someone is allowed
to mount proc and play with these options as in remount you this may
cause issues.

Eric
