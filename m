From: David Drysdale <drysdale@google.com>
Subject: [PATCHv3 0/1] Document how to add a new syscall
Date: Fri, 31 Jul 2015 15:35:45 +0100
Message-ID: <1438353346-67177-1-git-send-email-drysdale@google.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Josh Triplett <josh@joshtriplett.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Milosz Tanski <milosz@adfin.com>, Fam Zheng <famz@redhat.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

[Admin note: I'm on vacation next week, so I'll collate any additional
feedback when I get back.]

Given that I've gotten some of the details wrong in the past (and I've
seen others do likewise), I thought it might be helpful to collate the
best practices for adding a new system call to the kernel.

Apologies for the wide circulation -- I've tried to include folk who've
recently added or proposed a system call, as they're most likely to
have opinions on:
 - whether this a useful addition to Documentation/
 - whether the details of the advice are correct and complete.

Thanks,
David

(With thanks to Andrew Morton for looking over an initial draft, and to
Michael Kerrisk for suggesting several clarifications and additions.)


Changes since v2:
 - add struct-with-size as option for extensibility [Ingo Molnar]
 - mention LTP and xfstests [Cyril Hrubis]
 - always use file descriptors as handles for kernel objects [Josh Triplett]
 - consider poll(2) semantics for new file descriptors [Josh Triplett]
 - use a CONFIG option to control new functionality [Josh Triplett]
 - check ptrace_may_access() for process manipulation [Josh Triplett]
 - various minor markups [Josh Triplett]

Changes since v1:
 - added paragraph on build requirements to Testing section [Shuah Khan,
   Peter Zijlstra]
 - various text clarifications [Kees Cook]
 - added Reviewed-by markers


David Drysdale (1):
  Documentation: describe how to add a system call

 Documentation/adding-syscalls.txt | 531 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 531 insertions(+)
 create mode 100644 Documentation/adding-syscalls.txt

--
2.2.0.rc0.207.ga3a616c
