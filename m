From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 08/15] kexec: New syscall kexec_file_load() declaration
Date: Thu, 26 Jun 2014 14:03:17 -0700
Message-ID: <CALCETrU8mixFxpS2Bt2Q7S08zUFxZwE1zfqHw8PEetqewgR7RQ@mail.gmail.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-9-git-send-email-vgoyal@redhat.com> <20140626204303.GE11136@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140626204303.GE11136@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Greg Kroah-Hartman <greg@kroah.com>, Borislav Petkov <bp@alien8.de>, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 26, 2014 at 1:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jun 26, 2014 at 04:33:37PM -0400, Vivek Goyal wrote:
>> This is the new syscall kexec_file_load() declaration/interface. I have
>> reserved the syscall number only for x86_64 so far. Other architectures
>> (including i386) can reserve syscall number when they enable the support
>> for this new syscall.
>>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> CC: linux-api@vger.kernel.org
>
> +.BR KEXEC_FILE_NO_INITRAMFS
> +Loading initrd/initramfs is optional. Specify this flag if no initramfs
> +is being loaded. If this flag is set, kernel will ignore the value passed
> +in

This seems pointless.  Why not just pass -1 for initrd_fd to indicate
that no initrd is needed?

--Andy
