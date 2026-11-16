Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794852645;
	b=kqP1+RpQdrCKsAYJSrME0sopGT7C+Htzs50/dtJzZRD/BlWtO8fSQ0f4gYNqwrahe4Nk
	 nOtHiSf//EXmrbVX2Tj765VxBRica2108ZnDogWvgFlhBPDaeJYVUUv+CUmM3tNw0OtsM
	 wJYrmuS8xUOiFnZI92eU/w99CiauIVtjblCKhj9bCcc48/8mUjnQQs1k2AMgalDbHbuEY
	 2uPsN4bJdwjX6Vl6AkbM+s697xL6g4ImgWmiVMtEgQA3ISg1OwmFDSaiCMK0Iv4vzpgDh
	 KfCZhGO6RWntGOv1eMmRUVXRir8b+ZsGQt4fbW8zESUKJ6aR6d8ppASDl2MsLb8Xs5Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794852645;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=t10LdZZQL9q+bSGABLhe386ponBIV6xlTkNunDiJC5Y=;
	b=3Ux8szBbyQpJggt7KGU5RJ1eASqKPI4i7Xa4rWQl+Qi61oLJ6+ls+tsEaxdz8JkA04Xg
	 PGETs19Qn4bk7OS4CBeJmvOfdc11ukyJYNccnA2c94E7tZdR9Vos8/ofptfG/t3gRIFA4
	 EVYpGepyu7YlDB/uODJ4hMjH6Oxw32Zn6DV/3Lx1laaxG/HxZsVQURCVsujZaKEnGBLKE
	 sdTR8pddBmrgcWSMEP0oF/F1yS1oNAj5yRnEmvV5S5iwNKjZeI4XsCVQP9eS64fKfDyV2
	 WMbEb/B0Uwy8BI0KKNVDleL4DpaeD1dDWDSIkQHuUsmYjlrHgI/WvbSSMkKdP76PldQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x0lt4j5h;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F71B606A323
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 18:10:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F71B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x0lt4j5h
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b56221d361so5867648a12.3
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 10:10:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794852643; cv=none;
        d=google.com; s=arc-20260327;
        b=ixmIYIG7dvn5BFl/bmQXwgQFyynGGFabyQkoYIPxJj49VOdwJwTNxvIPsnNtQrn0IA
         aWTvjZwWwdgBkr5IUkvAyBPUMpRQI8mrK2iziqkg+5sUoUn7U3uQy/j+9kG+BVITVluI
         GXLeC6zdJ5rPZKUmzI4NIT8X9jzX6o33HoRWgh3yD36LDE87Sa78q9Xuyrc5t96awD6J
         3vWkfnZtrWpanZsjhFUz5iKTeEq12xHpWNOtimMWfzUtsYv3MPcoJLWQrmi2LWuC6VzI
         sx133Ppa5t6ZbsmK+zhDsY5vI4K8PVziEXpKvInnB2Z7cVwoQfEel0n8qGdeO62bYNFc
         xaRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t10LdZZQL9q+bSGABLhe386ponBIV6xlTkNunDiJC5Y=;
        fh=jeY7QrkNletp9zFz83FpOZUDqwoWTb+FMlGKPKfaTfE=;
        b=AX40uWg2eOkJypWvUX3+3kTFA2bTWEA/TfZVdRqpkZgucPZfnpY8hZS7tVlI7IIaw4
         pfwD6Izp7y9GxoggUynCzDEl+6Eh78I17dKzTrjI//lCSfgKgOopAHBiUjcS6V2KOoeP
         HAF6oAVWV62rrdIe6G81nNt7KxQab9yLIMc/go43kKfBBXncYJ6pjVXulERs5BwdoDgX
         ahRXqJQu0EGYBmC3jykw6Jv0XOnpf8I1a8XjGwxwb/K4qxypD+qCfQEXnQPB45JnKQO8
         o6W3+8DcjsEJfkUDM+D2Y+NsU5sIwGDbjsb+bhRT3El0cjTjVlyoY01gP/1j1oBxbc2h
         EWVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794852643; x=1795457443; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t10LdZZQL9q+bSGABLhe386ponBIV6xlTkNunDiJC5Y=;
        b=x0lt4j5h7o5ZOIupC6QpocZBfmv8wFzUHnqEUjT+qXXHs4fqM/212o+JPya3Ne+Seo
         tLIn+ce71Roeft17QbgYTLYZCJ0+SlsLtt4o2OLm95aLJ5VyGYDhMzriK8UdMTHsHNnj
         8mTqTlr5/Ax8I+pLOcrqBMRwU57PT7keOGJO4t4tmQGJKRYz/1wZ/uaK+JY6cLy80yx1
         pkobwBcMhURP6h4GfSR12sTX8GLQ2Qvn5juEllVfsWcYtDCP4X7X2kujH+BqvT2pv+Ny
         N7Wj9fipbTOHczIeVSeB+l1xH0/w8nez4g0GJUB68vMGCquO73GzeOY0af50BLWOXJ1z
         6RHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794852643; x=1795457443;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t10LdZZQL9q+bSGABLhe386ponBIV6xlTkNunDiJC5Y=;
        b=X8R/UqR3Plyz3Z3KCQ2xnGsWxoqq2IJUxqFPWqsl+BT6bggcREPalCxOa2H4OsRaqP
         VIvWtiE/iy+kkFryB7+SBjsOlWnS/e6rfkEOkbw6j16i5f0wBtPwrdfjUoi/sThQfBaR
         +695S9fybihvT2VYaNR26F5AvKTRFgYdmI/Q5B8WzobIBHBabgURTm20ZcW8Y2i2izNc
         qAYdKvekC0MtamswKUs0hu3e6uEgpm1fqibybLxJ6fXaxsGv/31GaHRrVg+RNTxaQQp6
         DD8T/fJDQW5Ag3mgbf+eh+Ma95INb2RPe8Jpx6Sbm7DSDLTGUCvWgmSvVLmoiKV1kmH0
         8crA==
