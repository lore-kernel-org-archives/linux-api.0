From: Philipp Rudo <prudo@linux.ibm.com>
Subject: Re: [PATCH V40 08/29] kexec_file: split KEXEC_VERIFY_SIG into
 KEXEC_SIG and KEXEC_SIG_FORCE
Date: Fri, 30 Aug 2019 16:26:22 +0200
Message-ID: <20190830162622.534a0b8f@laptop-ibm>
References: <20190820001805.241928-1-matthewgarrett@google.com>
        <20190820001805.241928-9-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820001805.241928-9-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, Jiri Bohac <jbohac@suse.cz>, linux-api@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>, David Howells <dhowells@redhat.com>, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Matthew,

found a typo ...

On Mon, 19 Aug 2019 17:17:44 -0700
Matthew Garrett <matthewgarrett@google.com> wrote:

[...]

> index 6d0635ceddd0..9b4f37a4edf1 100644
> --- a/arch/s390/kernel/kexec_elf.c
> +++ b/arch/s390/kernel/kexec_elf.c
> @@ -130,7 +130,7 @@ static int s390_elf_probe(const char *buf, unsigned long len)
>  const struct kexec_file_ops s390_kexec_elf_ops = {
>  	.probe = s390_elf_probe,
>  	.load = s390_elf_load,
> -#ifdef CONFIG_KEXEC_VERIFY_SIG
> +#ifdef CONFIG_KEXEC__SIG
		      ^^
... here.
>  	.verify_sig = s390_verify_sig,
> -#endif /* CONFIG_KEXEC_VERIFY_SIG */
> +#endif /* CONFIG_KEXEC_SIG */
>  };

Thanks
Philipp
