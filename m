From: Julien Tinnes <jln@chromium.org>
Subject: Re: [PATCH 1/3] fs: add O_BENEATH flag to openat(2)
Date: Mon, 3 Nov 2014 10:26:43 -0800
Message-ID: <CAKyRK=j=yrWxwgAaqTiM+sEaf+-kNmYm3efK9N83oXafEwFa_Q@mail.gmail.com>
References: <1415015305-15494-1-git-send-email-drysdale@google.com>
	<1415015305-15494-2-git-send-email-drysdale@google.com>
	<20141103152036.GA7996@ZenIV.linux.org.uk>
	<CALCETrWmivJCvAAZPQo9Jf5gDiSbpWKesjZWfqEQRXPOBSPY9g@mail.gmail.com>
	<CAHse=S9AGNF84cLYszPSM2q7-78+KfuTCoap7eYyMEcbx97Zyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAHse=S9AGNF84cLYszPSM2q7-78+KfuTCoap7eYyMEcbx97Zyw@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 3, 2014 at 9:37 AM, David Drysdale <drysdale@google.com> wrote:
> On Mon, Nov 3, 2014 at 3:42 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> This is extremely useful in conjunction with seccomp.
>
> Yes, that was my understanding of how the Chrome[OS] folk wanted
> to use it.

Yes, exactly. Without this, if we want to give a sandboxed process A
access to a directory, we need to:
1. Create a new 'broker" process B
2. Make sure to have an IPC channel between A and B.
3. SIGSYS open() and openat() in A via seccomp-bpf
4. Have an async-signal-safe handler that can IPC open / openat.

There is a lot of hidden complexity in such a set-up. For instance, if
you need to prevent contention, the number of threads in the broker B
should scale automatically.

This is 'fine' (but undesirable) for a big beast such as Chromium
which needs such a complex set-ups anyways, but David's patch would
make it a lot easier to build a sandbox and whitelist directories for
everyone, simply by enforcing O_BENEATH in seccomp and whitelisting
open directory file descriptors in the sandboxed process.

Julien
