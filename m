From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC PATCH 1/1] seccomp: provide information about the previous syscall
Date: Fri, 22 Jan 2016 13:23:23 -0800
Message-ID: <CAGXu5jKbghS7e0sxRt1hEnancaNo-rXQAJrM_NKUwpivFs6sSw@mail.gmail.com>
References: <1453444200-8604-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
	<1453444200-8604-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
	<20160122173050.GE9608@ast-mbp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160122173050.GE9608@ast-mbp.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 22, 2016 at 9:30 AM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Fri, Jan 22, 2016 at 03:30:00PM +0900, Daniel Sangorrin wrote:
>> This patch allows applications to restrict the order in which
>> its system calls may be requested. In order to do that, we
>> provide seccomp-BPF scripts with information about the
>> previous system call requested.
>>
>> An example use case consists of detecting (and stopping) return
>> oriented attacks that disturb the normal execution flow of
>> a user program.
>>
>> Signed-off-by: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
> ...
>> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> ...
>>  struct seccomp_data {
>>       int nr;
>> +     int prev_nr;
>>       __u32 arch;
>>       __u64 instruction_pointer;
>>       __u64 args[6];
>
> this will break abi for existing seccomp programs.
> New field has to be at the end.

Yeah, and if we break abi, we need to add further sanity checking to
the parser to determine which "version" of seccomp_data we need. I'm
not convinced that there is enough utility here to break ABI.

(Though if we do, I'd like to add tid to the seccomp_data, which has
been requested in the past to make some pid-based arg checks easier to
do.)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