X-Forwarded-Encrypted: i=1; AL+hErHH9RfeYHNhLT3CD9Y/xIJACA+vy+mypHmhuLvBRqglrF3wxLVtYuOXPMmTOdJFLI4+RIKkwtptr1E=@vger.kernel.org
X-Gm-Message-State: APuU4Z8RxP+RTOGDPEZl8P6tXVVXA0i0hmzyZkCfULEaLASUreVlB/o4
	6d2xN8zErq7opj9KOnj31VeSQvE4TsPEvbdgsONjSvBHN0pZnbVLoL1HbeiBCV0w9BWtHJkUplN
	mnXApB89wspXGS32VFBDo+87qvvm6Bms=
X-Gm-Gg: AYBFou1xtdwZK1pdaFxnKIVXj0Ri1zVk3pRSqdOUFti0n2NIKG+bGTBoW+Z7MPVlE/7
	8NOQbCQ9roKbRrw4bl/iOtkW+pHJPQ7SI7W75niS/0+FLS0SydBnV6rfnFEADq7FH4uG+xGSU5K
	8OGmgZfYNYaklcKcGzReSFoCcA0QmjRMh3FKuZstx/d+LGvNNV9iP7sp+8lmm80AUayw+5g2QQr
	gEkXuT9QCx5Ys0IrP0gI8PRhOQGCO1D4mvmPfrBFd3Tw7K4fF83imjB+qAzQcGzmYqDy37xjXxs
	YEYbhfLsPkG94DOlripRSKrvxEdAVOJ9aF7Y9TEdVN6z9H874gKLdB7eXuJ7IsAa2tNowWrmaJd
	VRGkdeB86hoTH/0DjOiGlNHcboukRMRPgiYjExJhxH/HpZG+lVTFsROJ2kshZnbKW9GZmfSIrkt
	m9L5f8frK9DIRBev27B8YScfj9lx22A8Ce8oJfbhTxWmDA
