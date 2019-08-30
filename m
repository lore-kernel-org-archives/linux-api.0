From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH V40 04/29] lockdown: Enforce module signatures if the kernel is locked down
Date: Fri, 30 Aug 2019 17:31:13 +0100
Message-ID: <3638.1567182673@warthog.procyon.org.uk>
References: <20190820001805.241928-5-matthewgarrett@google.com> <20190820001805.241928-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820001805.241928-5-matthewgarrett@google.com>
Content-ID: <3637.1567182673.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: dhowells@redhat.com, jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, Jessica Yu <jeyu@kernel.org>
List-Id: linux-api@vger.kernel.org

Matthew Garrett <matthewgarrett@google.com> wrote:

>  enum lockdown_reason {
>  	LOCKDOWN_NONE,
> +	LOCKDOWN_MODULE_SIGNATURE,
>  	LOCKDOWN_INTEGRITY_MAX,
>  	LOCKDOWN_CONFIDENTIALITY_MAX,
>  };

Aren't you mixing disjoint sets?

> +	[LOCKDOWN_MODULE_SIGNATURE] = "unsigned module loading",

Wouldn't it be better to pass this string as a parameter to
security_locked_down()?

David
