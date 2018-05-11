From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v5 7/7] proc: add option to mount only a pids subset
Date: Fri, 11 May 2018 15:58:39 +0200
Message-ID: <CAG48ez0bXvp1iF=HqyhEP1p5B6PRR07_j0qRoypJqs8x3Z+=mw@mail.gmail.com>
References: <20180511093707.GA1403@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180511093707.GA1403@comp-core-i7-2640m-0182e6>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, aniel Micay <danielmicay@gmail.com>, Jon
List-Id: linux-api@vger.kernel.org

On Fri, May 11, 2018 at 11:37 AM, Alexey Gladkov
<gladkov.alexey@gmail.com> wrote:
> This allows to hide all files and directories in the procfs that are not
> related to tasks.

/proc/$pid/net and /proc/$pid/task/$tid/net aren't in scope for this
protection, even though they contain information about the whole
network namespace of the task, right?
