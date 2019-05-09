From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH linux-next v10 0/7] ptrace: add PTRACE_GET_SYSCALL_INFO
 request
Date: Thu, 9 May 2019 18:14:20 +0200
Message-ID: <20190509161420.GD24526@redhat.com>
References: <20190415234307.GA9364@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190415234307.GA9364@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromyatnikov <esyr@redhat.com>, Andy Lutomirski <luto@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Greentime Hu <greentime@andestech.com>, Helge Deller <deller@gmx.de>, "James E.J. Bottomley" <jejb@parisc-linux.org>, James Hogan <jhogan@kernel.org>, Kees Cook <keescook@chromium.org>, Michael Ellerman <mpe@ellerman.id.au>, Paul Burton <paul.burton@mips.com>, Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>, Richard Kuo <rkuo@codeaurora.org>, Shuah Khan <shuah@kernel.org>, Vincent Chen <deanbo422@gmail.com>, linux-api@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 04/16, Dmitry V. Levin wrote:
>
> [Andrew, could you take this patchset into your tree, please?]

Just in case...

I have already acked 6/7.

Other patches look good to me too, just I don't think I can actually review
these non-x86 changes.

Oleg.
