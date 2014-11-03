From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/3] fs: add O_BENEATH flag to openat(2)
Date: Mon, 3 Nov 2014 10:29:21 -0800
Message-ID: <CALCETrXVLkqQNPNQRMm4Z6EGEJNNujpX_27GcV7CmQmSuSdsJQ@mail.gmail.com>
References: <1415015305-15494-1-git-send-email-drysdale@google.com>
 <1415015305-15494-2-git-send-email-drysdale@google.com> <20141103152036.GA7996@ZenIV.linux.org.uk>
 <CALCETrWmivJCvAAZPQo9Jf5gDiSbpWKesjZWfqEQRXPOBSPY9g@mail.gmail.com>
 <CAHse=S9AGNF84cLYszPSM2q7-78+KfuTCoap7eYyMEcbx97Zyw@mail.gmail.com> <CAKyRK=hRX1xk_0cRNhZ341HwU9Nim5_vhpM5twJHUOt8fH29=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKyRK=hRX1xk_0cRNhZ341HwU9Nim5_vhpM5twJHUOt8fH29=w@mail.gmail.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 3, 2014 at 10:25 AM, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Mon, Nov 3, 2014 at 9:37 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On Mon, Nov 3, 2014 at 3:42 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>> wrote:
>> > On Mon, Nov 3, 2014 at 7:20 AM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
>> >> On Mon, Nov 03, 2014 at 11:48:23AM +0000, David Drysdale wrote:
>> >>> Add a new O_BENEATH flag for openat(2) which restricts the
>> >>> provided path, rejecting (with -EACCES) paths that are not beneath
>> >>> the provided dfd.  In particular, reject:
>> >>>  - paths that contain .. components
>> >>>  - paths that begin with /
>> >>>  - symlinks that have paths as above.
>> >>
>> >> Yecch...  The degree of usefulness aside (and I'm not convinced that it
>> >> is non-zero),
>> >
>> > This is extremely useful in conjunction with seccomp.
>>
>> Yes, that was my understanding of how the Chrome[OS] folk wanted
>> to use it.
>
>
> Yes, exactly. Without this, if we want to give a sandboxed process A access
> to a directory, we need to:
> 1. Create a new 'broker" process B
> 2. Make sure to have an IPC channel between A and B.
> 3. SIGSYS open() and openat() in A via seccomp-bpf
> 4. Have an async-signal-safe handler that can IPC open / openat.

You can do this with user namespaces, too.  But this is way more
complicated than it should be, and it has a lot more overhead.

--Andy

>
> There is a lot of hidden complexity in such a set-up. For instance, if you
> need to prevent contention, the number of threads in the broker B should
> scale automatically.
>
> This is 'fine' (but undesirable) for a big beast such as Chromium which
> needs such a complex set-ups anyways, but David's patch would make it a lot
> easier to build a sandbox and whitelist directories for everyone, simply by
> enforcing O_BENEATH in seccomp and whitelisting open directory file
> descriptors in the sandboxed process.
>
> Julien



-- 
Andy Lutomirski
AMA Capital Management, LLC