X-Received: by 2002:aa7:c4cc:0:b0:6b4:1037:2bb1 with SMTP id
 4fb4d7f45d1cf-6b7c0bc27a9mr6612692a12.22.1794852642773; Mon, 16 Nov 2026
 10:10:42 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114184720.373178-1-renzo@cs.unibo.it> <20261114184720.373178-2-renzo@cs.unibo.it>
In-Reply-To: <20261114184720.373178-2-renzo@cs.unibo.it>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Mon, 16 Nov 2026 19:10:30 +0100
X-Gm-Features: AclHuK-3zf0u-_tVqqSwOuwnlXe0JuQIB0eE-s6YSpQo7rK-ZYPGihb4jDlFOAE
Message-ID: <CA+=Fv5QPMYffznpkrEhZ3pMWtpHwNUUa3OaHxLexu8S47a7tRQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] asm/ptrace.h: add instruction_pointer_set
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oleg Nesterov <oleg@redhat.com>, Shuah Khan <shuah@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
	Eugene Syromyatnikov <evgsyr@gmail.com>, Davide Berardi <berardi.dav@gmail.com>, 
	"Dmitry V . Levin" <ldv@strace.io>, =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, strace-devel@lists.strace.io, 
	linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Brian Cain <bcain@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, linux-alpha@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-um@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Renzo,

On Sat, Nov 14, 2026 at 7:47=E2=80=AFPM Renzo Davoli <renzo@cs.unibo.it> wr=
ote:
>
> Add an instruction_pointer_set function for architectures that do
> not currently provide one.
>
> Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
> ---
>  arch/alpha/include/asm/ptrace.h      | 6 ++++++
>  arch/hexagon/include/asm/ptrace.h    | 6 ++++++
>  arch/m68k/include/asm/ptrace.h       | 6 ++++++
>  arch/microblaze/include/asm/ptrace.h | 6 ++++++
>  arch/nios2/include/asm/ptrace.h      | 6 ++++++
>  arch/um/include/asm/ptrace-generic.h | 6 ++++++
>  arch/xtensa/include/asm/ptrace.h     | 6 ++++++
>  7 files changed, 42 insertions(+)
>
> diff --git a/arch/alpha/include/asm/ptrace.h b/arch/alpha/include/asm/ptr=
ace.h
> index 45d1229344b6..1a6f073e892e 100644
> --- a/arch/alpha/include/asm/ptrace.h
> +++ b/arch/alpha/include/asm/ptrace.h
> @@ -33,6 +33,12 @@ static __always_inline bool regs_irqs_disabled(struct =
pt_regs *regs)
>         return arch_irqs_disabled_flags(regs->ps);
>  }
>
> +static inline void instruction_pointer_set(struct pt_regs *regs,
> +                                          unsigned long val)
> +{
> +       instruction_pointer(regs) =3D val;
> +}
> +
>  /* Syscall emulation defines */
>  #define PTRACE_SYSEMU                  0x1d
>  #define PTRACE_SYSEMU_SINGLESTEP       0x1e
> diff --git a/arch/hexagon/include/asm/ptrace.h b/arch/hexagon/include/asm=
/ptrace.h
> index ed35da1ee685..0a121f6e3bfc 100644
> --- a/arch/hexagon/include/asm/ptrace.h
> +++ b/arch/hexagon/include/asm/ptrace.h
> @@ -18,6 +18,12 @@ extern const char *regs_query_register_name(unsigned i=
nt offset);
>         ((struct pt_regs *) \
>          ((unsigned long)current_thread_info() + THREAD_SIZE) - 1)
>
> +static inline void instruction_pointer_set(struct pt_regs *regs,
> +                                          unsigned long val)
> +{
> +       instruction_pointer(regs) =3D val;
> +}
> +
>  #if CONFIG_HEXAGON_ARCH_VERSION >=3D 4
>  #define arch_has_single_step() (1)
>  #endif
> diff --git a/arch/m68k/include/asm/ptrace.h b/arch/m68k/include/asm/ptrac=
e.h
> index bc86ce012025..6e8a8f0daee8 100644
> --- a/arch/m68k/include/asm/ptrace.h
> +++ b/arch/m68k/include/asm/ptrace.h
> @@ -18,6 +18,12 @@
>         (struct pt_regs *)((char *)current_thread_info() + THREAD_SIZE) -=
 1
