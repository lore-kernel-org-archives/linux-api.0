From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v06 12/36] x86 uapi asm/signal.h: use __kernel_size_t
 instead of size_t
Date: Mon, 7 Aug 2017 16:30:43 +0200
Message-ID: <CAK8P3a1BdOB2Wmvi=KBXbKT+rpwCrjwBcmW=9wNYtC+eTN9XNw@mail.gmail.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi> <20170806164428.2273-13-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-13-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 6, 2017 at 6:44 PM, Mikko Rapeli <mikko.rapeli@iki.fi> wrote:
> Fixes userspace compilation error:
>
> error: unknown type name =E2=80=98size_t=E2=80=99
>
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/include/uapi/asm/signal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/uapi/asm/signal.h b/arch/x86/include/uapi/a=
sm/signal.h
> index 8264f47cf53e..74346db30758 100644
> --- a/arch/x86/include/uapi/asm/signal.h
> +++ b/arch/x86/include/uapi/asm/signal.h
> @@ -127,7 +127,7 @@ struct sigaction {
>  typedef struct sigaltstack {
>         void __user *ss_sp;
>         int ss_flags;
> -       size_t ss_size;
> +       __kernel_size_t ss_size;
>  } stack_t;
>

In patch 14, you took a different approach based on an earlier comment
of mine, for the same structure. I think we should definitely take the same
approach for signal.h across all architectures, whichever we end up using.

      Arnd
