From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v8] seccomp, ptrace: add support for dumping seccomp filters
Date: Mon, 26 Oct 2015 15:46:58 +0900
Message-ID: <CAGXu5jLH++bDe-yf=jVxSxqO0FFLtpGnme9TFp2s-uPSZ4jbSg@mail.gmail.com>
References: <1445370612-18843-1-git-send-email-tycho.andersen@canonical.com>
	<1445370612-18843-2-git-send-email-tycho.andersen@canonical.com>
	<20151020202024.GA5772@redhat.com>
	<20151020220814.GA3232@hopstrocity>
	<20151021185146.GA27176@redhat.com>
	<20151021191533.GD30729@hopstrocity>
	<20151021210756.GA641@redhat.com>
	<20151021213306.GF30729@hopstrocity>
	<20151025153943.GA1912@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151025153943.GA1912@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tycho Andersen <tycho.andersen@canonical.com>, Alexei Starovoitov <ast@kernel.org>, Will Drewry <wad@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Daniel Borkmann <daniel@iogearbox.net>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 26, 2015 at 12:39 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 10/21, Tycho Andersen wrote:
>>
>> > And this leads to another question... If we expect that this interface
>> > can change later, then perhaps PTRACE_SECCOMP_GET_FILTER should also
>> > dump some header before copy_to_user(fprog->filter) ? Say, just
>> > "unsigned long version" == 0 for now. So that we can avoid
>> > PTRACE_SECCOMP_GET_FILTER_V2 in future.
>>
>> So this is interesting. Like Kees mentioned, the bulk of the work
>> would be done by the bpf syscall. We'd still need some way to get
>> access to the fd itself, which we could (ab)use
>> PTRACE_SECCOMP_GET_FILTER for, by returning the fd + BPF_MAXINSNS (so
>> that it doesn't conflict with length) or something like that. Or add a
>> _V2 as you say. If there is some change we can make to have a nicer
>> interface than fd + BPF_MAXINSNS to future proof, I'm fine with making
>> it.
>
> Can't comment, this is up to you/Kees ;)
>
> So, just in case, let me repeat I am fine with this patch.

Cool, thanks. I'll get this into my tree after kernel summit. Thanks
for suffering through all this Tycho!

-Kees

-- 
Kees Cook
Chrome OS Security