>  #define current_user_stack_pointer() rdusp()
>
> +static inline void instruction_pointer_set(struct pt_regs *regs,
> +                                          unsigned long val)
> +{
> +       instruction_pointer(regs) =3D val;
> +}
> +
>  #define arch_has_single_step() (1)
>
>  #ifdef CONFIG_MMU
> diff --git a/arch/microblaze/include/asm/ptrace.h b/arch/microblaze/inclu=
de/asm/ptrace.h
> index 17982292a64f..69e10658d7a9 100644
> --- a/arch/microblaze/include/asm/ptrace.h
> +++ b/arch/microblaze/include/asm/ptrace.h
> @@ -20,5 +20,11 @@ static inline long regs_return_value(struct pt_regs *r=
egs)
>         return regs->r3;
>  }
>
> +static inline void instruction_pointer_set(struct pt_regs *regs,
> +                                          unsigned long val)
> +{
> +       instruction_pointer(regs) =3D val;
> +}
> +
>  #endif /* __ASSEMBLER__ */
>  #endif /* _ASM_MICROBLAZE_PTRACE_H */
> diff --git a/arch/nios2/include/asm/ptrace.h b/arch/nios2/include/asm/ptr=
ace.h
> index 96cbcd40c7ce..d120d8ecb187 100644
> --- a/arch/nios2/include/asm/ptrace.h
> +++ b/arch/nios2/include/asm/ptrace.h
> @@ -70,6 +70,12 @@ struct switch_stack {
>  #define user_stack_pointer(regs)       ((regs)->sp)
>  extern void show_regs(struct pt_regs *);
>
> +static inline void instruction_pointer_set(struct pt_regs *regs,
> +                                          unsigned long val)
> +{
> +       instruction_pointer(regs) =3D val;
> +}
> +
>  #define current_pt_regs() \
>         ((struct pt_regs *)((unsigned long)current_thread_info() + THREAD=
_SIZE)\
>                 - 1)
> diff --git a/arch/um/include/asm/ptrace-generic.h b/arch/um/include/asm/p=
trace-generic.h
> index 62e9916078ec..632d4ce3334d 100644
> --- a/arch/um/include/asm/ptrace-generic.h
> +++ b/arch/um/include/asm/ptrace-generic.h
> @@ -29,6 +29,12 @@ struct pt_regs {
>
>  #define PTRACE_OLDSETOPTIONS 21
>
> +static inline void instruction_pointer_set(struct pt_regs *regs,
> +                                          unsigned long val)
> +{
> +       instruction_pointer(regs) =3D val;
> +}
> +
>  #ifdef CONFIG_BINFMT_ELF_FDPIC
>  #define PTRACE_GETFDPIC                31
>  #define PTRACE_GETFDPIC_EXEC   0
> diff --git a/arch/xtensa/include/asm/ptrace.h b/arch/xtensa/include/asm/p=
trace.h
> index d0568ff6d349..97b14418955e 100644
> --- a/arch/xtensa/include/asm/ptrace.h
> +++ b/arch/xtensa/include/asm/ptrace.h
> @@ -103,6 +103,12 @@ static inline unsigned long regs_return_value(struct=
 pt_regs *regs)
>         return regs->areg[2];
>  }
>
> +static inline void instruction_pointer_set(struct pt_regs *regs,
> +                                          unsigned long val)
> +{
> +       instruction_pointer(regs) =3D val;
> +}
> +
>  int do_syscall_trace_enter(struct pt_regs *regs);
>  void do_syscall_trace_leave(struct pt_regs *regs);
>
> --
> 2.47.3
>

The Alpha change looks good and applies cleanly on my for-next,
including the generic-entry fixes.

Tested both series together on my AlphaServer ES40. The ptrace
selftests passed on all three CPUs, including syscall skipping
and instruction-pointer modification.

For the Alpha part:

Acked-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>

Thanks,
Magnus
