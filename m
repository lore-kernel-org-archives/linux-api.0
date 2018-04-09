From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Mon, 9 Apr 2018 10:14:15 +0200
Message-ID: <9040da29-2803-5c00-d47c-ae676a86b65c@iogearbox.net>
References: <CAADnVQLu5EZLJ1C9-dd4=K+sed6+38oy047+nqCMfuPFB=wttw@mail.gmail.com>
 <20180408080742.GE7362@linux-l9pv.suse>
 <20180409034008.dyte7k5kgkbjh5is@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180409034008.dyte7k5kgkbjh5is@ast-mbp.dhcp.thefacebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, joeyli <jlee@suse.com>
Cc: Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Matthew Garrett <mjg59@google.com>, Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 04/09/2018 05:40 AM, Alexei Starovoitov wrote:
> On Sun, Apr 08, 2018 at 04:07:42PM +0800, joeyli wrote:
[...]
>>> If the only thing that folks are paranoid about is reading
>>> arbitrary kernel memory with bpf_probe_read() helper
>>> then preferred patch would be to disable it during verification
>>> when in lockdown mode
>>
>> Sorry for I didn't fully understand your idea...
>> Do you mean that using bpf verifier to filter out bpf program that
>> uses bpf_probe_read()?
> 
> Take a look bpf_get_trace_printk_proto().
> Similarly we can add bpf_get_probe_read_proto() that
> will return NULL if lockdown is on.
> Then programs with bpf_probe_read() will be rejected by the verifier.

Fully agree with the above. For the two helpers, something like the below
would be sufficient to reject progs at verification time.

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d88e96d..51a6c2e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -117,6 +117,11 @@ static const struct bpf_func_proto bpf_probe_read_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };

+static const struct bpf_func_proto *bpf_get_probe_read_proto(void)
+{
+	return kernel_is_locked_down("BPF") ? NULL : &bpf_probe_read_proto;
+}
+
 BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
 	   u32, size)
 {
@@ -282,6 +287,9 @@ static const struct bpf_func_proto bpf_trace_printk_proto = {

 const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
 {
+	if (kernel_is_locked_down("BPF"))
+		return NULL;
+
 	/*
 	 * this program might be calling bpf_trace_printk,
 	 * so allocate per-cpu printk buffers
@@ -535,7 +543,7 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_map_delete_elem:
 		return &bpf_map_delete_elem_proto;
 	case BPF_FUNC_probe_read:
-		return &bpf_probe_read_proto;
+		return bpf_get_probe_read_proto();
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_tail_call:
