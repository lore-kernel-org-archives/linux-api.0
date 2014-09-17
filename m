From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Tue, 16 Sep 2014 17:13:23 -0700
Message-ID: <8738brhzoc.fsf@tassilo.jf.intel.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Richard Larocque <rlarocque@google.com> writes:

Perhaps I'm missing something, but how do you modify the AUX vector
for the children?
  
> +config VDSO_DISABLE_PRCTL
> +	depends on X86
> +	bool "prctl to disable VDSO loading"
> +	---help---
> +	  Enabling this option adds support for prctl calls that
> +	  set and retrieve a per-process flag to disable VDSO loading on
> +	  exec() for this process and all of its children.

I don't think it makes any sense to have a config for a simple
feature like this. Just do it unconditionally.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
