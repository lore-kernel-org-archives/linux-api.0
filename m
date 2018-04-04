From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 19:34:25 -0700
Message-ID: <CAADnVQLu5EZLJ1C9-dd4=K+sed6+38oy047+nqCMfuPFB=wttw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Matthew Garrett <mjg59@google.com>, Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 9:26 AM, Andy Lutomirski <luto@kernel.org> wrote:
> On Tue, Apr 3, 2018 at 8:41 AM, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> On Tue, Apr 03, 2018 at 08:11:07AM -0700, Andy Lutomirski wrote:
>>> >
>>> >> "bpf: Restrict kernel image access functions when the kernel is locked down":
>>> >> This patch just sucks in general.
>>> >
>>> > Yes - but that's what Alexei Starovoitov specified.  bpf kind of sucks since
>>> > it gives you unrestricted access to the kernel.
>>>
>>> bpf, in certain contexts, gives you unrestricted access to *reading*
>>> kernel memory.  bpf should, under no circumstances, let you write to
>>> the kernel unless you're using fault injection or similar.
>>>
>>> I'm surprised that Alexei acked this patch.  If something like XDP or
>>> bpfilter starts becoming widely used, this patch will require a lot of
>>> reworking to avoid breaking standard distros.
>>
>> my understanding was that this lockdown set attemps to disallow _reads_
>> of kernel memory from anything, so first version of patch was adding
>> run-time checks for bpf_probe_read() which is no-go
>> and without this helper the bpf for tracing is losing a lot of its power,
>> so the easiest is to disable it all.
>
> Fair enough.

Actually looking at the patch again:
https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/commit/?h=efi-lock-down&id=78bb0059c3b8304a8d124b55feebc780fb3e0500

If the only thing that folks are paranoid about is reading
arbitrary kernel memory with bpf_probe_read() helper
then preferred patch would be to disable it during verification
when in lockdown mode.
No run-time overhead and android folks will be happy
that lockdown doesn't break their work.
They converted out-of-tree networking accounting
module and corresponding user daemon to use bpf:
https://www.linuxplumbersconf.org/2017/ocw/system/presentations/4791/original/eBPF%20cgroup%20filters%20for%20data%20usage%20accounting%20on%20Android.pdf
