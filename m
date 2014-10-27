From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Mon, 27 Oct 2014 18:01:10 +0000
Message-ID: <CAHse=S8qDS5z+Ac7TVY0QE2W9oNUaaaiZE0Vuytv15d7aFLEWw@mail.gmail.com>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
 <87zjcszz8y.fsf@x220.int.ebiederm.org> <CAHse=S-Xyk7CFn=tAGzo+tuUFt+04aBw+mGQmi=kWAaBJGALBw@mail.gmail.com>
 <CALCETrXBjLZTWVJfcsE4NA-JP9zSSgn=6ND0=cZ9BTy=CoN7pA@mail.gmail.com>
 <87ioje2ggq.fsf@x220.int.ebiederm.org> <CAHse=S_dpm8Do-H01Bo49a9TdYw+pSDzYomLOrBsYEcdO=Pytw@mail.gmail.com>
 <87wq7shuk6.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87wq7shuk6.fsf@x220.int.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 22, 2014 at 6:40 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> David Drysdale <drysdale@google.com> writes:
>> On Tue, Oct 21, 2014 at 5:29 AM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> It is more a description of what we have done but as a magic string it
>>> is descriptive.  Documetation/devices.txt documents that /dev/fd/ should
>>> exist, making it an unambiguous path.  Further these days the kernel
>>> sets the device naming policy in dev, so I think we are strongly safe in
>>> using that path in any event.
>>>
>>> I think execveat is interesting in the kernel because the motivating
>>> cases are the cases where anything except a static executable is
>>> uninteresting.
>>
>> FYI, there is potential in the future for something other than static
>> executables -- the FreeBSD Capsicum implementation includes changes
>> to the dynamic linker to get its search path as a list of pre-opened dfds
>> (in LD_LIBRARY_PATH_FDS) rather than paths.
>
> Which still leaves open the question how do you find the dynamic
> linker.  Is that also a pre-opened dfd?

I *think* it's still effectively a path lookup of the INTERP header in
the kernel (but the pathname is restricted to be one of a set of
standard pre-registered interpreters).

> Using /dev/fd/$N is also the kind of thing that a shell or a script
> interpret could special case instead relying on a filesystem node
> to exist.

True.
